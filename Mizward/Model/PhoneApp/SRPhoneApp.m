//
//  SRPhoneApp.m
//  SiRuiV4.0
//
//  Created by zhangjunbo on 15/6/23.
//  Copyright (c) 2015年 SiRui. All rights reserved.
//

#import "SRPhoneApp.h"
#import "SRControlRequest.h"
#import "SRHttpUtil.h"
#import "SRURLUtil.h"
#import "SRPortalResponse.h"
#import "SRTCPRequest.h"
#import "SRTCPClient.h"
#import "SRKeychain.h"
#import "SRVehicleBasicInfo.h"
#import "SRVehicleStatusInfo.h"
#import "SRPortal.h"
#import "SRSMSCommandVos.h"
#import "SRUIUtil.h"
#import "SRUserDefaults.h"
#import "SRCustomer.h"
#import "SRBLEManager.h"

#import <AFNetworking/AFNetworking.h>
#import <MJExtension/MJExtension.h>
#import <BlocksKit/MFMessageComposeViewController+BlocksKit.h>

@implementation SRPhoneApp

//HTTP发送控制消息
+ (void)sendControlCommandWithRequest:(SRControlRequest *)request andCompleteBlock:(CompleteBlock)completeBlock
{
    [SRHttpUtil POST :[SRURLUtil PhoneApp_ControlUrl] WithParameter:request.customerDictionary completeBlock:^(NSError *error, id responseObject) {
        
        if (error) {
            if (completeBlock) completeBlock(error, responseObject);
            return ;
        }
        
        SRPortalResponse *response = [SRPortalResponse objectWithKeyValues:responseObject];
        if (response.result.resultCode != SRHTTP_Success) {
            error = [NSError errorWithDomain:response.result.resultMessage
                                        code:response.result.resultCode
                                    userInfo:response.result.fieldErrors];
            if (completeBlock) completeBlock(error, nil);
        } else {
            if (completeBlock) completeBlock(nil, @(YES));
        }
    }];
}

//同时发送HTTP 和 TCP
+ (void)sendControlByTCPAndHTTPWithCmd:(SRTLVTag_Instruction)cmd vehicleID:(NSInteger)vehicleID andCompleteBlock:(CompleteBlock)completeBlock
{
    //同时发送TCP和HTTP两个请求
    __block volatile BOOL hasResponse = NO;
    __block volatile BOOL controlTimeout = NO;
    
    CompleteBlock endBlock = ^(NSError *error, id responseObject){
        
        if (error && error.code == NSURLErrorTimedOut && controlTimeout) {
            //都超时才超时
            if (completeBlock) completeBlock(error, nil);
        } else if (error && error.code == NSURLErrorTimedOut && !controlTimeout) {
            //只有一个超时要等待另一个执行结果
            controlTimeout = YES;
        } else if (error && !hasResponse) {
            //执行失败，不用等待另一个
            hasResponse = YES;
            if (completeBlock) completeBlock(error, nil);
        } else if (!error && !hasResponse) {
            //执行成功不用等待另一个
            hasResponse = YES;
            if (completeBlock) completeBlock(nil, [NSString stringWithFormat:SRLocal(@"string_instruction_success"), [self getStringWithInstructionID:cmd]]);
        }
    };
    
    NSInteger controlSeries = [SRUserDefaults serialNumber];
    
    //tcp
    SRTCPRequest *request = [SRTCPRequest InstructionRequestWithCmdID:cmd
                                                        controlSeries:controlSeries 
                                                         andVehicleID:vehicleID];
    [[SRTCPClient sharedInterface] sendTCPRequest:request withCompleteBlock:endBlock];
    //http
    SRControlRequest *httpRequest = [[SRControlRequest alloc] init];
    httpRequest.userName = [SRKeychain UserName];
    httpRequest.password = [SRKeychain Password];
    httpRequest.vehicleID = vehicleID;
    httpRequest.instructionID = cmd;
    httpRequest.controlSeries = controlSeries;
    [self sendControlCommandWithRequest:httpRequest andCompleteBlock:endBlock];
}

//选择命令下发方式
+(SRControlType)chooseControlModeWithCmd:(SRTLVTag_Instruction)cmd andVehicleId:(NSInteger)vehicleID
{
    SRControlType result = SRControlType_Unsupport;
    
    SRVehicleBasicInfo *basicInfo = [SRPortal sharedInterface].currentVehicleBasicInfo;
    SRVehicleStatusInfo *statusInfo = basicInfo.status;
    
    BOOL httpAbility = NO;
    BOOL smsAbility = NO;
    NSString *smsCommandString = [basicInfo.smsCommands getSMSCommandStringWithTag:cmd];
    
    switch (cmd) {
        case TLVTag_Instruction_Lock:
            httpAbility = [basicInfo hasAbilityWithTag:TLVTag_Ability_Lock];
            smsAbility = [basicInfo hasAbilityWithTag:TLVTag_Ability_Lock_SMS];
            break;
        case TLVTag_Instruction_Unlock:
            httpAbility = [basicInfo hasAbilityWithTag:TLVTag_Ability_Unlock];
            smsAbility = [basicInfo hasAbilityWithTag:TLVTag_Ability_Unlock_SMS];
            break;
        case TLVTag_Instruction_EngineOn:
            httpAbility = [basicInfo hasAbilityWithTag:TLVTag_Ability_EngineOn];
            smsAbility = [basicInfo hasAbilityWithTag:TLVTag_Ability_EngineOn_SMS];
            break;
        case TLVTag_Instruction_EngineOff:
            httpAbility = [basicInfo hasAbilityWithTag:TLVTag_Ability_EngineOff];
            smsAbility = [basicInfo hasAbilityWithTag:TLVTag_Ability_EngineOff_SMS];
            break;
        case TLVTag_Instruction_OilOn:
            httpAbility = [basicInfo hasAbilityWithTag:TLVTag_Ability_OilOn];
            smsAbility = [basicInfo hasAbilityWithTag:TLVTag_Ability_OilOn_SMS];
            break;
        case TLVTag_Instruction_OilBreak:
            httpAbility = [basicInfo hasAbilityWithTag:TLVTag_Ability_OilBreak];
            smsAbility = [basicInfo hasAbilityWithTag:TLVTag_Ability_OilBreak_SMS];
            break;
        case TLVTag_Instruction_Call:
            httpAbility = [basicInfo hasAbilityWithTag:TLVTag_Ability_Call];
            smsAbility = [basicInfo hasAbilityWithTag:TLVTag_Ability_Call_SMS];
            break;
            //        case TLVTag_Instruction_Silence:
            //            httpAbility = [basicInfo hasAbilityWithTag:TLVTag_Ability_Lock];
            //            smsAbility = [basicInfo hasAbilityWithTag:TLVTag_Ability_Lock_SMS];
            //            break;
        case TLVTag_Instruction_WindowClose:
            httpAbility = [basicInfo hasAbilityWithTag:TLVTag_Ability_WindowClose];
            break;
        case TLVTag_Instruction_WindowOpen:
            httpAbility = [basicInfo hasAbilityWithTag:TLVTag_Ability_WindowOpen];
            break;
        case TLVTag_Instruction_SkyClose:
            httpAbility = [basicInfo hasAbilityWithTag:TLVTag_Ability_SkyClose];
            break;
        case TLVTag_Instruction_SkyOpen:
            httpAbility = [basicInfo hasAbilityWithTag:TLVTag_Ability_SkyOpen];
            break;
            
        case TLVTag_Instruction_GPSWeak:
        case TLVTag_Instruction_Defence:
        case TLVTag_Instruction_Undefence:
            httpAbility = YES;
            break;
            
        default:
            break;
    }
    
    if (smsAbility && smsCommandString && [basicInfo.msisdn isNumber]) {
        smsAbility = YES;
    } else {
        smsAbility = NO;
    }
    
    if (basicInfo.onlyPPKE) {
        //如果只有PPKE
        if ([[SRBLEManager sharedInterface] canSendControlInstruction:cmd toVehicle:vehicleID]) {
            result = SRControlType_BT;
        } else {
            result = SRControlType_Unsupport;
        }
    } else {
        //有OST
        if ([[SRBLEManager sharedInterface] canSendControlInstruction:cmd toVehicle:vehicleID]) {
            result = SRControlType_BT;
        } else if ((statusInfo.isOnline != 1 || ![AFHTTPRequestOperationManager manager].reachabilityManager.reachable)
                && smsAbility) {
            result = SRControlType_SMS;
        } else if (httpAbility) {
            result = SRControlType_TCP_HTTP;
        } else {
            result = SRControlType_Unsupport;
        }
    }
    
    return result;
}

//获取命令名称
+ (NSString *)getStringWithInstructionID:(SRTLVTag_Instruction)instructionID{
    
    NSDictionary *dic = @{
                          @(TLVTag_Instruction_Lock)        : SRLocal(@"string_Lock"),
                          @(TLVTag_Instruction_Unlock)      : SRLocal(@"string_Unlock"),
                          @(TLVTag_Instruction_EngineOn)    : SRLocal(@"string_EngineOn"),
                          @(TLVTag_Instruction_EngineOff)   : SRLocal(@"string_EngineOff"),
                          @(TLVTag_Instruction_OilOn)       : SRLocal(@"string_OilOn"),
                          @(TLVTag_Instruction_OilBreak)    : SRLocal(@"string_OilBreak"),
                          @(TLVTag_Instruction_Call)        : SRLocal(@"string_Call"),
                          @(TLVTag_Instruction_Silence)     : SRLocal(@"string_Silence"),
                          @(TLVTag_Instruction_WindowClose) : SRLocal(@"string_WindowClose"),
                          @(TLVTag_Instruction_WindowOpen)  : SRLocal(@"string_WindowOpen"),
                          @(TLVTag_Instruction_SkyClose)    : SRLocal(@"string_SkyClose"),
                          @(TLVTag_Instruction_SkyOpen)     : SRLocal(@"string_SkyOpen"),
                          @(TLVTag_Instruction_GPSWeak)     : SRLocal(@"string_GPSWeak"),
                          @(TLVTag_Instruction_Defence)     : SRLocal(@"string_Defence"),
                          @(TLVTag_Instruction_Undefence)   : SRLocal(@"string_Undefence"),
                          };
    
    return dic[@(instructionID)];
}

//发送短信
+ (void)sendSMSToPhone:(NSString *)phoneNumber withMessage:(NSString *)message andCompleteBlock:(CompleteBlock)completeBlock
{
    __block NSError *error;
    if (![MFMessageComposeViewController canSendText]) {
        SRLogError(@"该设备不支持短信功能");
        error = [NSError errorWithDomain:@"该设备不支持短信功能"
                                    code:-1
                                userInfo:nil];
        if (completeBlock) completeBlock(error, nil);
        return;
    }
    
    MFMessageComposeViewController *controller = [[MFMessageComposeViewController alloc] init];
    controller.recipients = [NSArray arrayWithObject:phoneNumber];
    controller.body = message;
    
    controller.bk_completionBlock = ^(MFMessageComposeViewController *controller, MessageComposeResult result){
        [controller dismissViewControllerAnimated:YES completion:NULL];
        
        NSString *resultMessage;
        switch (result)
        {
            case MessageComposeResultCancelled:
                SRLogDebug(@"Result: SMS sending canceled");
                error = [NSError errorWithDomain:@"发送取消"
                                            code:-1
                                        userInfo:nil];
                break;
                
            case MessageComposeResultSent:
                SRLogDebug(@"Result: SMS sending success");
                break;
                
            case MessageComposeResultFailed:
                SRLogDebug(@"短信发送失败");
                error = [NSError errorWithDomain:@"发送失败"
                                            code:-1
                                        userInfo:nil];
                break;
                
            default:
                SRLogDebug(@"Result: SMS not sent");
                break;
        }
        
        if (completeBlock) completeBlock(error, resultMessage);
    };
    
    [[SRUIUtil rootViewController] presentViewController:controller animated:YES completion:NULL];
}

//发送指令到当前车辆
+ (void)sendControlCommandWithCmd:(SRTLVTag_Instruction)cmd andCompleteBlock:(CompleteBlock)completeBlock
{
    [self sendControlCommandWithCmd:cmd vehicleID:[SRUserDefaults currentVehicleID] andCompleteBlock:completeBlock];
}

//发送指令到指定车辆
+ (void)sendControlCommandWithCmd:(SRTLVTag_Instruction)cmd vehicleID:(NSInteger)vehicleID andCompleteBlock:(CompleteBlock)completeBlock
{
    NSError *error;
    
    SRControlType controlMode = [self chooseControlModeWithCmd:cmd andVehicleId:vehicleID];
    SRVehicleBasicInfo *basicInfo = [SRPortal sharedInterface].vehicleDic[@(vehicleID)];
    
    //添加蓝牙控制
    if (controlMode == SRControlType_BT) {
        [[SRBLEManager sharedInterface] sendControlInstruction:cmd toVehicle:vehicleID withCompleteBlock:completeBlock];
//    } else if ( controlMode == SRControlType_SMS) {
//        [SRUIUtil dissmissLoadingHUD];
//        [self sendSMSToPhone:basicInfo.msisdn withMessage:[basicInfo.smsCommands getSMSCommandStringWithTag:cmd] andCompleteBlock:^(NSError *error, id responseObject) {
//            if (error) {
//                error = [NSError errorWithDomain:[NSString stringWithFormat:SRLocal(@"string_instruction_sms_fail"), [self getStringWithInstructionID:cmd]]
//                                            code:-1
//                                        userInfo:nil];
//                if (completeBlock) completeBlock(error, nil);
//            } else {
//                if (completeBlock) completeBlock(nil, [NSString stringWithFormat:SRLocal(@"string_instruction_sms_success"), [self getStringWithInstructionID:cmd]]);
//            }
//        }];
    } else if (controlMode == SRControlType_TCP_HTTP) {
        [self sendControlByTCPAndHTTPWithCmd:cmd vehicleID:vehicleID andCompleteBlock:completeBlock];
    } else {
        //添加蓝牙未连接消息提醒
        if (basicInfo.hasBluetooth) {
            error = [NSError errorWithDomain:@"指令未发送，您的设备支持蓝牙控制，请检查蓝牙连接状态"
                                        code:-1
                                    userInfo:nil];
        } else {
            error = [NSError errorWithDomain:@"该设备不支持此功能"
                                        code:-1
                                    userInfo:nil];
        }
        
        if (completeBlock) completeBlock(error, nil);
    }
}

//预约启动，未登录时发送
+ (void)sendControlCmdToServer:(SRTLVTag_Instruction)cmd withUserName:(NSString *)userName password:(NSString *)password vehicleID:(NSInteger)vehicleID andEndBlock:(CompleteBlock)completeBlock
{
    SRControlRequest *httpRequest = [[SRControlRequest alloc] init];
    httpRequest.userName = userName;
    httpRequest.password = password;
    httpRequest.vehicleID = vehicleID;
    httpRequest.instructionID = cmd;
    [self sendControlCommandWithRequest:httpRequest andCompleteBlock:^(NSError *error, id responseObject){
        if (error) {
            if (completeBlock) completeBlock(error, nil);
        } else {
            if (completeBlock) completeBlock(nil, [NSString stringWithFormat:SRLocal(@"string_instruction_success"), [self getStringWithInstructionID:cmd]]);
        }
    }];
}

@end

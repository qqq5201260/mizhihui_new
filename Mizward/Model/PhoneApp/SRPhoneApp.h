//
//  SRPhoneApp.h
//  SiRuiV4.0
//
//  Created by zhangjunbo on 15/6/23.
//  Copyright (c) 2015年 SiRui. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SRPhoneApp : NSObject

//获取命令名称
+ (NSString *)getStringWithInstructionID:(SRTLVTag_Instruction)instructionID;

//选择命令下发方式
+(SRControlType)chooseControlModeWithCmd:(SRTLVTag_Instruction)cmd andVehicleId:(NSInteger)vehicleID;

//发送短信
+ (void)sendSMSToPhone:(NSString *)phoneNumber withMessage:(NSString *)message andCompleteBlock:(CompleteBlock)completeBlock;

//发送控制指令(TCP、HTTP同时发送)
+ (void)sendControlCommandWithCmd:(SRTLVTag_Instruction)cmd andCompleteBlock:(CompleteBlock)completeBlock;
+ (void)sendControlCommandWithCmd:(SRTLVTag_Instruction)cmd vehicleID:(NSInteger)vehicleID andCompleteBlock:(CompleteBlock)completeBlock;
//发送控制指令(只有HTTP，供预约启动使用)
+ (void)sendControlCmdToServer:(SRTLVTag_Instruction)cmd withUserName:(NSString *)userName password:(NSString *)password vehicleID:(NSInteger)vehicleID andEndBlock:(CompleteBlock)completeBlock;

@end

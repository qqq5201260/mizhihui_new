//
//  SRPortal+Login.m
//  SiRuiV4.0
//
//  Created by zhangjunbo on 15/6/25.
//  Copyright (c) 2015年 SiRui. All rights reserved.
//

#import "SRPortal+Login.h"
#import "SRHttpUtil.h"
#import "SRURLUtil.h"
#import "SRPortalRequest.h"
#import "SRPortalResponse.h"
#import "SRUIUtil.h"
#import "SRKeychain.h"
#import "SRUserDefaults.h"
#import "SREventCenter.h"
#import "SRDataBase.h"
#import "SRPortal+User.h"
#import "SRPortal+CarInfo.h"
#import "SRCustomer.h"

#import "SRVehicleBasicInfo.h"
#import "SRDataBase+Vehicle.h"
#import <MJExtension/MJExtension.h>
#import "FZKTDispatch_after.h"
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
#endif

//游客模式60s提示
static FZKTDispatch_after *exhibition60s;

//游客模式结束时间
static FZKTDispatch_after *exhibitionOver;





@implementation SRPortal (Login)

//登陆
+ (void)loginWithRequest:(SRPortalRequestLogin *)request andCompleteBlock:(CompleteBlock)completeBlock
{
    [SRHttpUtil POST :[SRURLUtil Portal_LoginUrl] WithParameter:request.loginDic completeBlock:^(NSError *error, id responseObject) {
        
        [SRUIUtil dissmissLoadingHUD];
        
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
            
            
            SRPortalResponseLogin *login = [SRPortalResponseLogin objectWithKeyValues:response.entity];
            [SRKeychain updateUserName:request.userNameWithoutRSA];
            [SRKeychain updatePassword:request.passWordWithoutRSA];
            [SRUserDefaults updateSerialNumber:login.controlSeries];
//            [[SREventCenter sharedInterface] loginStatusChange:SRLoginStatus_DidLogin];
            
            if (login.needUpdate) {
                [SRUIUtil showAlertWithTitle:SRLocal(@"title_alert") message:SRLocal(@"description_forceUpdate") doneButton:SRLocal(@"bt_forceUpdate") andDoneBlock:^{
                    [SRUIUtil jumpToAppStore];
                }];
            } else {
                [self checkLatestVersionWithCompleteBlock:^(NSError *error, id responseObject) {
                    if (error || ![responseObject boolValue]) return ;
                    [UIAlertView bk_showAlertViewWithTitle:SRLocal(@"title_alert") message:SRLocal(@"description_update") cancelButtonTitle:SRLocal(@"bt_ignore") otherButtonTitles:@[SRLocal(@"bt_forceUpdate")] handler:^(UIAlertView *alertView, NSInteger buttonIndex) {
                        if (buttonIndex == alertView.cancelButtonIndex) return ;
                        [SRUIUtil jumpToAppStore];
                    }];
                }];
            }
            
            if (completeBlock) completeBlock(nil, login);
            
            //获取其他信息
            
            //获取车辆信息
            SRPortalRequestQueryCarBasicInfo *request = [[SRPortalRequestQueryCarBasicInfo alloc] init];
            [SRPortal queryVehicleBasicInfoWithRequest:request andCompleteBlock:^(NSError *error, NSMutableDictionary *dic) {
                if (error) return ;
                
                NSArray *vehicles = dic.allValues;
                [vehicles enumerateObjectsUsingBlock:^(SRVehicleBasicInfo *obj, NSUInteger idx, BOOL *stop) {
                    SRPortalRequestQueryCarStatusInfo *request = [[SRPortalRequestQueryCarStatusInfo alloc] init];
                    request.vehicleID = obj.vehicleID;
                    [SRPortal queryVehicleStatusInfoWithRequest:request andCompleteBlock:nil];
                }];
                [SRPortal querySMSCommandsWithCompleteBlock:nil];
            }];
            
            //获取用户信息
            [SRPortal queryCustomerWithCompleteBlock:^(NSError *error, id responseObject) {
                if (error) return ;
                [SRPortal queryPermissionWithCompleteBlock:nil];
            }];
        }
    }];
}

//游客登录
+ (void)exhibitionLoginWithRequest:(SRPortalRequestExhibitionLogin *)request andCompleteBlock:(CompleteBlock)completeBlock
{
    [SRHttpUtil POST :[SRURLUtil Portal_ExhibitionLoginUrl] WithParameter:request.loginDic completeBlock:^(NSError *error, id responseObject) {
        
        [SRUIUtil dissmissLoadingHUD];
        
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
            SRPortalResponseLogin *login = [SRPortalResponseLogin objectWithKeyValues:response.entity];
            [SRKeychain updateUserName:request.userNameWithoutRSA];
            [SRKeychain updatePassword:request.passWordWithoutRSA];
            [SRUserDefaults updateSerialNumber:login.controlSeries];
//            [[SREventCenter sharedInterface] loginStatusChange:SRLoginStatus_Visitor];
            
            //记录展车用户登陆时间
            [SRUserDefaults visitorCustomerLoginTime:[NSDate date]];
            
            if (login.needUpdate) {
                [SRUIUtil showAlertWithTitle:SRLocal(@"title_alert") message:SRLocal(@"description_forceUpdate") doneButton:SRLocal(@"bt_forceUpdate") andDoneBlock:^{
                    [SRUIUtil jumpToAppStore];
                }];
            } else {
                [self checkLatestVersionWithCompleteBlock:^(NSError *error, id responseObject) {
                    if (error || ![responseObject boolValue]) return ;
                    [UIAlertView bk_showAlertViewWithTitle:SRLocal(@"title_alert") message:SRLocal(@"description_update") cancelButtonTitle:SRLocal(@"bt_ignore") otherButtonTitles:@[SRLocal(@"bt_forceUpdate")] handler:^(UIAlertView *alertView, NSInteger buttonIndex) {
                        if (buttonIndex == alertView.cancelButtonIndex) return ;
                        [SRUIUtil jumpToAppStore];
                    }];
                }];
            }
            
            if (completeBlock) completeBlock(nil, login);
            
            //获取其他信息
            
            //获取车辆信息
            SRPortalRequestQueryCarBasicInfo *request = [[SRPortalRequestQueryCarBasicInfo alloc] init];
            [SRPortal queryVehicleBasicInfoWithRequest:request andCompleteBlock:^(NSError *error, NSMutableDictionary *dic) {
                if (error) return ;
                
                NSArray *vehicles = dic.allValues;
                [vehicles enumerateObjectsUsingBlock:^(SRVehicleBasicInfo *obj, NSUInteger idx, BOOL *stop) {
                    SRPortalRequestQueryCarStatusInfo *request = [[SRPortalRequestQueryCarStatusInfo alloc] init];
                    request.vehicleID = obj.vehicleID;
                    [SRPortal queryVehicleStatusInfoWithRequest:request andCompleteBlock:nil];
                }];
                [SRPortal querySMSCommandsWithCompleteBlock:nil];
            }];
            
            //获取用户信息
            [SRPortal queryCustomerWithCompleteBlock:^(NSError *error, id responseObject) {
                if (error) return ;
                [SRPortal queryPermissionWithCompleteBlock:nil];
                
                [SRUIUtil showTopAutoDisappearHUDWithMessage:[NSString stringWithFormat:@"您当前为体验账号，体验时长为%zd分钟", [self sharedInterface].customer.exhibitionExperienceTime]];
                

                NSDictionary *alertDic = [NSDictionary dictionaryWithObject:[NSString stringWithFormat:@"体验将在1分钟后结束"]
                                                                    forKey:SRLocalNotificationExperienceAlert];
                if (!exhibition60s) {
                    exhibition60s = [[FZKTDispatch_after alloc]init];
                }
                [self sendLocalNotification:alertDic str:@"体验将在1分钟后结束" time:60*([self sharedInterface].customer.exhibitionExperienceTime-1) dispatch:exhibition60s];
                

                NSDictionary *overdueDic = [NSDictionary dictionaryWithObject:[NSString stringWithFormat:@"您的体验时间已结束，如需继续体验请返回登录页面重新扫描体验"] forKey:SRLocalNotificationExperienceOverdue];
                if (!exhibitionOver) {
                    exhibitionOver = [[FZKTDispatch_after alloc]init];
                }
                [self sendLocalNotification:overdueDic str:@"您的体验时间已结束，如需继续体验请返回登录页面重新扫描体验" time:60*[self sharedInterface].customer.exhibitionExperienceTime dispatch:exhibitionOver];
                
            }];
        }
    }];
}

//前后台切换
+ (void)updateAppBackgroundStatus:(BOOL)isBackground andCompleteBlock:(CompleteBlock)completeBlock
{
    SRPortalRequestUpdateAppStatus *request = [[SRPortalRequestUpdateAppStatus alloc] init];
    request.isBackGround = isBackground;
    [SRHttpUtil POST:[SRURLUtil Portal_UpdateAppStatusUrl] WithParameter:request.keyValues completeBlock:^(NSError *error, id responseObject) {
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

//注销
+ (void)logoutWithCompleteBlock:(CompleteBlock)completeBlock
{
    [[self sharedInterface] clearData];
    [[SRDataBase sharedInterface] clearData];
    [SRUserDefaults resetDefaults];
    [[SREventCenter sharedInterface] loginStatusChange:SRLoginStatus_NotLogin];
    
    SRPortalRequestLogout *request = [[SRPortalRequestLogout alloc] init];
    [SRHttpUtil POST:[SRURLUtil Portal_LogoutUrl] WithParameter:request.keyValues completeBlock:^(NSError *error, id responseObject) {
        [SRUIUtil dissmissLoadingHUD];
        
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

+ (void)updataAppStatus:(BOOL)isBackground WithCompleteBlock:(CompleteBlock)completeBlock
{
    
    if (![SRKeychain Password] || [SRKeychain Password].length <= 0
        || ![SRKeychain UserName] || [SRKeychain UserName].length <= 0
        || ![SRUserDefaults isLogin]) {
        if (completeBlock) completeBlock(nil, nil);
        return;
    }
    
    SRPortalRequestUpdateAppStatus *request = [[SRPortalRequestUpdateAppStatus alloc] init];
    request.isBackGround = isBackground;
    
    [SRHttpUtil POST :[SRURLUtil Portal_UpdateAppStatusUrl] WithParameter:request.keyValues completeBlock:^(NSError *error, id responseObject) {
        
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
            if (completeBlock) completeBlock(nil, response.result.resultMessage);
        }
    }];
}

+ (void)checkLatestVersionWithCompleteBlock:(CompleteBlock)completeBlock
{
    [SRHttpUtil POST :[SRURLUtil appVersionCheck] WithParameter:nil completeBlock:^(NSError *error, id responseObject) {
        
        if (error) {
            if (completeBlock) completeBlock(error, responseObject);
            return ;
        }
        
        if (error) {
            if (completeBlock) completeBlock(error, responseObject);
            return ;
        }
        
        NSArray *infoArray = [responseObject objectForKey:@"results"];
        if ([infoArray count]) {
            NSDictionary *releaseInfo = [infoArray objectAtIndex:0];
            NSString *lastVersion = [releaseInfo objectForKey:@"version"];
            
            if (NSOrderedDescending == [lastVersion compare:CurrentAPPVersion]) {
                if (completeBlock) completeBlock(error, @(YES));
                return;
            } else {
                if (completeBlock) completeBlock(error, @(NO));
                return;
            }
        }
        
        if (completeBlock) completeBlock(error, @(NO));
    }];
}


/**
 发送本地通知

 @param content <#content description#>
 @param after 延迟时间  单位秒
 */
+ (void)sendLocalNotification:(NSDictionary *)content str:(NSString *)str time:(NSTimeInterval)time dispatch:(FZKTDispatch_after *)dispatch_after{

//    if(!dispatch_after){
//        dispatch_after = [FZKTDispatch_after new];
//    }
    CGFloat vision = [[[UIDevice currentDevice] systemVersion] floatValue];
    if (vision >= 10.0 ) {

    // 使用 UNUserNotificationCenter 来管理通知
    UNUserNotificationCenter* center = [UNUserNotificationCenter currentNotificationCenter];
    
    //需创建一个包含待通知内容的 UNMutableNotificationContent 对象，注意不是 UNNotificationContent ,此对象为不可变对象。
    UNMutableNotificationContent *contents = [[UNMutableNotificationContent alloc] init];
    contents.body = str;
//    contents.title = @"标题";
    contents.userInfo = content;
    contents.sound = [UNNotificationSound defaultSound];
    
    // 在 alertTime 后推送本地推送
    UNTimeIntervalNotificationTrigger* trigger = [UNTimeIntervalNotificationTrigger
                                                  triggerWithTimeInterval:0.01 repeats:NO];
    
    UNNotificationRequest* request = [UNNotificationRequest requestWithIdentifier:@"FiveSecond"
                                                                          content:contents trigger:trigger];
    
    //添加推送成功后的处理！
    [dispatch_after runDispatch_after:time block:^{
        //添加推送到uiapplication
        if([SRUserDefaults loginStatus]==SRLoginStatus_Visitor){
        [center addNotificationRequest:request withCompletionHandler:^(NSError * _Nullable error) {
            //展车用户
            if (content
                && content[SRLocalNotificationExperienceAlert]
                && [SRUserDefaults loginStatus] == SRLoginStatus_Visitor) {
                dispatch_async(dispatch_get_main_queue(), ^{
                          [SRUIUtil showTopAutoDisappearHUDWithMessage:content[SRLocalNotificationExperienceAlert]];
                });
          
            } else if (content
                       && content[SRLocalNotificationExperienceOverdue]
                       && [SRUserDefaults loginStatus] == SRLoginStatus_Visitor) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [SRUIUtil showReloginAlertWithMessage:content[SRLocalNotificationExperienceOverdue] doneButton:@"确定"];

                });
                
            }
            
            
        }];
        }
    }];

    }else{
        UILocalNotification *overdueNotification = [[UILocalNotification alloc] init];

        overdueNotification.timeZone = [NSTimeZone defaultTimeZone];
        overdueNotification.repeatInterval = 0;
        
        overdueNotification.userInfo = content;
        overdueNotification.alertBody = str;
        //添加推送到uiapplication
        
        [dispatch_after runDispatch_after:time block:^{
            //添加推送到uiapplication
            if([SRUserDefaults loginStatus]==SRLoginStatus_Visitor){
                
                [[UIApplication sharedApplication] presentLocalNotificationNow:overdueNotification];
            }
        }];

    }

    
    

}

@end

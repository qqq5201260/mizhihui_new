//
//  SRPortal+APNs.m
//  SiRuiV4.0
//
//  Created by zhangjunbo on 15/6/23.
//  Copyright (c) 2015年 SiRui. All rights reserved.
//

#import "SRPortal+APNs.h"
#import "SRAPNsMessage.h"
#import "SRMessageInfo.h"
#import "SRAPNsMessageInfo.h"
#import "SRUIUtil.h"
#import "SRAPNsOrderRecommend.h"
#import "SRUserDefaults.h"
#import "SRAPNsOrderStartInfo.h"
#import "SRCustomer.h"
#import "SRMessageUtil.h"
#import <MJExtension/MJExtension.h>

@implementation SRPortal (APNs)

+ (void)parseAPNsMessage:(NSDictionary *)userInfo
{
    SRAPNsMessage *apnsMessage = [SRAPNsMessage objectWithKeyValues:userInfo];
    
    SRLogDebug(@"%@", apnsMessage.keyValues);
    SRLogDebug(@"%@", apnsMessage.keyValues);
    SRLogDebug(@"%@", apnsMessage.aps.keyValues);
    SRLogDebug(@"%@", apnsMessage.MSG.keyValues);
    SRLogDebug(@"%@", apnsMessage.MSG.object);
    
    [self updateNewMessageFlag:apnsMessage];
    
    //预约启动
    if (apnsMessage.MSG && apnsMessage.MSG.mt == SRMessageSubType_Remind_OrderStart) {
        [self parseOrderStartMessage:apnsMessage];
        return;
    } else if (apnsMessage.MSG && apnsMessage.MSG.mt == SRMessageSubType_Function_OrderStartRecommend) {
        [self parseOrderStartRecommendMessage:apnsMessage];
        return;
    }
    
    if (apnsMessage.MSG.cid != [SRUserDefaults customerID]) {
        return;
    }
    
    if (apnsMessage.MSG && apnsMessage.MSG.mt == SRMessageSubType_Remind_PasswordChange) {
        [self parsePasswordChangeMessage:apnsMessage];
    } else if (apnsMessage.MSG && apnsMessage.MSG.mt == SRMessageSubType_Remind_CustomerDelete) {
        [self parseCustomerDeleteMessage:apnsMessage];
    } else if (apnsMessage.MSG && apnsMessage.MSG.t == SRMessageType_IM) {
        [self parseIMMessage:apnsMessage];
    } else {
        [SRMessageUtil showAPNsMessage:apnsMessage withTapBlock:^{
            [SRUIUtil PushSRMessageCenterViewController];
        }];
    }
}

+ (void)updateNewMessageFlag:(SRAPNsMessage *)apnsMessage
{
    switch (apnsMessage.MSG.t) {
        case SRMessageType_IM:
            [self sharedInterface].customer.hasNewMessageInIm = YES;
            break;
        case SRMessageType_Alert:
            [self sharedInterface].customer.hasNewMessageInAlert = YES;
            break;
        case SRMessageType_Remind:
            [self sharedInterface].customer.hasNewMessageInRemind = YES;
            break;
        case SRMessageType_Function:
            [self sharedInterface].customer.hasNewMessageInFunction = YES;
            break;
            
        default:
//            [self sharedInterface].customer.hasNewMessageInIm = YES;
//            [self sharedInterface].customer.hasNewMessageInAlert = YES;
//            [self sharedInterface].customer.hasNewMessageInRemind = YES;
//            [self sharedInterface].customer.hasNewMessageInFunction = YES;
            break;
    }
}

+ (void)parseOrderStartMessage:(SRAPNsMessage *)apnsMessage
{
    SRAPNsOrderStartInfo *info = [SRAPNsOrderStartInfo objectWithKeyValues:apnsMessage.MSG.object];
    [SRUIUtil showOrderStartAlert:info];
}

+ (void)parseOrderStartRecommendMessage:(SRAPNsMessage *)apnsMessage
{
    SRAPNsOrderRecommend *info = [SRAPNsOrderRecommend objectWithKeyValues:apnsMessage.MSG.object];
    [SRUIUtil showOrderRecommendAlert:apnsMessage.aps.alert userName:info.cn];
}

+ (void)parsePasswordChangeMessage:(SRAPNsMessage *)apnsMessage
{
    [SRUIUtil showReloginAlertWithMessage:apnsMessage.aps.alert doneButton:@"确定"];
}

+ (void)parseCustomerDeleteMessage:(SRAPNsMessage *)apnsMessage
{
    [SRUIUtil showReloginAlertWithMessage:apnsMessage.aps.alert doneButton:@"确定"];
}

+ (void)parseIMMessage:(SRAPNsMessage *)apnsMessage
{
    [SRMessageUtil showAPNsMessage:apnsMessage withTapBlock:^{
        [SRUIUtil PushSRCustomerServiceViewController];
    }];
}

@end

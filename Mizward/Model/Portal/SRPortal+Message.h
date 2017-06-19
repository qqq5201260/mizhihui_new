//
//  SRPortal+Message.h
//  SiRuiV4.0
//
//  Created by zhangjunbo on 15/6/27.
//  Copyright (c) 2015年 SiRui. All rights reserved.
//

#import "SRPortal.h"

@class SRPortalRequestQueryMessageSwitch, SRPortalRequestModifyMessageSwitch, SRPortalRequestQueryMessagePage, SRPortalRequestQueryMessageUnreadCount;

@interface SRPortal (Message)

//查询消息开关
+ (void)queryMessageSwitchWithRequest:(SRPortalRequestQueryMessageSwitch *)request andCompleteBlock:(CompleteBlock)completeBlock;

//更新消息开关
+ (void)modifyMessageSwitchWithRequest:(SRPortalRequestModifyMessageSwitch *)request andCompleteBlock:(CompleteBlock)completeBlock;

//查询消息列表
+ (void)queryMessageWithRequest:(SRPortalRequestQueryMessagePage *)request isRefresh:(BOOL)isRefresh andCompleteBlock:(CompleteBlock)completeBlock;

//查询未读消息
+ (void)queryMessageUnreadCountWithCompleteBlock:(CompleteBlock)completeBlock;

@end

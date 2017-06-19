//
//  SRPortal+User.h
//  SiRuiV4.0
//
//  Created by zhangjunbo on 15/6/25.
//  Copyright (c) 2015年 SiRui. All rights reserved.
//

#import "SRPortal.h"

@class SRPortalRequestModifyUserRecord, SRPortalRequestAuthentication;

@interface SRPortal (User)

//查询用户信息
+ (void)queryCustomerWithCompleteBlock:(CompleteBlock)completeBlock;

//查询修改权限
+ (void)queryPermissionWithCompleteBlock:(CompleteBlock)completeBlock;

//修改用户信息
+ (void)modifyUserRecordWithRequest:(SRPortalRequestModifyUserRecord *)request andCompleteBlock:(CompleteBlock)completeBlock;

//绑定手机
+ (void)updateBindStatus:(BOOL)isBind withCompleteBlock:(CompleteBlock)completeBlock;

//轨迹开关设置
+ (void)updateTripSwitch:(BOOL)isOpen withCompleteBlock:(CompleteBlock)completeBlock;

//实名认证
+ (void)realNameAuthenticationWithRequest:(SRPortalRequestAuthentication *)request andCompleteBlock:(CompleteBlock)completeBlock;

//签到
+ (void)signDailyWithCompleteBlock:(CompleteBlock)completeBlock;

//积分列表
+ (void)queryPointRecordIsRefresh:(BOOL)isRefresh andCompleteBlock:(CompleteBlock)completeBlock;

@end

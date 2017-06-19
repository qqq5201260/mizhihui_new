//
//  SRPortal+Login.h
//  SiRuiV4.0
//
//  Created by zhangjunbo on 15/6/25.
//  Copyright (c) 2015年 SiRui. All rights reserved.
//

#import "SRPortal.h"

@class SRPortalRequestExhibitionLogin;

@interface SRPortal (Login)

//登陆
+ (void)loginWithRequest:(SRPortalRequestLogin *)request andCompleteBlock:(CompleteBlock)completeBlock;

//游客登录
+ (void)exhibitionLoginWithRequest:(SRPortalRequestExhibitionLogin *)request andCompleteBlock:(CompleteBlock)completeBlock;

//前后台切换
+ (void)updateAppBackgroundStatus:(BOOL)isBackground andCompleteBlock:(CompleteBlock)completeBlock;

//注销
+ (void)logoutWithCompleteBlock:(CompleteBlock)completeBlock;

//更新APP状态
+ (void)updataAppStatus:(BOOL)isBackground WithCompleteBlock:(CompleteBlock)completeBlock;
//是否有新版本
+ (void)checkLatestVersionWithCompleteBlock:(CompleteBlock)completeBlock;

@end

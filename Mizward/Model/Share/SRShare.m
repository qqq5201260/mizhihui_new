//
//  SRShare.m
//  SiRuiV4.0
//
//  Created by zhangjunbo on 15/7/10.
//  Copyright (c) 2015年 SiRui. All rights reserved.
//

#import "SRShare.h"
#import "SRShareInfo.h"
#import "SRUIUtil.h"
#import "AppDelegate.h"
#import "SRNotificationCenter.h"

#import <ShareSDK/ShareSDK.h>
#import <ShareSDKUI/ShareSDK+SSUI.h>
#import <ShareSDKConnector/ShareSDKConnector.h>
#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/QQApiInterface.h>
#import "WXApi.h"
//#import "WeiboSDK.h"


@implementation SRShare

+ (void)load {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __block id observer = [SRNotificationCenter sr_addObserverForName:UIApplicationDidFinishLaunchingNotification object:nil queue:nil usingBlock:^(NSNotification *note) {
            [SRNotificationCenter sr_removeObserver:observer];
            
            [ShareSDK registerApp:@"9c757dec5678"
                  activePlatforms:@[//@(SSDKPlatformTypeSinaWeibo), //新浪微博SDK 包含 IFDA 无法通过审核
                                    @(SSDKPlatformTypeSMS),
                                    @(SSDKPlatformSubTypeWechatSession),
                                    @(SSDKPlatformSubTypeWechatTimeline),
                                    @(SSDKPlatformSubTypeQQFriend),
                                    @(SSDKPlatformSubTypeQZone)]
                         onImport:^(SSDKPlatformType platformType)
             {
                 switch (platformType)
                 {
//                     case SSDKPlatformTypeSinaWeibo:
//                         [ShareSDKConnector connectWeibo:[WeiboSDK class]];
//                         break;
                     case SSDKPlatformTypeWechat:
                         [ShareSDKConnector connectWeChat:[WXApi class]];
                         break;
                     case SSDKPlatformTypeQQ:
                         [ShareSDKConnector connectQQ:[QQApiInterface class] tencentOAuthClass:[TencentOAuth class]];
                         break;
                     default:
                         break;
                 }
             }
                  onConfiguration:^(SSDKPlatformType platformType, NSMutableDictionary *appInfo)
             {
                 
                 switch (platformType)
                 {
                     case SSDKPlatformTypeSinaWeibo:
                         //设置新浪微博应用信息,其中authType设置为使用SSO＋Web形式授权
                         [appInfo SSDKSetupSinaWeiboByAppKey:@"1565014335"
                                                   appSecret:@"1e140ff96a0f251892ecade1f47a9c2d"
                                                 redirectUri:@"http://www.mizway.com/app.html"
                                                    authType:SSDKAuthTypeBoth];
                         break;
                     case SSDKPlatformTypeWechat:
                         [appInfo SSDKSetupWeChatByAppId:@"wxf118e6c6d249de71"
                                               appSecret:@"7f261b9cadd48b4209492a8e01b75288"];
                         break;
                     case SSDKPlatformTypeQQ:
                         [appInfo SSDKSetupQQByAppId:@"1104822312"
                                              appKey:@"XcKQ23iodJFYjA6z"
                                            authType:SSDKAuthTypeBoth];
                         break;
                     default:
                         break;
                 }
             }];

        }];
    });
}

+ (void)share:(SRShareInfo *)info
{
    NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
    [shareParams SSDKSetupShareParamsByText:info.content
                                     images:@[info.image]
                                        url:[NSURL URLWithString:info.url]
                                      title:info.title
                                       type:SSDKContentTypeAuto];
    [ShareSDK showShareActionSheet:nil
                             items:nil
                       shareParams:shareParams
               onShareStateChanged:^(SSDKResponseState state, SSDKPlatformType platformType, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error, BOOL end) {
                   
                   switch (state) {
                       case SSDKResponseStateSuccess:
                           [SRUIUtil showAutoDisappearHUDWithMessage:@"分享成功" isDetail:NO];
                           break;
                       case SSDKResponseStateFail:
                           [SRUIUtil showAutoDisappearHUDWithMessage:@"分享失败" isDetail:NO];
                           break;
                       default:
                           break;
                   }
                   
               }];
}

@end

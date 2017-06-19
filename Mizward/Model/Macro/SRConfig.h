//
//  SRConfig.h
//  SiRuiV4.0
//
//  Created by zhangjunbo on 15/6/15.
//  Copyright (c) 2015年 SiRui. All rights reserved.
//

#ifndef SiRuiV4_0_SRConfig_h
#define SiRuiV4_0_SRConfig_h

#pragma mark - 数据库加密配置

#if DEBUG
    #define DataBaseEncrypd     (0)
#else
    #define DataBaseEncrypd     (0)
#endif

#pragma mark - HTTP网络配置

extern const NSTimeInterval kHttpTimeoutSeconds_sr;//HTTP相应超时

#pragma mark - TCP网络配置

extern const NSTimeInterval kTcpKeyAliveSeconds_sr;//TCP保活时间

extern const NSTimeInterval kTcpConnectTimeOutSeconds_sr;//TCP连接超时
extern const NSTimeInterval kTcpResponseTimeOutSeconds_sr;//TCP相应超时
extern const NSInteger kTcpMaxConnectRetryTimes_sr;//TCP重试最大次数

#pragma mark - SLB

extern const NSTimeInterval kSlbFrequencySeconds;//SLB间隔

#pragma mark - authCode

extern const NSTimeInterval kAuthCodeValidTime;//验证码失效时间

#pragma mark - Password

extern const NSTimeInterval kPasswordAvoidTime;//切入改后台后5分钟需要输入密码

#pragma mark - 游客账户 (二维码)

extern NSString * const SRLocalNotificationExperienceAlert;//体验即将到期
extern NSString * const SRLocalNotificationExperienceOverdue;//体验到期

#pragma mark - 体验账户

extern NSString * const SRExperienceAccount;//体验账号
extern NSString * const SRExperiencePassword;//体验密码

#endif

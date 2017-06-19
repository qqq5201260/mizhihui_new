//
//  SRConfig.c
//  SiRuiV4.0
//
//  Created by zhangjunbo on 15/7/13.
//  Copyright (c) 2015年 SiRui. All rights reserved.
//

#import "SRConfig.h"

#pragma mark - HTTP网络配置

const NSTimeInterval kHttpTimeoutSeconds_sr = 30; //HTTP相应超时30S

#pragma mark - TCP网络配置

const NSTimeInterval kTcpKeyAliveSeconds_sr = 2*60*NSEC_PER_SEC; //TCP保活时间2分钟

const NSTimeInterval kTcpConnectTimeOutSeconds_sr = 5*NSEC_PER_SEC; //TCP连接超时5S

const NSTimeInterval kTcpResponseTimeOutSeconds_sr = 30*NSEC_PER_SEC; //TCP相应超时30S

const NSInteger      kTcpMaxConnectRetryTimes_sr = 3; //TCP重试最大次数3次

#pragma mark - SLB

const NSTimeInterval kSlbFrequencySeconds = 10*60*NSEC_PER_SEC; //SLB间隔10分钟

#pragma mark - authCode

const NSTimeInterval kAuthCodeValidTime = 5*60; //验证码失效时间

#pragma mark - Password

const NSTimeInterval kPasswordAvoidTime = 10; //切入改后台后5分钟需要输入密码

#pragma mark - 游客账户

NSString * const SRLocalNotificationExperienceAlert = @"SRLocalNotificationExperienceAlert";
NSString * const SRLocalNotificationExperienceOverdue = @"SRLocalNotificationExperienceOverdue";

#pragma mark - 体验账户

NSString * const SRExperienceAccount = @"mizway";//体验账号
NSString * const SRExperiencePassword = @"123456";//体验密码
//
//  SRHttpUtil.h
//  SiRuiV4.0
//
//  Created by zhangjunbo on 15/6/15.
//  Copyright (c) 2015年 SiRui. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol AFMultipartFormData;

@interface SRHttpUtil : NSObject

+ (void)clearSession;

#pragma mark - 监测网络的可链接性
+ (BOOL) netWorkReachabilityWithURLString:(NSString *) strUrl;
+ (void) startNetWorkReachabilityMonitoring;

#pragma mark - POST请求
+ (void) POST:(NSString *)requestURLString WithParameter:(NSDictionary *)parameter completeBlock: (CompleteBlock)completeBlock;

+ (void) POST: (NSString *) requestURLString  WithParameter: (NSDictionary *) parameter completeBlock: (CompleteBlock) completeBlock autoRetry:(int)timesToRetry retryInterval:(int)intervalInSeconds;

+ (void) POST:(NSString *)requestURLString WithParameter:(NSDictionary *)parameter constructingBodyWithBlock:(void (^)(id <AFMultipartFormData> formData))block completeBlock: (CompleteBlock)completeBlock;

+ (void) POST:(NSString *)requestURLString WithParameter:(NSDictionary *)parameter constructingBodyWithBlock:(void (^)(id <AFMultipartFormData> formData))block completeBlock: (CompleteBlock)completeBlock autoRetry:(int)timesToRetry retryInterval:(int)intervalInSeconds;

#pragma mark - GET请求
+ (void) GET: (NSString *) requestURLString WithParameter: (NSDictionary *) parameter completeBlock: (CompleteBlock) completeBlock;

+ (void) GET: (NSString *) requestURLString WithParameter: (NSDictionary *) parameter completeBlock: (CompleteBlock) completeBlock autoRetry:(int)timesToRetry retryInterval:(int)intervalInSeconds;

@end

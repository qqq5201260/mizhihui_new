//
//  SRHttpUtil.m
//  SiRuiV4.0
//
//  Created by zhangjunbo on 15/6/15.
//  Copyright (c) 2015年 SiRui. All rights reserved.
//

#import "SRHttpUtil.h"
#import "SRURLUtil.h"
#import "SREventCenter.h"
#import <AFNetworking+AutoRetry/AFHTTPSessionManager+AutoRetry.h>
#import <AFNetworking+AutoRetry/AFHTTPRequestOperationManager+AutoRetry.h>

@implementation SRHttpUtil

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self startNetWorkReachabilityMonitoring];
    });
}

+ (void)clearSession {
    NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    NSArray *cookies = [storage cookiesForURL:[NSURL URLWithString:[SRURLUtil BaseURL_Portal]]];
    for (NSHTTPCookie *cookie in cookies) {
        [storage deleteCookie:cookie];
    }
    
//    cookies = [storage cookiesForURL:[NSURL URLWithString:[SRURLUtil BaseURL_Online]]];
//    for (NSHTTPCookie *cookie in cookies) {
//        [storage deleteCookie:cookie];
//    }
    
    cookies = [storage cookiesForURL:[NSURL URLWithString:[SRURLUtil BaseURL_PhoneApp]]];
    for (NSHTTPCookie *cookie in cookies) {
        [storage deleteCookie:cookie];
    }
}

#pragma mark - 监测网络的可链接性
+ (BOOL) netWorkReachabilityWithURLString:(NSString *) strUrl
{
    __block BOOL netState = NO;
    NSURL *baseURL = [NSURL URLWithString:strUrl];
    
    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:baseURL];
    [manager.reachabilityManager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        switch (status) {
            case AFNetworkReachabilityStatusReachableViaWWAN:
            case AFNetworkReachabilityStatusReachableViaWiFi:
                netState = YES;
                break;
            case AFNetworkReachabilityStatusNotReachable:
                netState = NO;
            default:
                break;
        }
    }];
    
    return netState;
}

+ (void) startNetWorkReachabilityMonitoring {
    [[AFHTTPRequestOperationManager manager].reachabilityManager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        
        [[SREventCenter sharedInterface] netWorkReachabilityChange:status];
        
        switch (status) {
            case AFNetworkReachabilityStatusReachableViaWWAN:
                NSLog(@"当前网络---WWAN");
                break;
            case AFNetworkReachabilityStatusReachableViaWiFi:
                NSLog(@"当前网络---WiFi");
                break;
            case AFNetworkReachabilityStatusNotReachable:
                NSLog(@"当前网络---无网络");
            default:
                break;
        }
    }];
    [[AFHTTPRequestOperationManager manager].reachabilityManager startMonitoring];
}

#pragma mark - POST请求
+ (void) POST:(NSString *)requestURLString WithParameter:(NSDictionary *)parameter completeBlock: (CompleteBlock) completeBlock {
    [self POST:requestURLString WithParameter:parameter completeBlock:completeBlock autoRetry:0 retryInterval:0];
}

+ (void) POST: (NSString *) requestURLString WithParameter: (NSDictionary *) parameter completeBlock: (CompleteBlock) completeBlock autoRetry:(int)timesToRetry retryInterval:(int)intervalInSeconds {
    
    SRLogDebug(@"%@ %@", requestURLString, parameter);
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    if (!manager.reachabilityManager.reachable) {
        NSError *error = [NSError errorWithDomain:SRLocal(@"string_http_-1005")
                                             code:SRHTTP_NetUnreachable
                                         userInfo:nil];
        completeBlock(error, nil);
        return;
    }
    
    manager.requestSerializer.timeoutInterval = kHttpTimeoutSeconds_sr;
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/plain", @"text/html", @"text/javascript", @"application/json", nil];
    [manager POST:requestURLString parameters:parameter success:^(AFHTTPRequestOperation *operation, id responseObject) {
        SRLogDebug(@"%@", requestURLString);
        SRLogDebug(@"%@", responseObject);
        completeBlock(nil, responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        SRLogError(@"%@", error);
        completeBlock([self errorWithError:error], nil);
    } autoRetry:timesToRetry retryInterval:intervalInSeconds];
    
}

+ (void) POST:(NSString *)requestURLString WithParameter:(NSDictionary *)parameter constructingBodyWithBlock:(void (^)(id <AFMultipartFormData> formData))block completeBlock: (CompleteBlock)completeBlock
{
    [self POST:requestURLString WithParameter:parameter constructingBodyWithBlock:block completeBlock:completeBlock autoRetry:0 retryInterval:0];
}

+ (void) POST:(NSString *)requestURLString WithParameter:(NSDictionary *)parameter constructingBodyWithBlock:(void (^)(id <AFMultipartFormData> formData))block completeBlock: (CompleteBlock)completeBlock autoRetry:(int)timesToRetry retryInterval:(int)intervalInSeconds
{
    SRLogDebug(@"%@ %@", requestURLString, parameter);
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    if (!manager.reachabilityManager.reachable) {
        NSError *error = [NSError errorWithDomain:SRLocal(@"string_http_-1005")
                                             code:SRHTTP_NetUnreachable
                                         userInfo:nil];
        completeBlock(error, nil);
        return;
    }
    
    manager.requestSerializer.timeoutInterval = kHttpTimeoutSeconds_sr;
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/plain", @"text/html", @"text/javascript", @"application/json", nil];
    [manager POST:requestURLString parameters:parameter constructingBodyWithBlock:block success:^(AFHTTPRequestOperation *operation, id responseObject) {
        SRLogDebug(@"%@", requestURLString);
        SRLogDebug(@"%@", responseObject);
        completeBlock(nil, responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        completeBlock([self errorWithError:error], nil);
    } autoRetry:timesToRetry retryInterval:intervalInSeconds];
}

#pragma GET请求
+ (void) GET: (NSString *) requestURLString WithParameter: (NSDictionary *) parameter completeBlock: (CompleteBlock) completeBlock {
    [self GET:requestURLString WithParameter:parameter completeBlock:completeBlock autoRetry:0 retryInterval:0];
}

+ (void) GET: (NSString *) requestURLString WithParameter: (NSDictionary *) parameter completeBlock: (CompleteBlock) completeBlock autoRetry:(int)timesToRetry retryInterval:(int)intervalInSeconds {
    
    SRLogDebug(@"%@ %@", requestURLString, parameter);
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    if (!manager.reachabilityManager.reachable) {
        NSError *error = [NSError errorWithDomain:SRLocal(@"string_http_-1005")
                                             code:SRHTTP_NetUnreachable
                                         userInfo:nil];
        completeBlock(error, nil);
        return;
    }
    
    manager.requestSerializer.timeoutInterval = kHttpTimeoutSeconds_sr;
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/plain", @"text/html", @"text/javascript", @"application/json", nil];
    [manager GET:requestURLString parameters:parameter success:^(AFHTTPRequestOperation *operation, id responseObject) {
        SRLogDebug(@"%@", responseObject);
        completeBlock(nil, responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        completeBlock([self errorWithError:error], nil);
    } autoRetry:timesToRetry retryInterval:intervalInSeconds];
}

+ (NSError *)errorWithError:(NSError *)error
{
    NSString *errorDomain;
    switch (error.code) {
        case SRHTTP_NotConnected:
            errorDomain = SRLocal(@"string_http_-1005");
            break;
        case SRHTTP_TimeOut:
            errorDomain = SRLocal(@"string_http_-1001");
            break;
        case SRHTTP_NetUnreachable:
            errorDomain = SRLocal(@"string_http_-1005");
            break;
        case SRHTTP_UserNameOrPasswordError:
            errorDomain = SRLocal(@"string_http_5");
            break;
            
        default:
            errorDomain = SRLocal(@"string_http_error");
            break;
    }
    
   return  [[NSError alloc] initWithDomain:errorDomain code:error.code userInfo:error.userInfo];
}

@end

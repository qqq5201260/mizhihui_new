//
//  SRSLBMod.m
//  SiRuiV4.0
//
//  Created by zhangjunbo on 15/6/17.
//  Copyright (c) 2015年 SiRui. All rights reserved.
//

#import "SRSLBMod.h"
#import "SRNotificationCenter.h"
#import "SRHttpUtil.h"
#import "SRURLUtil.h"
#import "SRSLBServerInfo.h"
#import <AFNetworking/AFNetworking.h>
#import <MJExtension/MJExtension.h>

NSString * const server4SPortal = @"4sportal";
NSString * const server4SOnline = @"4sonline";
NSString * const serverPhoneApp = @"phoneapp";
NSString * const serverTcp      = @"tcp";
NSString * const serverExtended = @"extended";

static dispatch_queue_t slb_sync_queue() {
    static dispatch_queue_t sr_slb_sync_queue;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sr_slb_sync_queue = dispatch_queue_create("com.sirui.slb", DISPATCH_QUEUE_CONCURRENT);
    });
    
    return sr_slb_sync_queue;
}

@interface SRSLBMod ()
{
    dispatch_source_t slbTimer;
}

@property (nonatomic, strong) id networkObserver;
@property (nonatomic, strong) id applicationOberver;

@end

@implementation SRSLBMod
{
    BOOL didResivedResponse;
}

Singleton_Implementation(SRSLBMod)

+ (void)load
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __block id observer = [SRNotificationCenter sr_addObserverForName:UIApplicationDidFinishLaunchingNotification object:nil queue:nil usingBlock:^(NSNotification *note) {
            [SRNotificationCenter sr_removeObserver:observer];
            
            [self sharedInterface];
        }];
    });
}

- (void)dealloc {
    [SRNotificationCenter sr_removeObserver:_applicationOberver];
}

- (instancetype)init {
    if (self = [super init]) {
        
        @weakify(self)
        _applicationOberver = [SRNotificationCenter sr_addObserverForName:UIApplicationDidBecomeActiveNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *note) {
            @strongify(self)
            [self getSLBFromServerWithCompleteBlock:nil];
        }];
        
        _networkObserver = [SRNotificationCenter sr_addObserverForName:AFNetworkingReachabilityDidChangeNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *note) {
            @strongify(self)
            [self getSLBFromServerWithCompleteBlock:nil];
        }];
        
        slbTimer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, slb_sync_queue());
        dispatch_source_set_timer(slbTimer, dispatch_walltime(DISPATCH_TIME_NOW, kSlbFrequencySeconds), kSlbFrequencySeconds, 0.0);
        dispatch_source_set_event_handler(slbTimer, ^{
            @strongify(self)
            [self getSLBFromServerWithCompleteBlock:nil];
        });
        dispatch_source_set_cancel_handler(slbTimer, ^{
        });
        
        dispatch_resume(slbTimer);
    }
    
    return self;
}

- (void)getSLBFromServerWithCompleteBlock:(CompleteBlock)completeBlock {
    
    didResivedResponse = NO;
    
    CompleteBlock block = ^(NSError *error, id responseObject){
        if (error) {
            if (completeBlock) completeBlock(nil, @(NO));
            return ;
        }
        if (self->didResivedResponse) return ;
        
        self->didResivedResponse = YES;
        
        NSArray *list = [SRSLBServerInfo objectArrayWithKeyValuesArray:responseObject[@"serverList"]];
        
        [list enumerateObjectsUsingBlock:^(SRSLBServerInfo *obj, NSUInteger idx, BOOL *stop) {
            if (!obj.enabled) return ;
            NSMutableString *strURL = [NSMutableString stringWithString:@"http://"];
            if (obj.ip) {
                [strURL appendString:obj.ip];
            }
            
            if (obj.port) {
                [strURL appendFormat:@":%@", obj.port];
            }
            
            if ([obj.server isEqualToString:server4SPortal]) {
                [SRURLUtil setBaseURL_Portal:strURL];
            } else if ([obj.server isEqualToString:server4SOnline]) {
                [SRURLUtil setBaseURL_Online:strURL];
            } else if ([obj.server isEqualToString:serverPhoneApp]) {
                [SRURLUtil setBaseURL_PhoneApp:strURL];
            } else if ([obj.server isEqualToString:serverTcp]) {
                [SRURLUtil setTcpHost:obj.ip];
                [SRURLUtil setTcpPort:obj.port.integerValue];
            } else {
                
            }
        }];
        
        if (completeBlock) completeBlock(nil, @(YES));
    };
    
    [SRHttpUtil POST:[SRURLUtil SLB_IPUrl] WithParameter:nil completeBlock:block];
    
    [SRHttpUtil POST:[SRURLUtil SLB_DNSUrl] WithParameter:nil completeBlock:block];
    
}

@end

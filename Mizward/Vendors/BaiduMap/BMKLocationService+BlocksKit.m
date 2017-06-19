//
//  BMKLocationService+BlocksKit.m
//  SiRuiV4.0
//
//  Created by zhangjunbo on 15/7/4.
//  Copyright (c) 2015年 SiRui. All rights reserved.
//

#import "BMKLocationService+BlocksKit.h"
#import <BlocksKit/A2DynamicDelegate.h>
#import <BlocksKit/NSObject+A2BlockDelegate.h>
#import <BlocksKit/NSObject+A2DynamicDelegate.h>

#pragma mark Delegate

@interface A2DynamicBMKLocationServiceDelegate : A2DynamicDelegate <BMKLocationServiceDelegate>

@end

@implementation A2DynamicBMKLocationServiceDelegate

- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
    id realDelegate = self.realDelegate;
    if (realDelegate && [realDelegate respondsToSelector:@selector(didUpdateBMKUserLocation:)])
        [realDelegate didUpdateBMKUserLocation:userLocation];
    
    void (^block)(BMKUserLocation *userLocation) = [self blockImplementationForMethod:_cmd];
    if (block)
        block(userLocation);
}



@end

@implementation BMKLocationService (BlocksKit)

@dynamic bk_didUpdateBMKUserLocation;

+ (void)load
{
    @autoreleasepool {
        [self bk_registerDynamicDelegate];
        [self bk_linkDelegateMethods:@{
                                       @"bk_didUpdateBMKUserLocation": @"didUpdateBMKUserLocation:"
                                       }];
    }
}

@end

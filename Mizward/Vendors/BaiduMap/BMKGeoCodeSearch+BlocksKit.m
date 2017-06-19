//
//  BMKGeoCodeSearch+BlocksKit.m
//  SiRuiV4.0
//
//  Created by zhangjunbo on 15/7/4.
//  Copyright (c) 2015年 SiRui. All rights reserved.
//

#import "BMKGeoCodeSearch+BlocksKit.h"
#import <BlocksKit/A2DynamicDelegate.h>
#import <BlocksKit/NSObject+A2BlockDelegate.h>
#import <BlocksKit/NSObject+A2DynamicDelegate.h>

#pragma mark Delegate

@interface A2DynamicBMKGeoCodeSearchDelegate : A2DynamicDelegate <BMKGeoCodeSearchDelegate>

@end

@implementation A2DynamicBMKGeoCodeSearchDelegate

- (void)onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error
{
    id realDelegate = self.realDelegate;
    if (realDelegate && [realDelegate respondsToSelector:@selector(onGetReverseGeoCodeResult:result:errorCode:)])
        [realDelegate onGetReverseGeoCodeResult:searcher result:result errorCode:error];
    
    void (^block)(BMKGeoCodeSearch *searcher , BMKReverseGeoCodeResult *result, BMKSearchErrorCode error) = [self blockImplementationForMethod:_cmd];
    if (block)
        block(searcher, result, error);
}



@end


@implementation BMKGeoCodeSearch (BlocksKit)

@dynamic bk_onGetReverseGeoCodeResult;

+ (void)load
{
    @autoreleasepool {
        [self bk_registerDynamicDelegate];
        [self bk_linkDelegateMethods:@{
                                       @"bk_onGetReverseGeoCodeResult": @"onGetReverseGeoCodeResult:result:errorCode:"
                                       }];
    }
}

@end

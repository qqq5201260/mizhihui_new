//
//  MJExtensionConfig.m
//  SiRuiV4.0
//
//  Created by zhangjunbo on 15/6/16.
//  Copyright (c) 2015年 SiRui. All rights reserved.
//

#import "MJExtensionConfig.h"
#import <MJExtension/MJExtension.h>

#import "SRTCPResponseBody.h"
#import "SRSMSCommandVos.h"
#import "SRSeriesInfo.h"
#import "SRVehicleBasicInfo.h"
#import "SRIMMessage.h"
#import "SRMaintainReserveInfo.h"
#import "SRMaintainResponse.h"
#import "SRMaintainHistory.h"

@implementation MJExtensionConfig

+ (void)load {

#pragma mark SRTCPResponseBody类中的parameters数组存放的是SRTLV模型
    [SRTCPResponseBody setupObjectClassInArray:^NSDictionary *{
        return @{
                 @"parameters" : @"SRTLV"
                 };
    }];

#pragma mark SRSMSCommandVos类中的smsCommandVos数组存放的是SRTLV模型
    [SRSMSCommandVos setupObjectClassInArray:^NSDictionary *{
        return @{
                 @"smsCommandVos" : @"SRTLV"
                 };
    }];
    
#pragma mark SRSeriesInfo类中的vehicleModelVOs数组存放的是SRVehicleInfo模型
    [SRSeriesInfo setupObjectClassInArray:^NSDictionary *{
        return @{
                 @"vehicleModelVOs" : @"SRVehicleInfo"
                 };
    }];
    
#pragma mark SRVehicleBasicInfo类中的abilities数组存放的是SRTLV模型
    [SRVehicleBasicInfo setupObjectClassInArray:^NSDictionary *{
        return @{
                 @"abilities_v2" : @"SRTLV"
                 };
    }];

#pragma mark SRIMInfo类中的ID 替换为id
    [SRIMMessage setupReplacedKeyFromPropertyName:^NSDictionary *{
        return @{
                 @"ID" : @"id"
                 };
    }];
    
#pragma mark SRMaintainReserveInfo类中的uncommonMaintenItems数组存放的是SRMaintainUncommonItem模型
    [SRMaintainReserveInfo setupObjectClassInArray:^NSDictionary *{
        return @{
                 @"uncommonMaintenItems" : @"SRMaintainUncommonItem"
                 };
    }];
    
#pragma mark SRMaintainDepResponse类中的depVOs数组存放的是SRMaintainDepInfo模型
    [SRMaintainDepResponse setupObjectClassInArray:^NSDictionary *{
        return @{
                 @"depVOs" : @"SRMaintainDepInfo"
                 };
    }];
    
#pragma mark SRMaintainHistory类中的uncommonMaintenItems数组存放的是SRMaintainUncommonItem模型
    [SRMaintainHistory setupObjectClassInArray:^NSDictionary *{
        return @{
                 @"uncommonMaintenItems" : @"SRMaintainUncommonItem"
                 };
    }];
}

@end

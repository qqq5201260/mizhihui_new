//
//  SRRealmMaintainReserve.m
//  Mizward
//
//  Created by zhangjunbo on 15/9/1.
//  Copyright (c) 2015年 Mizward. All rights reserved.
//

#import "SRRealmMaintainReserve.h"
#import "SRMaintainReserveInfo.h"
#import "SRUserDefaults.h"

@implementation SRRealmMaintainReserve

+ (nullable NSString *)primaryKey
{
    return @"maintenReservationID";
}

- (instancetype)initWithMaintainReserveInfo:(SRMaintainReserveInfo *)info
{
    if (self = [super init]) {
        _maintenReservationID = info.maintenReservationID;
        _maintenID = info.maintenID;
        _currentMileage = info.currentMileage;
        _nextMileage = info.nextMileage;
        _status = info.status;
        _commonMaintenItemsTop = info.commonMaintenItemsTopString?info.commonMaintenItemsTopString:@"";
        _commonMaintenItemsBottom = info.commonMaintenItemsBottomString?info.commonMaintenItemsBottomString:@"";
        _uncommonMaintenItems = info.uncommonMaintenItemsString?info.uncommonMaintenItemsString:@"";
        
        _customerID = [SRUserDefaults customerID];
        _vehicleID = [SRUserDefaults currentVehicleID];
    }
    return self;
}

- (SRMaintainReserveInfo *)maintainReserveInfo
{
    SRMaintainReserveInfo *info = [[SRMaintainReserveInfo alloc] init];
    info.maintenReservationID = self.maintenReservationID;
    info.maintenID = self.maintenID;
    info.currentMileage = self.currentMileage;
    info.nextMileage = self.nextMileage;
    info.status = self.status;
    [info setCommonMaintenItemsTopWithString:self.commonMaintenItemsTop];
    [info setCommonMaintenItemsBottomWithString:self.commonMaintenItemsBottom];
    [info setUncommonMaintenItemsWithString:self.uncommonMaintenItems];
    return info;
}

@end

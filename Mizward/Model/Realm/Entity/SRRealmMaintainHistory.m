//
//  SRRealmMaintainHistory.m
//  Mizward
//
//  Created by zhangjunbo on 15/9/1.
//  Copyright (c) 2015年 Mizward. All rights reserved.
//

#import "SRRealmMaintainHistory.h"
#import "SRMaintainHistory.h"

@implementation SRRealmMaintainHistory

+ (nullable NSString *)primaryKey
{
    return @"maintenReservationID";
}

- (instancetype)initWithMaintainHistory:(SRMaintainHistory*)history
{
    if (self = [super init]) {
        _maintenReservationID = history.maintenReservationID;
        _maintenID = history.maintenID;
        _customerID = history.customerID;
        _vehicleID = history.vehicleID;
        _depID = history.depID;
        _depName = history.depName?history.depName:@"";
        _currentMileage = history.currentMileage;
        _fee = history.fee;
        _status = history.status;
        _type = history.type;
        _isIgnore = history.isIgnore;
        _startTimeStr = history.startTimeStr?history.startTimeStr:@"";
        _commonMaintenItems = history.commonMaintenItemsString?history.commonMaintenItemsString:@"";
        _uncommonMaintenItems = history.uncommonMaintenItemsString?history.uncommonMaintenItemsString:@"";
        _defineMaintenItems = history.defineMaintenItemsString?history.defineMaintenItemsString:@"";
    }
    
    return self;
}

- (SRMaintainHistory *)maintainHistory
{
    SRMaintainHistory *history = [[SRMaintainHistory alloc] init];
    history.maintenReservationID = self.maintenReservationID;
    history.maintenID = self.maintenID;
    history.customerID = self.customerID;
    history.vehicleID = self.vehicleID;
    history.depID = self.depID;
    history.depName = self.depName;
    history.currentMileage = self.currentMileage;
    history.fee = self.fee;
    history.status = self.status;
    history.type = self.type;
    history.isIgnore = self.isIgnore;
    history.startTimeStr = self.startTimeStr;
    [history setCommonMaintenItemsWithString:self.commonMaintenItems];
    [history setUncommonMaintenItemsWithString:self.uncommonMaintenItems];
    [history setDefineMaintenItemsWithString:self.defineMaintenItems];
    return history;
}

@end

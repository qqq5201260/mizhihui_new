//
//  SRRealmTrip.m
//  Mizward
//
//  Created by zhangjunbo on 15/9/1.
//  Copyright (c) 2015年 Mizward. All rights reserved.
//

#import "SRRealmTrip.h"
#import "SRTripInfo.h"
#import "SRUserDefaults.h"

@implementation SRRealmTrip

+ (nullable NSString *)primaryKey
{
    return @"tripID";
}

- (instancetype)initWithTripInfo:(SRTripInfo *)info
{
    if (self = [super init]) {
        _tripID = info.tripID?info.tripID:@"";
        _startTime = info.startTime?info.startTime:@"";
        _endTime = info.endTime?info.endTime:@"";
        _mileage = info.mileage;
        _fuelCons = info.fuelCons;
        _avgFuelCons = info.avgFuelCons;
        _fee = info.fee;
        _startLat = info.startLat;
        _startLng = info.startLng;
        _endLat = info.endLat;
        _endLng = info.endLng;
        
        _vehicleID = [SRUserDefaults currentVehicleID];
    }
    return self;
}

- (SRTripInfo *)tripInfo
{
    SRTripInfo *info = [[SRTripInfo alloc] init];
    info.tripID = self.tripID;
    info.startTime = self.startTime;
    info.endTime = self.endTime;
    info.mileage = self.mileage;
    info.fuelCons = self.fuelCons;
    info.avgFuelCons = self.avgFuelCons;
    info.fee = self.fee;
    info.startLat = self.startLat;
    info.startLng = self.startLng;
    info.endLat = self.endLat;
    info.endLng = self.endLng;
    return info;
}

@end

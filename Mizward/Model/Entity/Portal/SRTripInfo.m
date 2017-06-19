//
//  SRTripInfo.m
//  SiRuiV4.0
//
//  Created by zhangjunbo on 15/6/16.
//  Copyright (c) 2015年 SiRui. All rights reserved.
//

#import "SRTripInfo.h"
#import "SRUserDefaults.h"

@implementation SRTripInfo

- (instancetype)init {
    if (self = [super init]) {
        _vehicleID = [SRUserDefaults currentVehicleID];
    }
    
    return self;
}

- (void)setStartTime:(NSString *)startTime {
    _startTime = [NSString LocalTimeString_YYYYMMddHHmmss:startTime];
}

- (void)setEndTime:(NSString *)endTime {
    _endTime = [NSString LocalTimeString_YYYYMMddHHmmss:endTime];
}

- (void)setStartTimeLocal:(NSString *)startTime {
    _startTime = startTime;
}

- (void)setEndTimeLocal:(NSString *)endTime {
    _endTime = endTime;
}

@end

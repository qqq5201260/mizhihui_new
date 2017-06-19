//
//  SRVehicleStatusInfo.m
//  SiRuiV4.0
//
//  Created by zhangjunbo on 15/6/16.
//  Copyright (c) 2015年 SiRui. All rights reserved.
//

#import "SRVehicleStatusInfo.h"
#import "SRUserDefaults.h"

@implementation SRVehicleStatusInfo

- (void)setGpsTime:(NSString *)gpsTime {
    _gpsTime = [NSString LocalTimeString_YYYYMMddHHmmss:gpsTime];
}

- (void)setGpsTimeLocal:(NSString *)gpsTime {
    _gpsTime = gpsTime;
}

- (NSInteger)isOnline {
    if ([SRUserDefaults isExperienceUser]) {
        return 1;
    } else {
        return _isOnline;
    }
}

@end

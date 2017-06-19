//
//  SRTripPoint.m
//  SiRuiV4.0
//
//  Created by zhangjunbo on 15/6/16.
//  Copyright (c) 2015年 SiRui. All rights reserved.
//

#import "SRTripPoint.h"
#import <MJExtension/MJExtension.h>

@implementation SRTripPoint

- (void)setUTCTime:(NSString *)uTCTime {
    _uTCTime = uTCTime;
    _localTime = [NSString LocalTimeString_YYYYMMddHHmmss:uTCTime];
}

- (CLLocationCoordinate2D)location
{
    return CLLocationCoordinate2DMake(self.lat, self.lng);
}

- (NSDictionary *)customerDictionaryValue {
    NSMutableDictionary *customer = [NSMutableDictionary dictionaryWithDictionary:self.keyValues];
    [customer removeObjectForKey:@"location"];
    return customer;
}

@end

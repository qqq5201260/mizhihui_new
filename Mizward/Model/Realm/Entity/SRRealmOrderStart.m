//
//  SRRealmOrderStart.m
//  Mizward
//
//  Created by zhangjunbo on 15/9/1.
//  Copyright (c) 2015年 Mizward. All rights reserved.
//

#import "SRRealmOrderStart.h"
#import "SROrderStartInfo.h"
#import "SRUserDefaults.h"

@implementation SRRealmOrderStart

+ (nullable NSString *)primaryKey
{
    return @"startClockID";
}

- (instancetype)initWithOrderStartInfo:(SROrderStartInfo *)info
{
    if (self = [super init]) {
        _startClockID = info.startClockID;
        _type = info.type;
        _vehicleID = info.vehicleID;
        _startTime = info.startTime?info.startTime:@"";
        _isRepeat = info.isRepeat;
        _startTimeLength = info.startTimeLength;
        _repeatType = info.repeatType?info.repeatType:@"";
        _isOpen = info.isOpen;
        _customerID = [SRUserDefaults customerID];
    }
    return self;
}

- (SROrderStartInfo *)orderStartInfo
{
    SROrderStartInfo *info = [[SROrderStartInfo alloc] init];
    info.startClockID = self.startClockID;
    info.type = self.type;
    info.vehicleID = self.vehicleID;
    info.startTime = self.startTime;
    info.isRepeat = self.isRepeat;
    info.startTimeLength = self.startTimeLength;
    info.repeatType = self.repeatType;
    info.isOpen = self.isOpen;
    return info;
}

@end

//
//  SRRealmMaintainDep.m
//  Mizward
//
//  Created by zhangjunbo on 15/9/1.
//  Copyright (c) 2015年 Mizward. All rights reserved.
//

#import "SRRealmMaintainDep.h"
#import "SRMaintainDepInfo.h"

@implementation SRRealmMaintainDep

+ (nullable NSString *)depID
{
    return @"customerID";
}

- (instancetype)initWithMaintainDepInfo:(SRMaintainDepInfo *)info
{
    if (self = [super init]) {
        _depID = info.depID;
        _name = info.name?info.name:@"";
        _lat = info.lat;
        _lng = info.lng;
        _address = info.address?info.address:@"";
        _phone = info.phone?info.phone:@"";
    }
    
    return self;
}

- (SRMaintainDepInfo *)maintainDepInfo
{
    SRMaintainDepInfo *info = [[SRMaintainDepInfo alloc] init];
    info.depID = self.depID;
    info.name = self.name;
    info.lat = self.lat;
    info.lng = self.lng;
    info.address = self.address;
    info.phone = self.phone;
    return info;
}

@end

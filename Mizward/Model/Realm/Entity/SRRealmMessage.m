//
//  SRRealmMessage.m
//  Mizward
//
//  Created by zhangjunbo on 15/9/1.
//  Copyright (c) 2015年 Mizward. All rights reserved.
//

#import "SRRealmMessage.h"
#import "SRMessageInfo.h"

@implementation SRRealmMessage

+ (nullable NSString *)primaryKey
{
    return @"msgid";
}

- (instancetype)initWithMessageInfo:(SRMessageInfo *)info
{
    if (self = [super init]) {
        _type = info.type;
        _msgtype = info.msgtype;
        _msgid = info.msgid;
        _customerid = info.customerid;
        _vehicleid = info.vehicleid;
        _message = info.message?info.message:@"";
        _time = info.time?info.time:@"";
    }
    return self;
}

- (SRMessageInfo *)messageInfo
{
    SRMessageInfo *info = [[SRMessageInfo alloc] init];
    info.type = self.type;
    info.msgtype = self.msgtype;
    info.msgid = self.msgid;
    info.customerid = self.customerid;
    info.vehicleid = self.vehicleid;
    info.message = self.message;
    info.time = self.time;
    return info;
}

@end

//
//  SRTCPLoginBody.m
//  SiRuiV4.0
//
//  Created by zhangjunbo on 15/6/16.
//  Copyright (c) 2015年 SiRui. All rights reserved.
//

#import "SRTCPReqLoginBody.h"
#import "SRKeychain.h"

@implementation SRTCPReqLoginBody

- (instancetype)init {
    self = [super init];
    if (self) {
        _clientType = 4;
        _protocolVersion = @"3.0.1";
        _hardWareversion = CurrentSystemVersion;
        _softwareVersion = CurrentAPPVersion;
        _token = [SRKeychain UUID];
    }
    
    return self;
}

@end

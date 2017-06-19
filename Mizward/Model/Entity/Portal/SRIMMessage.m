//
//  SRIMMessage.m
//  SiRuiV4.0
//
//  Created by zhangjunbo on 15/6/25.
//  Copyright (c) 2015年 SiRui. All rights reserved.
//

#import "SRIMMessage.h"
#import "SRUserDefaults.h"

@implementation SRIMMessage

- (instancetype)init {
    if (self = [super init]) {
        _customerID = [SRUserDefaults customerID];
    }
    return self;
}

- (void)setAdddate:(NSString *)adddate
{
    _adddate = adddate;
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    @try {
        if ([adddate rangeOfString:@"."].location == NSNotFound) {
            [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
        } else {
            [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss.SSS"];
        }
        _date = [formatter dateFromString:adddate];
    }
    @catch (NSException *exception) {
        _date = [NSDate date];
    }
}

@end

//
//  SRAPNsMessageInfo.m
//  SiRuiV4.0
//
//  Created by zhangjunbo on 15/7/15.
//  Copyright (c) 2015年 SiRui. All rights reserved.
//

#import "SRAPNsMessageInfo.h"

NSString * const dicSeparater = @"ξ";
NSString * const arraySeparater = @",";

@implementation SRAPNsMessageInfo

- (void)setO:(NSString *)o
{
    _o = o;
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    NSArray *list = [o componentsSeparatedByString:arraySeparater];
    [list enumerateObjectsUsingBlock:^(NSString * obj, NSUInteger idx, BOOL *stop) {
        NSArray *temp = [obj componentsSeparatedByString:dicSeparater];
        [dic setObject:temp[1] forKey:temp[0]];
    }];
    
    self.object = dic;
}

@end

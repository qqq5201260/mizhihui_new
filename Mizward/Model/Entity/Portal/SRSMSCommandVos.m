//
//  SRSMSCommandVos.m
//  SiRuiV4.0
//
//  Created by zhangjunbo on 15/6/16.
//  Copyright (c) 2015年 SiRui. All rights reserved.
//

#import "SRSMSCommandVos.h"
#import "SRTLV.h"
#import <MJExtension/MJExtension.h>

@implementation SRSMSCommandVos

- (NSString *)stringValue
{
    if (!self.smsCommandVos || self.smsCommandVos.count == 0) return nil;
    
    NSMutableArray *array = [NSMutableArray array];
    [self.smsCommandVos enumerateObjectsUsingBlock:^(SRTLV *obj, NSUInteger idx, BOOL *stop) {
        NSError *error = nil;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:obj.keyValues options:NSJSONWritingPrettyPrinted error:&error];
        if (!error) {
            NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
            [array addObject:jsonString];
        }
    }];
    
    return [array componentsJoinedByString:@"*"];
}

- (instancetype)initWithString:(NSString *)aString
{
    if (self = [super init]) {
        NSArray *jsonArray = [aString componentsSeparatedByString:@"*"];
        
        NSMutableArray *abilities = [NSMutableArray array];
        [jsonArray enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL *stop) {
            NSData *jsonData = [obj dataUsingEncoding:NSUTF8StringEncoding];
            NSError *error = nil;
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableLeaves error:&error];
            if (!error) {
                SRTLV *tlv = [SRTLV objectWithKeyValues:dic];
                [abilities addObject:tlv];
            }
        }];
        
        self.smsCommandVos = abilities;
    }
    
    return self;
}

- (NSString *)getSMSCommandStringWithTag:(SRTLVTag_Instruction)tag
{
    if (!self.smsCommandVos) return nil;
    
    __block NSString *smsCommandString;
    [self.smsCommandVos enumerateObjectsUsingBlock:^(SRTLV *obj, NSUInteger idx, BOOL *stop) {
        if (obj.tag == tag) {
            *stop = YES;
            smsCommandString = obj.value;
        }
    }];
    return smsCommandString;
}

@end

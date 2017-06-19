//
//  SRMaintainHistory.m
//  SiRuiV4.0
//
//  Created by zhangjunbo on 15/7/29.
//  Copyright (c) 2015年 SiRui. All rights reserved.
//

#import "SRMaintainHistory.h"
#import "SRMaintainUncommonItem.h"
#import <MJExtension/MJExtension.h>

@implementation SRMaintainHistory

- (SRMaintainUncommonItem *)uncommonMaintenItemWithName:(NSString *)name
{
    if (!self.uncommonMaintenItems || self.uncommonMaintenItems.count == 0) {
        return nil;
    }
    
    __block SRMaintainUncommonItem *item;
    [self.uncommonMaintenItems enumerateObjectsUsingBlock:^(SRMaintainUncommonItem *obj, NSUInteger idx, BOOL *stop) {
        if ([obj.name isEqualToString:name]) {
            item = obj;
            *stop = YES;
        }
    }];
    
    return item;
}

- (NSString *)commonMaintenItemsString
{
    if (!self.commonMaintenItems || self.commonMaintenItems.count == 0) return nil;
    
    return [self.commonMaintenItems componentsJoinedByString:@"*"];
}

- (void)setCommonMaintenItemsWithString:(NSString *)string
{
    if (!string) return;
    
    self.commonMaintenItems = [string componentsSeparatedByString:@"*"];
}

- (NSString *)uncommonMaintenItemsString
{
    if (!self.uncommonMaintenItems || self.uncommonMaintenItems.count == 0) return nil;
    
    NSMutableArray *array = [NSMutableArray array];
    [self.uncommonMaintenItems enumerateObjectsUsingBlock:^(SRMaintainUncommonItem *obj, NSUInteger idx, BOOL *stop) {
        NSError *error = nil;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:obj.keyValues options:NSJSONWritingPrettyPrinted error:&error];
        if (!error) {
            NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
            [array addObject:jsonString];
        }
    }];
    
    return [array componentsJoinedByString:@"*"];
}

- (void)setUncommonMaintenItemsWithString:(NSString *)string
{
    if (!string) return;
    
    NSArray *jsonArray = [string componentsSeparatedByString:@"*"];
    
    NSMutableArray *uncommonMaintenItems = [NSMutableArray array];
    [jsonArray enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL *stop) {
        NSData *jsonData = [obj dataUsingEncoding:NSUTF8StringEncoding];
        NSError *error = nil;
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableLeaves error:&error];
        if (!error) {
            SRMaintainUncommonItem *item = [SRMaintainUncommonItem objectWithKeyValues:dic];
            [uncommonMaintenItems addObject:item];
        }
    }];
    
    self.uncommonMaintenItems = uncommonMaintenItems;
}

- (NSString *)defineMaintenItemsString
{
    if (!self.defineMaintenItems || self.defineMaintenItems.count == 0) return nil;
    
    return [self.defineMaintenItems componentsJoinedByString:@"*"];
}

- (void)setDefineMaintenItemsWithString:(NSString *)string
{
    if (!string) return;
    
    self.defineMaintenItems = [string componentsSeparatedByString:@"*"];
}

@end

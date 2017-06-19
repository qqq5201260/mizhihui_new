//
//  SRMaintainReserveInfo.m
//  SiRuiV4.0
//
//  Created by zhangjunbo on 15/7/27.
//  Copyright (c) 2015年 SiRui. All rights reserved.
//

#import "SRMaintainReserveInfo.h"
#import "SRUserDefaults.h"
#import "SRMaintainUncommonItem.h"
#import <MJExtension/MJExtension.h>

@implementation SRMaintainReserveInfo

- (instancetype)init {
    if (self = [super init]) {
        _customerID = [SRUserDefaults customerID];
    }
    
    return self;
}

- (SRMaintainGeneralType)maintainGeneralType {
    if (self.commonMaintenItemsTop && self.commonMaintenItemsTop.count == 4) {
        return SRMaintainGeneralType_Big;
    } else {
        return SRMaintainGeneralType_Little;
    }
}

- (NSArray *)specialTypes
{
    NSMutableArray *array = [NSMutableArray array];
    [self.commonMaintenItemsBottom enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL *stop) {
        [array addObject:[SRMaintainReserveInfo uncommonMaintainTypeDic][obj]];
    }];
    
    return array;
}

- (NSArray *)uncommonTypes
{
    NSMutableArray *array = [NSMutableArray array];
    [self.uncommonMaintenItems enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL *stop) {
        [array addObject:[SRMaintainReserveInfo uncommonMaintainTypeDic][obj]];
    }];
    
    return array;
}

- (NSString *)commonMaintenItemsTopString
{
    if (!self.commonMaintenItemsTop || self.commonMaintenItemsTop.count == 0) return nil;
    
    return [self.commonMaintenItemsTop componentsJoinedByString:@"*"];
}

- (void)setCommonMaintenItemsTopWithString:(NSString *)string
{
    if (!string) return;
    
    self.commonMaintenItemsTop = [string componentsSeparatedByString:@"*"];
}

- (NSString *)commonMaintenItemsBottomString
{
    if (!self.commonMaintenItemsBottom || self.commonMaintenItemsBottom.count == 0) return nil;
    
    return [self.commonMaintenItemsBottom componentsJoinedByString:@"*"];
}

- (void)setCommonMaintenItemsBottomWithString:(NSString *)string
{
    if (!string) return;
    
    self.commonMaintenItemsBottom = [string componentsSeparatedByString:@"*"];
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

@end

@implementation SRMaintainReserveInfo (expand)

+ (NSArray *)commonBigMaintainTitles
{
    return @[SRLocal(@"maintain_engine_oil"),
             SRLocal(@"maintain_engine_oil_filter"),
             SRLocal(@"maintain_air_filter"),
             SRLocal(@"maintain_air_condition_filter")];
}

+ (NSArray *)commonLittleMaintainTitles
{
    return @[SRLocal(@"maintain_engine_oil"),
             SRLocal(@"maintain_engine_oil_filter")];
}

+ (NSArray *)uncommonMaintainItems
{
    return @[SRLocal(@"maintain_tire"),
             SRLocal(@"maintain_brake"),
             SRLocal(@"maintain_battery"),
             SRLocal(@"maintain_wiper")];
}

+ (NSDictionary *)commonMaintainItemsDic
{
    return @{@(SRMaintainGeneralType_Big)   :   SRLocal(@"maintain_common_big"),
             @(SRMaintainGeneralType_Little)  :   SRLocal(@"maintain_common_little")};
}

+ (NSDictionary *)commonMaintainTypeDic
{
    return @{SRLocal(@"maintain_common_big")   :   @(SRMaintainGeneralType_Big),
             SRLocal(@"maintain_common_little")  :   @(SRMaintainGeneralType_Little)};
}

+ (NSDictionary *)uncommonMaintainItemsDic
{
    return @{@(SRMaintainSpecialType_Tire)   :   SRLocal(@"maintain_tire"),
             @(SRMaintainSpecialType_Brake)  :   SRLocal(@"maintain_brake"),
             @(SRMaintainSpecialType_Battery):   SRLocal(@"maintain_battery"),
             @(SRMaintainSpecialType_Wiper)  :   SRLocal(@"maintain_wiper")};
}

+ (NSDictionary *)uncommonMaintainTypeDic
{
    return @{SRLocal(@"maintain_tire")  :   @(SRMaintainSpecialType_Tire),
             SRLocal(@"maintain_brake") :  @(SRMaintainSpecialType_Brake),
             SRLocal(@"maintain_battery")  :   @(SRMaintainSpecialType_Battery),
             SRLocal(@"maintain_wiper")  :   @(SRMaintainSpecialType_Wiper)};
}

@end

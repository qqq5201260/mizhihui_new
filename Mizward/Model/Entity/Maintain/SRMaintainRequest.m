//
//  SRMaintainRequest.m
//  SiRuiV4.0
//
//  Created by zhangjunbo on 15/7/28.
//  Copyright (c) 2015年 SiRui. All rights reserved.
//

#import "SRMaintainRequest.h"
#import "SRUserDefaults.h"
#import "SRMaintainHistory.h"
#import "SRMaintainReserveInfo.h"
#import "SRMaintainUncommonItem.h"

#pragma mark - 查询下次预约项目

@implementation SRMaintainRequestQueryReserve

@end

#pragma mark - 查询4S店

@interface SRMaintainRequestQueryDepPage ()

@property (nonatomic, copy) NSString    *cacheTime;

@end

@implementation SRMaintainRequestQueryDepPage

- (instancetype)init {
    if (self = [super init]) {
        _pageIndex = 1;
        _pageSize = 30;
        _cacheTime = [SRUserDefaults maintainDepCacheTime];
    }
    
    return self;
}

@end

#pragma mark - 添加预约记录

@implementation SRMaintainRequestAddReserve

@end

#pragma mark - 添加历史记录

@implementation SRMaintainRequestAddHistory

- (instancetype)init {
    if (self = [super init]) {
        NSArray *items = [SRMaintainReserveInfo uncommonMaintainItems];
        NSMutableArray *temp = [NSMutableArray array];
        [items enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL *stop) {
            [temp addObject:[NSString stringWithFormat:@"%@_0_1", obj]];
        }];
        
        _uncommonMaintenItems = [temp componentsJoinedByString:@","];
    }
    
    return self;
}

- (BOOL)isCloseWithItemName:(NSString *)name
{
    __block BOOL isClose = YES;
    NSArray *temp = [self.uncommonMaintenItems componentsSeparatedByString:@","];
    [temp enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL *stop) {
        if ([obj containsString:name]) {
            NSArray *items = [obj componentsSeparatedByString:@"_"];
            isClose = [[items lastObject] boolValue];
            *stop = YES;
        }
    }];
    
    return isClose;
}

- (void)setCurrentMileage:(CGFloat)currentMileage {
    CGFloat delta = currentMileage - _currentMileage;
    _currentMileage = currentMileage;
    //当前里程更新后需要更新非常规保养里程
    NSMutableArray *temp = (NSMutableArray *)[self.uncommonMaintenItems componentsSeparatedByString:@","];
    [temp enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL *stop) {
        NSArray *items = [obj componentsSeparatedByString:@"_"];
        NSString *newItem = [NSString stringWithFormat:@"%@_%.1f_%@",
                             items[0],
                             [items[1] floatValue]+delta,
                             items[2]];
        [temp replaceObjectAtIndex:idx withObject:newItem];
    }];
    self.uncommonMaintenItems = [temp componentsJoinedByString:@","];
}

- (CGFloat)remainMileageWithItemName:(NSString *)name
{
    __block CGFloat nextMileage = 0;
    NSArray *temp = [self.uncommonMaintenItems componentsSeparatedByString:@","];
    [temp enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL *stop) {
        if ([obj containsString:name]) {
            NSArray *items = [obj componentsSeparatedByString:@"_"];
            nextMileage = [items[1] floatValue];
            *stop = YES;
        }
    }];
    
    return nextMileage - self.currentMileage;
}

- (void)updateUncommonMaintainItemsWithItemName:(NSString *)name
                                  remainMileage:(NSNumber *)mileage
                                        isClose:(NSNumber *)isClose
{
    NSMutableArray *temp = (NSMutableArray *)[self.uncommonMaintenItems componentsSeparatedByString:@","];
    __block BOOL hasItem = NO;
    [temp enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL *stop) {
        if ([obj containsString:name]) {
            NSArray *items = [obj componentsSeparatedByString:@"_"];
            NSString *newItem = [NSString stringWithFormat:@"%@_%.1f_%@",
                                 name,
                                 mileage?(mileage.floatValue+self.currentMileage):[items[1] floatValue],
                                 isClose?isClose:items[2]];
            [temp replaceObjectAtIndex:idx withObject:newItem];
            *stop = YES;
            hasItem = YES;
        }
    }];
    
    if (!hasItem) {
        NSString * newItem = [NSString stringWithFormat:@"%@_%.1f_%@",
                              name,
                              mileage?mileage.floatValue:0,
                              isClose?isClose:@(1)];
        [temp addObject:newItem];
    }
    
    self.uncommonMaintenItems = [temp componentsJoinedByString:@","];
}

- (void)updateUncommonMaintainItemsWithItemName:(NSString *)name
                                        isClose:(NSNumber *)isClose
{
    [self updateUncommonMaintainItemsWithItemName:name remainMileage:nil isClose:isClose];
}

- (void)updateUncommonMaintainItemsWithItemName:(NSString *)name
                                  remainMileage:(NSNumber *)mileage
{
    [self updateUncommonMaintainItemsWithItemName:name remainMileage:mileage isClose:nil];
}

@end

#pragma mark - 修改历史记录

@implementation SRMaintainRequestUpdateHistory

- (instancetype)initWithMaintainHistory:(SRMaintainHistory *)history {
    if (self = [super init]) {
        self.vehicleID = history.vehicleID;
        self.depID = history.depID;
        self.depName = history.depName;
        self.startTime = history.startTimeStr;
        self.isIgnore = history.isIgnore;
        self.currentMileage = history.currentMileage;
        self.type = history.type;
        _maintenReservationID = history.maintenReservationID;
        self.fee = history.fee;
        
        NSMutableArray *array = [NSMutableArray array];
        [history.uncommonMaintenItems enumerateObjectsUsingBlock:^(SRMaintainUncommonItem *obj, NSUInteger idx, BOOL *stop) {
            [array addObject:[NSString stringWithFormat:@"%@_%.1f_%@", obj.name, obj.nextMileage, @(obj.isIgnore)]];
        }];
        self.uncommonMaintenItems = [array componentsJoinedByString:@","];
        
        NSMutableArray *array1 = [NSMutableArray array];
        [history.defineMaintenItems enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            [array1 addObject:obj];
        }];
        self.defineMaintenItems = [array1 componentsJoinedByString:@","];
    }
    
    return self;
}

@end

#pragma mark - 查询历史记录

@implementation SRMaintainRequestQueryHistoryPage

- (instancetype)init {
    if (self = [super init]) {
        _pageIndex = 1;
        _pageSize = 30;
    }
    
    return self;
}

@end

#pragma mark - 删除历史记录

@implementation  SRMaintainRequestDeleteHistory 

@end


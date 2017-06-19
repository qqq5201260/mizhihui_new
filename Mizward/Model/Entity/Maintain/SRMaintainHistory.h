//
//  SRMaintainHistory.h
//  SiRuiV4.0
//
//  Created by zhangjunbo on 15/7/29.
//  Copyright (c) 2015年 SiRui. All rights reserved.
//

#import "SREntity.h"

@class SRMaintainUncommonItem;

@interface SRMaintainHistory : SREntity

@property (nonatomic, assign) NSInteger maintenReservationID; //预约ID
@property (nonatomic, assign) NSInteger maintenID;//工单ID
@property (nonatomic, assign) NSInteger customerID;
@property (nonatomic, assign) NSInteger vehicleID;
@property (nonatomic, assign) NSInteger depID;
@property (nonatomic, copy)   NSString  *depName;
@property (nonatomic, assign) CGFloat   currentMileage;//KM
@property (nonatomic, assign) CGFloat   fee;//元
@property (nonatomic, assign) SRMaintainStatus status;
@property (nonatomic, assign) SRMaintainGeneralType type;
@property (nonatomic, assign) BOOL      isIgnore;
@property (nonatomic, copy)   NSString  *startTimeStr;
@property (nonatomic, strong) NSArray   *commonMaintenItems;//大保、小保，string列表
@property (nonatomic, strong) NSArray   *uncommonMaintenItems;//非常规保养，SRMaintainUncommonItem
@property (nonatomic, strong) NSArray   *defineMaintenItems;//自定义项目，string列表

- (SRMaintainUncommonItem *)uncommonMaintenItemWithName:(NSString *)name;

- (NSString *)commonMaintenItemsString;
- (void)setCommonMaintenItemsWithString:(NSString *)string;

- (NSString *)uncommonMaintenItemsString;
- (void)setUncommonMaintenItemsWithString:(NSString *)string;

- (NSString *)defineMaintenItemsString;
- (void)setDefineMaintenItemsWithString:(NSString *)string;

@end

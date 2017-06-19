//
//  SRMaintainReserveInfo.h
//  SiRuiV4.0
//
//  Created by zhangjunbo on 15/7/27.
//  Copyright (c) 2015年 SiRui. All rights reserved.
//

#import "SREntity.h"

@interface SRMaintainReserveInfo : SREntity

@property (nonatomic, assign) NSInteger maintenReservationID;
@property (nonatomic, assign) NSInteger maintenID;
@property (nonatomic, assign) CGFloat currentMileage;
@property (nonatomic, assign) CGFloat nextMileage;
@property (nonatomic, assign) SRMaintainStatus status;
@property (nonatomic, strong) NSArray *commonMaintenItemsTop;
@property (nonatomic, strong) NSArray *commonMaintenItemsBottom;
@property (nonatomic, strong) NSArray *uncommonMaintenItems; //obj:SRMaintainUncommonItem

//自定义字段
@property (nonatomic, assign) NSInteger vehicleID;
@property (nonatomic, assign) NSInteger customerID;

- (SRMaintainGeneralType)maintainGeneralType;
- (NSArray *)specialTypes;
- (NSArray *)uncommonTypes;

- (NSString *)commonMaintenItemsTopString;
- (void)setCommonMaintenItemsTopWithString:(NSString *)string;

- (NSString *)commonMaintenItemsBottomString;
- (void)setCommonMaintenItemsBottomWithString:(NSString *)string;

- (NSString *)uncommonMaintenItemsString;
- (void)setUncommonMaintenItemsWithString:(NSString *)string;

@end

@interface SRMaintainReserveInfo (expand)

+ (NSArray *)commonBigMaintainTitles;
+ (NSArray *)commonLittleMaintainTitles;
+ (NSArray *)uncommonMaintainItems;
+ (NSDictionary *)commonMaintainItemsDic;
+ (NSDictionary *)commonMaintainTypeDic;
+ (NSDictionary *)uncommonMaintainItemsDic;
+ (NSDictionary *)uncommonMaintainTypeDic;

@end

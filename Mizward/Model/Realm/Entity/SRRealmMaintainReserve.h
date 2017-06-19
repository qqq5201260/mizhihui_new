//
//  SRRealmMaintainReserve.h
//  Mizward
//
//  Created by zhangjunbo on 15/9/1.
//  Copyright (c) 2015年 Mizward. All rights reserved.
//

#import <Realm/RLMObject.h>

@class SRMaintainReserveInfo;

@interface SRRealmMaintainReserve : RLMObject

@property   NSInteger maintenReservationID;
@property   NSInteger maintenID;
@property   CGFloat currentMileage;
@property   CGFloat nextMileage;
@property   NSInteger status;
@property   NSString *commonMaintenItemsTop;
@property   NSString *commonMaintenItemsBottom;
@property   NSString *uncommonMaintenItems; //obj:SRMaintainUncommonItem

//自定义字段
@property (nonatomic, assign) NSInteger vehicleID;
@property (nonatomic, assign) NSInteger customerID;

- (instancetype)initWithMaintainReserveInfo:(SRMaintainReserveInfo *)info;
- (SRMaintainReserveInfo *)maintainReserveInfo;

@end

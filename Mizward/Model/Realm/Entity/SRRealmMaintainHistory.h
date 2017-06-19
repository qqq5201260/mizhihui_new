//
//  SRRealmMaintainHistory.h
//  Mizward
//
//  Created by zhangjunbo on 15/9/1.
//  Copyright (c) 2015年 Mizward. All rights reserved.
//

#import <Realm/RLMObject.h>

@class SRMaintainHistory;

@interface SRRealmMaintainHistory : RLMObject

@property   NSInteger maintenReservationID; //预约ID
@property   NSInteger maintenID;//工单ID
@property   NSInteger customerID;
@property   NSInteger vehicleID;
@property   NSInteger depID;
@property   NSString  *depName;
@property   CGFloat   currentMileage;//KM
@property   CGFloat   fee;//元
@property   NSInteger status;
@property   NSInteger type;
@property   BOOL      isIgnore;
@property   NSString  *startTimeStr;
@property   NSString *commonMaintenItems;//大保、小保，string列表
@property   NSString *uncommonMaintenItems;//非常规保养，SRMaintainUncommonItem
@property   NSString *defineMaintenItems;//自定义项目，string列表

- (instancetype)initWithMaintainHistory:(SRMaintainHistory*)history;

- (SRMaintainHistory *)maintainHistory;

@end

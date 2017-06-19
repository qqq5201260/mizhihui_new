//
//  SRRealmTrip.h
//  Mizward
//
//  Created by zhangjunbo on 15/9/1.
//  Copyright (c) 2015年 Mizward. All rights reserved.
//

#import <Realm/RLMObject.h>

@class SRTripInfo;

@interface SRRealmTrip : RLMObject

@property   NSString *tripID;
@property   NSString *startTime;
@property   NSString *endTime;
@property   CGFloat mileage;
@property   CGFloat fuelCons;
@property   CGFloat avgFuelCons;
@property   CGFloat fee;
@property   CGFloat startLat;
@property   CGFloat startLng;
@property   CGFloat endLat;
@property   CGFloat endLng;

//自定义字段
@property (nonatomic, assign) NSInteger vehicleID;

- (instancetype)initWithTripInfo:(SRTripInfo *)info;
- (SRTripInfo *)tripInfo;

@end

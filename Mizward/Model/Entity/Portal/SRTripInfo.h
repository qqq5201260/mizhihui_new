//
//  SRTripInfo.h
//  SiRuiV4.0
//
//  Created by zhangjunbo on 15/6/16.
//  Copyright (c) 2015年 SiRui. All rights reserved.
//

#import "SREntity.h"

@interface SRTripInfo : SREntity

@property (nonatomic, copy) NSString *tripID;
@property (nonatomic, copy) NSString *startTime;
@property (nonatomic, copy) NSString *endTime;
@property (nonatomic, assign) CGFloat mileage;
@property (nonatomic, assign) CGFloat fuelCons;
@property (nonatomic, assign) CGFloat avgFuelCons;
@property (nonatomic, assign) CGFloat fee;
@property (nonatomic, assign) CGFloat startLat;
@property (nonatomic, assign) CGFloat startLng;
@property (nonatomic, assign) CGFloat endLat;
@property (nonatomic, assign) CGFloat endLng;

//自定义字段
@property (nonatomic, assign) NSInteger vehicleID;

- (void)setStartTimeLocal:(NSString *)startTime;
- (void)setEndTimeLocal:(NSString *)endTime;

@end

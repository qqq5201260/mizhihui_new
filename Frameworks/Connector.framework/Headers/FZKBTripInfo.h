//
//  FZKBTripInfo.h
//  Connector
//
//  Created by 宋搏 on 2017/5/4.
//  Copyright © 2017年 chinapke. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface FZKBTripInfo : NSObject

@property (nonatomic, assign) CGFloat avgFuelCons;
@property (nonatomic, assign) double endLat;
@property (nonatomic, assign) double endLng;
@property (nonatomic, strong) NSString * endTime;
@property (nonatomic, assign) CGFloat fee;
@property (nonatomic, assign) CGFloat fuelCons;
@property (nonatomic, assign) BOOL isEffective;
@property (nonatomic, assign) CGFloat mileage;
@property (nonatomic, assign) double startLat;
@property (nonatomic, assign) double startLng;
@property (nonatomic, strong) NSString * startTime;
@property (nonatomic, strong) NSString * tripID;
@property (nonatomic, assign) NSInteger vehicleID;

@end

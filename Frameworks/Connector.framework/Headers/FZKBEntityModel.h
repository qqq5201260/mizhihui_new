
//
//  FZKBEntityModel.h
//  Connector
//
//  Created by czl on date
//  Copyright © 2017年 chinapke. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface FZKBEntityModel : NSObject

+ (instancetype)shareModel;

@property (nonatomic,assign) NSInteger door;

@property (nonatomic,assign) NSInteger windowSky;

@property (nonatomic,assign) NSInteger startNumber;

@property (nonatomic,assign) NSInteger busyStatus;

@property (nonatomic,assign) CGFloat fenceCentralLng;

@property (nonatomic,assign) NSInteger hasNotConfirmAlarm;

@property (nonatomic,assign) NSInteger defence;

@property (nonatomic,assign) NSInteger tirePressure;

@property (nonatomic,assign) NSInteger isOnline;

@property (nonatomic,assign) CGFloat speed;

@property (nonatomic,assign) NSInteger doorLB;

@property (nonatomic,assign) NSInteger sleepStatus;

@property (nonatomic,assign) CGFloat oil;

@property (nonatomic,assign) NSInteger lightBig;

@property (nonatomic,assign) NSInteger doorRF;

@property (nonatomic,assign) NSInteger engineStatus;

@property (nonatomic,assign) NSInteger gpsStatus;

@property (nonatomic,assign) NSInteger doorLF;

@property (nonatomic,assign) NSInteger isInFence;

@property (nonatomic,assign) CGFloat lat;

@property (nonatomic,assign) NSInteger direction;

@property (nonatomic,assign) NSInteger windowRF;

@property (nonatomic,assign) NSInteger ACC;

@property (nonatomic,assign) CGFloat temp;

@property (nonatomic,assign) NSInteger windowLB;

@property (nonatomic,assign) NSInteger doorLock;

@property (nonatomic,assign) CGFloat lng;

@property (nonatomic,assign) NSInteger windowRB;

@property (nonatomic,assign) NSInteger signalStrength;

@property (nonatomic,assign) NSInteger doorRB;

@property (nonatomic,assign) CGFloat electricity;

@property (nonatomic,assign) CGFloat oilSize;

@property (nonatomic,copy) NSString *gpsTime;

@property (nonatomic,assign) NSInteger trunkDoorLock;

@property (nonatomic,assign) NSInteger windowLF;

@property (nonatomic,assign) CGFloat oilLeft;

@property (nonatomic,assign) NSInteger electricityStatus;

@property (nonatomic,assign) NSInteger lightSmall;

@property (nonatomic,assign) NSInteger tempStatus;

@property (nonatomic,assign) NSInteger trunkDoor;

@property (nonatomic,assign) CGFloat fenceCentralLat;

@property (nonatomic,assign) NSInteger fenceRadius;

@property (nonatomic,assign) CGFloat mileAge;

@property (nonatomic,assign) NSInteger oilStatus;


@end

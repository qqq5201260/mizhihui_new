//
//  SRVehicleStatusInfo.h
//  SiRuiV4.0
//
//  Created by zhangjunbo on 15/6/16.
//  Copyright (c) 2015年 SiRui. All rights reserved.
//

#import "SREntity.h"

@interface SRVehicleStatusInfo : SREntity

@property (nonatomic, assign) NSInteger ACC;
@property (nonatomic, assign) NSInteger busyStatus;//设备忙闲状态 0:闲置 其它:忙
@property (nonatomic, assign) NSInteger defence;//防盗状态  0:无效 1:设防 2:撤防
@property (nonatomic, copy)   NSString  *deviceStatusRefreshTime;
@property (nonatomic, assign) NSInteger direction;
@property (nonatomic, assign) NSInteger door;
@property (nonatomic, assign) NSInteger doorLB;//左后门   0：未知 1：开启   2：关闭
@property (nonatomic, assign) NSInteger doorLF;
@property (nonatomic, assign) NSInteger doorLock;
@property (nonatomic, assign) NSInteger doorRB;
@property (nonatomic, assign) NSInteger doorRF;
@property (nonatomic, assign) CGFloat   electricity;
@property (nonatomic, assign) NSInteger electricityStatus;
@property (nonatomic, assign) NSInteger engineStatus;
@property (nonatomic, assign) NSInteger gpsStatus;
@property (nonatomic, copy)   NSString  *gpsTime;
@property (nonatomic, assign) NSInteger hasNotConfirmAlarm;
@property (nonatomic, assign) NSInteger isOnline;
@property (nonatomic, assign) CGFloat   lat;
@property (nonatomic, copy)   NSString  *latestMessageTime;
@property (nonatomic, assign) NSInteger lightBig;
@property (nonatomic, assign) NSInteger lightSmall;
@property (nonatomic, assign) CGFloat   lng;
@property (nonatomic, assign) CGFloat   mileAge;
@property (nonatomic, assign) NSInteger oil;
@property (nonatomic, assign) NSInteger oilLeft;
@property (nonatomic, assign) NSInteger oilSize;
@property (nonatomic, assign) NSInteger oilStatus;
@property (nonatomic, assign) NSInteger signalStrength;
@property (nonatomic, assign) NSInteger sleepStatus;
@property (nonatomic, assign) NSInteger speed;
@property (nonatomic, assign) NSInteger startNumber;
@property (nonatomic, assign) CGFloat   temp;
@property (nonatomic, assign) NSInteger tempStatus;
@property (nonatomic, assign) NSInteger tirePressure;
@property (nonatomic, assign) NSInteger trunkDoor;
@property (nonatomic, assign) NSInteger trunkDoorLock;
@property (nonatomic, assign) NSInteger windowLB;
@property (nonatomic, assign) NSInteger windowLF;
@property (nonatomic, assign) NSInteger windowRB;
@property (nonatomic, assign) NSInteger windowRF;
@property (nonatomic, assign) NSInteger windowSky;

- (void)setGpsTimeLocal:(NSString *)gpsTime;

@end

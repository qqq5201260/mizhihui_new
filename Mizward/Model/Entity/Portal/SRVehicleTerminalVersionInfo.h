//
//  SRVehicleTerminalVersionInfo.h
//  Mizward
//
//  Created by zhangjunbo on 15/9/16.
//  Copyright (c) 2015年 Mizward. All rights reserved.
//

#import "SREntity.h"

@interface SRVehicleTerminalVersionInfo : SREntity

@property (nonatomic, assign) NSInteger vehicleID;
@property (nonatomic, assign) NSInteger updateID;
@property (nonatomic, copy)   NSString *terminalName;
@property (nonatomic, copy)   NSString *version;
@property (nonatomic, copy)   NSString *size;
@property (nonatomic, copy)   NSString *memo;
@property (nonatomic, assign) BOOL      isUpdated;

@end

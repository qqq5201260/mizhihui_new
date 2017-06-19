//
//  SRVehicleInfo.h
//  SiRuiV4.0
//
//  Created by zhangjunbo on 15/6/16.
//  Copyright (c) 2015年 SiRui. All rights reserved.
//

#import "SREntity.h"

@interface SRVehicleInfo : SREntity

@property (nonatomic, assign)   NSInteger   vehicleModelID;
@property (nonatomic, copy)     NSString    *vehicleName;

@end

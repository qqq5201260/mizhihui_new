//
//  FZKBTotalInfosModel.h
//  Connector
//
//  Created by czl on 2017/4/19.
//  Copyright © 2017年 chinapke. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FZKBVehicleBasicInfoModel.h"
#import "FZKBVehicleStatusInfoModel.h"

@interface FZKBTotalInfosModel : NSObject<NSCoding>

@property (nonatomic , strong) FZKBVehicleBasicInfoModel              * vehicleBasicInfo;
@property (nonatomic , strong) FZKBVehicleStatusInfoModel              * vehicleStatusInfo;

@end

//
//  SRPortal.h
//  SiRuiV4.0
//
//  Created by zhangjunbo on 15/6/18.
//  Copyright (c) 2015年 SiRui. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SRPortalRequestLogin, SRCustomer, SRVehicleBasicInfo;

@interface SRPortal : NSObject

Singleton_Interface(SRPortal)

//用户信息
@property (nonatomic, strong) SRCustomer *customer;
//车辆列表
@property (nonatomic, strong) NSMutableDictionary *vehicleDic;
@property (nonatomic, assign) BOOL isBleDebugging; //蓝牙调试需要后台运行

//获取所有车辆
- (NSArray *)allVehicles;
//获取所有含终端的车辆
- (NSArray *)allVehiclesWithTerminal;
//当前车辆
- (SRVehicleBasicInfo *)currentVehicleBasicInfo;
//根据ID获取车辆
- (SRVehicleBasicInfo *)vehicleBasicInfoWithVehicleID:(NSInteger)vehicleID;
//根据车牌获取车辆
- (SRVehicleBasicInfo *)vehicleBasicInfoWithPlateNubmer:(NSString *)plateNumber;
//清空数据
- (void)clearData;


@end

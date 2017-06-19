//
//  SRDataBase+VehicleBasic.h
//  SiRuiV4.0
//
//  Created by zhangjunbo on 15/6/16.
//  Copyright (c) 2015年 SiRui. All rights reserved.
//

#import "SRDataBase.h"

@interface SRDataBase (Vehicle)

//创建表
- (void)createVehicleTable;
//插入或更新
- (void)updateVehicleList:(NSArray *)list withCompleteBlock:(CompleteBlock)completeBlock;
//删除（按车辆）
- (void)deleteVehicleByVehicleID:(NSInteger)vehicleID withCompleteBlock:(CompleteBlock)completeBlock;
//删除（按用户）
- (void)deleteVehicleByCustomerID:(NSInteger)vehicleID withCompleteBlock:(CompleteBlock)completeBlock;
//删除（所有）
- (void)deleteAllVehicleWithCompleteBlock:(CompleteBlock)completeBlock;
//查询（按车辆）
- (void)queryVehicleByVehicleID:(NSInteger)vehicleID withCompleteBlock:(CompleteBlock)completeBlock;
//查询（按用户）
- (void)queryVehicleByCustomerID:(NSInteger)customerID withCompleteBlock:(CompleteBlock)completeBlock;
//查询（所有）
- (void)queryAllVehicleWithCompleteBlock:(CompleteBlock)completeBlock;

@end

//
//  SRDataBase+MaintainReserve.h
//  SiRuiV4.0
//
//  Created by zhangjunbo on 15/7/28.
//  Copyright (c) 2015年 SiRui. All rights reserved.
//

#import "SRDataBase.h"

@class SRMaintainReserveInfo;

@interface SRDataBase (MaintainReserve)

//创建表
- (void)createMaintainReserveTable;
//插入或更新
- (void)updateMaintainReserveInfo:(SRMaintainReserveInfo *)info withCompleteBlock:(CompleteBlock)completeBlock;
//删除所有
- (void)deleteAllMaintainReserveInfoWithCompleteBlock:(CompleteBlock)completeBlock;
//根据车辆ID删除
- (void)deleteMaintainReserveInfoByVehicleID:(NSInteger)vehicleID withCompleteBlock:(CompleteBlock)completeBlock;
//根据车辆ID查询
- (void)queryMaintainReserveInfoByVehicleID:(NSInteger)vehicleID withCompleteBlock:(CompleteBlock)completeBlock;

@end

//
//  SRDataBase+MaintainHistory.h
//  SiRuiV4.0
//
//  Created by zhangjunbo on 15/7/29.
//  Copyright (c) 2015年 SiRui. All rights reserved.
//

#import "SRDataBase.h"

@interface SRDataBase (MaintainHistory)

//创建表
- (void)createMaintainHistoryTable;
//更新
- (void)updateMaintainHistoryList:(NSArray *)list withCompleteBlock:(CompleteBlock)completeBlock;
//删除所有
- (void)deleteAllMaintainHistoryWithCompleteBlock:(CompleteBlock)completeBlock;
//根据ID删除
- (void)deleteMaintainHistoryByMaintenReservationID:(NSInteger)maintenReservationID withCompleteBlock:(CompleteBlock)completeBlock;
//根据车辆ID查询
- (void)queryAllMaintainHistoryByVehicleID:(NSInteger)vehicleID withCompleteBlock:(CompleteBlock)completeBlock;

@end

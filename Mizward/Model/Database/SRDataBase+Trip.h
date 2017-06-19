//
//  SRDataBase+Trip.h
//  SiRuiV4.0
//
//  Created by zhangjunbo on 15/6/16.
//  Copyright (c) 2015年 SiRui. All rights reserved.
//

#import "SRDataBase.h"

@interface SRDataBase (Trip)

//创建表
- (void)createTripTable;
//插入或更新
- (void)updateTripList:(NSArray *)list withCompleteBlock:(CompleteBlock)completeBlock;
//删除（按ID）
- (void)deleteTripByTripID:(NSString *)tripID withCompleteBlock:(CompleteBlock)completeBlock;
//删除（按车辆）
- (void)deleteTripByVehicleID:(NSInteger)vehicleID withCompleteBlock:(CompleteBlock)completeBlock;
//删除（按日期、车辆）
- (void)deleteTripByDate:(NSDate *)date vehicleID:(NSInteger)vehicleID withCompleteBlock:(CompleteBlock)completeBlock;
//删除（所有）
- (void)deleteAllTripWithCompleteBlock:(CompleteBlock)completeBlock;
//查询（按日期、车辆）
- (void)queryTripByDate:(NSDate *)date vehicleID:(NSInteger)vehicleID withCompleteBlock:(CompleteBlock)completeBlock;

@end

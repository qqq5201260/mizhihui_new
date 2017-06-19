//
//  SRDataBase+TripPoints.h
//  Mizward
//
//  Created by zhangjunbo on 15/9/1.
//  Copyright (c) 2015年 Mizward. All rights reserved.
//

#import "SRDataBase.h"

@interface SRDataBase (TripPoints)

//创建表
- (void)createTripPointsTable;
//插入或更新
- (void)updateTripPoints:(NSArray *)list tripID:(NSString *)tripID andVehicleID:(NSInteger)vehicleID withCompleteBlock:(CompleteBlock)completeBlock;
//删除（按ID）
- (void)deleteTripPointsByTripID:(NSString *)tripID withCompleteBlock:(CompleteBlock)completeBlock;
//删除（所有）
- (void)deleteAllTripPointsWithCompleteBlock:(CompleteBlock)completeBlock;
//查询（按ID）
- (void)queryTripPointsByTripID:(NSString *)tripID withCompleteBlock:(CompleteBlock)completeBlock;

@end

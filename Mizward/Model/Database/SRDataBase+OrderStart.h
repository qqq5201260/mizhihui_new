//
//  SRDataBase+OrderStart.h
//  SiRuiV4.0
//
//  Created by zhangjunbo on 15/6/17.
//  Copyright (c) 2015年 SiRui. All rights reserved.
//

#import "SRDataBase.h"

@class SROrderStartInfo;

@interface SRDataBase (OrderStart)

//创建表
- (void)createOrderStartTable;
//插入或更新
- (void)updateOrderStartList:(NSArray *)list withCompleteBlock:(CompleteBlock)completeBlock;
//删除（按车辆）
- (void)deleteOrderStartByVehicleID:(NSInteger)vehicleID withCompleteBlock:(CompleteBlock)completeBlock;
//删除（按ID）
- (void)deleteOrderStartByStartClockID:(NSInteger)startClockID withCompleteBlock:(CompleteBlock)completeBlock;
//删除（按用户）
- (void)deleteOrderStartByCustomerID:(NSInteger)customerID withCompleteBlock:(CompleteBlock)completeBlock;
//删除（所有）
- (void)deleteAllOrderStartWithCompleteBlock:(CompleteBlock)completeBlock;
//查询（按车辆）
- (void)queryOrderStartByVehicleID:(NSInteger)vehicleID withCompleteBlock:(CompleteBlock)completeBlock;
//查询（按ID）
- (void)queryOrderStartByStartClockID:(NSInteger)startClockID withCompleteBlock:(CompleteBlock)completeBlock;
//查询（按用户）
- (void)queryOrderStartByCustomerID:(NSInteger)customerID withCompleteBlock:(CompleteBlock)completeBlock;
//查询（所有）
- (void)queryAllOrderStartWithCompleteBlock:(CompleteBlock)completeBlock;

@end

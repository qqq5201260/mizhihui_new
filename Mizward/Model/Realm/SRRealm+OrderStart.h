//
//  SRRealm+OrderStart.h
//  Mizward
//
//  Created by zhangjunbo on 15/9/1.
//  Copyright (c) 2015年 Mizward. All rights reserved.
//

#import "SRRealm.h"

@class SROrderStartInfo;

@interface SRRealm (OrderStart)

- (void)updateOrderStartList:(NSArray *)list withCompleteBlock:(CompleteBlock)completeBlock;

- (void)deleteOrderStartByVehicleID:(NSInteger)vehicleID withCompleteBlock:(CompleteBlock)completeBlock;
- (void)deleteOrderStartByStartClockID:(NSInteger)startClockID withCompleteBlock:(CompleteBlock)completeBlock;
- (void)deleteOrderStartByCustomerID:(NSInteger)customerID withCompleteBlock:(CompleteBlock)completeBlock;
- (void)deleteAllOrderStartWithCompleteBlock:(CompleteBlock)completeBlock;

- (void)queryOrderStartByVehicleID:(NSInteger)vehicleID withCompleteBlock:(CompleteBlock)completeBlock;
- (void)queryOrderStartByStartClockID:(NSInteger)startClockID withCompleteBlock:(CompleteBlock)completeBlock;
- (void)queryOrderStartByCustomerID:(NSInteger)customerID withCompleteBlock:(CompleteBlock)completeBlock;
- (void)queryAllOrderStartWithCompleteBlock:(CompleteBlock)completeBlock;

@end

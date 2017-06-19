//
//  SRRealm+Vehicle.h
//  Mizward
//
//  Created by zhangjunbo on 15/9/1.
//  Copyright (c) 2015年 Mizward. All rights reserved.
//

#import "SRRealm.h"

@interface SRRealm (Vehicle)

- (void)updateVehicleList:(NSArray *)list withCompleteBlock:(CompleteBlock)completeBlock;

- (void)deleteVehicleByVehicleID:(NSInteger)vehicleID withCompleteBlock:(CompleteBlock)completeBlock;
- (void)deleteVehicleByCustomerID:(NSInteger)customerID withCompleteBlock:(CompleteBlock)completeBlock;
- (void)deleteAllVehicleWithCompleteBlock:(CompleteBlock)completeBlock;

- (void)queryVehicleByVehicleID:(NSInteger)vehicleID withCompleteBlock:(CompleteBlock)completeBlock;
- (void)queryVehicleByCustomerID:(NSInteger)customerID withCompleteBlock:(CompleteBlock)completeBlock;
- (void)queryAllVehicleWithCompleteBlock:(CompleteBlock)completeBlock;

@end

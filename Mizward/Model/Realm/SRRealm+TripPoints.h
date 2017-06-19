//
//  SRRealm+TripPoints.h
//  Mizward
//
//  Created by zhangjunbo on 15/9/1.
//  Copyright (c) 2015年 Mizward. All rights reserved.
//

#import "SRRealm.h"

@interface SRRealm (TripPoints)

- (void)updateTripPoints:(NSArray *)list tripID:(NSString *)tripID andVehicleID:(NSInteger)vehicleID withCompleteBlock:(CompleteBlock)completeBlock;

- (void)deleteTripPointsByTripID:(NSString *)tripID withCompleteBlock:(CompleteBlock)completeBlock;
- (void)deleteAllTripPointsWithCompleteBlock:(CompleteBlock)completeBlock;

- (void)queryTripPointsByTripID:(NSString *)tripID withCompleteBlock:(CompleteBlock)completeBlock;

@end

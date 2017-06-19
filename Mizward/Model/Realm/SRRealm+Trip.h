//
//  SRRealm+Trip.h
//  Mizward
//
//  Created by zhangjunbo on 15/9/1.
//  Copyright (c) 2015年 Mizward. All rights reserved.
//

#import "SRRealm.h"

@interface SRRealm (Trip)

- (void)updateTripList:(NSArray *)list withCompleteBlock:(CompleteBlock)completeBlock;

- (void)deleteTripByTripID:(NSString *)tripID withCompleteBlock:(CompleteBlock)completeBlock;
- (void)deleteTripByVehicleID:(NSInteger)vehicleID withCompleteBlock:(CompleteBlock)completeBlock;
- (void)deleteTripByDate:(NSDate *)date vehicleID:(NSInteger)vehicleID withCompleteBlock:(CompleteBlock)completeBlock;
- (void)deleteAllTripWithCompleteBlock:(CompleteBlock)completeBlock;

- (void)queryTripByDate:(NSDate *)date vehicleID:(NSInteger)vehicleID withCompleteBlock:(CompleteBlock)completeBlock;

@end

//
//  SRRealm+TripPoints.m
//  Mizward
//
//  Created by zhangjunbo on 15/9/1.
//  Copyright (c) 2015年 Mizward. All rights reserved.
//

#import "SRRealm+TripPoints.h"
#import "SRTripPoint.h"
#import "SRRealmTripPoints.h"
#import <Realm/Realm.h>
#import <MJExtension/MJExtension.h>

@implementation SRRealm (TripPoints)

- (void)updateTripPoints:(NSArray *)list tripID:(NSString *)tripID andVehicleID:(NSInteger)vehicleID withCompleteBlock:(CompleteBlock)completeBlock
{
    [self executeOnMain:^{
        [self.realm beginWriteTransaction];
        [self.realm deleteAllObjects];
        [self.realm addOrUpdateObject:[[SRRealmTripPoints alloc] initWithTripID:tripID
                                                                      vehicleID:vehicleID
                                                                     tripPoints:list]];
        [self.realm commitWriteTransaction];
        !completeBlock?:completeBlock(nil, @(YES));
    } afterDelay:0];
}

- (void)deleteTripPointsByTripID:(NSString *)tripID withCompleteBlock:(CompleteBlock)completeBlock
{
    RLMResults *results = [SRRealmTripPoints objectsInRealm:self.realm
                                                    where:[NSString stringWithFormat:@"tripID == %@", tripID]];
    [self executeOnMain:^{
        [self.realm beginWriteTransaction];
        [self.realm deleteObjects:results];
        [self.realm commitWriteTransaction];
        !completeBlock?:completeBlock(nil, @(YES));
    } afterDelay:0];
}

- (void)deleteAllTripPointsWithCompleteBlock:(CompleteBlock)completeBlock
{
    [self executeOnMain:^{
        [self.realm beginWriteTransaction];
        [self.realm deleteObjects:[SRRealmTripPoints allObjects]];
        [self.realm commitWriteTransaction];
        !completeBlock?:completeBlock(nil, @(YES));
    } afterDelay:0];
}

- (void)queryTripPointsByTripID:(NSString *)tripID withCompleteBlock:(CompleteBlock)completeBlock
{
    RLMResults *results = [SRRealmTripPoints objectsInRealm:self.realm
                                                    where:[NSString stringWithFormat:@"tripID == %@", tripID]];
    SRRealmTripPoints *trip = results.firstObject;
    !completeBlock?:completeBlock(nil, trip?[trip tripPoints]:nil);
}

@end

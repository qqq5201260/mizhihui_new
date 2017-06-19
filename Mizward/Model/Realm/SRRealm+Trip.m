//
//  SRRealm+Trip.m
//  Mizward
//
//  Created by zhangjunbo on 15/9/1.
//  Copyright (c) 2015年 Mizward. All rights reserved.
//

#import "SRRealm+Trip.h"
#import "SRTripInfo.h"
#import "SRRealmTrip.h"
#import <Realm/Realm.h>
#import <DateTools/DateTools.h>

@implementation SRRealm (Trip)

- (void)updateTripList:(NSArray *)list withCompleteBlock:(CompleteBlock)completeBlock
{
    NSMutableArray *array = [NSMutableArray array];
    [list enumerateObjectsUsingBlock:^(SRTripInfo *obj, NSUInteger idx, BOOL *stop) {
        @autoreleasepool {
            SRRealmTrip *info = [[SRRealmTrip alloc] initWithTripInfo:obj];
            [array addObject:info];
        }
    }];
    [self executeOnMain:^{
        [self.realm beginWriteTransaction];
        [self.realm addOrUpdateObjectsFromArray:array];
        [self.realm commitWriteTransaction];
        !completeBlock?:completeBlock(nil, @(YES));
    } afterDelay:0];
    
}

- (void)deleteTripByTripID:(NSString *)tripID withCompleteBlock:(CompleteBlock)completeBlock
{
    RLMResults *results = [SRRealmTrip objectsInRealm:self.realm
                                                      where:[NSString stringWithFormat:@"tripID == %zd", tripID]];
    [self executeOnMain:^{
        [self.realm beginWriteTransaction];
        [self.realm deleteObjects:results];
        [self.realm commitWriteTransaction];
        !completeBlock?:completeBlock(nil, @(YES));
    } afterDelay:0];
    
}

- (void)deleteTripByVehicleID:(NSInteger)vehicleID withCompleteBlock:(CompleteBlock)completeBlock
{
    RLMResults *results = [SRRealmTrip objectsInRealm:self.realm
                                                where:[NSString stringWithFormat:@"vehicleID == %zd", vehicleID]];
    
    [self executeOnMain:^{
        [self.realm beginWriteTransaction];
        [self.realm deleteObjects:results];
        [self.realm commitWriteTransaction];
        !completeBlock?:completeBlock(nil, @(YES));
    } afterDelay:0];
}

- (void)deleteTripByDate:(NSDate *)date vehicleID:(NSInteger)vehicleID withCompleteBlock:(CompleteBlock)completeBlock
{
    NSString *time = [date stringOfDateWithFormatYYYYMMdd];
//    NSString *start = [NSString stringWithFormat:@"%@ 00:00:00", time];
//    time = [[date dateByAddingDays:1] stringOfDateWithFormatYYYYMMdd];
//    NSString *end = [NSString stringWithFormat:@"%@ 00:00:00", time];
    
//    NSPredicate *pred = [NSPredicate predicateWithFormat:@"startTime CONTAINS %@ AND vehicleID == %zd", time ,vehicleID];
//    RLMResults *results = [SRRealmTrip objectsWithPredicate:pred];
    
    RLMResults *results = [SRRealmTrip objectsInRealm:self.realm
                                                where:[NSString stringWithFormat:@"startTime CONTAINS %@ AND vehicleID == %zd", time ,vehicleID]];
    [self executeOnMain:^{
        [self.realm beginWriteTransaction];
        [self.realm deleteObjects:results];
        [self.realm commitWriteTransaction];
        !completeBlock?:completeBlock(nil, @(YES));
    } afterDelay:0];
}

- (void)deleteAllTripWithCompleteBlock:(CompleteBlock)completeBlock
{
    [self executeOnMain:^{
        [self.realm beginWriteTransaction];
        [self.realm deleteObjects:[SRRealmTrip allObjects]];
        [self.realm commitWriteTransaction];
        !completeBlock?:completeBlock(nil, @(YES));
    } afterDelay:0];
    
}

- (void)queryTripByDate:(NSDate *)date vehicleID:(NSInteger)vehicleID withCompleteBlock:(CompleteBlock)completeBlock
{
    NSString *time = [date stringOfDateWithFormatYYYYMMdd];
//    NSString *start = [NSString stringWithFormat:@"%@ 00:00:00", time];
//    time = [[date dateByAddingDays:1] stringOfDateWithFormatYYYYMMdd];
//    NSString *end = [NSString stringWithFormat:@"%@ 00:00:00", time];
    
    RLMResults *results = [[SRRealmTrip objectsInRealm:self.realm
                                                where:[NSString stringWithFormat:@"startTime BEGINSWITH %@ AND vehicleID == %zd", time ,vehicleID]] sortedResultsUsingProperty:@"startTime" ascending:NO];
    
//    NSPredicate *pred = [NSPredicate predicateWithFormat:@"startTime BEGINSWITH %@ AND vehicleID = %zd", time ,vehicleID];
//    RLMResults *results = [[SRRealmTrip objectsWithPredicate:pred] sortedResultsUsingProperty:@"startTime" ascending:NO];
    
    NSMutableArray *array = [NSMutableArray array];
    @autoreleasepool {
        for (NSInteger idx = 0; idx < results.count; ++idx) {
            [array addObject:[results[idx] tripInfo]];
        }
    }
    !completeBlock?:completeBlock(nil, array);
}

@end

//
//  SRRealm+Vehicle.m
//  Mizward
//
//  Created by zhangjunbo on 15/9/1.
//  Copyright (c) 2015年 Mizward. All rights reserved.
//

#import "SRRealm+Vehicle.h"
#import "SRVehicleBasicInfo.h"
#import "SRRealmVehicle.h"
#import <Realm/Realm.h>

@implementation SRRealm (Vehicle)

- (void)updateVehicleList:(NSArray *)list withCompleteBlock:(CompleteBlock)completeBlock
{
    NSMutableArray *array = [NSMutableArray array];
    [list enumerateObjectsUsingBlock:^(SRVehicleBasicInfo *obj, NSUInteger idx, BOOL *stop) {
        @autoreleasepool {
            SRRealmVehicle *info = [[SRRealmVehicle alloc] initWithVehicleBasicInfo:obj];
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

- (void)deleteVehicleByVehicleID:(NSInteger)vehicleID withCompleteBlock:(CompleteBlock)completeBlock
{
    RLMResults *results = [SRRealmVehicle objectsInRealm:self.realm
                                                where:[NSString stringWithFormat:@"vehicleID == %zd", vehicleID]];

    [self executeOnMain:^{
        [self.realm beginWriteTransaction];
        [self.realm deleteObjects:results];
        [self.realm commitWriteTransaction];
        !completeBlock?:completeBlock(nil, @(YES));
    } afterDelay:0];
}

- (void)deleteVehicleByCustomerID:(NSInteger)customerID withCompleteBlock:(CompleteBlock)completeBlock
{
    RLMResults *results = [SRRealmVehicle objectsInRealm:self.realm
                                                   where:[NSString stringWithFormat:@"customerID == %zd", customerID]];
    [self executeOnMain:^{
        [self.realm beginWriteTransaction];
        [self.realm deleteObjects:results];
        [self.realm commitWriteTransaction];
        !completeBlock?:completeBlock(nil, @(YES));
    } afterDelay:0];
}

- (void)deleteAllVehicleWithCompleteBlock:(CompleteBlock)completeBlock
{    
    [self executeOnMain:^{
        [self.realm beginWriteTransaction];
        [self.realm deleteObjects:[SRRealmVehicle allObjects]];
        [self.realm commitWriteTransaction];
        !completeBlock?:completeBlock(nil, @(YES));
    } afterDelay:0];
}

- (void)queryVehicleByVehicleID:(NSInteger)vehicleID withCompleteBlock:(CompleteBlock)completeBlock
{
    RLMResults *results = [SRRealmVehicle objectsInRealm:self.realm
                                                   where:[NSString stringWithFormat:@"vehicleID == %zd", vehicleID]];
    NSMutableArray *array = [NSMutableArray array];
    @autoreleasepool {
        for (NSInteger idx = 0; idx < results.count; ++idx) {
            [array addObject:[results[idx] vehicleBasicInfo]];
        }
    }
    !completeBlock?:completeBlock(nil, array);
}

- (void)queryVehicleByCustomerID:(NSInteger)customerID withCompleteBlock:(CompleteBlock)completeBlock
{
    RLMResults *results = [SRRealmVehicle objectsInRealm:self.realm
                                                   where:[NSString stringWithFormat:@"customerID == %zd", customerID]];
    NSMutableArray *array = [NSMutableArray array];
    @autoreleasepool {
        for (NSInteger idx = 0; idx < results.count; ++idx) {
            [array addObject:[results[idx] vehicleBasicInfo]];
        }
    }
    !completeBlock?:completeBlock(nil, array);
}

- (void)queryAllVehicleWithCompleteBlock:(CompleteBlock)completeBlock
{
    RLMResults *results = [SRRealmVehicle allObjects];
    NSMutableArray *array = [NSMutableArray array];
    @autoreleasepool {
        for (NSInteger idx = 0; idx < results.count; ++idx) {
            [array addObject:[results[idx] vehicleBasicInfo]];
        }
    }
    !completeBlock?:completeBlock(nil, array);
}

@end

//
//  SRRealm+OrderStart.m
//  Mizward
//
//  Created by zhangjunbo on 15/9/1.
//  Copyright (c) 2015年 Mizward. All rights reserved.
//

#import "SRRealm+OrderStart.h"
#import "SROrderStartInfo.h"
#import "SRRealmOrderStart.h"
#import <Realm/Realm.h>

@implementation SRRealm (OrderStart)

- (void)updateOrderStartList:(NSArray *)list withCompleteBlock:(CompleteBlock)completeBlock
{
    NSMutableArray *array = [NSMutableArray array];
    [list enumerateObjectsUsingBlock:^(SROrderStartInfo *obj, NSUInteger idx, BOOL *stop) {
        @autoreleasepool {
            SRRealmOrderStart *info = [[SRRealmOrderStart alloc] initWithOrderStartInfo:obj];
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

- (void)deleteOrderStartByVehicleID:(NSInteger)vehicleID withCompleteBlock:(CompleteBlock)completeBlock
{
    RLMResults *results = [SRRealmOrderStart objectsInRealm:self.realm
                                                   where:[NSString stringWithFormat:@"vehicleID == %zd", vehicleID]];
    [self executeOnMain:^{
        [self.realm beginWriteTransaction];
        [self.realm deleteObjects:results];
        [self.realm commitWriteTransaction];
        !completeBlock?:completeBlock(nil, @(YES));
    } afterDelay:0];
    
}

- (void)deleteOrderStartByStartClockID:(NSInteger)startClockID withCompleteBlock:(CompleteBlock)completeBlock
{
    RLMResults *results = [SRRealmOrderStart objectsInRealm:self.realm
                                                      where:[NSString stringWithFormat:@"startClockID == %zd", startClockID]];
    [self executeOnMain:^{
        [self.realm beginWriteTransaction];
        [self.realm deleteObjects:results];
        [self.realm commitWriteTransaction];
        !completeBlock?:completeBlock(nil, @(YES));
    } afterDelay:0];
    
}

- (void)deleteOrderStartByCustomerID:(NSInteger)customerID withCompleteBlock:(CompleteBlock)completeBlock
{
    RLMResults *results = [SRRealmOrderStart objectsInRealm:self.realm
                                                      where:[NSString stringWithFormat:@"customerID == %zd", customerID]];
    [self executeOnMain:^{
        [self.realm beginWriteTransaction];
        [self.realm deleteObjects:results];
        [self.realm commitWriteTransaction];
        !completeBlock?:completeBlock(nil, @(YES));
    } afterDelay:0];
    
}

- (void)deleteAllOrderStartWithCompleteBlock:(CompleteBlock)completeBlock
{
    [self executeOnMain:^{
        [self.realm beginWriteTransaction];
        [self.realm deleteObjects:[SRRealmOrderStart allObjects]];
        [self.realm commitWriteTransaction];
        !completeBlock?:completeBlock(nil, @(YES));
    } afterDelay:0];
    
}

- (void)queryOrderStartByVehicleID:(NSInteger)vehicleID withCompleteBlock:(CompleteBlock)completeBlock
{
    RLMResults *results = [[SRRealmOrderStart objectsInRealm:self.realm
                                                   where:[NSString stringWithFormat:@"vehicleID == %zd ", vehicleID]] sortedResultsUsingProperty:@"startClockID" ascending:YES];
    NSMutableArray *array = [NSMutableArray array];
    @autoreleasepool {
        for (NSInteger idx = 0; idx < results.count; ++idx) {
            [array addObject:[results[idx] orderStartInfo]];
        }
    }
    !completeBlock?:completeBlock(nil, array);
}

- (void)queryOrderStartByStartClockID:(NSInteger)startClockID withCompleteBlock:(CompleteBlock)completeBlock
{
    RLMResults *results = [SRRealmOrderStart objectsInRealm:self.realm
                                                      where:[NSString stringWithFormat:@"startClockID == %zd ", startClockID]];
    SRRealmOrderStart *info = results.firstObject;
    !completeBlock?:completeBlock(nil, info?[info orderStartInfo]:nil);
}

- (void)queryOrderStartByCustomerID:(NSInteger)customerID withCompleteBlock:(CompleteBlock)completeBlock
{
    RLMResults *results = [[SRRealmOrderStart objectsInRealm:self.realm
                                                      where:[NSString stringWithFormat:@"customerID == %zd ", customerID]] sortedResultsUsingProperty:@"startClockID" ascending:YES];
    NSMutableArray *array = [NSMutableArray array];
    @autoreleasepool {
        for (NSInteger idx = 0; idx < results.count; ++idx) {
            [array addObject:[results[idx] orderStartInfo]];
        }
    }
    !completeBlock?:completeBlock(nil, array);
}

- (void)queryAllOrderStartWithCompleteBlock:(CompleteBlock)completeBlock
{
    RLMResults *results = [[SRRealmOrderStart allObjects] sortedResultsUsingProperty:@"startClockID" ascending:YES];
    NSMutableArray *array = [NSMutableArray array];
    @autoreleasepool {
        for (NSInteger idx = 0; idx < results.count; ++idx) {
            [array addObject:[results[idx] orderStartInfo]];
        }
    }
    !completeBlock?:completeBlock(nil, array);
}

@end

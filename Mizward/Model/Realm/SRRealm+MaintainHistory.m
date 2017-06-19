//
//  SRRealm+MaintainHistory.m
//  Mizward
//
//  Created by zhangjunbo on 15/9/1.
//  Copyright (c) 2015年 Mizward. All rights reserved.
//

#import "SRRealm+MaintainHistory.h"
#import "SRMaintainHistory.h"
#import "SRRealmMaintainHistory.h"
#import <Realm/Realm.h>

@implementation SRRealm (MaintainHistory)

- (void)updateMaintainHistoryList:(NSArray *)list withCompleteBlock:(CompleteBlock)completeBlock
{
    NSMutableArray *array = [NSMutableArray array];
    [list enumerateObjectsUsingBlock:^(SRMaintainHistory *obj, NSUInteger idx, BOOL *stop) {
        @autoreleasepool {
            SRRealmMaintainHistory *info = [[SRRealmMaintainHistory alloc] initWithMaintainHistory:obj];
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

- (void)deleteAllMaintainHistoryWithCompleteBlock:(CompleteBlock)completeBlock
{
    [self executeOnMain:^{
        [self.realm beginWriteTransaction];
        [self.realm deleteObjects:[SRRealmMaintainHistory allObjects]];
        [self.realm commitWriteTransaction];
        !completeBlock?:completeBlock(nil, @(YES));
    } afterDelay:0];
    
}

- (void)queryAllMaintainHistoryByVehicleID:(NSInteger)vehicleID withCompleteBlock:(CompleteBlock)completeBlock
{
    RLMResults *results = [[SRRealmMaintainHistory objectsInRealm:self.realm
                                                       where:[NSString stringWithFormat:@"vehicleID == %zd", vehicleID]] sortedResultsUsingProperty:@"startTimeStr" ascending:NO];
    NSMutableArray *array = [NSMutableArray array];
    @autoreleasepool {
        for (NSInteger idx = 0; idx < results.count; ++idx) {
            [array addObject:[results[idx] maintainHistory]];
        }
    }
    !completeBlock?:completeBlock(nil, array);
}

@end

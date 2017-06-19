//
//  SRRealm+MaintainDep.m
//  Mizward
//
//  Created by zhangjunbo on 15/9/1.
//  Copyright (c) 2015年 Mizward. All rights reserved.
//

#import "SRRealm+MaintainDep.h"
#import "SRMaintainDepInfo.h"
#import "SRRealmMaintainDep.h"
#import <Realm/Realm.h>

@implementation SRRealm (MaintainDep)

- (void)updateMaintainDeps:(NSArray *)list withCompleteBlock:(CompleteBlock)completeBlock
{
    NSMutableArray *array = [NSMutableArray array];
    [list enumerateObjectsUsingBlock:^(SRMaintainDepInfo *obj, NSUInteger idx, BOOL *stop) {
        @autoreleasepool {
            SRRealmMaintainDep *info = [[SRRealmMaintainDep alloc] initWithMaintainDepInfo:obj];
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

- (void)deleteAllMaintainDepsWithCompleteBlock:(CompleteBlock)completeBlock
{
    [self executeOnMain:^{
        [self.realm beginWriteTransaction];
        [self.realm deleteObjects:[SRRealmMaintainDep allObjects]];
        [self.realm commitWriteTransaction];
        !completeBlock?:completeBlock(nil, @(YES));
    } afterDelay:0];
    
}

- (void)queryMaintainDepByDepID:(NSInteger)depID withCompleteBlock:(CompleteBlock)completeBlock
{
    RLMResults *results = [SRRealmMaintainDep objectsInRealm:self.realm
                                                    where:[NSString stringWithFormat:@"depID == %zd", depID]];
    NSMutableArray *array = [NSMutableArray array];
    @autoreleasepool {
        for (NSInteger idx = 0; idx < results.count; ++idx) {
            [array addObject:[results[idx] maintainDepInfo]];
        }
    }
    !completeBlock?:completeBlock(nil, array);
}

- (void)queryAllMaintainDepsWithCompleteBlock:(CompleteBlock)completeBlock
{
    RLMResults *results = [SRRealmMaintainDep allObjects];
    NSMutableArray *array = [NSMutableArray array];
    @autoreleasepool {
        for (NSInteger idx = 0; idx < results.count; ++idx) {
            [array addObject:[results[idx] maintainDepInfo]];
        }
    }
    !completeBlock?:completeBlock(nil, array);
}

- (void)queryAllMaintainDepsNameLike:(NSString *)name withCompleteBlock:(CompleteBlock)completeBlock
{
    RLMResults *results = [SRRealmMaintainDep objectsInRealm:self.realm
                                                       where:[NSString stringWithFormat:@"name CONTAINS %@", name]];
    NSMutableArray *array = [NSMutableArray array];
    @autoreleasepool {
        for (NSInteger idx = 0; idx < results.count; ++idx) {
            [array addObject:[results[idx] maintainDepInfo]];
        }
    }
    !completeBlock?:completeBlock(nil, array);
}

@end

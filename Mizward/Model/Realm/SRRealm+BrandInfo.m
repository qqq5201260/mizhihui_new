//
//  SRRealm+BrandInfo.m
//  Mizward
//
//  Created by zhangjunbo on 15/9/1.
//  Copyright (c) 2015年 Mizward. All rights reserved.
//

#import "SRRealm+BrandInfo.h"
#import "SRBrandInfo.h"
#import "SRRealmBrandInfo.h"
#import <Realm/Realm.h>

@implementation SRRealm (BrandInfo)

- (void)updateBrandInfos:(NSArray *)list withCompleteBlock:(CompleteBlock)completeBlock
{
    NSMutableArray *array = [NSMutableArray array];
    [list enumerateObjectsUsingBlock:^(SRBrandInfo *obj, NSUInteger idx, BOOL *stop) {
        @autoreleasepool {
            SRRealmBrandInfo *info = [[SRRealmBrandInfo alloc] initWithBrandInfo:obj];
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

- (void)deleteAllBrandInfosWithCompleteBlock:(CompleteBlock)completeBlock
{
    [self executeOnMain:^{
        [self.realm beginWriteTransaction];
        [self.realm deleteObjects:[SRRealmBrandInfo allObjects]];
        [self.realm commitWriteTransaction];
        !completeBlock?:completeBlock(nil, @(YES));
    } afterDelay:0];
}

- (void)queryAllBrandInfosWithCompleteBlock:(CompleteBlock)completeBlock
{
    RLMResults *results = [[SRRealmBrandInfo allObjects] sortedResultsUsingProperty:@"entityID" ascending:YES];

    NSMutableArray *array = [NSMutableArray array];
    @autoreleasepool {
        for (NSInteger idx = 0; idx < results.count; ++idx) {
            [array addObject:[results[idx] brandInfo]];
        }
    }
    !completeBlock?:completeBlock(nil, array);
}

@end

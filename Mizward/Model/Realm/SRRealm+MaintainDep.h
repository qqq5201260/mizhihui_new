//
//  SRRealm+MaintainDep.h
//  Mizward
//
//  Created by zhangjunbo on 15/9/1.
//  Copyright (c) 2015年 Mizward. All rights reserved.
//

#import "SRRealm.h"

@interface SRRealm (MaintainDep)

- (void)updateMaintainDeps:(NSArray *)list withCompleteBlock:(CompleteBlock)completeBlock;
- (void)deleteAllMaintainDepsWithCompleteBlock:(CompleteBlock)completeBlock;

- (void)queryMaintainDepByDepID:(NSInteger)depID withCompleteBlock:(CompleteBlock)completeBlock;
- (void)queryAllMaintainDepsWithCompleteBlock:(CompleteBlock)completeBlock;

- (void)queryAllMaintainDepsNameLike:(NSString *)name withCompleteBlock:(CompleteBlock)completeBlock;

@end

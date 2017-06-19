//
//  SRRealm+BrandInfo.h
//  Mizward
//
//  Created by zhangjunbo on 15/9/1.
//  Copyright (c) 2015年 Mizward. All rights reserved.
//

#import "SRRealm.h"

@interface SRRealm (BrandInfo)

- (void)updateBrandInfos:(NSArray *)list withCompleteBlock:(CompleteBlock)completeBlock;
- (void)deleteAllBrandInfosWithCompleteBlock:(CompleteBlock)completeBlock;

- (void)queryAllBrandInfosWithCompleteBlock:(CompleteBlock)completeBlock;

@end

//
//  SRDataBase+BrandInfo.h
//  SiRuiV4.0
//
//  Created by zhangjunbo on 15/7/28.
//  Copyright (c) 2015年 SiRui. All rights reserved.
//

#import "SRDataBase.h"

@interface SRDataBase (BrandInfo)

//创建表
- (void)createBrandInfoTable;
//更新列表
- (void)updateBrandInfos:(NSArray *)list withCompleteBlock:(CompleteBlock)completeBlock;
//删除所有
- (void)deleteAllBrandInfosWithCompleteBlock:(CompleteBlock)completeBlock;
//查询单个品牌
- (void)queryBrandInfoByBrandID:(NSInteger)brandID withCompleteBlock:(CompleteBlock)completeBlock;
//查询所有
- (void)queryAllBrandInfosWithCompleteBlock:(CompleteBlock)completeBlock;

@end

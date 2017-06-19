//
//  SRDataBase+MaintainDep.h
//  SiRuiV4.0
//
//  Created by zhangjunbo on 15/7/28.
//  Copyright (c) 2015年 SiRui. All rights reserved.
//

#import "SRDataBase.h"

@interface SRDataBase (MaintainDep)

//创建表
- (void)createMaintainDepTable;
//更新
- (void)updateMaintainDeps:(NSArray *)list withCompleteBlock:(CompleteBlock)completeBlock;
//删除所有
- (void)deleteAllMaintainDepsWithCompleteBlock:(CompleteBlock)completeBlock;
//根据ID查询
- (void)queryMaintainDepByDepID:(NSInteger)depID withCompleteBlock:(CompleteBlock)completeBlock;
//查询所有
- (void)queryAllMaintainDepsWithCompleteBlock:(CompleteBlock)completeBlock;
//模糊查询
- (void)queryAllMaintainDepsNameLike:(NSString *)name withCompleteBlock:(CompleteBlock)completeBlock;

@end

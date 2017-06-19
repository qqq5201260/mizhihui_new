//
//  SRDataBase+Customer.h
//  SiRuiV4.0
//
//  Created by zhangjunbo on 15/6/16.
//  Copyright (c) 2015年 SiRui. All rights reserved.
//

#import "SRDataBase.h"

@class SRCustomer;

@interface SRDataBase (Customer)

//创建表
- (void)createCustomerTable;
//更新
- (void)updateCustomer:(SRCustomer *)customer withCompleteBlock:(CompleteBlock)completeBlock;
//根据ID删除
- (void)deleteCustomerByID:(NSInteger)customerID withCompleteBlock:(CompleteBlock)completeBlock;
//根据用户名删除
- (void)deleteCustomerByUserName:(NSString *)userName withCompleteBlock:(CompleteBlock)completeBlock;
//删除所有
- (void)deleteAllCustomerWithCompleteBlock:(CompleteBlock)completeBlock;
//根据ID查询
- (void)queryCustomerByID:(NSInteger)customerID withCompleteBlock:(CompleteBlock)completeBlock;
//根据用户名查询
- (void)queryCustomerByUserName:(NSString *)userName withCompleteBlock:(CompleteBlock)completeBlock;
//查询所有
- (void)queryAllCustomerWithCompleteBlock:(CompleteBlock)completeBlock;

@end

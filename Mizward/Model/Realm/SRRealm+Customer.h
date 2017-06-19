//
//  SRRealm+Customer.h
//  Mizward
//
//  Created by zhangjunbo on 15/9/1.
//  Copyright (c) 2015年 Mizward. All rights reserved.
//

#import "SRRealm.h"

@class  SRCustomer;

@interface SRRealm (Customer)

- (void)updateCustomer:(SRCustomer *)customer withCompleteBlock:(CompleteBlock)completeBlock;

- (void)deleteCustomerByID:(NSInteger)customerID withCompleteBlock:(CompleteBlock)completeBlock;
- (void)deleteCustomerByUserName:(NSString *)userName withCompleteBlock:(CompleteBlock)completeBlock;
- (void)deleteAllCustomerWithCompleteBlock:(CompleteBlock)completeBlock;

- (void)queryCustomerByID:(NSInteger)customerID withCompleteBlock:(CompleteBlock)completeBlock;
- (void)queryCustomerByUserName:(NSString *)userName withCompleteBlock:(CompleteBlock)completeBlock;
- (void)queryAllCustomerWithCompleteBlock:(CompleteBlock)completeBlock;

@end

//
//  SRRealm+Customer.m
//  Mizward
//
//  Created by zhangjunbo on 15/9/1.
//  Copyright (c) 2015年 Mizward. All rights reserved.
//

#import "SRRealm+Customer.h"
#import "SRCustomer.h"
#import "SRRealmCustomer.h"
#import <Realm/Realm.h>

@implementation SRRealm (Customer)

- (void)updateCustomer:(SRCustomer *)customer withCompleteBlock:(CompleteBlock)completeBlock
{
    [self executeOnMain:^{
        [self.realm beginWriteTransaction];
        [self.realm deleteAllObjects];
        [self.realm addOrUpdateObject:[[SRRealmCustomer alloc] initWithCustomer:customer]];
        [self.realm commitWriteTransaction];
        !completeBlock?:completeBlock(nil, @(YES));
    } afterDelay:0];
}

- (void)deleteCustomerByID:(NSInteger)customerID withCompleteBlock:(CompleteBlock)completeBlock
{
    [self executeOnMain:^{
        [self.realm beginWriteTransaction];
        RLMResults *results = [SRRealmCustomer objectsInRealm:self.realm
                                                        where:[NSString stringWithFormat:@"customerID == %zd", customerID]];
        [self.realm deleteObjects:results];
        [self.realm commitWriteTransaction];
        !completeBlock?:completeBlock(nil, @(YES));
    } afterDelay:0];
}

- (void)deleteCustomerByUserName:(NSString *)userName withCompleteBlock:(CompleteBlock)completeBlock
{
    [self executeOnMain:^{
        [self.realm beginWriteTransaction];
        RLMResults *results = [SRRealmCustomer objectsInRealm:self.realm
                                                        where:[NSString stringWithFormat:@"customerUserName == %zd", userName]];
        [self.realm deleteObjects:results];
        [self.realm commitWriteTransaction];
        !completeBlock?:completeBlock(nil, @(YES));
    } afterDelay:0];
    
}

- (void)deleteAllCustomerWithCompleteBlock:(CompleteBlock)completeBlock
{
    [self executeOnMain:^{
        [self.realm beginWriteTransaction];
        [self.realm deleteObjects:[SRRealmCustomer allObjects]];
        [self.realm commitWriteTransaction];
        !completeBlock?:completeBlock(nil, @(YES));
    } afterDelay:0];
    
}

- (void)queryCustomerByID:(NSInteger)customerID withCompleteBlock:(CompleteBlock)completeBlock
{
    RLMResults *results = [SRRealmCustomer objectsInRealm:self.realm
                                                    where:[NSString stringWithFormat:@"customerID == %zd", customerID]];
    SRRealmCustomer *customer = results.firstObject;
    !completeBlock?:completeBlock(nil, customer?[customer customer]:nil);
}

- (void)queryCustomerByUserName:(NSString *)userName withCompleteBlock:(CompleteBlock)completeBlock
{
    RLMResults *results = [SRRealmCustomer objectsInRealm:self.realm
                                                    where:[NSString stringWithFormat:@"customerUserName == %@", userName]];
    SRRealmCustomer *customer = results.firstObject;
    !completeBlock?:completeBlock(nil, customer?[customer customer]:nil);
}

- (void)queryAllCustomerWithCompleteBlock:(CompleteBlock)completeBlock
{
    RLMResults *results = [SRRealmCustomer allObjects];
    NSMutableArray *array = [NSMutableArray array];
    @autoreleasepool {
        for (NSInteger idx = 0; idx < results.count; ++idx) {
            [array addObject:[results[idx] customer]];
        }
    }
    !completeBlock?:completeBlock(nil, array);
}

@end

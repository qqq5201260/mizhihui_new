//
//  SRRealm+Message.m
//  Mizward
//
//  Created by zhangjunbo on 15/9/1.
//  Copyright (c) 2015年 Mizward. All rights reserved.
//

#import "SRRealm+Message.h"
#import "SRMessageInfo.h"
#import "SRRealmMessage.h"
#import <Realm/Realm.h>

@implementation SRRealm (Message)

- (void)updateMessageInfo:(SRMessageInfo *)info withCompleteBlock:(CompleteBlock)completeBlock
{
    [self executeOnMain:^{
        [self.realm beginWriteTransaction];
        [self.realm addOrUpdateObject:[[SRRealmMessage alloc] initWithMessageInfo:info]];
        [self.realm commitWriteTransaction];
        !completeBlock?:completeBlock(nil, @(YES));
    } afterDelay:0];
    
}

- (void)updateMessageInfos:(NSArray *)infos withCompleteBlock:(CompleteBlock)completeBlock
{
    NSMutableArray *array = [NSMutableArray array];
    [infos enumerateObjectsUsingBlock:^(SRMessageInfo *obj, NSUInteger idx, BOOL *stop) {
        @autoreleasepool {
            SRRealmMessage *info = [[SRRealmMessage alloc] initWithMessageInfo:obj];
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

- (void)deleteMessageInfo:(SRMessageInfo *)info withCompleteBlock:(CompleteBlock)completeBlock
{
    RLMResults *results = [SRRealmMessage objectsInRealm:self.realm
                                                   where:[NSString stringWithFormat:@"msgid == %zd", info.msgid]];
    [self executeOnMain:^{
        [self.realm beginWriteTransaction];
        [self.realm deleteObjects:results];
        [self.realm commitWriteTransaction];
        !completeBlock?:completeBlock(nil, @(YES));
    } afterDelay:0];
    
}

- (void)deleteMessageInfoWithMessageType:(SRMessageType)messageType CompleteBlock:(CompleteBlock)completeBlock
{
    RLMResults *results = [SRRealmMessage objectsInRealm:self.realm
                                                   where:[NSString stringWithFormat:@"type == %zd", messageType]];
    [self executeOnMain:^{
        [self.realm beginWriteTransaction];
        [self.realm deleteObjects:results];
        [self.realm commitWriteTransaction];
        !completeBlock?:completeBlock(nil, @(YES));
    } afterDelay:0];
    
}

- (void)deleteAllMessageInfosWithCompleteBlock:(CompleteBlock)completeBlock
{
    [self executeOnMain:^{
        [self.realm beginWriteTransaction];
        [self.realm deleteObjects:[SRRealmMessage allObjects]];
        [self.realm commitWriteTransaction];
        !completeBlock?:completeBlock(nil, @(YES));
    } afterDelay:0];
    
}

- (void)queryMessageInfoWithVehicleID:(NSInteger)vehicleID customerID:(NSInteger)customerID messageType:(SRMessageType)messageType CompleteBlock:(CompleteBlock)completeBlock
{
    RLMResults *results = [SRRealmMessage objectsInRealm:self.realm
                                                   where:[NSString stringWithFormat:@"vehicleid == %zd AND customerid == %zd AND type == %zd", vehicleID, customerID, messageType]];
    NSMutableArray *array = [NSMutableArray array];
    @autoreleasepool {
        for (NSInteger idx = 0; idx < results.count; ++idx) {
            [array addObject:[results[idx] messageInfo]];
        }
    }
    !completeBlock?:completeBlock(nil, array);
}

- (void)queryMessageInfoWithMessageType:(SRMessageType)messageType CompleteBlock:(CompleteBlock)completeBlock
{
    RLMResults *results = [SRRealmMessage objectsInRealm:self.realm
                                                   where:[NSString stringWithFormat:@"type == %zd", messageType]];
    NSMutableArray *array = [NSMutableArray array];
    @autoreleasepool {
        for (NSInteger idx = 0; idx < results.count; ++idx) {
            [array addObject:[results[idx] messageInfo]];
        }
    }
    !completeBlock?:completeBlock(nil, array);
}

- (void)queryMessageInfoWithMessageID:(NSInteger)msgID CompleteBlock:(CompleteBlock)completeBlock
{
    RLMResults *results = [SRRealmMessage objectsInRealm:self.realm
                                                   where:[NSString stringWithFormat:@"msgid == %zd", msgID]];
    SRRealmMessage *info = results.firstObject;
    !completeBlock?:completeBlock(nil, info?[info messageInfo]:nil);
}

- (void)queryAllMessageInfosWithCompleteBlock:(CompleteBlock)completeBlock
{
    RLMResults *results = [SRRealmMessage allObjects];
    NSMutableArray *array = [NSMutableArray array];
    @autoreleasepool {
        for (NSInteger idx = 0; idx < results.count; ++idx) {
            [array addObject:[results[idx] messageInfo]];
        }
    }
    !completeBlock?:completeBlock(nil, array);

}

@end

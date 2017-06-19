//
//  SRRealm+MaintainReserve.m
//  Mizward
//
//  Created by zhangjunbo on 15/9/1.
//  Copyright (c) 2015年 Mizward. All rights reserved.
//

#import "SRRealm+MaintainReserve.h"
#import "SRMaintainReserveInfo.h"
#import "SRRealmMaintainReserve.h"
#import <Realm/Realm.h>

@implementation SRRealm (MaintainReserve)

- (void)updateMaintainReserveInfo:(SRMaintainReserveInfo *)info withCompleteBlock:(CompleteBlock)completeBlock
{
    [self executeOnMain:^{
        [self.realm beginWriteTransaction];
        [self.realm deleteAllObjects];
        [self.realm addOrUpdateObject:[[SRRealmMaintainReserve alloc] initWithMaintainReserveInfo:info]];
        [self.realm commitWriteTransaction];
        !completeBlock?:completeBlock(nil, @(YES));
    } afterDelay:0];
    
}

- (void)deleteAllMaintainReserveInfoWithCompleteBlock:(CompleteBlock)completeBlock
{
    [self executeOnMain:^{
        [self.realm beginWriteTransaction];
        [self.realm deleteAllObjects];
        [self.realm commitWriteTransaction];
        !completeBlock?:completeBlock(nil, @(YES));
    } afterDelay:0];
    
}

- (void)deleteMaintainReserveInfoByVehicleID:(NSInteger)vehicleID withCompleteBlock:(CompleteBlock)completeBlock
{
    RLMResults *results = [SRRealmMaintainReserve objectsInRealm:self.realm
                                                           where:[NSString stringWithFormat:@"vehicleID == %zd", vehicleID]];
    [self executeOnMain:^{
        [self.realm beginWriteTransaction];
        [self.realm deleteObjects:results];
        [self.realm commitWriteTransaction];
        !completeBlock?:completeBlock(nil, @(YES));
    } afterDelay:0];
    
}

- (void)queryMaintainReserveInfoByVehicleID:(NSInteger)vehicleID withCompleteBlock:(CompleteBlock)completeBlock
{
    RLMResults *results = [SRRealmMaintainReserve objectsInRealm:self.realm
                                                    where:[NSString stringWithFormat:@"vehicleID == %zd", vehicleID]];
    SRRealmMaintainReserve *info = results.firstObject;
    !completeBlock?:completeBlock(nil, info?[info maintainReserveInfo]:nil);
}

@end

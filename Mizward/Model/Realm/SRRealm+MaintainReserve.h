//
//  SRRealm+MaintainReserve.h
//  Mizward
//
//  Created by zhangjunbo on 15/9/1.
//  Copyright (c) 2015年 Mizward. All rights reserved.
//

#import "SRRealm.h"

@class SRMaintainReserveInfo;

@interface SRRealm (MaintainReserve)

- (void)updateMaintainReserveInfo:(SRMaintainReserveInfo *)info withCompleteBlock:(CompleteBlock)completeBlock;
- (void)deleteAllMaintainReserveInfoWithCompleteBlock:(CompleteBlock)completeBlock;
- (void)deleteMaintainReserveInfoByVehicleID:(NSInteger)vehicleID withCompleteBlock:(CompleteBlock)completeBlock;

- (void)queryMaintainReserveInfoByVehicleID:(NSInteger)vehicleID withCompleteBlock:(CompleteBlock)completeBlock;

@end

//
//  SRRealm+MaintainHistory.h
//  Mizward
//
//  Created by zhangjunbo on 15/9/1.
//  Copyright (c) 2015年 Mizward. All rights reserved.
//

#import "SRRealm.h"

@interface SRRealm (MaintainHistory)

- (void)updateMaintainHistoryList:(NSArray *)list withCompleteBlock:(CompleteBlock)completeBlock;

- (void)deleteAllMaintainHistoryWithCompleteBlock:(CompleteBlock)completeBlock;

- (void)queryAllMaintainHistoryByVehicleID:(NSInteger)vehicleID withCompleteBlock:(CompleteBlock)completeBlock;

@end

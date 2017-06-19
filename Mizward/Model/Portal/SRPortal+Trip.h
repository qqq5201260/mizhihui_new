//
//  SRPortal+Trip.h
//  SiRuiV4.0
//
//  Created by zhangjunbo on 15/6/25.
//  Copyright (c) 2015年 SiRui. All rights reserved.
//

#import "SRPortal.h"

@class SRPortalRequestQueryTrip, SRPortalRequestQueryTripGPSPoints;

@interface SRPortal (Trip)

//查询轨迹列表
+ (void)queryVehicleTripsWithRequest:(SRPortalRequestQueryTrip *)request andCompleteBlock:(CompleteBlock)completeBlock;

//查询轨迹点
+ (void)queryVehicleTripGPSPointsWithRequest:(SRPortalRequestQueryTripGPSPoints *)request andCompleteBlock:(CompleteBlock)completeBlock;

//删除轨迹
+ (void)deleteTrips:(NSArray *)trips withCompleteBlock:(CompleteBlock)completeBlock;

@end

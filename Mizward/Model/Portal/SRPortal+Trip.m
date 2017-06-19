//
//  SRPortal+Trip.m
//  SiRuiV4.0
//
//  Created by zhangjunbo on 15/6/25.
//  Copyright (c) 2015年 SiRui. All rights reserved.
//

#import "SRPortal+Trip.h"
#import "SRPortalRequest.h"
#import "SRPortalResponse.h"
#import "SRURLUtil.h"
#import "SRHttpUtil.h"
#import "SRTripInfo.h"
#import "SRTripPoint.h"
#import "SRDataBase+Trip.h"
#import "SRDataBase+TripPoints.h"
#import "SRDataBase+Vehicle.h"
#import "SRVehicleBasicInfo.h"
#import "SRUserDefaults.h"
#import <MJExtension/MJExtension.h>

@implementation SRPortal (Trip)

//查询轨迹列表
+ (void)queryVehicleTripsWithRequest:(SRPortalRequestQueryTrip *)request andCompleteBlock:(CompleteBlock)completeBlock
{
    [self queryVehicleTripsWithPageRequest:[[SRPortalRequestQueryTripPage alloc] initWithRequest:request] onlyCurrentPage:NO andCompleteBlock:^(NSError *error, NSArray *list) {
        
        if (error) {
            if (completeBlock) completeBlock(error, nil);
            return ;
        }
        
        NSArray *sorted = [list sortedArrayWithOptions:NSSortConcurrent usingComparator:^NSComparisonResult(SRTripInfo *obj1, SRTripInfo *obj2) {
            //升序
            return [obj1.startTime compare:obj2.startTime] == NSOrderedDescending;
        }];
        
        [[SRDataBase sharedInterface] deleteTripByDate:request.date vehicleID:request.vehicleID withCompleteBlock:^(NSError *error, id responseObject) {
            [[SRDataBase sharedInterface] updateTripList:sorted withCompleteBlock:nil];
        }];
        
        if (completeBlock) completeBlock(nil, sorted);
    }];
}

//查询轨迹列表-按页查询
+ (void)queryVehicleTripsWithPageRequest:(SRPortalRequestQueryTripPage *)request onlyCurrentPage:(BOOL)onlyCurrent andCompleteBlock:(CompleteBlock)completeBlock
{
    [SRHttpUtil POST :[SRURLUtil Portal_QueryTripUrl] WithParameter:request.customerDictionary completeBlock:^(NSError *error, id responseObject) {
        
        if (error) {
            if (completeBlock) completeBlock(error, responseObject);
            return ;
        }
        
        SRPortalResponse *response = [SRPortalResponse objectWithKeyValues:responseObject];
        if (response.result.resultCode != SRHTTP_Success) {
            error = [NSError errorWithDomain:response.result.resultMessage
                                        code:response.result.resultCode
                                    userInfo:response.result.fieldErrors];
            if (completeBlock) completeBlock(error, nil);
        } else {
            
            //读取数据
            NSMutableArray  *tripList = (NSMutableArray *)[SRTripInfo objectArrayWithKeyValuesArray:response.pageResult.entityList];
            
            //获取余下页数的数据
            if (response.pageResult.totalPage > response.pageResult.pageIndex && !onlyCurrent) {
                //继续获取
                dispatch_apply(response.pageResult.totalPage - response.pageResult.pageIndex, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(size_t index) {
                    SRPortalRequestQueryTripPage *pageRequest = [[SRPortalRequestQueryTripPage alloc] initWithRequest:request];
                    pageRequest.pageIndex = response.pageResult.totalPage - index;
                    [self queryVehicleTripsWithPageRequest:pageRequest onlyCurrentPage:YES andCompleteBlock:^(NSError *error, id responseObject) {
                        if (error) {
                            SRLogError(@"Fail to get TripList with request %@", pageRequest.keyValues);
                        } else {
                            [tripList addObjectsFromArray:responseObject];
                        }
                    }];
                });
            }
            
            if (completeBlock) completeBlock(nil, tripList);
        }
    }];
}

//查询轨迹点
+ (void)queryVehicleTripGPSPointsWithRequest:(SRPortalRequestQueryTripGPSPoints *)request andCompleteBlock:(CompleteBlock)completeBlock
{
    [[SRDataBase sharedInterface] queryTripPointsByTripID:request.tripID withCompleteBlock:^(NSError *error, NSArray *responseObject) {
        if (!error && responseObject && responseObject.count>0) {
            completeBlock(nil, responseObject);
        } else {
            [self queryVehicleTripGPSPointsWithRequest:[[SRPortalRequestQueryTripGPSPointsPage alloc] initWithRequest:request] onlyCurrentPage:NO andCompleteBlock:^(NSError *error, NSMutableArray *list) {
                
                if (error) {
                    if (completeBlock) completeBlock(error, nil);
                    return ;
                }
                
                if (completeBlock) completeBlock(nil, list);
                
                [[SRDataBase sharedInterface] updateTripPoints:list tripID:request.tripID andVehicleID:[SRUserDefaults currentVehicleID] withCompleteBlock:nil];
            }];
        }
    }];
}

//查询轨迹点-按页查询
+ (void)queryVehicleTripGPSPointsWithRequest:(SRPortalRequestQueryTripGPSPointsPage *)request onlyCurrentPage:(BOOL)onlyCurrent andCompleteBlock:(CompleteBlock)completeBlock
{
    [SRHttpUtil POST :[SRURLUtil Portal_QueryTripGPSPointsUrl] WithParameter:request.keyValues completeBlock:^(NSError *error, id responseObject) {
        
        if (error) {
            if (completeBlock) completeBlock(error, responseObject);
            return ;
        }
        
        SRPortalResponse *response = [SRPortalResponse objectWithKeyValues:responseObject];
        if (response.result.resultCode != SRHTTP_Success) {
            error = [NSError errorWithDomain:response.result.resultMessage
                                        code:response.result.resultCode
                                    userInfo:response.result.fieldErrors];
            if (completeBlock) completeBlock(error, nil);
        } else {
            
            //读取数据
            NSMutableArray  *tripList = (NSMutableArray *)[SRTripPoint objectArrayWithKeyValuesArray:response.pageResult.entityList];
            
            //获取余下页数的数据
            if (response.pageResult.totalPage > response.pageResult.pageIndex && !onlyCurrent) {
                //继续获取
                dispatch_apply(response.pageResult.totalPage - response.pageResult.pageIndex, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(size_t index) {
                    SRPortalRequestQueryTripGPSPointsPage *pageRequest = [[SRPortalRequestQueryTripGPSPointsPage alloc] initWithRequest:request];
                    pageRequest.pageIndex = response.pageResult.totalPage - index;
                    [self queryVehicleTripGPSPointsWithRequest:pageRequest onlyCurrentPage:YES andCompleteBlock:^(NSError *error, id responseObject) {
                        if (error) {
                            SRLogError(@"Fail to get TripList with request %@", pageRequest.keyValues);
                        } else {
                            [tripList addObjectsFromArray:responseObject];
                        }
                    }];
                });
            }
            
            if (completeBlock) completeBlock(nil, tripList);
        }
    }];
}

//删除轨迹
+ (void)deleteTrips:(NSArray *)trips withCompleteBlock:(CompleteBlock)completeBlock
{
    SRPortalRequestDeleteTrip *request = [[SRPortalRequestDeleteTrip alloc] init];
    [request setTripArray:trips];
    [SRHttpUtil POST :[SRURLUtil Portal_DeleteTripUrl] WithParameter:request.keyValues completeBlock:^(NSError *error, id responseObject) {
        
        if (error) {
            if (completeBlock) completeBlock(error, responseObject);
            return ;
        }
        
        SRPortalResponse *response = [SRPortalResponse objectWithKeyValues:responseObject];
        if (response.result.resultCode != SRHTTP_Success) {
            error = [NSError errorWithDomain:response.result.resultMessage
                                        code:response.result.resultCode
                                    userInfo:response.result.fieldErrors];
            if (completeBlock) completeBlock(error, nil);
        } else {
            [trips enumerateObjectsUsingBlock:^(SRTripInfo * obj, NSUInteger idx, BOOL *stop) {
                [[SRDataBase sharedInterface] deleteTripByTripID:obj.tripID withCompleteBlock:nil];
            }];
            
            if (completeBlock) completeBlock(nil, @(YES));
        }
    }];
}

@end

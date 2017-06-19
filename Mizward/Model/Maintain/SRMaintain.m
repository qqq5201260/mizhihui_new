//
//  SRMaintain.m
//  SiRuiV4.0
//
//  Created by zhangjunbo on 15/7/27.
//  Copyright (c) 2015年 SiRui. All rights reserved.
//

#import "SRMaintain.h"
#import "SRMaintainReserveInfo.h"
#import "SRURLUtil.h"
#import "SRHttpUtil.h"
#import "SRMaintainRequest.h"
#import "SRPortalResponse.h"
#import "SRMaintainDepInfo.h"
#import "SRMaintainResponse.h"
#import "SRUserDefaults.h"
#import "SRMaintainHistory.h"
#import "SRDataBase+MaintainReserve.h"
#import "SRDataBase+MaintainDep.h"
#import "SRDataBase+MaintainHistory.h"
#import <MJExtension/MJExtension.h>

@implementation SRMaintain

//查询下次保养项目
+ (void)queryMaintainReserveWithRequest:(SRMaintainRequestQueryReserve *)request andCompleteBlock:(CompleteBlock)completeBlock
{
    [SRHttpUtil POST:[SRURLUtil Portal_MaintainQueryReserveUrl] WithParameter:request.keyValues completeBlock:^(NSError *error, id responseObject) {
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
            SRMaintainReserveInfo *info = [SRMaintainReserveInfo objectWithKeyValues:response.entity];
            info.vehicleID = request.vehicleID;
            
            [[SRDataBase sharedInterface] updateMaintainReserveInfo:info withCompleteBlock:nil];
            
            if (completeBlock) completeBlock(nil, info);
        }
    }];
}

//查询4S店
+ (void)queryMaintainDepWithCompleteBlock:(CompleteBlock)completeBlock
{
    [self queryMaintainDepWithRequest:[[SRMaintainRequestQueryDepPage alloc] init] onlyCurrentPage:NO andCompleteBlock:^(NSError *error, NSMutableArray *list) {
        if (error) {
            if (completeBlock) completeBlock(error, nil);
            return ;
        }
        
        if (list && list.count>0) {
            [[SRDataBase sharedInterface] updateMaintainDeps:list withCompleteBlock:nil];
        }
        
        if (completeBlock) completeBlock(nil, list);
    }];
}

///查询4S店-按页查询
+ (void)queryMaintainDepWithRequest:(SRMaintainRequestQueryDepPage *)request onlyCurrentPage:(BOOL)onlyCurrent andCompleteBlock:(CompleteBlock)completeBlock
{
    [SRHttpUtil POST :[SRURLUtil Portal_MaintainQueryDepUrl] WithParameter:request.keyValues completeBlock:^(NSError *error, id responseObject) {
        
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
            
            SRMaintainDepResponse *depResponse = [SRMaintainDepResponse objectWithKeyValues:response.entity];
            
            if (!depResponse) {
                if (completeBlock) completeBlock(nil, nil);
                return;
            }
            
            [SRUserDefaults updateMaintainDepCacheTime:depResponse.cacheTime];
        
            //读取数据
            NSMutableArray *depList = [NSMutableArray array];
            //只读取首页的默认部门信息
            if (request.pageIndex == 1 && depResponse.dep) {
                [depList addObject:depResponse.dep];
            }
            
            if (depResponse.depVOs) {
                [depList addObjectsFromArray:depResponse.depVOs];
            }
            
            //获取余下页数的数据
            if (response.pageResult.totalPage > response.pageResult.pageIndex && !onlyCurrent) {
                //继续获取
                dispatch_apply(response.pageResult.totalPage - response.pageResult.pageIndex, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(size_t index) {
                    SRMaintainRequestQueryDepPage *pageRequest = [[SRMaintainRequestQueryDepPage alloc] init];
                    pageRequest.pageIndex = response.pageResult.totalPage - index;
                    [self queryMaintainDepWithRequest:pageRequest onlyCurrentPage:YES andCompleteBlock:^(NSError *error, id responseObject) {
                        if (error) {
                            SRLogError(@"Fail to get TripList with request %@", pageRequest.keyValues);
                        } else {
                            [depList addObjectsFromArray:responseObject];
                        }
                    }];
                });
            }
            
            if (completeBlock) completeBlock(nil, depList);
        }
    }];
}

//添加预约
+ (void)addMaintainReserveWithRequest:(SRMaintainRequestAddReserve *)request andCompleteBlock:(CompleteBlock)completeBlock
{
    [SRHttpUtil POST:[SRURLUtil Portal_MaintainAddReserveUrl] WithParameter:request.keyValues completeBlock:^(NSError *error, id responseObject) {
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
            SRMaintainHistory *info = [SRMaintainHistory objectWithKeyValues:response.entity];
            [[SRDataBase sharedInterface] updateMaintainHistoryList:@[info] withCompleteBlock:nil];
            if (completeBlock) completeBlock(nil, info);
        }
    }];
}

//添加历史记录
+ (void)addMaintainHistoryWithRequest:(SRMaintainRequestAddHistory *)request andCompleteBlock:(CompleteBlock)completeBlock
{
    [SRHttpUtil POST:[SRURLUtil Portal_MaintainAddHistoryUrl] WithParameter:request.keyValues completeBlock:^(NSError *error, id responseObject) {
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
            SRMaintainHistory *info = [SRMaintainHistory objectWithKeyValues:response.entity];
            [[SRDataBase sharedInterface] updateMaintainHistoryList:@[info] withCompleteBlock:nil];
            if (completeBlock) completeBlock(nil, info);
        }
    }];
}

static NSInteger currentMessagePage = 0;
static NSInteger totalMessagePage = 0;
//查询历史记录
+ (void)queryMaintainHistoryWithRequest:(SRMaintainRequestQueryHistoryPage *)request isRefresh:(BOOL)isRefresh andCompleteBlock:(CompleteBlock)completeBlock
{
    if (isRefresh) {
        currentMessagePage = 1;
    } else if (currentMessagePage > totalMessagePage) {
        [[SRDataBase sharedInterface] queryAllMaintainHistoryByVehicleID:request.vehicleID withCompleteBlock:^(NSError *error, id responseObject) {
            if (completeBlock) completeBlock(nil, responseObject);
        }];
//        if (completeBlock) completeBlock(nil, nil);
        return;
    } else {
        ++currentMessagePage;
    }
    request.pageIndex = currentMessagePage;
    
    [SRHttpUtil POST:[SRURLUtil Portal_MaintainQueryHistoryUrl] WithParameter:request.keyValues completeBlock:^(NSError *error, id responseObject) {
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
            totalMessagePage = response.pageResult.totalPage;
            currentMessagePage = response.pageResult.pageIndex;
            
            NSArray *infos = [SRMaintainHistory objectArrayWithKeyValuesArray:response.pageResult.entityList];
            if (currentMessagePage == 1) {
                //第一页，清空数据
                [[SRDataBase sharedInterface] deleteMaintainReserveInfoByVehicleID:request.vehicleID withCompleteBlock:^(NSError *error, id responseObject) {
//                    [[SRDataBase sharedInterface] updateMaintainHistoryList:infos withCompleteBlock:^(NSError *error, id responseObject) {
//                        if (completeBlock) completeBlock(nil, infos);
//                    }];
                    [[SRDataBase sharedInterface] updateMaintainHistoryList:infos withCompleteBlock:^(NSError *error, id responseObject) {
                        [[SRDataBase sharedInterface] queryAllMaintainHistoryByVehicleID:request.vehicleID withCompleteBlock:^(NSError *error, id responseObject) {
                            if (completeBlock) completeBlock(nil, responseObject);
                        }];
                    }];
                }];
            } else {
                [[SRDataBase sharedInterface] updateMaintainHistoryList:infos withCompleteBlock:^(NSError *error, id responseObject) {
                    [[SRDataBase sharedInterface] queryAllMaintainHistoryByVehicleID:request.vehicleID withCompleteBlock:^(NSError *error, id responseObject) {
                        if (completeBlock) completeBlock(nil, responseObject);
                    }];
                }];
            }
        }
    }];
}

//修改历史记录
+ (void)updateMaintainHistoryWithRequest:(SRMaintainRequestUpdateHistory *)request andCompleteBlock:(CompleteBlock)completeBlock
{
    [SRHttpUtil POST:[SRURLUtil Portal_MaintainUpdateHistoryUrl] WithParameter:request.keyValues completeBlock:^(NSError *error, id responseObject) {
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
            SRMaintainHistory *info = [SRMaintainHistory objectWithKeyValues:response.entity];
            [[SRDataBase sharedInterface] updateMaintainHistoryList:@[info] withCompleteBlock:nil];
            if (completeBlock) completeBlock(nil, info);
        }
    }];
}

//删除历史记录
+ (void)deleteMaintainHistoryWithRequest:(SRMaintainRequestDeleteHistory *)request andCompleteBlock:(CompleteBlock)completeBlock
{
    [SRHttpUtil POST:[SRURLUtil Portal_MaintainDeleteHistoryUrl] WithParameter:request.keyValues completeBlock:^(NSError *error, id responseObject) {
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
            SRMaintainHistory *info = [SRMaintainHistory objectWithKeyValues:response.entity];
            [[SRDataBase sharedInterface] deleteMaintainHistoryByMaintenReservationID:request.maintenReservationID withCompleteBlock:nil];
            if (completeBlock) completeBlock(nil, info);
        }
    }];
}

@end

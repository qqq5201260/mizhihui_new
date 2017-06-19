//
//  SRPortal+OrderStart.m
//  SiRuiV4.0
//
//  Created by zhangjunbo on 15/6/23.
//  Copyright (c) 2015年 SiRui. All rights reserved.
//

#import "SRPortal+OrderStart.h"
#import "SRHttpUtil.h"
#import "SRPortalResponse.h"
#import "SRPortalRequest.h"
#import "SROrderStartInfo.h"
#import "SRURLUtil.h"
#import "SRDataBase+OrderStart.h"

#import <MJExtension/MJExtension.h>

@implementation SRPortal (OrderStart)

//查询预约记录
+ (void)queryOrderStartWithCompleteBlock:(CompleteBlock)completeBlock
{
    SRPortalRequestQueryOrderStart *request = [[SRPortalRequestQueryOrderStart alloc] init];
    [SRHttpUtil POST :[SRURLUtil Portal_QueryOrderStartUrl] WithParameter:request.keyValues completeBlock:^(NSError *error, id responseObject) {
        
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
            NSArray *list = [SROrderStartInfo objectArrayWithKeyValuesArray:response.pageResult.entityList];
            NSMutableDictionary *dic = [NSMutableDictionary dictionary];
            if (list) {
                [[SRDataBase sharedInterface] deleteAllOrderStartWithCompleteBlock:^(NSError *error, id responseObject) {
                    [[SRDataBase sharedInterface] updateOrderStartList:list withCompleteBlock:nil];
                }];
                [list enumerateObjectsUsingBlock:^(SROrderStartInfo *obj, NSUInteger idx, BOOL *stop) {
                    NSMutableArray *temp = dic[@(obj.vehicleID)];
                    if (!temp) {
                        temp = [NSMutableArray array];
                        [dic setObject:temp forKey:@(obj.vehicleID)];
                    }
                    
                    [temp addObject:obj];
                }];
            }
            
            if (completeBlock) completeBlock(nil, dic);
        }
    }];

}

//新增预约记录
+ (void)addOrderStartWithRequest:(SRPortalRequestAddOrderStart *)request andCompleteBlock:(CompleteBlock)completeBlock
{
    [SRHttpUtil POST :[SRURLUtil Portal_AddOrderStartUrl] WithParameter:request.keyValues completeBlock:^(NSError *error, id responseObject) {
        
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
            SROrderStartInfo *info = [[SROrderStartInfo alloc] initWithAddRequest:request];
            info.startClockID = [response.entity integerValue];
            
            [[SRDataBase sharedInterface] updateOrderStartList:@[info] withCompleteBlock:nil];
            
            if (completeBlock) completeBlock(nil, info);
        }
    }];
}

//修改预约记录
+ (void)updateOrderStartWithRequest:(SRPortalRequestUpdateOrderStart *)request andCompleteBlock:(CompleteBlock)completeBlock
{
    [SRHttpUtil POST :[SRURLUtil Portal_UpdateOrderStartUrl] WithParameter:request.keyValues completeBlock:^(NSError *error, id responseObject) {
        
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
            SROrderStartInfo *info = [[SROrderStartInfo alloc] initWithUpdateRequest:request];
            [[SRDataBase sharedInterface] updateOrderStartList:@[info] withCompleteBlock:nil];
            
            if (completeBlock) completeBlock(nil, info);
        }
    }];
}

//删除预约记录
+ (void)deleteOrderStartWithRequest:(SRPortalRequestDeleteOrderStart *)request andCompleteBlock:(CompleteBlock)completeBlock
{
    [SRHttpUtil POST :[SRURLUtil Portal_DeleteOrderStartUrl] WithParameter:request.keyValues completeBlock:^(NSError *error, id responseObject) {
        
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
            [[SRDataBase sharedInterface] deleteOrderStartByStartClockID:request.startClockID withCompleteBlock:nil];
            if (completeBlock) completeBlock(nil, @(YES));
        }
    }];
}

//关闭预约新功能提醒
+ (void)closeOrderStartRemindWithCompleteBlock:(CompleteBlock)completeBlock
{
    SRPortalRequestCloseOrderStartRemind *request = [[SRPortalRequestCloseOrderStartRemind alloc] init];
    [SRHttpUtil POST :[SRURLUtil Portal_CloseOrderStartRemindUrl] WithParameter:request.keyValues completeBlock:^(NSError *error, id responseObject) {
        
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
            if (completeBlock) completeBlock(nil, @(YES));
        }
    }];
}

@end

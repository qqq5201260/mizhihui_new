//
//  SRPortal+OrderStart.h
//  SiRuiV4.0
//
//  Created by zhangjunbo on 15/6/23.
//  Copyright (c) 2015年 SiRui. All rights reserved.
//

#import "SRPortal.h"

@class SRPortalRequestAddOrderStart, SRPortalRequestUpdateOrderStart, SRPortalRequestDeleteOrderStart;

@interface SRPortal (OrderStart)

//查询预约记录
+ (void)queryOrderStartWithCompleteBlock:(CompleteBlock)completeBlock;

//新增预约记录
+ (void)addOrderStartWithRequest:(SRPortalRequestAddOrderStart *)request andCompleteBlock:(CompleteBlock)completeBlock;

//修改预约记录
+ (void)updateOrderStartWithRequest:(SRPortalRequestUpdateOrderStart *)request andCompleteBlock:(CompleteBlock)completeBlock;

//删除预约记录
+ (void)deleteOrderStartWithRequest:(SRPortalRequestDeleteOrderStart *)request andCompleteBlock:(CompleteBlock)completeBlock;

//关闭预约新功能提醒
+ (void)closeOrderStartRemindWithCompleteBlock:(CompleteBlock)completeBlock;

@end

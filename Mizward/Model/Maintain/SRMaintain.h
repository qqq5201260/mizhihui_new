//
//  SRMaintain.h
//  SiRuiV4.0
//
//  Created by zhangjunbo on 15/7/27.
//  Copyright (c) 2015年 SiRui. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SRMaintainRequestQueryReserve, SRMaintainRequestQueryDepPage, SRMaintainRequestAddReserve, SRMaintainRequestAddHistory, SRMaintainRequestQueryHistoryPage, SRMaintainRequestUpdateHistory, SRMaintainRequestDeleteHistory;

@interface SRMaintain : NSObject

//查询下次保养项目
+ (void)queryMaintainReserveWithRequest:(SRMaintainRequestQueryReserve *)request andCompleteBlock:(CompleteBlock)completeBlock;

//查询4S店
+ (void)queryMaintainDepWithCompleteBlock:(CompleteBlock)completeBlock;

//添加预约
+ (void)addMaintainReserveWithRequest:(SRMaintainRequestAddReserve *)request andCompleteBlock:(CompleteBlock)completeBlock;

//添加历史记录
+ (void)addMaintainHistoryWithRequest:(SRMaintainRequestAddHistory *)request andCompleteBlock:(CompleteBlock)completeBlock;

//查询历史记录
+ (void)queryMaintainHistoryWithRequest:(SRMaintainRequestQueryHistoryPage *)request isRefresh:(BOOL)isRefresh andCompleteBlock:(CompleteBlock)completeBlock;

//修改历史记录
+ (void)updateMaintainHistoryWithRequest:(SRMaintainRequestUpdateHistory *)request andCompleteBlock:(CompleteBlock)completeBlock;

//删除历史记录
+ (void)deleteMaintainHistoryWithRequest:(SRMaintainRequestDeleteHistory *)request andCompleteBlock:(CompleteBlock)completeBlock;

@end

//
//  SRPortal+IM.h
//  SiRuiV4.0
//
//  Created by zhangjunbo on 15/6/25.
//  Copyright (c) 2015年 SiRui. All rights reserved.
//

#import "SRPortal.h"

@class SRPortalRequestQueryIM, SRPortalRequestSendIM;

@interface SRPortal (IM)

//查询消息列表
+ (void)queryIMWithRequest:(SRPortalRequestQueryIM *)request andCompleteBlock:(CompleteBlock)completeBlock;

//发送消息
+ (void)sendIMWithRequest:(SRPortalRequestSendIM *)request andCompleteBlock:(CompleteBlock)completeBlock;

@end

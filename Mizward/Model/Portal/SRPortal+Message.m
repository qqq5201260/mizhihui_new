//
//  SRPortal+Message.m
//  SiRuiV4.0
//
//  Created by zhangjunbo on 15/6/27.
//  Copyright (c) 2015年 SiRui. All rights reserved.
//

#import "SRPortal+Message.h"
#import "SRPortalRequest.h"
#import "SRPortalResponse.h"
#import "SRHttpUtil.h"
#import "SRURLUtil.h"
#import "SRDataBase+Message.h"
#import "SRMessageInfo.h"
#import "SRMessageSwitchInfo.h"
#import "SRMessageUnreadInfo.h"
#import "SRCustomer.h"
#import <MJExtension/MJExtension.h>

@implementation SRPortal (Message)

//查询消息开关
+ (void)queryMessageSwitchWithRequest:(SRPortalRequestQueryMessageSwitch *)request andCompleteBlock:(CompleteBlock)completeBlock
{
    [SRHttpUtil POST:[SRURLUtil Portal_QueryMessageSwitchUrl] WithParameter:request.keyValues completeBlock:^(NSError *error, id responseObject) {
        if (error) {
            if (completeBlock) completeBlock(error, nil);
            return ;
        }
        
        SRPortalResponse *response = [SRPortalResponse objectWithKeyValues:responseObject];
        if (response.result.resultCode != SRHTTP_Success) {
            error = [NSError errorWithDomain:response.result.resultMessage
                                        code:response.result.resultCode
                                    userInfo:response.result.fieldErrors];
            if (completeBlock) completeBlock(error, nil);
        } else {
            
            NSArray *messageSwitchs = [SRMessageSwitchInfo objectArrayWithKeyValuesArray:response.entity];
            
            SRCustomer *customer = [self sharedInterface].customer;
            //补全所有开关信息，默认为开
            NSMutableArray *list = [NSMutableArray arrayWithArray:customer.messageSwitchs];
//            for (NSInteger type = SRMsgType_EngineOn; type <= SRMsgType_MarketingActivity; ++type) {
//                if (![customer messageSwitchWithMessageType:type]) {
//                    SRMessageSwitchInfo *info = [[SRMessageSwitchInfo alloc] init];
//                    info.msgType = type;
//                    info.isOpend = YES;
//                    [list addObject:info];
//                }
//            }
            customer.messageSwitchs = list;
            
            if (completeBlock) completeBlock(nil, messageSwitchs);
        }
    }];
}

//更新消息开关
+ (void)modifyMessageSwitchWithRequest:(SRPortalRequestModifyMessageSwitch *)request andCompleteBlock:(CompleteBlock)completeBlock
{
    [SRHttpUtil POST:[SRURLUtil Portal_ModifyMessageSwitchUrl] WithParameter:request.keyValues completeBlock:^(NSError *error, id responseObject) {
        if (error) {
            if (completeBlock) completeBlock(error, nil);
            return ;
        }
        
        SRPortalResponse *response = [SRPortalResponse objectWithKeyValues:responseObject];
        if (response.result.resultCode != SRHTTP_Success) {
            error = [NSError errorWithDomain:response.result.resultMessage
                                        code:response.result.resultCode
                                    userInfo:response.result.fieldErrors];
            if (completeBlock) completeBlock(error, nil);
        } else {
            SRCustomer *customer = [self sharedInterface].customer;
            [request.getSwitchsFromConfig enumerateObjectsUsingBlock:^(SRMessageSwitchInfo *obj, NSUInteger idx, BOOL *stop) {
                if ([customer messageSwitchWithMessageType:obj.msgType]) {
                    [customer messageSwitchWithMessageType:obj.msgType].isOpend = obj.isOpend;
                }
            }];
            if (completeBlock) completeBlock(nil, customer.messageSwitchs);
        }
    }];
}

static NSMutableDictionary *pageDic;
+ (NSInteger)currentPageWithMessageType:(SRMessageType)type
{
    if (!pageDic || !pageDic[@(type)]) {
        return 0;
    }
    
    return [pageDic[@(type)] integerValue];
}

+ (void)updateCurrentPageWithMessageType:(SRMessageType)type currentPage:(NSInteger)currentPage
{
    if (!pageDic) {
        pageDic = [NSMutableDictionary dictionary];
    }
    
    [pageDic setObject:@(currentPage) forKey:@(type)];
}

+ (NSInteger)totalPageWithMessageType:(SRMessageType)type
{
    NSString *key = [NSString stringWithFormat:@"%zd_total", type];
    if (!pageDic || !pageDic[key]) {
        return 0;
    }
    
    return [pageDic[key] integerValue];
}

+ (void)updateTotalPageWithMessageType:(SRMessageType)type totalPage:(NSInteger)totalPage
{
    if (!pageDic) {
        pageDic = [NSMutableDictionary dictionary];
    }
    
    NSString *key = [NSString stringWithFormat:@"%zd_total", type];
    [pageDic setObject:@(totalPage) forKey:key];
}

//查询消息列表
+ (void)queryMessageWithRequest:(SRPortalRequestQueryMessagePage *)request isRefresh:(BOOL)isRefresh andCompleteBlock:(CompleteBlock)completeBlock
{
    __block NSInteger currentMessagePage = [self currentPageWithMessageType:request.type];
    __block NSInteger totalMessagePage = [self totalPageWithMessageType:request.type];
    if (isRefresh) {
        currentMessagePage = 1;
    } else if (currentMessagePage > totalMessagePage) {
        [[SRDataBase sharedInterface] queryMessageInfoWithMessageType:request.type CompleteBlock:^(NSError *error, id responseObject) {
            if (completeBlock) completeBlock(nil, responseObject);
        }];
//        if (completeBlock) completeBlock(nil, nil);
        return;
    } else {
        ++currentMessagePage;
    }
    request.pageIndex = currentMessagePage;
    
    if (isRefresh) {
        switch (request.type) {
            case SRMessageType_Alert:
                [self sharedInterface].customer.hasNewMessageInAlert = NO;
                break;
            case SRMessageType_Remind:
                [self sharedInterface].customer.hasNewMessageInRemind = NO;
                break;
            case SRMessageType_Function:
                [self sharedInterface].customer.hasNewMessageInFunction = NO;
                break;
                
            default:
//                [self sharedInterface].customer.hasNewMessageInAlert = NO;
//                [self sharedInterface].customer.hasNewMessageInRemind = NO;
//                [self sharedInterface].customer.hasNewMessageInFunction = NO;
                break;
        }
    }
    
    [SRHttpUtil POST:[SRURLUtil Portal_QueryMessageListUrl] WithParameter:request.keyValues completeBlock:^(NSError *error, id responseObject) {
        if (error) {
            if (completeBlock) completeBlock(error, nil);
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
            [self updateTotalPageWithMessageType:request.type totalPage:totalMessagePage];
            [self updateCurrentPageWithMessageType:request.type currentPage:currentMessagePage];
            
            NSArray *messages = [SRMessageInfo objectArrayWithKeyValuesArray:response.pageResult.entityList];
            if (currentMessagePage == 1) {
                [[SRDataBase sharedInterface] deleteMessageInfoWithMessageType:request.type CompleteBlock:^(NSError *error, id responseObject) {
                    [[SRDataBase sharedInterface] updateMessageInfos:messages withCompleteBlock:^(NSError *error, id responseObject) {
                        if (completeBlock) completeBlock(nil, messages);
                    }];
                }];
            } else {
                [[SRDataBase sharedInterface] updateMessageInfos:messages withCompleteBlock:^(NSError *error, id responseObject) {
                    [[SRDataBase sharedInterface] queryMessageInfoWithMessageType:request.type CompleteBlock:^(NSError *error, id responseObject) {
                        if (completeBlock) completeBlock(nil, responseObject);
                    }];
                }];
            }
        }
    }];
}

//查询未读消息
+ (void)queryMessageUnreadCountWithCompleteBlock:(CompleteBlock)completeBlock
{
    SRPortalRequestQueryMessageUnreadCount *request = [[SRPortalRequestQueryMessageUnreadCount alloc] init];
    [SRHttpUtil POST:[SRURLUtil Portal_QueryMessageUnreadCountUrl] WithParameter:request.keyValues completeBlock:^(NSError *error, id responseObject) {
        if (error) {
            if (completeBlock) completeBlock(error, nil);
            return ;
        }
        
        SRPortalResponse *response = [SRPortalResponse objectWithKeyValues:responseObject];
        if (response.result.resultCode != SRHTTP_Success) {
            error = [NSError errorWithDomain:response.result.resultMessage
                                        code:response.result.resultCode
                                    userInfo:response.result.fieldErrors];
            if (completeBlock) completeBlock(error, nil);
        } else {
            NSArray *array = [SRMessageUnreadInfo objectArrayWithKeyValuesArray:response.entity];
            SRCustomer *customer = [self sharedInterface].customer;
            customer.messageUnread = array;
            if (completeBlock) completeBlock(nil, array);
        }
    }];
}


@end

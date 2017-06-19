//
//  SRDataBase+Message.h
//  
//
//  Created by zhangjunbo on 15/6/16.
//
//

#import "SRDataBase.h"

@class SRMessageInfo;

@interface SRDataBase (Message)

//创建表
- (void)createMessageTable;
//插入或更新（单条）
- (void)updateMessageInfo:(SRMessageInfo *)info withCompleteBlock:(CompleteBlock)completeBlock;
//插入后更新（批量）
- (void)updateMessageInfos:(NSArray *)infos withCompleteBlock:(CompleteBlock)completeBlock;
//删除（单条）
- (void)deleteMessageInfo:(SRMessageInfo *)info withCompleteBlock:(CompleteBlock)completeBlock;
//删除（按类型）
- (void)deleteMessageInfoWithMessageType:(SRMessageType)messageType CompleteBlock:(CompleteBlock)completeBlock;
//删除（所有）
- (void)deleteAllMessageInfosWithCompleteBlock:(CompleteBlock)completeBlock;
//查询（根据车辆ID）
- (void)queryMessageInfoWithVehicleID:(NSInteger)vehicleID customerID:(NSInteger)customerID messageType:(SRMessageType)messageType CompleteBlock:(CompleteBlock)completeBlock;
//查询（按类型）
- (void)queryMessageInfoWithMessageType:(SRMessageType)messageType CompleteBlock:(CompleteBlock)completeBlock;
//查询（按ID）
- (void)queryMessageInfoWithMessageID:(NSInteger)msgID CompleteBlock:(CompleteBlock)completeBlock;
//查询（所有）
- (void)queryAllMessageInfosWithCompleteBlock:(CompleteBlock)completeBlock;

@end

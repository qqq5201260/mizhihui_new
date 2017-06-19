//
//  SRRealm+Message.h
//  Mizward
//
//  Created by zhangjunbo on 15/9/1.
//  Copyright (c) 2015年 Mizward. All rights reserved.
//

#import "SRRealm.h"

@class SRMessageInfo;

@interface SRRealm (Message)

- (void)updateMessageInfo:(SRMessageInfo *)info withCompleteBlock:(CompleteBlock)completeBlock;
- (void)updateMessageInfos:(NSArray *)infos withCompleteBlock:(CompleteBlock)completeBlock;
- (void)deleteMessageInfo:(SRMessageInfo *)info withCompleteBlock:(CompleteBlock)completeBlock;
- (void)deleteMessageInfoWithMessageType:(SRMessageType)messageType CompleteBlock:(CompleteBlock)completeBlock;
- (void)deleteAllMessageInfosWithCompleteBlock:(CompleteBlock)completeBlock;
- (void)queryMessageInfoWithVehicleID:(NSInteger)vehicleID customerID:(NSInteger)customerID messageType:(SRMessageType)messageType CompleteBlock:(CompleteBlock)completeBlock;
- (void)queryMessageInfoWithMessageType:(SRMessageType)messageType CompleteBlock:(CompleteBlock)completeBlock;
- (void)queryMessageInfoWithMessageID:(NSInteger)msgID CompleteBlock:(CompleteBlock)completeBlock;
- (void)queryAllMessageInfosWithCompleteBlock:(CompleteBlock)completeBlock;

@end

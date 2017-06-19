//
//  SRMessageSwitchInfo.h
//  SiRuiV4.0
//
//  Created by zhangjunbo on 15/6/27.
//  Copyright (c) 2015年 SiRui. All rights reserved.
//

#import "SREntity.h"

@interface SRMessageSwitchInfo : SREntity

@property (nonatomic, assign) SRMessageType msgType;
@property (nonatomic, assign) BOOL      isOpend;

- (instancetype)initWithMsgType:(SRMessageType)msgType andIsOpen:(BOOL)isOpen;

@end

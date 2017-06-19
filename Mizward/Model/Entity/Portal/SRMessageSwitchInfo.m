//
//  SRMessageSwitchInfo.m
//  SiRuiV4.0
//
//  Created by zhangjunbo on 15/6/27.
//  Copyright (c) 2015年 SiRui. All rights reserved.
//

#import "SRMessageSwitchInfo.h"

@implementation SRMessageSwitchInfo

- (instancetype)initWithMsgType:(SRMessageType)msgType andIsOpen:(BOOL)isOpen
{
    if (self = [super init]) {
        _msgType = msgType;
        _isOpend = isOpen;
    }
    
    return self;
}

@end

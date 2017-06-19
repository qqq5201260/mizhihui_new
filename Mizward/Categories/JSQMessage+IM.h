//
//  JSQMessage+IM.h
//  SiRuiV4.0
//
//  Created by zhangjunbo on 15/6/26.
//  Copyright (c) 2015年 SiRui. All rights reserved.
//

#import "JSQMessage.h"

@class SRIMMessage;

typedef void(^JSQMessageRefreshBlock)(JSQMessage *message, NSInteger index);

@interface JSQMessage (IM)

+ (JSQMessage *)messageWithIMMessage:(SRIMMessage *)message;

+ (JSQMessage *)messageWithIMMessage:(SRIMMessage *)message
                               index:(NSInteger)index
                        refreshBlock:(JSQMessageRefreshBlock)block;
- (void)startDownload;

@end

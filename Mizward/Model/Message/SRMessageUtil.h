//
//  SRMessageUtil.h
//  SiRuiV4.0
//
//  Created by zhangjunbo on 15/7/22.
//  Copyright (c) 2015年 SiRui. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SRAPNsMessage;

@interface SRMessageUtil : NSObject

Singleton_Interface(SRMessageUtil)

+ (void)showAPNsMessage:(SRAPNsMessage *)info withTapBlock:(VoidBlock)doneBlock;

@end

//
//  SRSLBMod.h
//  SiRuiV4.0
//
//  Created by zhangjunbo on 15/6/17.
//  Copyright (c) 2015年 SiRui. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SRSLBMod : NSObject

Singleton_Interface(SRSLBMod)

//获取SLB信息
- (void)getSLBFromServerWithCompleteBlock:(CompleteBlock)completeBlock;

@end

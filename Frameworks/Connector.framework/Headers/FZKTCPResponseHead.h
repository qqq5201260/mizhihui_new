//
//  SRTCPResponseHead.h
//  SiRuiV4.0
//
//  Created by zhangjunbo on 15/6/16.
//  Copyright (c) 2015年 SiRui. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "FZKTCPRspInvokeResult.h"

@interface FZKTCPResponseHead : NSObject

@property (nonatomic, assign) NSInteger direction;
@property (nonatomic, assign) NSInteger functionID;
@property (nonatomic, assign) NSInteger serialNumber;

//指令执行结果
@property (nonatomic, strong) FZKTCPRspInvokeResult *invokeResult;

@end

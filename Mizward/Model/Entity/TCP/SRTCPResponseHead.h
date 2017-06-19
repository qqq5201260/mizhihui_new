//
//  SRTCPResponseHead.h
//  SiRuiV4.0
//
//  Created by zhangjunbo on 15/6/16.
//  Copyright (c) 2015年 SiRui. All rights reserved.
//

#import "SREntity.h"

@class SRTCPRspInvokeResult;

@interface SRTCPResponseHead : SREntity

@property (nonatomic, assign) NSInteger direction;
@property (nonatomic, assign) NSInteger functionID;
@property (nonatomic, assign) NSInteger serialNumber;

//指令执行结果
@property (nonatomic, strong) SRTCPRspInvokeResult *invokeResult;

@end

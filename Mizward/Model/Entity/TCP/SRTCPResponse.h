//
//  SRTCPResponse.h
//  SiRuiV4.0
//
//  Created by zhangjunbo on 15/6/16.
//  Copyright (c) 2015年 SiRui. All rights reserved.
//

#import "SREntity.h"

@class SRTCPResponseHead, SRTCPResponseBody;

@interface SRTCPResponse : SREntity

@property (nonatomic, strong) SRTCPResponseHead *head;
@property (nonatomic, strong) SRTCPResponseBody *body;

@end

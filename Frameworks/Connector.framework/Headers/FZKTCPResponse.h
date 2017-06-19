//
//  SRTCPResponse.h
//  SiRuiV4.0
//
//  Created by zhangjunbo on 15/6/16.
//  Copyright (c) 2015年 SiRui. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FZKTCPResponseHead.h"
#import "FZKTCPResponseBody.h"



@interface FZKTCPResponse : NSObject

@property (nonatomic, strong) FZKTCPResponseHead *head;
@property (nonatomic, strong) FZKTCPResponseBody *body;

@end

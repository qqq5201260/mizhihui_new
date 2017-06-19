//
//  SRTCPResponseBody.h
//  SiRuiV4.0
//
//  Created by zhangjunbo on 15/6/16.
//  Copyright (c) 2015年 SiRui. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FZKTLV.h"

@interface FZKTCPResponseBody : NSObject

//@property (nonatomic, assign) NSInteger errorCode;

@property (nonatomic, assign) NSInteger clientType;
@property (nonatomic, assign) NSInteger entityID;
@property (nonatomic, copy) NSArray   *parameters;

@end

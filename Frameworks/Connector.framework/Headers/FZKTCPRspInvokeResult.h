//
//  SRTCPRspInvokeResult.h
//  SiRuiV4.0
//
//  Created by zhangjunbo on 15/6/16.
//  Copyright (c) 2015年 SiRui. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FZKTCPRspInvokeResult : NSObject

@property (nonatomic, assign) NSInteger resultCode;
@property (nonatomic, copy) NSString *errorMessage;

@end

//
//  SRTCPClient.h
//  SiRuiV4.0
//
//  Created by zhangjunbo on 15/6/16.
//  Copyright (c) 2015年 SiRui. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SRTCPRequest;

@interface SRTCPClient : NSObject

Singleton_Interface(SRTCPClient)

//连接TCP
- (BOOL)connectWithError:(NSError **)error;
//断开TCP
- (void)disconnect;

//用户外部发送TCP控制指令 蓝牙调试回显 发送蓝牙状态
- (void)sendTCPRequest:(SRTCPRequest *)request withCompleteBlock:(CompleteBlock)completeBlock;

@end

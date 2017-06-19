//
//  SRTCPClient.h
//  TCP
//
//  Created by 宋搏 on 2017/4/26.
//  Copyright © 2017年 Fuizk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FZKTCPRequest.h"
#import "SRTypedef.h"





@interface FZKTCPClient : NSObject


@property (nonatomic, assign) BOOL connectRetryTimes;
@property (nonatomic, assign) BOOL isKeepAliveTimeOut;
@property (nonatomic, assign) BOOL isRedirected;
@property (nonatomic, assign) BOOL isTCPLogin;
@property (nonatomic, assign) NSInteger latestSynchronousResponseSerialNumber;
@property (nonatomic, assign) NSUInteger port;
@property (nonatomic, copy)   NSString *host;

@property (nonatomic, strong) NSMutableDictionary *completeBlockDic;//key:serialNumber obj:CompleteBlock


+(FZKTCPClient *)shareTCPClient;





//连接TCP
- (void)connect;

//连接状态
- (BOOL)connectState;

//断开TCP
- (void)disconnect;

//用户外部发送TCP控制指令 蓝牙调试回显 发送蓝牙状态
- (void)sendTCPRequest:(FZKTCPRequest *)request withCompleteBlock:(CompleteBlock)completeBlock;


- (void)tcpLogin;



@end

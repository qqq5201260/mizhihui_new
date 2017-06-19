//
//  SRTCPClient.m
//  SiRuiV4.0
//
//  Created by zhangjunbo on 15/6/16.
//  Copyright (c) 2015年 SiRui. All rights reserved.
//

#import "SRTCPClient.h"

#import "SRTCPRequest.h"
#import "SRTCPRequestHead.h"
#import "SRTCPResponse.h"
#import "SRTCPResponseHead.h"
#import "SRTCPResponseBody.h"
#import "SRTCPRspInvokeResult.h"

#import "SRTLV.h"
#import "SRVehicleBasicInfo.h"
#import "SRVehicleStatusInfo.h"
#import "SRVehicleBluetoothInfo.h"
#import "SRCustomer.h"

#import "SRDataBase+Vehicle.h"

#import "SRPortal.h"

#import "SRURLUtil.h"
#import "SRNotificationCenter.h"
#import "SRUserDefaults.h"
#import "SRKeychain.h"
#import "SRSoundPlayer.h"

#import "SREventCenter.h"

#import "SRTimer.h"

#import "SRBLEManager.h"

#import <AFNetworking/AFNetworking.h>
#import <CocoaAsyncSocket/GCDAsyncSocket.h>
#import <MJExtension/MJExtension.h>
#import <DateTools/DateTools.h>
#import <KVOController/FBKVOController.h>

//并行队列
static dispatch_queue_t tcp_data_sync_queue() {
    static dispatch_queue_t sr_tcp_data_sync_queue;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sr_tcp_data_sync_queue = dispatch_queue_create("com.sirui.tcp.data.receive", DISPATCH_QUEUE_CONCURRENT);
    });
    
    return sr_tcp_data_sync_queue;
}

static dispatch_group_t tcp_data_sync_group() {
    static dispatch_group_t sr_tcp_data_sync_group;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sr_tcp_data_sync_group = dispatch_group_create();
    });
    
    return sr_tcp_data_sync_group;
}

//串行队列
static dispatch_queue_t tcp_heart_beat_queue() {
    static dispatch_queue_t sr_tcp_heart_beat_queue;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sr_tcp_heart_beat_queue = dispatch_queue_create("com.sirui.tcp.heatbeat", DISPATCH_QUEUE_SERIAL);
    });
    
    return sr_tcp_heart_beat_queue;
}

@interface SRTCPClient () <GCDAsyncSocketDelegate>
{
    FBKVOController *kvoController;
}

@property (nonatomic, copy) NSString *host;
@property (nonatomic, assign) NSUInteger port;

@property (nonatomic, strong) GCDAsyncSocket *asyncSocket;

@property (nonatomic, strong) NSMutableDictionary *completeBlockDic;//key:serialNumber obj:CompleteBlock

@property (nonatomic, strong) NSMutableData *receivedData;

@property (nonatomic, strong) id networkObserver;
@property (nonatomic, strong) id backgroundObserver;
@property (nonatomic, strong) id activeObserver;

@property (nonatomic, strong) SRTimer *debuggingTimer;

@end

@implementation SRTCPClient
{
    BOOL isTCPLogin;
    BOOL isKeepingAlive;
    
    BOOL connectRetryTimes;
    
    BOOL isKeepAliveTimeOut;
    
    BOOL isRedirected;
    
    NSInteger latestSynchronousResponseSerialNumber;
}

Singleton_Implementation(SRTCPClient)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __block id observer = [SRNotificationCenter sr_addObserverForName:UIApplicationDidFinishLaunchingNotification object:nil queue:nil usingBlock:^(NSNotification *note) {
            [SRNotificationCenter sr_removeObserver:observer];
            
            [self sharedInterface];
        }];
    });
}

- (void)dealloc {
    [SRNotificationCenter sr_removeObserver:_networkObserver];
    [SRNotificationCenter sr_removeObserver:_backgroundObserver];
    
    [[SREventCenter sharedInterface] removeObserver:self observerQueue:dispatch_get_main_queue()];
    
    [kvoController unobserveAll];
    kvoController = nil;
    
    self.completeBlockDic = nil;
    
    [self endDebuggingTimer];
}

- (instancetype)init
{
    self = [super init];
    if (!self) return nil;
    
    isRedirected = NO;
    latestSynchronousResponseSerialNumber = -1;
    
    _receivedData = [NSMutableData data];
    _completeBlockDic = [NSMutableDictionary dictionary];
    
    @weakify(self)
    _networkObserver = [SRNotificationCenter sr_addObserverForName:AFNetworkingReachabilityDidChangeNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *note) {
        @strongify(self)
        
        if (![AFHTTPRequestOperationManager manager].reachabilityManager.reachable) {
            [self.asyncSocket disconnect];
            return;
        } else {
            [self connectWithError:nil];
        }
    }];
    
    _backgroundObserver = [SRNotificationCenter sr_addObserverForName:UIApplicationDidEnterBackgroundNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *note) {
        @strongify(self)
        if (![SRPortal sharedInterface].isBleDebugging) {
            [self disconnect];
        }
    }];
    
    kvoController = [[FBKVOController alloc] initWithObserver:self];
    [kvoController observe:[SRPortal sharedInterface] keyPath:@"needBackgroundConnect" options:NSKeyValueObservingOptionNew block:^(id observer, id object, NSDictionary *change) {
        if (![change[NSKeyValueChangeNewKey] boolValue]
            && [UIApplication sharedApplication].applicationState == UIApplicationStateBackground ) {
            [self disconnect];
        }
    }];
    
    [[SREventCenter sharedInterface] addObserver:self observerQueue:dispatch_get_main_queue()];
    
    _asyncSocket = [[GCDAsyncSocket alloc] initWithDelegate:self
                                              delegateQueue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)];
    [_asyncSocket setAutoDisconnectOnClosedReadStream:NO];
    
    _host = [SRURLUtil TcpHost];
    _port = [SRURLUtil TcpPort];
    
    return self;
}

- (BOOL)needConnect {
//    NSLog(@"%zd %zd %zd", _asyncSocket.isConnected, [SRUserDefaults isLogin], isTCPLogin);
    return !_asyncSocket.isConnected
            && [SRUserDefaults isLogin]
            && !isTCPLogin;
}

- (void)tcpLogin
{
    if (!_asyncSocket.isConnected || ![SRUserDefaults isLogin] || isTCPLogin) {
        return ;
    }
    
    SRTCPRequest *loginRequest = [SRTCPRequest LoginRequestWithUserName:[SRKeychain UserName]
                                                            andPassword:[SRKeychain Password]];
    
    @weakify(self)
    [self sendTCPRequest:loginRequest withCompleteBlock:^(NSError *error, SRTCPResponseHead *responseHead) {
        @strongify(self)
        
        if (error) {
            SRLogError(@"Login error: %@ %@============================================= 登陆错误", error, responseHead);
            [self executeOnMain:^{
                [self connectWithError:nil];
            } afterDelay:kTcpResponseTimeOutSeconds_sr];
        } else {
            if (self->isTCPLogin) {
                [self startKeepAliveTimelyWithHeartbeat:kTcpKeyAliveSeconds_sr];
            }
            
            [[SRBLEManager sharedInterface] updateAllPeripheralStatusToServerWithCompleteBlock:nil];
        }
    }];
}

#pragma mark - SREventCenter

- (void)loginStatusChange:(SRLoginStatus)status
{
    if (status == SRLoginStatus_NotLogin) {
        [self disconnect];
    } else {
        [self connectWithError:nil];
    }
}

#pragma mark - 连接管理

- (BOOL)connectWithError:(NSError **)errPtr {
    
//    NSLog(@"%zd", [SRUserDefaults loginStatus]);
//    if (![self needConnect]) return YES;
    
    //超过3次还未连接上需要重新重定向
    ++connectRetryTimes;
    SRLogDebug(@"TCP 连接次数：%zd", connectRetryTimes);
    isRedirected = connectRetryTimes>kTcpMaxConnectRetryTimes_sr?NO:isRedirected;
    
    if (!isRedirected) {
        self.host = [SRURLUtil TcpHost];
        self.port = [SRURLUtil TcpPort];
        SRLogDebug(@"开始寻址");
    } else {
        SRLogDebug(@"开始重定向");
    }
    
    if (![SRUserDefaults isLogin]) {
        SRLogDebug(@"未登录");
        if (errPtr) *errPtr = [[NSError alloc] initWithDomain:@"未登录" code:0 userInfo:nil];
        return NO;
    }
    
    if ([_host isEmpty] && _port<=0) {
        SRLogDebug(@"地址错误");
        NSError *error = [[NSError alloc] initWithDomain:@"地址错误" code:0 userInfo:nil];
        if (errPtr) *errPtr = error;
        return NO;
    }
    if (![AFHTTPRequestOperationManager manager].reachabilityManager.reachable) {
        SRLogDebug(@"无网络");
        if (errPtr) *errPtr = [[NSError alloc] initWithDomain:@"无网络" code:0 userInfo:nil];
        return NO;
    }
    
    if (_asyncSocket.isConnected) {
        [_asyncSocket disconnect];
        isTCPLogin = NO;
    }
    
    BOOL result = NO;
    @try {
        result = [_asyncSocket connectToHost:_host onPort:_port withTimeout:kTcpConnectTimeOutSeconds_sr error:errPtr];
    }
    @catch (NSException *exception) {
        SRLogError(@"%@ %@", exception, [exception callStackSymbols]);
    }
    @finally {
        return result;
    }
}

- (void)disconnect {
    [_asyncSocket disconnect];
    isTCPLogin = NO;
    isRedirected = NO;
}

#pragma mark - 数据发送

- (void)sendTCPRequest:(SRTCPRequest *)request withCompleteBlock:(CompleteBlock)completeBlock
{
    @weakify(self)
    if (!_asyncSocket.isConnected) {
        
        //如果未连接，立即连接
        [self executeOnMain:^{
            @strongify(self)
            if ([self needConnect]) [self connectWithError:nil];
        } afterDelay:0];
        
        //2S钟后再次尝试 发送指令
        [self executeOnMain:^{
            @strongify(self)
            
            if (self.asyncSocket.isConnected) {
                [self sendTCPRequest:request withCompleteBlock:completeBlock];
            } else {
                if (completeBlock) {
                    NSError *error = [NSError errorWithDomain:@"无法连接" code:0 userInfo:nil];
                    completeBlock(error, nil);
                }
            }
        } afterDelay:2 * NSEC_PER_SEC];
        
        return;
    }
    
    [_asyncSocket writeData:[request dataValue] withTimeout:-1 tag:request.head.serialNumber];
    
    if (completeBlock) {
        [_completeBlockDic setObject:completeBlock forKey:@(request.head.serialNumber)];
        [self executeOnMain:^{
            @strongify(self)
            CompleteBlock block = [self.completeBlockDic objectForKey:@(request.head.serialNumber)];
            if (block) {
                [self.completeBlockDic removeObjectForKey:@(request.head.serialNumber)];
                SRLogDebug(@"serialNumber:%@ TCP响应超时", @(request.head.serialNumber));
                NSError *error = [NSError errorWithDomain:@"网络连接错误" code:NSURLErrorTimedOut userInfo:nil];
                block(error, nil);
                block = nil;
            }
        } afterDelay:(request.head.functionID==TCPFuncID_Addressing||request.head.functionID==TCPFuncID_Login)?kTcpConnectTimeOutSeconds_sr:kTcpResponseTimeOutSeconds_sr];
    }
}

- (void)startKeepAliveTimelyWithHeartbeat:(NSInteger)seconds {
    if (isKeepingAlive) {
        return;
    }
    
   @weakify(self)
    dispatch_async(tcp_heart_beat_queue(), ^{
         @strongify(self)
        while (self.asyncSocket.isConnected) {
            self->isKeepingAlive = YES;
            SRLogDebug(@"发送心跳请求");
            [self.asyncSocket writeData:[GCDAsyncSocket ZeroData] withTimeout:-1 tag:0];
            self->isKeepAliveTimeOut = YES;
            //////超时验证
            [self executeOnMain:^{
                if (self->isKeepAliveTimeOut) [self connectWithError:nil];
            } afterDelay:kTcpResponseTimeOutSeconds_sr];
            
            sleep((unsigned int)seconds);
        }
        
        self->isKeepingAlive = NO;
    });
}

#pragma mark - 解包

- (void)parseReceivedData
{
    //并发执行
    @weakify(self)
    dispatch_group_async(tcp_data_sync_group(), tcp_data_sync_queue(), ^(){ @autoreleasepool{
        @strongify(self)
        
        NSData *packet;
        while ((packet = [self getPacketFromReceivedData])) {
            @try {
                [self parseResponse:packet];
            }
            @catch (NSException *exception) {
                SRLogError(@"%@, %@", exception, [exception callStackSymbols]);
            }
        }
    }});
    
    //前面执行完后，最后执行
    dispatch_group_notify(tcp_data_sync_group(), tcp_data_sync_queue(), ^(){
        SRLogDebug(@"数据解析完成");
    });
}

- (NSData *)getPacketFromReceivedData {
    
    @try {
        if (!self.receivedData || self.receivedData.length<8) return nil;
        
        NSInteger length = [[[NSString alloc] initWithData:[self.receivedData subdataWithRange:NSMakeRange(0, 4)]
                                                  encoding:NSUTF8StringEncoding]
                            integerValue];
        
        if (self.receivedData.length < length + 8) return nil;
        
        NSString *str = [[NSString alloc] initWithData:self.receivedData encoding:NSUTF8StringEncoding];
        NSRange foundObj=[str rangeOfString:@"{\"body\":{\"" options:NSCaseInsensitiveSearch];
        //第一个body的位置应该为8,如果为控制回复，只有head
        if (foundObj.location == 8 || [str rangeOfString:@"{\"head\":{\"" options:NSCaseInsensitiveSearch].location == 8 ) {
            //第一个包为完整包
            NSData *packet = [NSData dataWithData:[self.receivedData subdataWithRange:NSMakeRange(0, length + 8)]];
            if (self.receivedData.length > length + 8)
                [self.receivedData setData:[self.receivedData subdataWithRange:NSMakeRange(length + 8, self.receivedData.length-8-length)]];
            else
//                [self.receivedData setData:[NSMutableData data]];
                self.receivedData = [NSMutableData data];
            
            return packet;
        }
        
        SRLogError(@">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>");
        SRLogError(@"<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<");
        
        //数据异常处理
        if (foundObj.location == NSNotFound) {
            //该Data中没有body，是个脏数据，需要清除
            self.receivedData = [NSMutableData data];
            return nil;
        } else if (foundObj.location < 8) {
            //body位置不对，第一个包为不完整包，跳转到下一个body
            self.receivedData = (NSMutableData *)[_receivedData subdataWithRange:NSMakeRange(foundObj.location+foundObj.length,
                                                                                             _receivedData.length-foundObj.length-foundObj.location)];
            return [self getPacketFromReceivedData];
        } else {
            //跳转到下一个body
            self.receivedData = (NSMutableData *)[_receivedData subdataWithRange:NSMakeRange(foundObj.location-8,
                                                                                             _receivedData.length+8-foundObj.location)];
            return [self getPacketFromReceivedData];
        }
    }
    @catch (NSException *exception) {
        SRLogError(@"%@, %@", exception, [exception callStackSymbols]);
        return [self getPacketFromReceivedData];
    }
    
}


#pragma mark - 数据解析

- (void)parseResponse:(NSData *)responseData {
    
    //    SRLog(LOG_DEBUG, @"Response:%@", [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding]);
    
    if (!responseData || responseData.length < 8) {
        //解析出错
        return;
    }
    
    NSInteger length = [[[NSString alloc] initWithData:[responseData subdataWithRange:NSMakeRange(0, 4)]
                                              encoding:NSUTF8StringEncoding]
                        integerValue];
    
    if (length + 8 > responseData.length) {
        return;
    }
    
    if (length + 8 < responseData.length) {
        //有多个消息
        [self parseResponse:[responseData subdataWithRange:NSMakeRange(8+length, responseData.length-8-length)]];
    }
    
    NSInteger direct = [[[NSString alloc] initWithData:[responseData subdataWithRange:NSMakeRange(4, 2)]
                                              encoding:NSUTF8StringEncoding]
                        integerValue];
    NSInteger funcID = [[[NSString alloc] initWithData:[responseData subdataWithRange:NSMakeRange(6, 2)]
                                              encoding:NSUTF8StringEncoding]
                        integerValue];
    
    NSData *data = [responseData subdataWithRange:NSMakeRange(8, length)];
    
    @try {
        if (direct == TCPDirect_Response && funcID == TCPFuncID_Login) {
            [self parseLoginResponse:data];
        } else if (direct == TCPDirect_OneWay && funcID == TCPFuncID_Synchronous) {
            [self parseSynchronousResponse:data];
        } else if (direct == TCPDirect_Response && funcID == TCPFuncID_Instruction) {
            [self parseInstructionResponse:data];
        } else if (direct == TCPDirect_Response && funcID == TCPFuncID_Addressing) {
            [self parseAddresingResponse:data];
        } else if (direct == TCPDirect_OneWay && funcID == TCPFuncID_BleDebugging) {
            [self parseBleDebuggingData:data];
        }
    }
    @catch (NSException *exception) {
        SRLogError(@"%@ %@", exception, [exception callStackSymbols]);
    }
    
    responseData = nil;
}

- (void)parseLoginResponse:(NSData *)responseData {
    
    isTCPLogin = NO;
    
    NSError *error = nil;
    NSDictionary *jsonObject=[NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableLeaves error:&error];
    if (error) {
        SRLogError(@"%@", error);
        SRLogError(@"%@", [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding]);
        [self tcpLogin];
        return;
    }
    
    SRTCPResponse *response = [SRTCPResponse objectWithKeyValues:jsonObject];
    if (error) {
        SRLogError(@"%@", error);
        SRLogError(@"%@", [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding]);
        [self tcpLogin];
        return;
    }
    
    if (!response||response.head.invokeResult.resultCode != SRHTTP_Success) {
        SRLogError(@"TCP登陆失败：%@", response.head.invokeResult.errorMessage);
        isTCPLogin = NO;
        error = [NSError errorWithDomain:response.head.invokeResult.errorMessage
                                    code:response.head.invokeResult.resultCode userInfo:nil];
    } else {
        SRLogDebug(@"TCP登陆成功");
        isTCPLogin = YES;
    }
    
    @weakify(self)
    [self executeOnMain:^{
        @strongify(self)
        CompleteBlock completeBlock = (CompleteBlock)[self.completeBlockDic objectForKey:@(response.head.serialNumber)];
        if (completeBlock) {
            completeBlock(error, response.head);
            [self.completeBlockDic removeObjectForKey:@(response.head.serialNumber)];
            completeBlock = nil;
        }
    } afterDelay:0];
}

- (void)parseAddresingResponse:(NSData *)responseData {
    
    isRedirected = NO;
    isTCPLogin = NO;
    
    NSError *error = nil;
    NSDictionary *jsonObject=[NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableLeaves error:&error];
    if (error) {
        SRLogError(@"%@", error);
        SRLogError(@"%@", [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding]);
        return;
    }
    
    SRTCPResponse *response = [SRTCPResponse objectWithKeyValues:jsonObject];
    if (error || !response) {
        SRLogError(@"%@", error);
        SRLogError(@"%@", [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding]);
        return;
    }
    
    for (SRTLV *tlv in response.body.parameters) {
        self.port = tlv.tag;
        self.host = tlv.value;
    }
    
    SRLogDebug(@"TCP寻址成功");
    isRedirected = YES;
    
    @weakify(self)
    [self executeOnMain:^{
        @strongify(self)
        CompleteBlock completeBlock = (CompleteBlock)[self.completeBlockDic objectForKey:@(response.head.serialNumber)];
        if (completeBlock) {
            completeBlock(nil, response.head);
            [self.completeBlockDic removeObjectForKey:@(response.head.serialNumber)];
            completeBlock = nil;
        }
    } afterDelay:0];
}

- (void)parseInstructionResponse:(NSData *)responseData {
    
    NSError *error = nil;
    NSDictionary *jsonObject=[NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableLeaves error:&error];
    if (error) {
        SRLogError(@"%@", error);
        SRLogError(@"%@", [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding]);
        return;
    }
    
    SRTCPResponse *response = [SRTCPResponse objectWithKeyValues:jsonObject];
    if (!response || response.head.invokeResult.resultCode != SRHTTP_Success) {
        if (!response.head.invokeResult.errorMessage
            || [response.head.invokeResult.errorMessage isEmpty]) {
            response.head.invokeResult.errorMessage = @"指令执行失败，请稍候再试";
        }
        SRLogError(@"TCP指令执行失败：%zd %@", response.head.invokeResult.resultCode, response.head.invokeResult.errorMessage);
        
        error = [NSError errorWithDomain:response.head.invokeResult.errorMessage code:0 userInfo:nil];
    }
    
    @weakify(self)
    [self executeOnMain:^{
        @strongify(self)
        CompleteBlock completeBlock = (CompleteBlock)[self.completeBlockDic objectForKey:@(response.head.serialNumber)];
        if (completeBlock) {
            completeBlock(error, response.head);
            [self.completeBlockDic removeObjectForKey:@(response.head.serialNumber)];
            completeBlock = nil;
        }
    } afterDelay:0];
}

- (void)parseSynchronousResponse:(NSData *)responseData {
    
    NSError *error = nil;
    NSDictionary *jsonObject=[NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableLeaves error:&error];
    if (error) {
        SRLogError(@"%@", error);
        SRLogError(@"%@", [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding]);
        return;
    }
    
    SRTCPResponse *response = [SRTCPResponse objectWithKeyValues:jsonObject];
    if (error) {
        SRLogError(@"%@", error);
        SRLogError(@"%@", [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding]);
        return;
    }
    
    if (response.head.serialNumber <= latestSynchronousResponseSerialNumber) {
        SRLogError(@"无效流水号，消息丢弃！当前推送流水号：%zd 本地最新流水号：%zd", response.head.serialNumber, latestSynchronousResponseSerialNumber);
        return;
    }
    
    latestSynchronousResponseSerialNumber = response.head.serialNumber;
    
    //回复服务器
    SRTCPRequest *ack = [SRTCPRequest AckWithDirect:TCPDirect_OneWay_Ack
                                             funcID:response.head.functionID
                                    andSerialNumber:response.head.serialNumber];
    [self sendTCPRequest:ack withCompleteBlock:nil];
    

    if (![[SRPortal sharedInterface].vehicleDic objectForKey:@(response.body.entityID)]) {
        SRLogDebug(@"该账户下没有此车辆 vehicleID：%zd", response.body.entityID);
        for (SRTLV *tlv in response.body.parameters) {
            switch (tlv.tag) {
                    /////IOS 在苹果推送服务中处理
                case TLVTag_Event_UserNamePasswordChange:
                    break;
                case TLVTag_Event_BindStatusChange:
                    [SRPortal sharedInterface].customer.bindingStatus = [tlv.value integerValue];
                    [[SREventCenter sharedInterface] customerChange:[SRPortal sharedInterface].customer];
                    break;
                default:
                    break;
            }
        }
        return;
    }
    
    BOOL isValidLocation = NO;
    double lat = 0;
    double lng = 0;
    
    SRVehicleBasicInfo *basicInfo = [[SRPortal sharedInterface].vehicleDic objectForKey:@(response.body.entityID)];
    SRVehicleStatusInfo *statusInfo = basicInfo.status;
    
    for (SRTLV *parameter in response.body.parameters) {
        switch (parameter.tag) {
                ////////////////////状态
            case TLVTag_Synchronous_Online:    //12289
                statusInfo.isOnline = [parameter.value intValue];
                break;
            case TLVTag_Synchronous_GPS_Stars: //12291
                statusInfo.startNumber = [parameter.value intValue];
                break;
            case TLVTag_Synchronous_Engine:    //12292
                statusInfo.engineStatus = [parameter.value intValue];
                break;
            case TLVTag_Synchronous_Defence:   //12293
                statusInfo.defence = [parameter.value intValue];
                break;
            case TLVTag_Synchronous_ACC:   //12294
                statusInfo.ACC = [parameter.value intValue];
                break;
            case TLVTag_Synchronous_DoorLock:  //12295
                statusInfo.doorLock = [parameter.value intValue];
                break;
            case TLVTag_Synchronous_ElectricityStatus: //12297
                statusInfo.electricityStatus = [parameter.value intValue];
                break;
            case TLVTag_Synchronous_Electricity:   //12298
                statusInfo.electricity = [parameter.value doubleValue];
                break;
            case TLVTag_Synchronous_Mileage:   //12299
                statusInfo.mileAge = [parameter.value intValue];
                break;
            case TLVTag_Synchronous_CarRun:    //12301
                //                statusInfo.carRun = [parameter.value intValue];
                break;
            case TLVTag_Synchronous_GPS_Time:  //12302
            {
                NSString *gpsTimeString = [NSString LocalTimeString_YYYYMMddHHmmss:parameter.value];
                NSDate *gpsTimeDate = [NSDate convertDateFromStringWithFormatYYYYMMddHHmmss:gpsTimeString];
                NSDate *localGPSTimeDate = [NSDate convertDateFromStringWithFormatYYYYMMddHHmmss:statusInfo.gpsTime];
                if ([localGPSTimeDate isEarlierThan:gpsTimeDate]) {
                    isValidLocation  = YES;
                    statusInfo.gpsTime = parameter.value;
                }
            }
                break;
            case TLVTag_Synchronous_GPS_Lat:   //12303
                lat = [parameter.value doubleValue];
                break;
            case TLVTag_Synchronous_GPS_Lng:   //12304
                lng = [parameter.value doubleValue];
                break;
            case TLVTag_Synchronous_GPS_Speed: //12305
                statusInfo.speed = [parameter.value intValue];
                break;
            case TLVTag_Synchronous_TemperatureStatus: //12307
                statusInfo.tempStatus = [parameter.value intValue];
                break;
            case TLVTag_Synchronous_Temperature:   //12308
                statusInfo.temp = [parameter.value floatValue];
                break;
            case TLVTag_Synchronous_GPS:   //12309
                statusInfo.gpsStatus = [parameter.value intValue];
                break;
            case TLVTag_Synchronous_GPRS:  //12310
                statusInfo.signalStrength = [parameter.value intValue];
                break;
            case TLVTag_Synchronous_OBD:   //12317
                basicInfo.hasOBDModule = [parameter.value boolValue];
                break;
            case TLVTag_Synchronous_Oil:   //12312
                statusInfo.oil = [parameter.value intValue];
                break;
            case TLVTag_Synchronous_GPS_WEAK:  //12320
                statusInfo.sleepStatus = [parameter.value intValue];
                break;
            case TLVTag_Synchronous_Alarm: //16390
                //                [self parseAlarmString:parameter.value];
                break;
                
                /////////////////////////权限
            case TLVTag_Ability_Lock:  //1281
            case TLVTag_Ability_Unlock:    //1282
            case TLVTag_Ability_EngineOn:  //1283
            case TLVTag_Ability_EngineOff: //1284
            case TLVTag_Ability_OilOn: //1285
            case TLVTag_Ability_OilBreak:  //1286
            case TLVTag_Ability_Call:  //1287
            case TLVTag_Ability_Silence: //1288
            case TLVTag_Ability_WindowClose: //1289
            case TLVTag_Ability_WindowOpen: //1290
            case TLVTag_Ability_SkyClose: //1291
            case TLVTag_Ability_SkyOpen: //1292
            case TLVTag_Ability_Lock_SMS:  //1537
            case TLVTag_Ability_Unlock_SMS:    //1538
            case TLVTag_Ability_EngineOn_SMS:  //1539
            case TLVTag_Ability_EngineOff_SMS: //1540
            case TLVTag_Ability_OilOn_SMS: //1541
            case TLVTag_Ability_OilBreak_SMS:    //1542
            case TLVTag_Ability_Call_SMS:    //1543
                [basicInfo setAbilityWithTLV:parameter];
                break;
                
                //////////////////////事件
            case TLVTag_Event_Engine:  //16397
                [SRSoundPlayer playEngineOnSondWithShake:YES];
                break;
            case TLVTag_Event_Message: //17152
            {
//                NSError *error = nil;
//                NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:[parameter.value dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableLeaves error:&error];
//                if (error || !dic) break;
//                JBMessageInfo *info = [JBMessageInfo objectWithKeyValues:dic];
//                if (!info) break;
//                [[JBDatabase sharedInterface] queryMessageInfoWithMessageID:info.msgid CompleteBlock:^(NSError *error, id responseObject) {
//                    if (responseObject && [(NSArray *)responseObject count]!=0) {
//                        return ;
//                    }
//                    [[JBDatabase sharedInterface] insertMessageInfo:info withCompleteBlock:nil];
//                    [JBUIUtil showAlertWithTitle:@"提示" message:info.message andCancelButton:@"确定"];
//                }];
            }
                break;
            case TLVTag_Event_TripHidden:  //28674
                basicInfo.tripHidden = [[SRKeychain UUID] isEqualToString:parameter.value]?SRTrip_Hidden_Self:SRTrip_Hidden_Others;
                break;
            case TLVTag_Event_TripUnhidden:    //28675
                basicInfo.tripHidden = SRTrip_Unhidden;
                break;
            case TLVTag_Event_TerminalPasswordChange:  //28680
                //                [[SRControlMod shareInstance] getSMSCommandStrWithEndBlock:nil];
                break;
            case TLVTag_Event_ObdChange:    //28682
                basicInfo.openObd = [parameter.value integerValue];
                break;
                
                ////////////////////高端车型
            case TLVTag_Synchronous_Door_LF:   //12342
                statusInfo.doorLF = [parameter.value intValue];
                break;
            case TLVTag_Synchronous_Door_LB:   //12343
                statusInfo.doorLB = [parameter.value intValue];
                break;
            case TLVTag_Synchronous_Door_RF:   //12344
                statusInfo.doorRF = [parameter.value intValue];
                break;
            case TLVTag_Synchronous_Door_RB:   //12345
                statusInfo.doorRB = [parameter.value intValue];
                break;
            case TLVTag_Synchronous_Door_Trunck:   //12345
                statusInfo.trunkDoor = [parameter.value intValue];
                break;
            case TLVTag_Synchronous_Window_LF: //12347
                statusInfo.windowLF = [parameter.value intValue];
                break;
            case TLVTag_Synchronous_Window_LB: //12348
                statusInfo.windowLB = [parameter.value intValue];
                break;
            case TLVTag_Synchronous_Window_RF: //12349
                statusInfo.windowRF = [parameter.value intValue];
                break;
            case TLVTag_Synchronous_Window_RB: //12350
                statusInfo.windowRB = [parameter.value intValue];
                break;
            case TLVTag_Synchronous_Window_Sky:    //12351
                statusInfo.windowSky = [parameter.value intValue];
                break;
            case TLVTag_Synchronous_Light_Big: //12352
                statusInfo.lightBig = [parameter.value intValue];
                break;
            case TLVTag_Synchronous_Light_Little:  //12353
                statusInfo.lightSmall = [parameter.value intValue];
                break;
            case TLVTag_Synchronous_LeftOil_Litter:    //12354
                statusInfo.oilLeft = [parameter.value doubleValue];
                break;
                
            case TLVTag_Synchronous_Bluetooth:
                basicInfo.bluetooth = [SRVehicleBluetoothInfo objectWithKeyValues:parameter.value];
                break;
                
            default:
                break;
        }
        
    }
    
    if (isValidLocation && lat > 0 && lng > 0) {
        statusInfo.lat = lat;
        statusInfo.lng = lng;
    }
    
    [[SRDataBase sharedInterface] updateVehicleList:@[basicInfo] withCompleteBlock:nil];
    
    if (response.body.entityID == [SRUserDefaults currentVehicleID]) {
        [self executeOnMain:^{
            [[SREventCenter sharedInterface] currentVehicleChange:basicInfo];
        } afterDelay:0];
    }
}

- (void)parseBleDebuggingData:(NSData *)debuggingData {
    NSError *error = nil;
    NSDictionary *jsonObject=[NSJSONSerialization JSONObjectWithData:debuggingData options:NSJSONReadingMutableLeaves error:&error];
    if (error) {
        SRLogError(@"%@", error);
        SRLogError(@"%@", [[NSString alloc] initWithData:debuggingData encoding:NSUTF8StringEncoding]);
        return;
    }
    
    SRTCPResponse *debugging = [SRTCPResponse objectWithKeyValues:jsonObject];
    if (error) {
        SRLogError(@"%@", error);
        SRLogError(@"%@", [[NSString alloc] initWithData:debuggingData encoding:NSUTF8StringEncoding]);
        return;
    }
    
    [self startDebuggingTimer];
    
    for (SRTLV *parameter in debugging.body.parameters) {
        [[SRBLEManager sharedInterface] sendBleDebuggingToVehicle:debugging.body.entityID
                                                     debuggingStr:parameter.value
                                                withCompleteBlock:nil];
    }
}

- (void)startDebuggingTimer {
    [self endDebuggingTimer];
    
    [SRPortal sharedInterface].isBleDebugging = YES;
    self.debuggingTimer = [SRTimer scheduledTimerWithTimeInterval:60 block:^{
        [SRPortal sharedInterface].isBleDebugging = NO;
    } repeats:NO delay:0];
}

- (void)endDebuggingTimer {
    if (self.debuggingTimer) {
        [self.debuggingTimer invalidate];
        self.debuggingTimer = nil;
    }
}

#pragma mark - GCDAsyncSocketDelegate
- (void)socket:(GCDAsyncSocket *)sock didConnectToHost:(NSString *)host port:(UInt16)port
{
    SRLogDebug(@"socket:%p didConnectToHost:%@ port:%hu", sock, host, port);
    
    latestSynchronousResponseSerialNumber = -1;
    connectRetryTimes = 0;
    
    if (isRedirected) {
        //登陆
        [self tcpLogin];
    } else {
        //寻址
        SRTCPRequest *request = [SRTCPRequest AddressingRequestWithUserName:[SRKeychain UserName]];
        @weakify(self)
        [self sendTCPRequest:request withCompleteBlock:^(NSError *error, SRTCPResponseHead *responseHead) {
            @strongify(self)
            if (error) {
                SRLogError(@"%@ %@", error, responseHead);
                //寻址失败，重新连接
                @weakify(self)
                [self executeOnMain:^{
                    @strongify(self)
                    [self connectWithError:nil];
                } afterDelay:kTcpResponseTimeOutSeconds_sr];
                
            } else {
                [sock disconnect];;
                //寻址成功，重定向到新地址
                [self connectWithError:nil];
            }
        }];
    }
}

- (void)socketDidDisconnect:(GCDAsyncSocket *)sock withError:(NSError *)err
{
    SRLogDebug(@"socketDidDisconnect:%p withError: %@", sock, err);
    
    latestSynchronousResponseSerialNumber = -1;
    isTCPLogin = NO;
    [self.receivedData setData:[NSMutableData data]];
    
    //正常断开
    if (!err) return;
    
    //5S后尝试重新连接
    @weakify(self)
    [self executeOnMain:^{
        @strongify(self)
        [self connectWithError:nil];
        if (self->connectRetryTimes>kTcpMaxConnectRetryTimes_sr) self->connectRetryTimes=0;
    } afterDelay:kTcpConnectTimeOutSeconds_sr];
}

- (void)socketDidSecure:(GCDAsyncSocket *)sock {
    [_asyncSocket readDataWithTimeout:-1 tag:0];
}

- (NSTimeInterval)socket:(GCDAsyncSocket *)sock shouldTimeoutWriteWithTag:(long)tag elapsed:(NSTimeInterval)elapsed bytesDone:(NSUInteger)length {
    return elapsed;
}

- (void)socket:(GCDAsyncSocket *)sock didWriteDataWithTag:(long)tag
{
    [_asyncSocket readDataWithTimeout:-1 tag:tag];
}

- (void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag
{
    [_asyncSocket readDataWithTimeout:-1 tag:0];
    
    SRLogDebug(@"didReadData:%@", [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
    
    if ([data isEqualToData:[GCDAsyncSocket ZeroData]]) {
        isKeepAliveTimeOut = NO;
        SRLogDebug(@"收到心跳响应");
        return;
    }
    
    @try {
        if (!self.receivedData) {
            self.receivedData = [NSMutableData data];
        }
        
        [self.receivedData appendData:data];
    }
    @catch (NSException *exception) {
        SRLogError(@"%@, %@", exception, [exception callStackSymbols]);
        [self socket:nil didReadData:data withTag:tag];
        return;
    }
    
    [self parseReceivedData];
}


@end

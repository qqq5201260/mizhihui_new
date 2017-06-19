//
//  SRPeripheral.m
//  Mizward
//
//  Created by zhangjunbo on 15/8/25.
//  Copyright (c) 2015年 Mizward. All rights reserved.
//

#import "SRPeripheral.h"
#import "SRBLEHeader.h"
#import "SRBLESendData.h"
#import "SRBLEReceivedData.h"
#import "SRVehicleBasicInfo.h"
#import "SRVehicleBluetoothInfo.h"
#import "SRTimer.h"
#import "SREventCenter.h"
#import "SRBLEEncryptionInfo.h"
#import "SRBLEControlResult.h"
#import "SRPortal+Bluetooth.h"
#import "SRPortalRequest.h"
#import "SRVehicleBasicInfo.h"
#import "SRVehicleStatusInfo.h"
#import "SRBLEVehicleStatus.h"
#import "SRSoundPlayer.h"
#import "SRBLEBluetoothInfo.h"
#import "SRDataBase+Vehicle.h"
#import "SRUserDefaults.h"
#import "SRTCPClient.h"
#import "SRTCPRequest.h"
#import <MJExtension/MJExtension.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import <KVOController/FBKVOController.h>


//串行队列
static dispatch_queue_t ble_parse_data_queue() {
    static dispatch_queue_t ble_parse_data_queue;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        ble_parse_data_queue = dispatch_queue_create("com.sirui.ble.parsedata", DISPATCH_QUEUE_SERIAL);
    });
    
    return ble_parse_data_queue;
}

@interface SRPeripheral () <CBPeripheralDelegate>
{
    FBKVOController *kvoController;
}

@property (nonatomic, strong) NSDate *recordTime;

@property (nonatomic, strong) CBService *service;

@property (nonatomic, strong) CBCharacteristic *ble_write;
@property (nonatomic, strong) CBCharacteristic *terminal_write;
@property (nonatomic, strong) CBCharacteristic *terminal_read;

@property (nonatomic, strong) NSMutableData *data_terminal;
@property (nonatomic, strong) NSMutableData *data_ble;

@property (nonatomic, strong) NSMutableDictionary *blocksDic;   //key:SRBLEOperationInstruction
@property (nonatomic, strong) NSMutableDictionary *ackTimerDic;    //key:SRBLEOperationInstruction

@property (nonatomic, strong) SRTimer *debuggingTimer;

@end

@implementation SRPeripheral

- (void)dealloc {
    self.peripheral = nil;
    self.service = nil;
    
    self.ble_write = nil;
    self.terminal_read = nil;
    self.terminal_write = nil;
    
    self.data_ble = nil;
    self.data_terminal = nil;
    
    self.blocksDic = nil;
    
    [self.ackTimerDic enumerateKeysAndObjectsUsingBlock:^(id key, SRTimer *obj, BOOL *stop) {
        [obj invalidate];
    }];
    [self.ackTimerDic removeAllObjects];
    self.ackTimerDic = nil;
    
    [kvoController unobserveAll];
    self.KVOController = nil;
}

#pragma mark - Life Cycle

- (instancetype)init {
    if (self = [super init]) {
        [self defaultInit];
    }
    
    return self;
}

- (instancetype)initWithVehicleInfo:(SRVehicleBasicInfo *)basicInfo {
    if (self = [super init]) {
        [self defaultInit];
        _vehicleID = basicInfo.vehicleID;
        _bluetoothInfo = basicInfo.bluetooth;
    }
    return self;
}

- (void)defaultInit {
    _data_ble = [NSMutableData data];
    _data_terminal = [NSMutableData data];
    
    _blocksDic = [NSMutableDictionary dictionary];
    _ackTimerDic = [NSMutableDictionary dictionary];
    
    _bluetoothInfo = [[SRVehicleBluetoothInfo alloc] init];
    
    kvoController = [[FBKVOController alloc] initWithObserver:self];
}

#pragma mark - CBPeripheralDelegate

- (void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error
{
    if (error) {
        SRLogError(@"【蓝牙】服务连接失败: %@", [error localizedDescription]);
        [[SREventCenter sharedInterface] peripheralStateChange:self.peripheral withVehicleID:self.vehicleID];
        //上报蓝牙状态给服务器
        [[SRTCPClient sharedInterface] sendTCPRequest:[SRTCPRequest bleStatusWithVehicleID:self.vehicleID
                                                                               isConnected:NO]
                                    withCompleteBlock:nil];
        return;
    }
    
    [peripheral.services enumerateObjectsUsingBlock:^(CBService *obj, NSUInteger idx, BOOL *stop) {
        if ([obj.UUID isEqual:[CBUUID UUIDWithString:SRUUID_Peripheral_service]]) {
            self.service = obj;
            *stop = YES;
        }
    }];
}

- (void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error
{
    if (error) {
        SRLogError(@"【蓝牙】特性发现失败: %@ %@ %@", peripheral, service, [error localizedDescription]);
        return;
    }
    
    SRLogInfo(@"%@\n%@", service, service.characteristics);
    
    [service.characteristics enumerateObjectsUsingBlock:^(CBCharacteristic *obj, NSUInteger idx, BOOL *stop) {
        SRLogInfo(@"【蓝牙】%zd %@", obj.properties&CBCharacteristicPropertyNotify, obj.UUID);
        SRLogInfo(@"【蓝牙】Broadcast:%zd \n\
                  Read:%zd \n\
                  WriteWithoutResponse:%zd \n\
                  Write:%zd \n\
                  Notify:%zd \n\
                  Indicate:%zd \n\
                  AuthenticatedSignedWrites:%zd \n\
                  ExtendedProperties:%zd \n\
                  NotifyEncryptionRequired:%zd \n\
                  IndicateEncryptionRequired:%zd\n",
                  obj.properties&CBCharacteristicPropertyBroadcast>>0,
                  obj.properties&CBCharacteristicPropertyRead,
                  obj.properties&CBCharacteristicPropertyWriteWithoutResponse,
                  obj.properties&CBCharacteristicPropertyWrite,
                  obj.properties&CBCharacteristicPropertyNotify,
                  obj.properties&CBCharacteristicPropertyIndicate,
                  obj.properties&CBCharacteristicPropertyAuthenticatedSignedWrites,
                  obj.properties&CBCharacteristicPropertyExtendedProperties,
                  obj.properties&CBCharacteristicPropertyNotifyEncryptionRequired,
                  obj.properties&CBCharacteristicPropertyIndicateEncryptionRequired);
        
        if ([obj.UUID isEqual:[CBUUID UUIDWithString:SRUUID_Characteristic_Write_BLE]]) {
            self.ble_write = obj;
        } else if ([obj.UUID isEqual:[CBUUID UUIDWithString:SRUUID_Characteristic_Read_Terminal]]) {
            [peripheral setNotifyValue:YES forCharacteristic:obj];
            self.terminal_read = obj;
        } else if ([obj.UUID isEqual:[CBUUID UUIDWithString:SRUUID_Characteristic_Write_Terminal]]) {
            self.terminal_write = obj;
        }
    }];
    
    [[SREventCenter sharedInterface] peripheralStateChange:self.peripheral withVehicleID:self.vehicleID];
    
    //上报蓝牙状态给服务器
    [[SRTCPClient sharedInterface] sendTCPRequest:[SRTCPRequest bleStatusWithVehicleID:self.vehicleID
                                                                           isConnected:YES]
                                withCompleteBlock:nil];
    
//    [self testSend];
}

- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    if (error) {
        SRLogError(@"【蓝牙】特性数据读取错误:%@ %@", characteristic, [error localizedDescription]);
        return;
    }
    
//    NSString *string = [[NSString alloc] initWithData:characteristic.value encoding:NSUTF8StringEncoding];
//    SRLogDebug(@"----------%@", string);
    
    NSData *last = [characteristic.value subdataWithRange:NSMakeRange(characteristic.value.length-1, 1)];
    BOOL hasBreak = [last isEqualToData:[SRBLEData transferEndFlagData]];
    
    if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:SRUUID_Characteristic_Read_Terminal]]) {
        [self.data_terminal appendData:characteristic.value];
        if (hasBreak) {
            [self parseReceivedTerminalData:self.data_terminal];
            self.data_terminal = [NSMutableData data];
        }
    }
}

- (void)peripheral:(CBPeripheral *)peripheral didUpdateNotificationStateForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    if (error) {
        SRLogError(@"【蓝牙】特性状态变更错误: %@ %@", characteristic, error.localizedDescription);
        return;
    }
    
//    if (![characteristic.UUID isEqual:[CBUUID UUIDWithString:SRUUID_Characteristic_Read_BLE]]
//        ||![characteristic.UUID isEqual:[CBUUID UUIDWithString:SRUUID_Characteristic_Read_Terminal]]) {
//        return;
//    }
    
    if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:SRUUID_Characteristic_Read_Terminal]]) {
        return;
    }
    
    if (characteristic.isNotifying) {
        SRLogDebug(@"【蓝牙】通知开始 %@", characteristic);
        [peripheral readValueForCharacteristic:characteristic];
    } else {
        SRLogDebug(@"【蓝牙】通知结束 %@.", characteristic);
    }
}

- (void)peripheral:(CBPeripheral *)peripheral didWriteValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    NSString *string = [[NSString alloc] initWithData:characteristic.value encoding:NSUTF8StringEncoding];
    if (!error) {
        SRLogDebug(@"【蓝牙】发送成功===================%@", string);
    } else {
        //CBATTErrorDomain
        SRLogError(@"【蓝牙】发送失败===================%@ %@ %@", string, error, error.domain);
    }
}

#pragma mark - Public

- (BOOL)canSendDataToBLE
{
    return self.peripheral && self.peripheral.state == CBPeripheralStateConnected && self.ble_write;
}

- (BOOL)canSendDataToTerminal
{
//    SRLogDebug(@"%@ %zd %@", self.peripheral, self.peripheral.state, self.terminal_write);
//    SRLogDebug(@"%@ %@", self.terminal_read, self.ble_write);
//    return self.peripheral && self.peripheral.state == CBPeripheralStateConnected && self.terminal_write && self.isKeyCorrect;
    return self.peripheral && self.peripheral.state == CBPeripheralStateConnected && self.terminal_write;
}

- (void)sendCommand:(SRBLEInstruction)command withCompleteBlock:(CompleteBlock)completeBlock
{
    //1、查询控制滚动码
    SRBLESendData *query = [SRBLESendData queryControlNumber];
    [self sendDataToTerminal:query withCompleteBlock:^(NSError *error, SRBLEReceivedData *responseObject) {
        if (error) {
            if (completeBlock) completeBlock(error, responseObject);
            return ;
        }
        
        //2、下发控制指令 502下发后终端会ACK一个502，同时发出一个402，402为执行结果，402和502的顺序有可能随机，402有可能比502先收到
        //B402 CompleteBlock
        NSString *keyData = @(SRBLEOperationInstruction_B402).stringValue;
        CompleteBlock blockB402 = ^(NSError *error, SRBLEReceivedData *response){
//            SRBLEControlResult *result = response.controlResult;
            if (response && response.controlResult.instruction != command) {
                return ;
            }
            
            //清空402超时处理
            SRTimer *ackTimer = self.ackTimerDic[keyData];
            if (ackTimer) {
                [self.ackTimerDic removeObjectForKey:keyData];
                [ackTimer invalidate];
                ackTimer = nil;
            }
            
            if (response && ![response.controlResult isSuccess]) {
                error = [NSError errorWithDomain:response.controlResult.resultString
                                            code:response.controlResult.resultCode
                                        userInfo:nil];
            }
            
            if (completeBlock) completeBlock(error, response);
            //查询状态信息
            [self queryStatusWithCompleteBlock:nil];
            
            //清空502ACK超时block
            CompleteBlock blockB502 = self.blocksDic[@(SRBLEOperationInstruction_B502).stringValue];
            if (blockB502) {
                [self.ackTimerDic removeObjectForKey:@(SRBLEOperationInstruction_B502).stringValue];
                blockB502 = nil;
            }
            
//            [self queryStatusWithCompleteBlock:nil];
        };
        [self.blocksDic setValue:blockB402 forKey:keyData];
        
        
        //402执行结果超时处理
        SRTimer *ackTimer = self.ackTimerDic[keyData];
        if (ackTimer) {
            [self.ackTimerDic removeObjectForKey:keyData];
            [ackTimer invalidate];
            ackTimer = nil;
        }
        ackTimer = [SRTimer scheduledTimerWithTimeInterval:kBLEAckTimeout block:^{
            CompleteBlock blcok = self.blocksDic[keyData];
            if (!blcok) return;
            
            [self.blocksDic removeObjectForKey:keyData];
            blcok([NSError errorWithDomain:@"终端响应超时" code:-1 userInfo:nil], nil);
            blcok = nil;
        } repeats:YES delay:0];
        [self.ackTimerDic setObject:ackTimer forKey:keyData];
        
        //发送控制指令
        SRBLESendData *data = [SRBLESendData dataWithControlInstruction:command
                                                          controlNumber:responseObject.controlNumber
                                                                    key:self.bluetoothInfo.key
                                                                  idStr:self.bluetoothInfo.bluetoothID];
        [self sendDataToTerminal:data withCompleteBlock:^(NSError *error, SRBLEReceivedData *response) {
            //B502 CompleteBlock
            
            //收到502Ack直接返回，等待402结果
            if (!error) return ;
            
            //发送出错
            SRLogError(@"【蓝牙】%@", error);
            
            //发送出错，调用B402 CompleteBlock，结束控制
            CompleteBlock blcok = self.blocksDic[keyData];
            if (!blcok) return;
            
            [self.blocksDic removeObjectForKey:keyData];
            blcok(error, nil);
            blcok = nil;
        }];
    }];
}

- (void)sendQueryWithCompleteBlock:(CompleteBlock)completeBlock
{
    [self queryStatusWithCompleteBlock:completeBlock];
}

- (void)sendDebuggingData:(NSString *)dataStr withCompleteBlock:(CompleteBlock)completeBlock
{
    NSArray *param = [dataStr componentsSeparatedByString:@"#"];
    NSArray *oper = [param[3] componentsSeparatedByString:@","];
    SRBLESendData *data = [SRBLESendData dataWithTerminalType:strtoul([param[1] UTF8String], 0, 16)
                                         operationMessageType:strtoul([param[2] UTF8String], 0, 16)
                                         operationInstruction:strtoul([oper[0] UTF8String], 0, 16)
                               operationInstructionParamenter:oper.count>1?oper[1]:nil];
    
    [self sendDataToTerminal:data withCompleteBlock:completeBlock];
}

#pragma mark - Private

- (void)checkEncryptionInfoWithIDStr:(NSString *)idStr andKeyStr:(NSString *)keyStr {
//    self.isKeyCorrect = NO;
    //query
    SRBLESendData *query = [SRBLESendData queryEncryptionInfo];
    [self sendDataToTerminal:query withCompleteBlock:^(NSError *error, SRBLEReceivedData *response) {
        if (error) {
            SRLogError(@"【蓝牙】%@", error);
            //retry
            //防止断链后还在发送
            if (self.peripheral.state != CBPeripheralStateConnected) {
                return;
            }
            [self checkEncryptionInfoWithIDStr:idStr andKeyStr:keyStr];
        } else {
            
            SRLogDebug(@"【蓝牙】local id:%@ key:%@, btu:%@ %zd", idStr, keyStr, response.encryptionInfo.idStr, response.encryptionInfo);
            if (response.encryptionInfo
                && [response.encryptionInfo isIdStrCorrect:idStr]
                && [response.encryptionInfo isKeyCorrect:keyStr]) {
                [self updateBtSyncStatusToServer];
//                self.isKeyCorrect = YES;
                return ;
            }
            
            //如果是切换模式不设置ID及密钥
//            if (response.encryptionInfo && self.isSwitch
//                && ![response.encryptionInfo isKeyCorrect:keyStr]) {
//                return ;
//            }
            
            //config
            SRBLESendData *config = [SRBLESendData configDataWithID:idStr andKey:keyStr];
            [self sendDataToTerminal:config withCompleteBlock:^(NSError *error, SRBLEReceivedData *responseObject) {
                if (error
                    || !responseObject.encryptionInfo
                    || ![response.encryptionInfo isIdStrCorrect:idStr]
//                    || ![idStr isEqualToString:responseObject.encryptionInfo.idStr]
                    || ![responseObject.encryptionInfo isKeyCorrect:keyStr]) {
                    SRLogError(@"【蓝牙】%@", error);
                    SRLogDebug(@"【蓝牙】local id:%@ key:%@, btu:%@ %zd", idStr, keyStr, response.encryptionInfo.idStr, response.encryptionInfo);
                    //retry
//                    [self checkEncryptionInfoWithIDStr:idStr andKeyStr:keyStr];
                } else {
//                    self.isKeyCorrect = YES;
                    [self updateBtSyncStatusToServer];
                }
            }];
        }
    }];
}

- (void)updateBtSyncStatusToServer {
    //通知服务器，同步成功
    SRPortalRequestUpdateBtSyncStatus *request = [[SRPortalRequestUpdateBtSyncStatus alloc] init];
    request.vehicleID = self.vehicleID;
    request.bluetoothID = self.bluetoothInfo.bluetoothID;
    [SRPortal updateBTSyncStatusWithRequest:request andCompleteBlock:^(NSError *error, id responseObject) {
        if (error) {
            SRLogError(@"【蓝牙】%@", error);
        }
    }];
}

- (void)checkTerminalConnectionStatus
{
    [self sendDataToBle:[SRBLESendData terminalConnectionStatus] withCompleteBlock:^(NSError *error, id responseObject) {
        
    }];
}

- (void)checkTerminalVersionInfo {
    [self sendDataToTerminal:[SRBLESendData queryTerminalBasicInfo] withCompleteBlock:^(NSError *error, SRBLEReceivedData *response) {
        if (error || !response) {
            return ;
        }
        
        SRPortalRequestUpdateDeviceInfo *request = [[SRPortalRequestUpdateDeviceInfo alloc] init];
        request.vehicleID = self.vehicleID;
        request.locID = response.terminalType;
        request.deviceInfo = response.operationInstructionParamenter;
        [SRPortal updateBTDeviceInfoWithRequest:request andCompleteBlock:nil];
    }];
}

- (void)queryStatusWithCompleteBlock:(CompleteBlock)completeBlock
{
    SRBLESendData *data = [SRBLESendData dataWithQueryStatus];

    [self sendDataToTerminal:data withCompleteBlock:^(NSError *error, SRBLEReceivedData *response) {
        if (completeBlock) {
            completeBlock(error, response);
        }
        
//        NSData *data = [@"*29#3#2#b301,0120,20000,0000,00000,00,00,0" dataUsingEncoding:NSUTF8StringEncoding];
//        response = [[SRBLEReceivedData alloc] initWithData:data];
        
        if (response) {
            SRVehicleBasicInfo *info = [[SRPortal sharedInterface] vehicleBasicInfoWithVehicleID:self.vehicleID];
            
            SRBLEVehicleStatus *status = response.vehicleStatus;
            
            if (info.status.engineStatus != 1 && status.engine == 1) {
                [SRSoundPlayer playEngineOnSondWithShake:YES];
            }
            
            info.status.engineStatus = status.engine;
            info.status.doorLF = status.doorLF;
            info.status.doorRF = status.doorRF;
            info.status.doorLB = status.doorLB;
            info.status.doorRB = status.doorRB;
            info.status.trunkDoor = status.trunkDoor;
            info.status.windowLF = status.windowLF;
            info.status.windowRF = status.windowRF;
            info.status.windowLB = status.windowLB;
            info.status.windowRB = status.windowRB;
            info.status.windowSky = status.windowSky;
            info.status.lightBig = status.lightBig;
            info.status.lightSmall = status.lightSmall;
            info.status.doorLock = status.doorLock;
            info.status.isOnline = 1;
            [[SRDataBase sharedInterface] updateVehicleList:@[info] withCompleteBlock:nil];
            
            
            SRLogDebug(@"~~~~~~~~~~~~~蓝牙状态~~~~~~~~ self->%zd  current->%zd", self.vehicleID, [SRUserDefaults currentVehicleID]);
            SRLogDebug(@"%@", info.status.keyValues);
            SRLogDebug(@"~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~");
            SRLogDebug(@"%@", status.keyValues);
            SRLogDebug(@"~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~");
            
            if ([SRUserDefaults currentVehicleID] == self.vehicleID) {
                [[SREventCenter sharedInterface] currentVehicleChange:info];
            }
        }
        
    }];
}

- (void)askForBigDataTransferWithCompleteBlock:(CompleteBlock)completeBlock
{
    SRBLESendData *data = [SRBLESendData bleBigDataRequest];
    [self sendDataToBle:data withCompleteBlock:^(NSError *error, id responseObject) {
        if (completeBlock) {
            completeBlock(error, responseObject);
        }
    }];
}

- (void)updateBtInfoToServer {
    //通知服务器，更换MAC地址
    SRPortalRequestUpdateBtInfo *request = [[SRPortalRequestUpdateBtInfo alloc] init];
    request.vehicleID = self.vehicleID;
    request.macAddress = self.bluetoothInfo.mac;
    request.moduleName = self.bluetoothBasicInfo.moduleName;
    request.softVersion = self.bluetoothBasicInfo.softVersion;
    request.hardVersion = self.bluetoothBasicInfo.hardVersion;
    [SRPortal updateBtInfoWithRequest:request andCompleteBlock:^(NSError *error, id responseObject) {
 
    }];
}

#pragma mark - Receive

- (void)parseReceivedTerminalData:(NSData *)data {
    
//    recordTime = [[NSDate date] timeIntervalSince1970]*1000;
//    NSLog(@"%@", [NSDate date]);
    self.recordTime = [NSDate date];
    
    dispatch_async(ble_parse_data_queue(), ^{
        SRBLEReceivedData *received = [[SRBLEReceivedData alloc] initWithData:data];
        if (!received) {
            SRLogError(@"【蓝牙】数据解析错误");
            return;
        }
        
        NSString *keyData = @(received.operationInstruction).stringValue;
        CompleteBlock blcok = self.blocksDic[keyData];
        if (blcok) {
            [self.blocksDic removeObjectForKey:keyData];
            dispatch_async(dispatch_get_main_queue(), ^{
                blcok(nil, received);
            });
        }
        
        SRTimer *ackTimer = self.ackTimerDic[keyData];
        if (ackTimer) {
            [self.ackTimerDic removeObjectForKey:keyData];
            [ackTimer invalidate];
            ackTimer = nil;
        }
        
        if (received.operationMessageType == SRBLEMessageType_Publish) {
            //ack
            [self sendDataToTerminal:[SRBLESendData dataWithAckTerminalType:received.terminalType
                                                       operationInstruction:received.operationInstruction]
                   withCompleteBlock:nil];
        }
        
        if (received.operationInstruction == SRBLEOperationInstruction_A605) {
            self.bluetoothBasicInfo = received.bluetoothInfo;
            [self updateBtInfoToServer];
            //发送认证消息
            [self sendDataToBle:[SRBLESendData bleAuthDataWithID:self.bluetoothBasicInfo.authCode]
              withCompleteBlock:nil];
            //检测终端加密信息
            [self checkEncryptionInfoWithIDStr:self.bluetoothInfo.bluetoothID
                                     andKeyStr:self.bluetoothInfo.key];
            //检测终端连接状态
//            [self checkTerminalConnectionStatus];
            //检测终端版本信息
            [self checkTerminalVersionInfo];
            //查询状态信息
            [self queryStatusWithCompleteBlock:nil];
            
//            [self testSend];
        } else if (received.operationInstruction == SRBLEOperationInstruction_B803) {
            //ACK B804
        } else if (received.operationInstruction == SRBLEOperationInstruction_B805) {
        
        }
        
        if ([SRPortal sharedInterface].isBleDebugging) {
            //TCP发送调试回显数据到服务器
            [[SRTCPClient sharedInterface] sendTCPRequest:[SRTCPRequest bleDebuggingWithVehicleID:self.vehicleID
                                                                                        logString:[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]]
                                        withCompleteBlock:nil];
        }
        
    });
}

#pragma mark - Send

- (void)sendDataToBle:(SRBLESendData *)data withCompleteBlock:(CompleteBlock)completeBlock {
    //如果是长数据，需要等待BLE准备响应
    [self sendData:data toCharacteristic:self.ble_write withCompleteBlock:completeBlock];
}

- (void)sendDataToTerminal:(SRBLESendData *)data withCompleteBlock:(CompleteBlock)completeBlock {
    //如果是长数据，需要等待BLE准备响应
    [self sendData:data toCharacteristic:self.terminal_write withCompleteBlock:completeBlock];
}

- (void)sendData:(SRBLESendData *)data toCharacteristic:(CBCharacteristic *)characteristic withCompleteBlock:(CompleteBlock)completeBlock {
    
    //检测发送时间最小间隔
    NSDate *now = [NSDate date];
//    NSLog(@"%@", now);
//    SRLogDebug(@"%zd------------------------", [now timeIntervalSinceDate:self.recordTime]*1000);
    if ([now timeIntervalSinceDate:self.recordTime]*1000 < kBLESendDataMinInterval) {
        [self executeOnMain:^{
            [self sendData:data toCharacteristic:characteristic withCompleteBlock:completeBlock];
        } afterDelay:kBLESendDataMinInterval];
        return;
    }

    self.recordTime = now;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSData *transferData = data.dataValue;
        
        void (^sendBlock)(void) = ^(){
            
            NSString *keyData = @(data.operationInstruction).stringValue;
    
            SRTimer *ackTimer = self.ackTimerDic[keyData];
            if (ackTimer) {
                ++ackTimer.tag;
                //        NSLog(@"%zd!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!", ackTimer.tag);
                if (ackTimer.tag >= kBLERetryTimes) {
                    CompleteBlock blcok = self.blocksDic[keyData];
                    if (blcok) {
                        [self.blocksDic removeObjectForKey:keyData];
                        NSError *error = [NSError errorWithDomain:@"终端响应超时" code:-1 userInfo:nil];
                        dispatch_async(dispatch_get_main_queue(), ^{
                            blcok(error, nil);
                        });
                    }
                    
                    [self.ackTimerDic removeObjectForKey:keyData];
                    [ackTimer invalidate];
                    ackTimer = nil;
                    
                    return;
                }
            } else if ([data needAck]) {
                ackTimer = [SRTimer scheduledTimerWithTimeInterval:kBLEAckTimeout block:^{
                    [self sendData:data toCharacteristic:self.terminal_write withCompleteBlock:completeBlock];
                } repeats:YES delay:0];
                ackTimer.tag = 0;
                [self.ackTimerDic setObject:ackTimer forKey:keyData];
                //        NSLog(@"%zd!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!", ackTimer.tag);
            }
            
//            NSLog(@"%@", [[NSString alloc] initWithData:transferData encoding:NSUTF8StringEncoding]);
            [self sendData:transferData toCharacteristic:characteristic];
            
            if (completeBlock) {
                [self.blocksDic setValue:completeBlock forKey:keyData];
            }
        };
        
        if (transferData.length <= kMaxBLEPacketLength) {
            sendBlock();
            return ;
        }
        
        //如果是长数据，需要通知BLE并等待BLE准备响应
        [self askForBigDataTransferWithCompleteBlock:^(NSError *error, id responseObject) {
            if (error) {
                SRLogError(@"【蓝牙】%@", error);
                if (completeBlock) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        completeBlock(error, responseObject);
                    });
                }
            } else {
                sendBlock();
            }
        }];
    });
}

- (void)sendData:(NSData *)data toCharacteristic:(CBCharacteristic *)characteristic {
    
    //循环发送数据，每个包最大20字节,不足补0
    @autoreleasepool {
        for (NSInteger index = 0; index < data.length; ) {
            NSMutableData *new = [NSMutableData dataWithData:[data subdataWithRange:NSMakeRange(index, MIN(data.length-index, kMaxBLESendLength))]];
            
            //不足20补0
            if (new.length < kMaxBLESendLength) {
                UInt8 temp[kMaxBLESendLength-new.length];
                memset(temp, 0x00, sizeof(temp));
                [new appendBytes:temp length:sizeof(temp)];
            }
//            SRLogDebug(@"发送数据>>>>>>>>>>>>>>>>>>>%@", [[NSString alloc] initWithData:new encoding:NSUTF8StringEncoding]);
            [self.peripheral writeValue:new
                      forCharacteristic:characteristic
                                   type:CBCharacteristicWriteWithResponse];
            
            index += kMaxBLESendLength;
        }
        
        //刚好20字节，发送完成后再发送结束符
        if (data.length % kMaxBLESendLength == 0) {
            UInt8 temp[kMaxBLESendLength];
            memset(temp, 0x00, sizeof(temp));
            NSData *new = [[NSData alloc] initWithBytes:temp length:kMaxBLESendLength];
            [self.peripheral writeValue:new
                      forCharacteristic:characteristic
                                   type:CBCharacteristicWriteWithResponse];
        }
    }
}

#pragma mark - Setter

- (void)setPeripheral:(CBPeripheral *)peripheral {
    _peripheral = peripheral;
    _peripheral.delegate = self;
    
    if (!peripheral) return;
    
    [self observeForPeripheralState];
}

- (void)setService:(CBService *)service {
    _service = service;
    [self.peripheral discoverCharacteristics:nil forService:_service];
}

#pragma mark - Observe

- (void)observeForPeripheralState {
    [kvoController unobserve:self keyPath:@"peripheral"];
    [kvoController observe:self.peripheral keyPath:@"state" options:NSKeyValueObservingOptionNew block:^(id observer, id object, NSDictionary *change) {
        SRLogDebug(@"【蓝牙】%@", change);
        [[SREventCenter sharedInterface] peripheralStateChange:self.peripheral withVehicleID:self.vehicleID];
        
        if ([change[NSKeyValueChangeNewKey] integerValue] != CBPeripheralStateDisconnected) {
            return ;
        }
        //连接已断开，清空blocksDic，ackTimerDic
        [self.blocksDic enumerateKeysAndObjectsUsingBlock:^(id key, CompleteBlock block, BOOL *stop) {
            dispatch_async(dispatch_get_main_queue(), ^{
                block([NSError errorWithDomain:@"蓝牙连接已断开" code:-1 userInfo:nil], nil);
            });
        }];
        [self.ackTimerDic enumerateKeysAndObjectsUsingBlock:^(id key, SRTimer *timer, BOOL *stop) {
            [timer invalidate];
        }];
        [self.blocksDic removeAllObjects];
        [self.ackTimerDic removeAllObjects];
    }];
}

#pragma mark - DEBUG

- (void)testSend {
    SRBLESendData *data = [SRBLESendData dataWithQueryStatus];
    data.operationMessageType = SRBLEMessageType_Execute;
    data.operationInstructionParamenter = @"01234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123";
    
    [self sendDataToTerminal:data withCompleteBlock:^(NSError *error, id responseObject) {

    }];
}

@end

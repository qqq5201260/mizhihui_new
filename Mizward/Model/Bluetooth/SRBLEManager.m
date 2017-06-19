//
//  SRBLEManager.m
//  Mizward
//
//  Created by zhangjunbo on 15/8/25.
//  Copyright (c) 2015年 Mizward. All rights reserved.
//

#import "SRBLEManager.h"
#import "SRNotificationCenter.h"
#import "SRPeripheral.h"
#import "SRBLEHeader.h"
#import "SREventCenter.h"
#import "SRVehicleBluetoothInfo.h"
#import "SRVehicleBasicInfo.h"
#import "SRBLECoder.h"
#import "SRPortal.h"
#import "SRDataBase+Vehicle.h"
#import "SRNearbyPeripheral.h"
#import "SRPortal+Bluetooth.h"
#import "SRPortalRequest.h"
#import "SRBLEBluetoothInfo.h"
#import "SRPeripheral.h"
#import "SRUserDefaults.h"
#import "SRTCPClient.h"
#import "SRTCPRequest.h"
#import <CoreBluetooth/CoreBluetooth.h>
#import <KVOController/FBKVOController.h>

#import "SRBLEReceivedData.h"
#import "SRBLESendData.h"
#import "SRBLEEncryptionInfo.h"
#import "SRBLEUpdateInfo.h"
#import <MJExtension/MJExtension.h>
#import "FZKTDispatch_after.h"

@interface SRBLEManager () <CBCentralManagerDelegate>
{
    FBKVOController *kvoController;
    //    BOOL isNearbySearching;
}

@property (nonatomic, strong) id forgroundObserver;
@property (nonatomic, strong) id backgroundObserver;

@property (nonatomic, strong) CBCentralManager *centralManager;

@property (nonatomic, strong) NSMutableArray *userPeripheralList; //obj:SRPeripheral

@property (nonatomic, strong) dispatch_queue_t bleQueue;

@property (nonatomic, strong) FZKTDispatch_after *after;//保存最后一次连接蓝牙的时间

//@property (nonatomic, strong) NSMutableDictionary *nearbyPeripheralDic; //key:name obj:SRNearbyPeripheral

@end

@implementation SRBLEManager

Singleton_Implementation(SRBLEManager)

+ (void)load
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __block id observer = [SRNotificationCenter sr_addObserverForName:UIApplicationDidFinishLaunchingNotification object:nil queue:nil usingBlock:^(NSNotification *note) {
            [SRNotificationCenter sr_removeObserver:observer];
            
            [self sharedInterface];
        }];
    });
}

#pragma mark - Life Cycle

- (void)dealloc {
    [SRNotificationCenter sr_removeObserver:_backgroundObserver];
    [SRNotificationCenter sr_removeObserver:_forgroundObserver];
    
    [[SREventCenter sharedInterface] removeObserver:self observerQueue:dispatch_get_main_queue()];
    
    [self disconnectAllPeripherals];
    
    [self.userPeripheralList removeAllObjects];
    self.userPeripheralList = nil;
    
    //    [self.nearbyPeripheralDic removeAllObjects];
    //    self.nearbyPeripheralDic = nil;
    
    [self.centralManager stopScan];
    self.centralManager = nil;
    
    [kvoController unobserveAll];
    kvoController = nil;
}

- (instancetype)init {
    if (self = [super init]) {
        
        @weakify(self)
        _forgroundObserver = [SRNotificationCenter sr_addObserverForName:UIApplicationWillEnterForegroundNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *note) {
            @strongify(self)
            [self scanUserPeripherals];
        }];
        
        _backgroundObserver = [SRNotificationCenter sr_addObserverForName:UIApplicationDidEnterBackgroundNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *note) {
            @strongify(self)
            if (![SRPortal sharedInterface].isBleDebugging) {
                [self disconnectAllPeripherals];
            }
            //            else {
            //                [NSTimer bk_scheduledTimerWithTimeInterval:5 block:^(NSTimer *timer) {
            //                    SRPeripheral *peripheral = [self peripheralWithMac:@"8af659838b8c"];
            //                    [peripheral queryStatusWithCompleteBlock:nil];
            //                } repeats:YES];
            //
            //                [NSTimer bk_scheduledTimerWithTimeInterval:60 block:^(NSTimer *timer) {
            //                    [SRPortal sharedInterface].needBackgroundConnect = NO;
            //                } repeats:NO];
            //            }
        }];
        
        [[SREventCenter sharedInterface] addObserver:self observerQueue:dispatch_get_main_queue()];
        
        //        [SRPortal sharedInterface].needBackgroundConnect = YES;
        kvoController = [[FBKVOController alloc] initWithObserver:self];
        [kvoController observe:[SRPortal sharedInterface] keyPath:@"needBackgroundConnect" options:NSKeyValueObservingOptionNew block:^(id observer, id object, NSDictionary *change) {
            if (![change[NSKeyValueChangeNewKey] boolValue]
                && [UIApplication sharedApplication].applicationState == UIApplicationStateBackground ) {
                [self disconnectAllPeripherals];
            }
        }];
        
        //        _centralManager = [[CBCentralManager alloc] initWithDelegate:self queue:nil];
        _bleQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        
        _userPeripheralList = [NSMutableArray array];
        
        [self vehicleListChange:[SRPortal sharedInterface].allVehicles];
        
        //        _nearbyPeripheralDic = [NSMutableDictionary dictionary];
        
        //        SRBLESendData *test = [SRBLESendData dataWithControlInstruction:SRBLEInstruction_Call
        //                                                          controlNumber:48155
        //                                                                    key:@"333032346636" idStr:@"d65ed4"];
        //        [test dataValue];
        //        NSLog(@"");
    }
    
    return self;
}

#pragma mark - SREventCenter

- (void)vehicleListChange:(NSArray *)vehicles
{
    NSMutableArray *needAdd = [NSMutableArray array];
    NSMutableArray *needRemove = [NSMutableArray array];
    
    [vehicles enumerateObjectsUsingBlock:^(SRVehicleBasicInfo *obj, NSUInteger idx, BOOL *stop) {
        //        if (obj.vehicleID == 3551) {
        //            obj.bluetooth = [[SRVehicleBluetoothInfo alloc] init];
        //            obj.bluetooth.hasBluetooth = YES;
        //            obj.bluetooth.mac = [SRUserDefaults macAddress];
        //            obj.bluetooth.bluetoothID = [SRUserDefaults idString];
        //            obj.bluetooth.key = [SRUserDefaults keyString];
        //            obj.bluetooth.mac = @"a1f659838b8c";
        //            obj.bluetooth.mac = @"64f859838b8c";
        //            obj.bluetooth.mac = @"0fa253164a54";
        //            obj.bluetooth.mac = @"2efa59838b8c";
        //            obj.bluetooth.mac = @"11a253164a54";
        //            obj.bluetooth.mac = [SRUserDefaults macAddress];
        //            obj.bluetooth.mac = @"50f859838b8c";
        //            obj.bluetooth.mac = @"8af659838b8c";
        //            obj.bluetooth.bluetoothID = @"00123456";
        //            obj.bluetooth.key = @"123456789012";
        //        }
        
        if (![obj hasBluetooth]) return ;
        
        if (!self.centralManager) {
            self.centralManager = [[CBCentralManager alloc] initWithDelegate:self
                                                                       queue:self.bleQueue];
        }
        
        SRPeripheral *per = [self peripheralWithVehicleID:obj.vehicleID];
        if (per && [per.bluetoothInfo.mac isEqualToString:obj.bluetooth.mac]) {
            return;
        }
        
        if (!per) {
            //从未添加
            SRPeripheral *per = [[SRPeripheral alloc] initWithVehicleInfo:obj];
            [needAdd addObject:per];
        } else if (per && ![per.bluetoothInfo.mac isEqualToString:obj.bluetooth.mac]) {
            //设备蓝牙有变更
            [self disconnectPeripheral:per];
            
            SRPeripheral *per = [[SRPeripheral alloc] initWithVehicleInfo:obj];
            [needAdd addObject:per];
        }
    }];
    
    [self.userPeripheralList addObjectsFromArray:needAdd];
    
    [self.userPeripheralList enumerateObjectsUsingBlock:^(SRPeripheral *obj, NSUInteger idx, BOOL *stop) {
        if (![[SRPortal sharedInterface] vehicleBasicInfoWithVehicleID:obj.vehicleID]) {
            [needRemove addObject:obj];
        }
    }];
    
    [needRemove enumerateObjectsUsingBlock:^(SRPeripheral *obj, NSUInteger idx, BOOL *stop) {
        [self disconnectPeripheral:obj];
    }];
    
    [self scanUserPeripherals];
}

- (FZKTDispatch_after *)after{
    
    if (!_after) {
        _after = [FZKTDispatch_after new];
    }
    return _after;
}

- (BOOL)bleState{

    return self.centralManager.state == CBCentralManagerStatePoweredOn;
}

- (void)loginStatusChange:(SRLoginStatus)status
{
    if (status != SRLoginStatus_NotLogin) return;
    
    [self.userPeripheralList enumerateObjectsUsingBlock:^(SRPeripheral *obj, NSUInteger idx, BOOL *stop) {
        if (!obj.peripheral) return ;
        //        [self.centralManager cancelPeripheralConnection:obj.peripheral];
        [self disconnectPeripheral:obj];
    }];
    
    //    [self.userPeripheralList removeAllObjects];
    
    [self.centralManager stopScan];
}

#pragma mark - CBCentralManagerDelegate

- (void)centralManagerDidUpdateState:(CBCentralManager *)central
{
    switch (central.state) {
        case CBCentralManagerStatePoweredOn:
            SRLogInfo(@"【蓝牙】BLE--------开始扫描");
            [self scanUserPeripherals];
            break;
            
        case CBCentralManagerStateUnsupported:
            SRLogInfo(@"【蓝牙】BLE--------不支持");
            break;
        case CBCentralManagerStatePoweredOff:
            SRLogInfo(@"【蓝牙】BLE--------已关闭");
            [self disconnectAllPeripherals];
            break;
        case CBCentralManagerStateUnauthorized:
            SRLogInfo(@"【蓝牙】BLE--------未授权");
            break;
        case CBCentralManagerStateResetting:
            break;
        case CBCentralManagerStateUnknown:
            break;
            
        default:
            break;
    }
    
    [[SREventCenter sharedInterface] centralManagerStateChange:central];
}

- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI
{
    
    //    SRLogInfo(@"【蓝牙】发现外设 %@(%@, %@) %@ %zd", peripheral.name, peripheral.identifier.UUIDString, RSSI, advertisementData, peripheral.state);
    //    SRLogInfo(@"【蓝牙】发现外设 %@", peripheral.name);
    
    if (!peripheral.name || ![peripheral.name hasPrefix:@"btu-"]) return;
    
    //    if (isNearbySearching) {
    ////        if (!peripheral.name || ![peripheral.name hasPrefix:@"BTU"]) return;
    //        if (!peripheral.name) return;
    //
    //        SRNearbyPeripheral *nearby = [[SRNearbyPeripheral alloc] init];
    //        nearby.peripheral = peripheral;
    //        nearby.advertisementData = advertisementData;
    //        nearby.RSSI = RSSI;
    //        [self.nearbyPeripheralDic setObject:nearby forKey:peripheral.name];
    //        return;
    //    }
    
    //    NSString *mac = advertisementData[CBAdvertisementDataLocalNameKey];
    NSString *mac = [peripheral.name stringByReplacingOccurrencesOfString:@"btu-" withString:@""];
    SRPeripheral *local = [self peripheralWithMac:mac];
    if (!local || peripheral.state == CBPeripheralStateConnected) {
        return;
    }
    
    local.peripheral = peripheral;
    local.bluetoothInfo.name = peripheral.name;
    [self.centralManager connectPeripheral:peripheral options:nil];
    
    SRVehicleBasicInfo *info = [[SRPortal sharedInterface] vehicleBasicInfoWithVehicleID:local.vehicleID];
    info.bluetooth.name = peripheral.name;
    if (info) {
        [[SRDataBase sharedInterface] updateVehicleList:@[info] withCompleteBlock:nil];
    }
    
    __block BOOL needStop = YES;
    [self.userPeripheralList enumerateObjectsUsingBlock:^(SRPeripheral *obj, NSUInteger idx, BOOL *stop) {
        if (!obj.peripheral) {
            needStop = NO;
        }
    }];
    
    if (needStop) {
        SRLogDebug(@"【蓝牙】停止扫描");
        [self.centralManager stopScan];
    }
}

- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral
{
    SRLogDebug(@"【蓝牙】外设连接成功 %@", peripheral.name);
    [self.centralManager stopScan];
    [peripheral discoverServices:nil];
    
    //发现服务后才上报
    //    //上报蓝牙状态给服务器
    //    [[SRTCPClient sharedInterface] sendTCPRequest:[SRTCPRequest bleStatusWithVehicleID:[self vehicleIDWithperipheral:peripheral]
    //                                                                           isConnected:YES]
    //                                withCompleteBlock:nil];
}

- (void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error
{
    //    CBErrorDomain
    SRLogDebug(@"【蓝牙】外设连接失败 %@. (%@) %@", peripheral.name, [error localizedDescription], error);
    if (error) {
        //        [central connectPeripheral:peripheral options:nil];
        [self.centralManager stopScan];
    }
    
    //上报蓝牙状态给服务器
    [[SRTCPClient sharedInterface] sendTCPRequest:[SRTCPRequest bleStatusWithVehicleID:[self vehicleIDWithperipheral:peripheral]
                                                                           isConnected:NO]
                                withCompleteBlock:nil];
}

- (void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error
{
    SRLogDebug(@"【蓝牙】外设断开：%@. (%@) %@", peripheral.name, [error localizedDescription], error);
    if (error) {
        [central connectPeripheral:peripheral options:nil];
    }
    
    //上报蓝牙状态给服务器
    [[SRTCPClient sharedInterface] sendTCPRequest:[SRTCPRequest bleStatusWithVehicleID:[self vehicleIDWithperipheral:peripheral]
                                                                           isConnected:NO]
                                withCompleteBlock:nil];
}

#pragma mark - Public

- (BOOL)canSendControlInstruction:(SRTLVTag_Instruction)instruction toVehicle:(NSInteger)vehicleID;
{
    SRPeripheral *peripheral = [self peripheralWithVehicleID:vehicleID];
    //    NSLog(@"%zd %zd", [peripheral canSendDataToTerminal], [self bleInstructionFromTLVInstruction:instruction]);
    //    SRLogDebug(@"state:%zd", self.centralManager.state);
    //    SRLogDebug(@"peripheral:%@ %zd", peripheral, [peripheral canSendDataToTerminal]);
    //    SRLogDebug(@"Instruction:%zd", [self bleInstructionFromTLVInstruction:instruction]);
    return self.centralManager.state==CBCentralManagerStatePoweredOn
    && peripheral && [peripheral canSendDataToTerminal]
    && [self bleInstructionFromTLVInstruction:instruction]!=SRBLEInstruction_NULL;
}

- (void)sendQueryToVehicle:(NSInteger)vehicleID
         withCompleteBlock:(CompleteBlock)completeBlock
{
    if (self.centralManager.state != CBCentralManagerStatePoweredOn) {
        dispatch_async(dispatch_get_main_queue(), ^{
            !completeBlock?:completeBlock([NSError errorWithDomain:[self centralStatusString] code:-1 userInfo:nil], nil);
        });
        return;
    }
    
    SRPeripheral *peripheral = [self peripheralWithVehicleID:vehicleID];
    if (!peripheral || ![peripheral canSendDataToTerminal]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            !completeBlock?:completeBlock([NSError errorWithDomain:@"设备蓝牙未连接" code:-1 userInfo:nil], nil);
        });
        return;
    }
    
    [peripheral sendQueryWithCompleteBlock:completeBlock];
}

- (void)sendControlInstruction:(SRTLVTag_Instruction)instruction
                     toVehicle:(NSInteger)vehicleID
             withCompleteBlock:(CompleteBlock)completeBlock
{
    if (self.centralManager.state != CBCentralManagerStatePoweredOn) {
        dispatch_async(dispatch_get_main_queue(), ^{
            !completeBlock?:completeBlock([NSError errorWithDomain:[self centralStatusString] code:-1 userInfo:nil], nil);
        });
        return;
    }
    
    SRPeripheral *peripheral = [self peripheralWithVehicleID:vehicleID];
    if (!peripheral || ![peripheral canSendDataToTerminal]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            !completeBlock?:completeBlock([NSError errorWithDomain:@"设备蓝牙未连接" code:-1 userInfo:nil], nil);
        });
        return;
    }
    
    [peripheral sendCommand:[self bleInstructionFromTLVInstruction:instruction]
          withCompleteBlock:completeBlock];
}

- (void)sendBleDebuggingToVehicle:(NSInteger)vehicleID
                     debuggingStr:(NSString *)debuggingStr
                withCompleteBlock:(CompleteBlock)completeBlock
{
    if (self.centralManager.state != CBCentralManagerStatePoweredOn) {
        dispatch_async(dispatch_get_main_queue(), ^{
            !completeBlock?:completeBlock([NSError errorWithDomain:[self centralStatusString] code:-1 userInfo:nil], nil);
        });
        return;
    }
    
    SRPeripheral *peripheral = [self peripheralWithVehicleID:vehicleID];
    if (!peripheral || ![peripheral canSendDataToTerminal]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            !completeBlock?:completeBlock([NSError errorWithDomain:@"设备蓝牙未连接" code:-1 userInfo:nil], nil);
        });
        return;
    }
    
    [peripheral sendDebuggingData:debuggingStr withCompleteBlock:completeBlock];
}

- (void)connectPeripheralForVehicle:(NSInteger)vehicleID
                  withCompleteBlock:(CompleteBlock)completeBlock
{
    if (self.centralManager.state != CBCentralManagerStatePoweredOn) {
        dispatch_async(dispatch_get_main_queue(), ^{
            !completeBlock?:completeBlock([NSError errorWithDomain:[self centralStatusString] code:-1 userInfo:nil], nil);
        });
        return;
    }
    
    SRPeripheral *peripheral = [self peripheralWithVehicleID:vehicleID];
    if (!peripheral) {
        dispatch_async(dispatch_get_main_queue(), ^{
            !completeBlock?:completeBlock([NSError errorWithDomain:@"终端没有蓝牙设备" code:-1 userInfo:nil], nil);
        });
        return;
    } else if (peripheral.peripheral && peripheral.peripheral.state == CBPeripheralStateConnected && [peripheral canSendDataToTerminal]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            !completeBlock?:completeBlock(nil, @(YES));
        });
        return;
    }
    
    if (!peripheral.peripheral) {
        [self scanUserPeripherals];
    } else {
        [self.centralManager connectPeripheral:peripheral.peripheral options:nil];
    }
    
    [self.after runDispatch_after:kBLEScanTimeout block:^{
        [self.centralManager stopScan];
        SRPeripheral *peripheral = [self peripheralWithVehicleID:vehicleID];
        BOOL isSuccess = peripheral && [peripheral canSendDataToTerminal];
        dispatch_async(dispatch_get_main_queue(), ^{
            !completeBlock?:completeBlock(isSuccess?nil:[NSError errorWithDomain:@"蓝牙连接失败" code:-1 userInfo:nil],
                                          isSuccess?[self peripheralWithVehicleID:vehicleID]:nil);
        }
                       
       );
    }];
    
    //    //15S后检查连接状态
    //    [self executeOnMain:^{
    //
    //    } afterSeconds:kBLEConnectTimeout];
}

//同步所有蓝牙状态到服务器
- (void)updateAllPeripheralStatusToServerWithCompleteBlock:(CompleteBlock)completeBlock
{
    [self.userPeripheralList enumerateObjectsUsingBlock:^(SRPeripheral *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [[SRTCPClient sharedInterface] sendTCPRequest:[SRTCPRequest bleStatusWithVehicleID:obj.vehicleID
                                                                               isConnected:[obj canSendDataToTerminal]]
                                    withCompleteBlock:nil];
    }];
}

//- (void)scanNearbyPeripheralWithCompleteBlock:(CompleteBlock)completeBlock
//{
//    if (self.centralManager.state != CBCentralManagerStatePoweredOn) {
//        dispatch_async(dispatch_get_main_queue(), ^{
//            !completeBlock?:completeBlock([NSError errorWithDomain:[self centralStatusString] code:-1 userInfo:nil], nil);
//        });
//        return;
//    }
//
//    isNearbySearching = YES;
//    [self.centralManager stopScan];
//    [self.nearbyPeripheralDic removeAllObjects];
//    [self.centralManager scanForPeripheralsWithServices:nil
//                                                options:@{ CBCentralManagerScanOptionAllowDuplicatesKey : @YES }];
//    [self executeOnMain:^{
//        self->isNearbySearching = NO;
//        [self.centralManager stopScan];
//
//        if (completeBlock) completeBlock(nil, self.nearbyPeripheralDic.allValues);
//    } afterSeconds:kBLEScanNearbyTime];
//}

//- (void)switchNearbyPeripheral:(SRNearbyPeripheral *)peripheral
//                  forVehicleID:(NSInteger)vehicleID
//             withCompleteBlock:(CompleteBlock)completeBlock
//{
//    SRPeripheral *localPeripheral = [self peripheralWithVehicleID:vehicleID];
//
//    //更新已有蓝牙模块信息
//    SRVehicleBluetoothInfo *info = localPeripheral.bluetoothInfo;
//    info.mac = peripheral.mac;
//
//    //新蓝牙
//    SRPeripheral *srPeripheral = [[SRPeripheral alloc] init];
//    srPeripheral.peripheral = peripheral.peripheral;
//    srPeripheral.vehicleID = vehicleID;
//    srPeripheral.bluetoothInfo = info;
//    srPeripheral.isSwitch = YES;
//
//    [self.centralManager connectPeripheral:peripheral.peripheral options:nil];
//
//    //5秒后再次检查连接状态，如果无异常，认为已经连接
//    [self executeOnMain:^{
//        if (![srPeripheral canSendDataToTerminal]) {
//            //连接失败
//            NSError *error = [NSError errorWithDomain:@"蓝牙连接失败" code:-1 userInfo:nil];
//            [self.centralManager cancelPeripheralConnection:srPeripheral.peripheral];
//            if (completeBlock) completeBlock(error, nil);
//            return ;
//        } else if (!srPeripheral.isKeyCorrect) {
//            NSError *error = [NSError errorWithDomain:@"终端认证失败" code:-1 userInfo:nil];
//            [self.centralManager cancelPeripheralConnection:srPeripheral.peripheral];
//            if (completeBlock) completeBlock(error, nil);
//            return ;
//        }
//
//        //通知服务器，更换MAC地址
//        SRPortalRequestUpdateBtInfo *request = [[SRPortalRequestUpdateBtInfo alloc] init];
//        request.vehicleID = vehicleID;
//        request.macAddress = info.mac;
//        request.moduleName = srPeripheral.bluetoothBasicInfo.moduleName;
//        request.softVersion = srPeripheral.bluetoothBasicInfo.softVersion;
//        request.hardVersion = srPeripheral.bluetoothBasicInfo.hardVersion;
//        [SRPortal updateBtInfoWithRequest:request andCompleteBlock:^(NSError *error, id responseObject) {
//            if (error) {
//                [self.centralManager cancelPeripheralConnection:srPeripheral.peripheral];
//                if (completeBlock) completeBlock(error, nil);
//            } else {
//                //更新成功，替换本地保存数据
//                if (localPeripheral.peripheral) {
//                    [self.centralManager cancelPeripheralConnection:localPeripheral.peripheral];
//                }
//                [self.userPeripheralList removeObject:localPeripheral];
//
//                srPeripheral.isSwitch = NO;
//                [self.userPeripheralList addObject:srPeripheral];
//
//                if (completeBlock) completeBlock(nil, @(YES));
//            }
//        }];
//
//    } afterSeconds:5];
//}

#pragma mark - Private

- (void)scanUserPeripherals
{
    [self.centralManager stopScan];
    
    if (self.userPeripheralList.count <= 0) {
        return;
    }
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [self.centralManager scanForPeripheralsWithServices:nil
                                                    options:@{ CBCentralManagerScanOptionAllowDuplicatesKey : @YES }];
    });
    
    
    //    [self.centralManager performSelector:@selector(stopScan) withObject:nil afterDelay:kBLEScanTimeout];
}

- (void)disconnectAllPeripherals
{
    [self.userPeripheralList enumerateObjectsUsingBlock:^(SRPeripheral *obj, NSUInteger idx, BOOL *stop) {
        if (!obj.peripheral || obj.peripheral.state == CBPeripheralStateDisconnected) {
            return ;
        }
        [self.centralManager cancelPeripheralConnection:obj.peripheral];
    }];
    //    [self.userPeripheralList removeAllObjects];
}

- (void)disconnectPeripheral:(SRPeripheral *)peripheral
{
    if (!peripheral.peripheral) {
        return;
    }
    
    [self.centralManager cancelPeripheralConnection:peripheral.peripheral];
    if ([self.userPeripheralList containsObject:peripheral]) {
        [self.userPeripheralList removeObject:peripheral];
    }
}

//- (void)cancelPeripheralConnection:(CBPeripheral *)peripheral {
//    // Don't do anything if we're not connected
//    if (peripheral.state != CBPeripheralStateConnected) {
//        return;
//    }
//
//    // See if we are subscribed to a characteristic on the peripheral
//    if (peripheral.services != nil) {
//        for (CBService *service in peripheral.services) {
//            if (service.characteristics != nil) {
//                for (CBCharacteristic *characteristic in service.characteristics) {
////                    if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:TRANSFER_CHARACTERISTIC_UUID]]) {
////                        if (characteristic.isNotifying) {
////                            // It is notifying, so unsubscribe
////                            [self.discoveredPeripheral setNotifyValue:NO forCharacteristic:characteristic];
////
////                            // And we're done.
////                            return;
////                        }
////                    }
//                }
//            }
//        }
//    }
//
//    // If we've got this far, we're connected, but we're not subscribed, so we just disconnect
//    [self.centralManager cancelPeripheralConnection:peripheral];
//}

- (SRPeripheral *)peripheralWithMac:(NSString *)mac {
    __block SRPeripheral *peripheral;
    [self.userPeripheralList enumerateObjectsUsingBlock:^(SRPeripheral *obj, NSUInteger idx, BOOL *stop) {
        
        if ([self isSameMac:obj.bluetoothInfo.mac with:mac]) {
            peripheral = obj;
            *stop = YES;
        }
    }];
    
    return peripheral;
}

-(BOOL) isSameMac:(NSString*) l  with:(NSString *) r{
    if(l && [l isEqualToString:r])
    {
        return YES;
    }
    
    
    return l&&l.length>=12&&
    r&&r.length>=12&&
    [[l substringWithRange:NSMakeRange(0, 2)] isEqualToString:[r substringWithRange:NSMakeRange(10, 2)] ] &&
    [[l substringWithRange:NSMakeRange(2, 2)] isEqualToString:[r substringWithRange:NSMakeRange(8, 2)] ] &&
    [[l substringWithRange:NSMakeRange(4, 2)] isEqualToString:[r substringWithRange:NSMakeRange(6, 2)] ] &&
    [[l substringWithRange:NSMakeRange(6, 2)] isEqualToString:[r substringWithRange:NSMakeRange(4, 2)] ] &&
    [[l substringWithRange:NSMakeRange(8, 2)] isEqualToString:[r substringWithRange:NSMakeRange(2, 2)] ] &&
    [[l substringWithRange:NSMakeRange(10, 2)] isEqualToString:[r substringWithRange:NSMakeRange(0, 2)] ] ;
    
    return NO;
}

- (SRPeripheral *)peripheralWithVehicleID:(NSInteger)vehicleID {
    __block SRPeripheral *peripheral;
    [self.userPeripheralList enumerateObjectsUsingBlock:^(SRPeripheral *obj, NSUInteger idx, BOOL *stop) {
        if (obj.vehicleID == vehicleID) {
            peripheral = obj;
            *stop = YES;
        }
    }];
    
    return peripheral;
}

- (NSInteger)vehicleIDWithperipheral:(CBPeripheral *)peripheral {
    __block NSInteger vehicleID;
    [self.userPeripheralList enumerateObjectsUsingBlock:^(SRPeripheral *obj, NSUInteger idx, BOOL *stop) {
        if ([obj.peripheral isEqual:peripheral]) {
            vehicleID = obj.vehicleID;
            *stop = YES;
        }
    }];
    
    return vehicleID;
}

- (NSString *)centralStatusString {
    NSDictionary *dic = @{@(CBCentralManagerStatePoweredOn)     :   @"蓝牙已打开",
                          @(CBCentralManagerStateUnsupported)   :   @"该设备不支持蓝牙4.0功能",
                          @(CBCentralManagerStatePoweredOff)    :   @"蓝牙已关闭,请在【设置】->【蓝牙】中打开蓝牙功能",
                          @(CBCentralManagerStateUnauthorized)  :   @"未经授权",
                          @(CBCentralManagerStateResetting)     :   @"蓝牙正在重置",
                          @(CBCentralManagerStateUnknown)       :   @"蓝牙状态未知"
                          };
    return dic[@(self.centralManager.state)];
}

- (SRBLEInstruction)bleInstructionFromTLVInstruction:(SRTLVTag_Instruction)instruction
{
    NSDictionary *dic = @{@(TLVTag_Instruction_Lock)        :   @(SRBLEInstruction_Lock),
                          @(TLVTag_Instruction_Unlock)      :   @(SRBLEInstruction_Unlock),
                          @(TLVTag_Instruction_EngineOn)    :   @(SRBLEInstruction_EngineOn),
                          @(TLVTag_Instruction_EngineOff)   :   @(SRBLEInstruction_EngineOff),
                          @(TLVTag_Instruction_OilOn)       :   @(SRBLEInstruction_OilOn),
                          @(TLVTag_Instruction_OilBreak)    :   @(SRBLEInstruction_OilBreak),
                          @(TLVTag_Instruction_Call)        :   @(SRBLEInstruction_Call),
                          @(TLVTag_Instruction_Silence)     :   @(SRBLEInstruction_Silence),
                          @(TLVTag_Instruction_WindowClose) :   @(SRBLEInstruction_WindowClose),
                          @(TLVTag_Instruction_WindowOpen)  :   @(SRBLEInstruction_WindowOpen),
                          @(TLVTag_Instruction_SkyClose)    :   @(SRBLEInstruction_SkyClose),
                          @(TLVTag_Instruction_SkyOpen)     :   @(SRBLEInstruction_SkyOpen),
                          @(TLVTag_Instruction_GPSWeak)     :   @(SRBLEInstruction_NULL),
                          @(TLVTag_Instruction_Defence)     :   @(SRBLEInstruction_NULL),
                          @(TLVTag_Instruction_Undefence)   :   @(SRBLEInstruction_NULL)
                          };
    return [dic[@(instruction)] integerValue];
}

@end

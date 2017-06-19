//
//  SRPeripheral.h
//  Mizward
//
//  Created by zhangjunbo on 15/8/25.
//  Copyright (c) 2015年 Mizward. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SRBLEEnum.h"

@class CBPeripheral;
@class SRCharacteristic;
@class SRVehicleBasicInfo;
@class SRVehicleBluetoothInfo;
@class SRBLEBluetoothInfo;
@class SRBLESendData;

@interface SRPeripheral : NSObject
//车辆ID
@property (nonatomic, assign) NSInteger vehicleID;
//蓝牙信息
@property (nonatomic, strong) SRVehicleBluetoothInfo *bluetoothInfo;
//蓝牙外设信息
@property (nonatomic, strong) CBPeripheral *peripheral;
//更换蓝牙模块需要将蓝牙基本信息上传服务器
@property (nonatomic, strong) SRBLEBluetoothInfo *bluetoothBasicInfo;

//@property (nonatomic, assign) BOOL isSwitch;
//@property (nonatomic, assign) BOOL isKeyCorrect;

//根据车辆基本信息初始化
- (instancetype)initWithVehicleInfo:(SRVehicleBasicInfo *)basicInfo;
//是否可以发送数据到蓝牙
- (BOOL)canSendDataToBLE;
//是否可以发送数据到终端设备
- (BOOL)canSendDataToTerminal;
//发送控制指令
- (void)sendCommand:(SRBLEInstruction)command withCompleteBlock:(CompleteBlock)completeBlock;
//发送查询指令
- (void)sendQueryWithCompleteBlock:(CompleteBlock)completeBlock;
//查询状态
- (void)queryStatusWithCompleteBlock:(CompleteBlock)completeBlock;
//发送调试指令
- (void)sendDebuggingData:(NSString *)dataStr withCompleteBlock:(CompleteBlock)completeBlock;


@end

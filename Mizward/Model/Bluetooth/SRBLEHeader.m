//
//  SRBLEHeader.m
//  Mizward
//
//  Created by zhangjunbo on 15/8/25.
//  Copyright (c) 2015年 Mizward. All rights reserved.
//

#import "SRBLEHeader.h"

NSString * const SRUUID_Peripheral_service = @"FFF0";

//NSString * const SRUUID_Characteristic_Read_BLE = @"FFF2";
NSString * const SRUUID_Characteristic_Write_BLE = @"FFF3";
NSString * const SRUUID_Characteristic_Read_Terminal = @"FFF6";
NSString * const SRUUID_Characteristic_Write_Terminal = @"FFF5";

NSString * const kBTUAuth = @"2i0L1o5V0f8u2z9ik-@~";

const NSInteger kMaxBLESendLength = 20; //发送数据包最大长度

const NSInteger kMaxBLEPacketLength = 60;//数据分包最大长度

const NSTimeInterval kBLEScanTimeout = 15; //蓝牙扫描30s
const NSTimeInterval kBLEScanNearbyTime = 5;//扫描周边外设时间10s
const NSTimeInterval kBLEConnectTimeout = 5;//外设连接超时时间

const NSTimeInterval kBLESendDataMinInterval = 50; //发送数据最小间隔时间 100ms

const NSTimeInterval kBLEAckTimeout = 10; //指令响应超时10s

const NSTimeInterval kBLEExecuteTimeout = 30; //指令执行超时30s

const NSInteger kBLERetryTimes = 3; //重试次数



//
//  SRBLEHeader.h
//  Mizward
//
//  Created by zhangjunbo on 15/8/25.
//  Copyright (c) 2015年 Mizward. All rights reserved.
//

#ifndef Mizward_SRBLEHeader_h
#define Mizward_SRBLEHeader_h

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, SRCharacteristicType) {
    SRCharacteristic_Read_BLE = 1,
    SRCharacteristic_Write_BLE = 2,
    SRCharacteristic_Read_Terminal = 3,
    SRCharacteristic_Write_Terminal = 4,
    
    SRCharacteristic_Unknown = 0,
};

typedef struct _CONTROL_COMMAND_FORMAT
{
    UInt8 data[8];
}__attribute__((packed)) CONTROL_COMMAND_FORMAT;

extern NSString * const kBTUAuth; //BLE验证密钥

extern NSString * const SRUUID_Peripheral_service;
//extern NSString * const SRUUID_Characteristic_Read_BLE;
extern NSString * const SRUUID_Characteristic_Write_BLE;
extern NSString * const SRUUID_Characteristic_Read_Terminal;
extern NSString * const SRUUID_Characteristic_Write_Terminal;

extern const NSInteger kMaxBLESendLength; //单次发送数据最大长度
extern const NSInteger kMaxBLEPacketLength;//数据分包最大长度

extern const NSTimeInterval kBLEScanTimeout;//扫描外设超时时间
extern const NSTimeInterval kBLEScanNearbyTime;//扫描周边外设时间
extern const NSTimeInterval kBLEConnectTimeout;//外设连接超时时间

extern const NSTimeInterval kBLESendDataMinInterval;//发送数据最小间隔时间
extern const NSTimeInterval kBLEAckTimeout;//响应超时时间
extern const NSTimeInterval kBLEExecuteTimeout;//执行超时时间
extern const NSInteger kBLERetryTimes;//最大重试次数

#endif

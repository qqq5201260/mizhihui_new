//
//  SRVehicleBluetoothInfo.h
//  Mizward
//
//  Created by zhangjunbo on 15/8/27.
//  Copyright (c) 2015年 Mizward. All rights reserved.
//

#import "SREntity.h"

@interface SRVehicleBluetoothInfo : SREntity

@property (nonatomic, assign) BOOL hasBluetooth;
@property (nonatomic, assign) BOOL synced;
@property (nonatomic, copy) NSString *mac;
@property (nonatomic, copy) NSString *uuid;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *bluetoothID; //加密ID
@property (nonatomic, copy) NSString *key;          //加密密钥

@end

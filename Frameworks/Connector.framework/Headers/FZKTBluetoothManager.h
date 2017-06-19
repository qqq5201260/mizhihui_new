//
//  FZKTBluetoothManager.h
//  Connector
//
//  Created by czl on 2017/5/15.
//  Copyright © 2017年 chinapke. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SRBLEEnum.h"
#import "SRTypedef.h"
#import "FZKTBluetoothInfoModel.h"

@interface FZKTBluetoothManager : NSObject
/**
 单利
 
 @return
 */
+ (instancetype)shareBluetoothManager;


/**
 当前车辆id
 */
@property (nonatomic,readonly) NSInteger carId;

/**
 连接 指定蓝牙
 param mac 蓝牙mac地址
 param callBack 连接成功与失败的回调
 */
- (void)connect:(FZKTBluetoothInfoModel *) bleInfo;


/**
 判断是否可以发送蓝牙控制连接

 @return
 */
- (BOOL)canSendDataToTerminal;


/**
 
 蓝牙是否打开

 @return
 */
- (BOOL)canUserBle;

/**
 断开连接
 */
- (void)disConnect;


//发送控制指令
- (void)sendCommand:(SRBLEInstruction)command withCompleteBlock:(CompleteBlock)completeBlock;



@end

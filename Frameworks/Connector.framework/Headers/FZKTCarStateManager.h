//
//  FZKTCarStateParse.h
//  Connector
//
//  Created by czl on 2017/5/19.
//  Copyright © 2017年 chinapke. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FZKEnum.h"
#import <FZKTools.h>
#import "FZKTBluetoothInfoModel.h"

@interface FZKTCarStateManager : NSObject


SingleInterface(CarStateManager)


/**
 需要解析的车辆状态数据

 @param response 解析数据
 @param type 类型
 */
+ (void)parseResponse:(id)response type:(SRCarStateParseType)type;




/**
 进入app 汽车数据处理
 */
- (void)applicationDidBecomeActiveNotification:(NSInteger)carId;


/**
 app退出时回调
 */
//- (void)applicationDidEnterBackgroundNotification;
/**
 查找当前车辆对应蓝牙mac地址
 
 @return 蓝牙mac地址
 */
+ (FZKTBluetoothInfoModel *)getCurrentBleMac:(NSInteger)carId;


/**
 是否可用蓝牙

 @return
 */
+ (BOOL)canUserBle;

/**
 退出登录时
 */
- (void)applicationDidLoginout;

@end

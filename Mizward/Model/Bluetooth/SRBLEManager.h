//
//  SRBLEManager.h
//  Mizward
//
//  Created by zhangjunbo on 15/8/25.
//  Copyright (c) 2015年 Mizward. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SRBLEEnum.h"
#import "SREnum.h"

@class  SRNearbyPeripheral, SRPeripheral;

@interface SRBLEManager : NSObject

Singleton_Interface(SRBLEManager)
/**
 *  发送蓝牙控制指令
 *
 *  @param instruction   控制指令
 *  @param vehicleID     车辆ID
 *  @param completeBlock 回调
 */
- (void)sendControlInstruction:(SRTLVTag_Instruction)instruction
                     toVehicle:(NSInteger)vehicleID
             withCompleteBlock:(CompleteBlock)completeBlock;
/**
 *  发送状态查询指令
 *
 *  @param vehicleID     车辆ID
 *  @param completeBlock 回调
 */
- (void)sendQueryToVehicle:(NSInteger)vehicleID
         withCompleteBlock:(CompleteBlock)completeBlock;
/**
 *  发送蓝牙调试指令
 *
 *  @param vehicleID     车辆ID
 *  @param debuggingStr  调试指令
 *  @param completeBlock 回调
 */
- (void)sendBleDebuggingToVehicle:(NSInteger)vehicleID
                     debuggingStr:(NSString *)debuggingStr
                withCompleteBlock:(CompleteBlock)completeBlock;
/**
 *  获取蓝牙外设
 *
 *  @param vehicleID 车辆ID
 *
 *  @return 蓝牙外设
 */
- (SRPeripheral *)peripheralWithVehicleID:(NSInteger)vehicleID;

/**
 *  对应车辆是否可以发送蓝牙控制
 *
 *  @param instruction 指令
 *  @param vehicleID   车辆ID
 *
 *  @return 结果
 */
- (BOOL)canSendControlInstruction:(SRTLVTag_Instruction)instruction toVehicle:(NSInteger)vehicleID;

//连接指定车辆的蓝牙模块
- (void)connectPeripheralForVehicle:(NSInteger)vehicleID
                  withCompleteBlock:(CompleteBlock)completeBlock;

//同步所有蓝牙状态到服务器
- (void)updateAllPeripheralStatusToServerWithCompleteBlock:(CompleteBlock)completeBlock;


/**
 蓝牙开启状态

 @return
 */
- (BOOL)bleState;

////搜索周围蓝牙模块
//- (void)scanNearbyPeripheralWithCompleteBlock:(CompleteBlock)completeBlock;
//
////切换蓝牙模块
//- (void)switchNearbyPeripheral:(SRNearbyPeripheral *)peripheral
//                  forVehicleID:(NSInteger)vehicleID
//             withCompleteBlock:(CompleteBlock)completeBlock;

@end

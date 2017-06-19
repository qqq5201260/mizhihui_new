//
//  SRPortal+Bluetooth.h
//  Mizward
//
//  Created by zhangjunbo on 15/9/16.
//  Copyright (c) 2015年 Mizward. All rights reserved.
//

#import "SRPortal.h"

@class SRPortalRequestUpdateBtInfo, SRPortalRequestUpdateBtSyncStatus, SRPortalRequestUpdateDeviceInfo, SRPortalRequestChangeOrAddDevice;

@interface SRPortal (Bluetooth)

//更新蓝牙MAC地址
+ (void)updateBtInfoWithRequest:(SRPortalRequestUpdateBtInfo *)request andCompleteBlock:(CompleteBlock)completeBlock;

//获取终端升级信息
+ (void)queryTerminalUpdateInfoWithCompleteBlock:(CompleteBlock)completeBlock;

//更新密钥同步状态
+ (void)updateBTSyncStatusWithRequest:(SRPortalRequestUpdateBtSyncStatus *)request andCompleteBlock:(CompleteBlock)completeBlock;

//提交硬件信息
+ (void)updateBTDeviceInfoWithRequest:(SRPortalRequestUpdateDeviceInfo *)request andCompleteBlock:(CompleteBlock)completeBlock;

//更改或加装设备
+ (void)changeOrAddDeviceWithRequest:(SRPortalRequestChangeOrAddDevice *)request andCompleteBlock:(CompleteBlock)completeBlock;


@end

//
//  SRPortal+Bluetooth.m
//  Mizward
//
//  Created by zhangjunbo on 15/9/16.
//  Copyright (c) 2015年 Mizward. All rights reserved.
//

#import "SRPortal+Bluetooth.h"
#import "SRPortalRequest.h"
#import "SRPortalResponse.h"
#import "SRHttpUtil.h"
#import "SRURLUtil.h"
#import "SRVehicleBasicInfo.h"
#import "SRDataBase+Vehicle.h"
#import "SRVehicleBluetoothInfo.h"
#import "SRVehicleTerminalVersionInfo.h"
#import <MJExtension/MJExtension.h>

@implementation SRPortal (Bluetooth)

//更新蓝牙MAC地址
+ (void)updateBtInfoWithRequest:(SRPortalRequestUpdateBtInfo *)request andCompleteBlock:(CompleteBlock)completeBlock
{
    [SRHttpUtil POST:[SRURLUtil Portal_UpdateBtInfo] WithParameter:request.keyValues completeBlock:^(NSError *error, id responseObject) {
        if (error) {
            if (completeBlock) completeBlock(error, responseObject);
            return ;
        }
        
        SRPortalResponse *response = [SRPortalResponse objectWithKeyValues:responseObject];
        if (response.result.resultCode != SRHTTP_Success) {
            error = [NSError errorWithDomain:response.result.resultMessage
                                        code:response.result.resultCode
                                    userInfo:response.result.fieldErrors];
            if (completeBlock) completeBlock(error, nil);
            return;
        }
        
        SRVehicleBasicInfo *info = [[self sharedInterface] vehicleBasicInfoWithVehicleID:request.vehicleID];
        if (info) {
            info.bluetooth.mac = request.macAddress;
            [[SRDataBase sharedInterface] updateVehicleList:@[info] withCompleteBlock:nil];
        }
        
        
        if (completeBlock) completeBlock(nil, @(YES));
    }];
}

//获取终端升级信息
+ (void)queryTerminalUpdateInfoWithCompleteBlock:(CompleteBlock)completeBlock
{
    SRPortalRequestRSAApend *request = [[SRPortalRequestRSAApend alloc] init];
    [SRHttpUtil POST:[SRURLUtil Portal_QueryTerminalUpdateInfo] WithParameter:request.keyValues completeBlock:^(NSError *error, id responseObject) {
        if (error) {
            if (completeBlock) completeBlock(error, responseObject);
            return ;
        }
        
        SRPortalResponse *response = [SRPortalResponse objectWithKeyValues:responseObject];
        if (response.result.resultCode != SRHTTP_Success) {
            error = [NSError errorWithDomain:response.result.resultMessage
                                        code:response.result.resultCode
                                    userInfo:response.result.fieldErrors];
            if (completeBlock) completeBlock(error, nil);
            return;
        }
        
        NSArray *list = [SRVehicleTerminalVersionInfo objectArrayWithKeyValuesArray:response.entity];
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        [list enumerateObjectsUsingBlock:^(SRVehicleTerminalVersionInfo *obj, NSUInteger idx, BOOL *stop) {
            NSMutableArray *temp = dic[@(obj.vehicleID)];
            if (!temp) {
                temp = [NSMutableArray array];
                [dic setObject:temp forKey:dic[@(obj.vehicleID)]];
            }
            
            [temp addObject:obj];
        }];
        
        NSArray *vehicles = [self sharedInterface].allVehicles;
        [vehicles enumerateObjectsUsingBlock:^(SRVehicleBasicInfo *obj, NSUInteger idx, BOOL *stop) {
            obj.terminalVersionInfos = dic[@(obj.vehicleID)];
        }];
        
        [[SRDataBase sharedInterface] updateVehicleList:vehicles withCompleteBlock:nil];
        
        if (completeBlock) completeBlock(nil, dic);
    }];
}

//更新密钥同步状态
+ (void)updateBTSyncStatusWithRequest:(SRPortalRequestUpdateBtSyncStatus *)request andCompleteBlock:(CompleteBlock)completeBlock
{
    [SRHttpUtil POST:[SRURLUtil Portal_UpdateBtSyncStatus] WithParameter:request.keyValues completeBlock:^(NSError *error, id responseObject) {
        if (error) {
            if (completeBlock) completeBlock(error, responseObject);
            return ;
        }
        
        SRPortalResponse *response = [SRPortalResponse objectWithKeyValues:responseObject];
        if (response.result.resultCode != SRHTTP_Success) {
            error = [NSError errorWithDomain:response.result.resultMessage
                                        code:response.result.resultCode
                                    userInfo:response.result.fieldErrors];
            if (completeBlock) completeBlock(error, nil);
            return;
        }
        
        SRVehicleBasicInfo *info = [[self sharedInterface] vehicleBasicInfoWithVehicleID:request.vehicleID];
        if (info) {
            info.bluetooth.synced = YES;
            [[SRDataBase sharedInterface] updateVehicleList:@[info] withCompleteBlock:nil];
        }
        
        if (completeBlock) completeBlock(nil, @(YES));
    }];
}

//提交硬件信息
+ (void)updateBTDeviceInfoWithRequest:(SRPortalRequestUpdateDeviceInfo *)request andCompleteBlock:(CompleteBlock)completeBlock
{
    [SRHttpUtil POST:[SRURLUtil Portal_UpdateDeviceInfo] WithParameter:request.keyValues completeBlock:^(NSError *error, id responseObject) {
        if (error) {
            if (completeBlock) completeBlock(error, responseObject);
            return ;
        }
        
        SRPortalResponse *response = [SRPortalResponse objectWithKeyValues:responseObject];
        if (response.result.resultCode != SRHTTP_Success) {
            error = [NSError errorWithDomain:response.result.resultMessage
                                        code:response.result.resultCode
                                    userInfo:response.result.fieldErrors];
            if (completeBlock) completeBlock(error, nil);
            return;
        }
        
        if (completeBlock) completeBlock(nil, @(YES));
    }];
}

//更改或加装设备
+ (void)changeOrAddDeviceWithRequest:(SRPortalRequestChangeOrAddDevice *)request andCompleteBlock:(CompleteBlock)completeBlock
{
    [SRHttpUtil POST:[SRURLUtil Portal_ChangeOrAddDevice] WithParameter:request.keyValues completeBlock:^(NSError *error, id responseObject) {
        if (error) {
            if (completeBlock) completeBlock(error, responseObject);
            return ;
        }
        
        SRPortalResponse *response = [SRPortalResponse objectWithKeyValues:responseObject];
        if (response.result.resultCode != SRHTTP_Success) {
            error = [NSError errorWithDomain:response.result.resultMessage
                                        code:response.result.resultCode
                                    userInfo:response.result.fieldErrors];
            if (completeBlock) completeBlock(error, nil);
            return;
        }
        
        if (completeBlock) completeBlock(nil, @(YES));
    }];
}


@end

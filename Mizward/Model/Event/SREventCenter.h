//
//  SREventCenter.h
//  SiRuiV4.0
//
//  Created by zhangjunbo on 15/6/16.
//  Copyright (c) 2015年 SiRui. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking/AFNetworkReachabilityManager.h>

@class SRVehicleBasicInfo, SRCustomer, CBCentralManager, CBPeripheral;

@protocol SREventCenterrDelegate <NSObject>

- (void)APNSRegistEnd:(BOOL)isSuccess;
- (void)currentVehicleChange:(SRVehicleBasicInfo *)basicInfo;
- (void)loginStatusChange:(SRLoginStatus)status;
- (void)customerChange:(SRCustomer *)customer;
- (void)vehicleListChange:(NSArray *)vehicles;
- (void)netWorkReachabilityChange:(AFNetworkReachabilityStatus)status;

//蓝牙
- (void)centralManagerStateChange:(CBCentralManager *)manager;
- (void)peripheralStateChange:(CBPeripheral *)peripheral withVehicleID:(NSInteger)vehicleID;

@end

@interface SREventCenter : NSObject

Singleton_Interface(SREventCenter)

- (void)addObserver:(id)observer observerQueue:(dispatch_queue_t)delegateQueue;
- (void)removeObserver:(id)observer observerQueue:(dispatch_queue_t)delegateQueue;

- (void)APNSRegistEnd:(BOOL)isSuccess;

- (void)loginStatusChange:(SRLoginStatus)status;

- (void)currentVehicleChange:(SRVehicleBasicInfo *)vehicle;

- (void)customerChange:(SRCustomer *)customer;

- (void)vehicleListChange:(NSArray *)vehicles;

- (void)netWorkReachabilityChange:(AFNetworkReachabilityStatus)status;

//蓝牙
- (void)centralManagerStateChange:(CBCentralManager *)manager;
- (void)peripheralStateChange:(CBPeripheral *)peripheral withVehicleID:(NSInteger)vehicleID;

@end

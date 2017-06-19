//
//  SREventCenter.m
//  SiRuiV4.0
//
//  Created by zhangjunbo on 15/6/16.
//  Copyright (c) 2015年 SiRui. All rights reserved.
//

#import "SREventCenter.h"
#import "SRUserDefaults.h"
#import "GCDMulticastDelegate.h"
#import "SRDataBase+Customer.h"
#import "SRDataBase+Vehicle.h"
#import "SRUIUtil.h"
#import <ObjcAssociatedObjectHelpers/ObjcAssociatedObjectHelpers.h>

@implementation SREventCenter

Singleton_Implementation(SREventCenter)

//delegate:GCDMulticastDelegate<SREventCenterrDelegate>
SYNTHESIZE_ASC_OBJ(delegate, setDelegate);

- (void)addObserver:(id)observer observerQueue:(dispatch_queue_t)delegateQueue
{
    if (!self.delegate) {
        self.delegate = (GCDMulticastDelegate<SREventCenterrDelegate> *)[[GCDMulticastDelegate alloc] init];
    }
    [self.delegate addDelegate:observer delegateQueue:delegateQueue];
}

- (void)removeObserver:(id)observer observerQueue:(dispatch_queue_t)delegateQueue
{
    if (!self.delegate) {
        self.delegate = (GCDMulticastDelegate<SREventCenterrDelegate> *)[[GCDMulticastDelegate alloc] init];
    }
    [self.delegate removeDelegate:observer delegateQueue:delegateQueue];
}

- (void)APNSRegistEnd:(BOOL)isSuccess
{
    if (!self.delegate) {
        self.delegate = (GCDMulticastDelegate<SREventCenterrDelegate> *)[[GCDMulticastDelegate alloc] init];
    }
    [self.delegate APNSRegistEnd:isSuccess];
}

- (void)currentVehicleChange:(SRVehicleBasicInfo *)vehicle
{
    if (!self.delegate) {
        self.delegate = (GCDMulticastDelegate<SREventCenterrDelegate> *)[[GCDMulticastDelegate alloc] init];
    }
    [[SRDataBase sharedInterface] updateVehicleList:@[vehicle] withCompleteBlock:nil];
    [self.delegate currentVehicleChange:vehicle];
}

- (void)loginStatusChange:(SRLoginStatus)status
{
    if (!self.delegate) {
        self.delegate = (GCDMulticastDelegate<SREventCenterrDelegate> *)[[GCDMulticastDelegate alloc] init];
    }
    
    [SRUserDefaults updateLoginStatus:status];
    [self.delegate loginStatusChange:status];
    
    if ([SRUserDefaults isExperienceUser]) {
        [SRUIUtil startExperienceAlert];
    } else {
        [SRUIUtil stopExperienceAlert];
    }
}

- (void)customerChange:(SRCustomer *)customer
{
    if (!self.delegate) {
        self.delegate = (GCDMulticastDelegate<SREventCenterrDelegate> *)[[GCDMulticastDelegate alloc] init];
    }
    
    [[SRDataBase sharedInterface] updateCustomer:customer withCompleteBlock:nil];
    
    [self.delegate customerChange:customer];
}

- (void)vehicleListChange:(NSArray *)vehicles
{
    if (!self.delegate) {
        self.delegate = (GCDMulticastDelegate<SREventCenterrDelegate> *)[[GCDMulticastDelegate alloc] init];
    }
    
    [[SRDataBase sharedInterface] updateVehicleList:vehicles withCompleteBlock:nil];
    
    [self.delegate vehicleListChange:vehicles];
}

- (void)netWorkReachabilityChange:(AFNetworkReachabilityStatus)status
{
    if (!self.delegate) {
        self.delegate = (GCDMulticastDelegate<SREventCenterrDelegate> *)[[GCDMulticastDelegate alloc] init];
    }
    
    [self.delegate netWorkReachabilityChange:status];
}

//蓝牙
- (void)centralManagerStateChange:(CBCentralManager *)manager
{
    if (!self.delegate) {
        self.delegate = (GCDMulticastDelegate<SREventCenterrDelegate> *)[[GCDMulticastDelegate alloc] init];
    }
    
    [self.delegate centralManagerStateChange:manager];
}

- (void)peripheralStateChange:(CBPeripheral *)peripheral withVehicleID:(NSInteger)vehicleID
{
    if (!self.delegate) {
        self.delegate = (GCDMulticastDelegate<SREventCenterrDelegate> *)[[GCDMulticastDelegate alloc] init];
    }
    
    [self.delegate peripheralStateChange:peripheral withVehicleID:vehicleID];
}

@end

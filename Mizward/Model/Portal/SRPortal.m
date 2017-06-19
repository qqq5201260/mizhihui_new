//
//  SRPortal.m
//  SiRuiV4.0
//
//  Created by zhangjunbo on 15/6/18.
//  Copyright (c) 2015年 SiRui. All rights reserved.
//

#import "SRPortal.h"
#import "SRPortalRequest.h"
#import "SRPortalResponse.h"
#import "SRHttpUtil.h"
#import "SRURLUtil.h"
#import "SRBrandInfo.h"
#import "SRSeriesInfo.h"
#import "SRKeychain.h"
#import "SRUserDefaults+VehicleBasicInfo.h"
#import "SREventCenter.h"
#import "SRUIUtil.h"
#import "SRNotificationCenter.h"
#import "SRDataBase+Customer.h"
#import "SRDataBase+Vehicle.h"
#import "SRVehicleBasicInfo.h"
#import "SRCustomer.h"
#import "SRPortal+User.h"
#import "SRPortal+CarInfo.h"
#import "SRPortal+Login.h"
#import <AFNetworking/AFNetworking.h>
#import <MJExtension/MJExtension.h>


@interface SRPortal ()

@property (nonatomic, strong) id networkObserver;
@property (nonatomic, strong) id forgroundObserver;
@property (nonatomic, strong) id backgroundObserver;
@property (nonatomic, strong) id terminalObserver;

@end

@implementation SRPortal

Singleton_Implementation(SRPortal)

+ (void)load
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
//        __block id observer = [SRNotificationCenter sr_addObserverForName:UIApplicationDidFinishLaunchingNotification object:nil queue:nil usingBlock:^(NSNotification *note) {
//            [SRNotificationCenter sr_removeObserver:observer];
//        
//            [self sharedInterface];
//        }];
        
        [self sharedInterface];
    });
}

- (void)dealloc {
    [SRNotificationCenter sr_removeObserver:_backgroundObserver];
    [SRNotificationCenter sr_removeObserver:_forgroundObserver];
    [SRNotificationCenter sr_removeObserver:_networkObserver];
}

- (instancetype)init {
    if (self = [super init]) {
        
        [self clearData];
        
        [[SRDataBase sharedInterface] queryCustomerByID:[SRUserDefaults customerID] withCompleteBlock:^(NSError *error, id responseObject) {
            if (error) return ;
            self.customer = [responseObject count]>0?responseObject[0]:nil;
        }];
        
//        self.vehicleDic = [SRUserDefaults queryVehicleByCustomerID:[SRUserDefaults customerID]];
//        [[SREventCenter sharedInterface] vehicleListChange:self.allVehicles];
        
        [[SRDataBase sharedInterface] queryVehicleByCustomerID:[SRUserDefaults customerID] withCompleteBlock:^(NSError *error, id responseObject) {
            if (error) return ;
            self.vehicleDic = [responseObject count]>0?responseObject:nil;
            [[SREventCenter sharedInterface] vehicleListChange:self.allVehicles];
        }];
        
        @weakify(self)
        _forgroundObserver = [SRNotificationCenter sr_addObserverForName:UIApplicationWillEnterForegroundNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *note) {
            @strongify(self)
            
            [self autoLogin];
            
            [SRPortal updataAppStatus:NO WithCompleteBlock:nil];
        }];
        
        _backgroundObserver = [SRNotificationCenter sr_addObserverForName:UIApplicationDidEnterBackgroundNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *note) {
            
            //开始后台任务，时限3分钟
            __block UIBackgroundTaskIdentifier backgroundTask = [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:^{
                [[UIApplication sharedApplication] endBackgroundTask: backgroundTask];
                backgroundTask = UIBackgroundTaskInvalid;
            }];
            [SRPortal updataAppStatus:YES WithCompleteBlock:^(NSError *error, id responseObject) {
                //结束后台任务
                [[UIApplication sharedApplication] endBackgroundTask: backgroundTask];
                backgroundTask = UIBackgroundTaskInvalid;
            }];
        }];
        _terminalObserver = [SRNotificationCenter sr_addObserverForName:UIApplicationWillTerminateNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *note) {
            if ([SRUserDefaults isExperienceUser]) {
                [SRPortal logoutWithCompleteBlock:nil];
            }
        }];
        
        _networkObserver = [SRNotificationCenter sr_addObserverForName:AFNetworkingReachabilityDidChangeNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *note) {
            @strongify(self)
            [self autoLogin];
        }];
    }
    
    return self;
}

- (NSArray *)allVehicles
{
    if (!self.vehicleDic) return nil;
    
    return [self.vehicleDic.allValues sortedArrayUsingComparator:^NSComparisonResult(SRVehicleBasicInfo *obj1, SRVehicleBasicInfo *obj2) {
        return obj1.vehicleID > obj2.vehicleID;
    }];
}

- (NSArray *)allVehiclesWithTerminal
{
    if (!self.vehicleDic) return nil;
    
    NSMutableArray *temp = @[].mutableCopy;
    [self.vehicleDic.allValues enumerateObjectsUsingBlock:^(SRVehicleBasicInfo *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.hasTerminal) {
            [temp addObject:obj];
        }
    }];
    
    return [temp sortedArrayUsingComparator:^NSComparisonResult(SRVehicleBasicInfo *obj1, SRVehicleBasicInfo *obj2) {
        return obj1.vehicleID > obj2.vehicleID;
    }];
}

- (SRVehicleBasicInfo *)currentVehicleBasicInfo
{
    return self.vehicleDic[@([SRUserDefaults currentVehicleID])];
}

- (SRVehicleBasicInfo *)vehicleBasicInfoWithVehicleID:(NSInteger)vehicleID
{
    return self.vehicleDic[@(vehicleID)];
}

- (SRVehicleBasicInfo *)vehicleBasicInfoWithPlateNubmer:(NSString *)plateNumber
{
    __block SRVehicleBasicInfo *info;
    [self.vehicleDic.allValues enumerateObjectsUsingBlock:^(SRVehicleBasicInfo *obj, NSUInteger idx, BOOL *stop) {
        if (![obj.plateNumber isEqualToString:plateNumber]) return ;
        
        info = obj;
        *stop = YES;
    }];
    
    return info;
}

- (void)clearData {
    self.customer = [[SRCustomer alloc] init];
    self.vehicleDic = [NSMutableDictionary dictionary];
}

- (void)autoLogin {
    
    if (![SRKeychain Password] || [SRKeychain Password].length <= 0
        || ![SRKeychain UserName] || [SRKeychain UserName].length <= 0
        || ![SRUserDefaults isLogin]) {
        return;
    }
    
    if (![AFHTTPRequestOperationManager manager].reachabilityManager.reachable) {
        return;
    }
    
    SRPortalRequestLogin *request = [[SRPortalRequestLogin alloc] init];
    request.userName = [SRKeychain UserName];
    request.passWord = [SRKeychain Password];
    
    [SRPortal loginWithRequest:request andCompleteBlock:^(NSError *error, id responseObject) {
        if (error) {
            if (error.code == SRHTTP_UserNameOrPasswordError) {
                [SRUIUtil showReloginAlertWithMessage:error.domain doneButton:@"确定"];
            } else {
//                [SRUIUtil showAlertMessage:error.domain];
            }
            return ;
        }
    }];
}

@end

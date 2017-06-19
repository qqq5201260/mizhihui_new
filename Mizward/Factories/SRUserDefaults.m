//
//  JBUserDefaults.m
//  SiRuiV4.0
//
//  Created by zhangjunbo on 15/6/16.
//  Copyright (c) 2015年 SiRui. All rights reserved.
//

#import "SRUserDefaults.h"
#import "SRVehicleBasicInfo.h"
#import <MJExtension/MJExtension.h>

//注销后需要删除
NSString * const kSerialNumber  = @"kSN";//序列号
NSString * const kCurrentVehicleID = @"kCVID";//当前车辆ID
NSString * const kLoginStatus   = @"kLS";//登陆状态
NSString * const kCustomerID = @"kCID";//当前用户ID
NSString * const kHashCode = @"kHC";//hashCode
NSString * const kMapStatus = @"kMS";//地图
NSString * const kResignActiveDate = @"kRAD";//切入后台时间
NSString * const kPasswordAvoidStatus = @"kPAS";//是否免输入密码
NSString * const kBackgroundLockStatus = @"kBLS";//后台锁定
NSString * const kMaintainDepCacheTime = @"kMDCT";//保养4S店时间戳
NSString * const kVisitorLoginTime = @"kVLT";//展车用户登陆时间
NSString * const kTouchID   = @"kTID";//TouchID是否开启
NSString * const kVehicleBsicDic = @"kVBD";//车辆基本信息
//NSString * const kUserName = @"kT"; //用户名
//NSString * const kPassword = @"kT1";//密码
NSString * const kUserNamePassword = @"kUID";//用户名_密码
NSString * const kLogin5mins = @"kLogin5mins";//登录5分钟免密控制

//不能删除
NSString * const kVersion   = @"kV";//版本号
NSString * const kPushToken = @"kPT";//APNs推送pushToken
NSString * const kBaseURLDic_Debug = @"kBU_D";
NSString * const kBaseURLDic_Release = @"kBU_R";
NSString * const kBaseURLPortal = @"kBUP";
NSString * const kBaseURLPhoneApp = @"kBUPA";
NSString * const kBaseURLOnline = @"kBUO";
NSString * const kTcpHost = @"kTH";
NSString * const kTcpPort = @"kTP";
NSString * const kBaseURLSLB_IP = @"kBUSI";
NSString * const kBaseURLSLB_DNS = @"kBUSD";
NSString * const kBLESerialNumber = @"kBS";


@implementation SRUserDefaults

#pragma mark - Reset

//清空所有数据
+ (void)resetDefaults
{
//    NSString *appDomain = [[NSBundle mainBundle] bundleIdentifier];
//    [[self standardUserDefaults] removePersistentDomainForName:appDomain];
    
    NSUserDefaults * defs = [self standardUserDefaults];
    NSArray *keys = @[kSerialNumber, kCurrentVehicleID, kLoginStatus, kCustomerID, kHashCode, kMapStatus, kResignActiveDate, kPasswordAvoidStatus, kBackgroundLockStatus, kMaintainDepCacheTime, kVisitorLoginTime, kTouchID, kVehicleBsicDic, kUserNamePassword,kLogin5mins];
    [keys enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [defs removeObjectForKey:obj];
    }];
    [defs synchronize];
}

+ (BOOL)isExperienceUser
{
    return [self isLogin] && [self userName] && [[self userName] isEqualToString:SRExperienceAccount];
}

#pragma mark - userName password
+ (NSString *)userName
{
    NSString *namePassword = [[self standardUserDefaults] objectForKey:kUserNamePassword];
    if (namePassword) {
        NSArray *array = [[namePassword aes256_decrypt:[[NSBundle mainBundle] bundleIdentifier]] componentsSeparatedByString:@"_"];
        if (array && array.count ==2) {
            return array[0];
        }
    }
    
    return nil;
}

+ (NSString *)password
{
    NSString *namePassword = [[self standardUserDefaults] objectForKey:kUserNamePassword];
    if (namePassword) {
        NSArray *array = [[namePassword aes256_decrypt:[[NSBundle mainBundle] bundleIdentifier]] componentsSeparatedByString:@"_"];
        if (array && array.count ==2) {
            return array[1];
        }
    }
    
    return nil;
}

+ (void)updateUserName:(NSString *)userName password:(NSString *)password
{
    NSString *namePassword = [NSString stringWithFormat:@"%@_%@", userName, password];
    [[self standardUserDefaults] setObject:[namePassword aes256_encrypt:[[NSBundle mainBundle] bundleIdentifier]]
                                    forKey:kUserNamePassword];
    [[self standardUserDefaults] synchronize];
}

#pragma mark - serialNumber

+ (NSInteger)serialNumber
{
    NSNumber *serialNumber = [[self standardUserDefaults] objectForKey:kSerialNumber];
    if (serialNumber) {
        [self updateSerialNumber:serialNumber.integerValue + 1];
        return serialNumber.integerValue;
    } else {
        return 0;
    }
}

+ (void)updateSerialNumber:(NSInteger)serialNumber
{
    [[self standardUserDefaults] setObject:[NSNumber numberWithInteger:serialNumber]
                                    forKey:kSerialNumber];
    [[self standardUserDefaults] synchronize];
}



#pragma mark - bleSerialNumber
//BLE流水号
+ (UInt16)bleSerialNumber
{
    NSNumber *serialNumber = [[self standardUserDefaults] objectForKey:kBLESerialNumber];
    UInt16 number = serialNumber.integerValue;

    ++number;
    if (number == 0) {
        ++number;
    }
    
    NSLog(@"%zd", number);
    
    [self updateBLESerialNumber:number];
    
    return number;
}

+ (void)updateBLESerialNumber:(UInt16)bleSerialNumber
{
    [[self standardUserDefaults] setObject:[NSNumber numberWithInteger:bleSerialNumber]
                                    forKey:kBLESerialNumber];
    [[self standardUserDefaults] synchronize];
}

#pragma mark - currentVehicleID

+ (NSInteger)currentVehicleID
{
    NSNumber *currentVehicleID = [[self standardUserDefaults] objectForKey:kCurrentVehicleID];
    if (currentVehicleID) {
        return currentVehicleID.integerValue;
    } else {
        return 0;
    }
}

+ (void)updateCurrentVehicleID:(NSInteger)vehicleID
{
    if (vehicleID <= 0) return;
    
    [[self standardUserDefaults] setObject:[NSNumber numberWithInteger:vehicleID]
                                    forKey:kCurrentVehicleID];
    [[self standardUserDefaults] synchronize];
}

#pragma mark - customerID

+ (NSInteger)customerID
{
    NSNumber *currentVehicleID = [[self standardUserDefaults] objectForKey:kCustomerID];
    if (currentVehicleID) {
        return currentVehicleID.integerValue;
    } else {
        return 0;
    }
}

+ (void)updateCustomerID:(NSInteger)customerID
{
    [[self standardUserDefaults] setObject:[NSNumber numberWithInteger:customerID]
                                    forKey:kCustomerID];
    [[self standardUserDefaults] synchronize];
}

#pragma mark - 展车用户

//展车用户
+ (void)visitorCustomerLoginTime:(NSDate *)date
{
    [[self standardUserDefaults] setObject:date
                                    forKey:kVisitorLoginTime];
    [[self standardUserDefaults] synchronize];
}

+ (BOOL)isVisitorOverTime:(NSDate *)date experienceMinutes:(NSInteger)minutes
{
    NSDate *login = [[self standardUserDefaults] objectForKey:kVisitorLoginTime];
    if (login && minutes*60 <= fabs([login timeIntervalSinceDate:date])) {
        return YES;
    } else {
        return NO;
    }
}

#pragma mark - hashCode

+ (NSString *)hashCode
{
    return [[self standardUserDefaults] objectForKey:kHashCode];
}

+ (void)updateHashCode:(NSString *)hashCode
{
    [[self standardUserDefaults] setObject:hashCode
                                    forKey:kHashCode];
    [[self standardUserDefaults] synchronize];
}

#pragma mark - loginStatus

+ (BOOL)isLogin
{
    NSNumber *loginStatus = [[self standardUserDefaults] objectForKey:kLoginStatus];
    if (loginStatus) {
        return loginStatus.integerValue != SRLoginStatus_NotLogin;
    } else {
        return NO;
    }
}

+ (SRLoginStatus)loginStatus
{
    NSNumber *loginStatus = [[self standardUserDefaults] objectForKey:kLoginStatus];
    if (loginStatus) {
        return loginStatus.integerValue;
    } else {
        return SRLoginStatus_NotLogin;
    }
}

+ (void)updateLoginStatus:(SRLoginStatus)status
{
    [[self standardUserDefaults] setObject:[NSNumber numberWithInteger:status]
                                    forKey:kLoginStatus];
    [[self standardUserDefaults] synchronize];
}

#pragma mark - URL

+ (NSDictionary *)baseURLDic
{
#if DEBUG
    return [[self standardUserDefaults] objectForKey:kBaseURLDic_Debug];
#else
    return [[self standardUserDefaults] objectForKey:kBaseURLDic_Release];
#endif
}

+ (void)updateBaseURLDic:(NSDictionary *)baseURLDic
{
#if DEBUG
    [[self standardUserDefaults] setObject:baseURLDic
                                    forKey:kBaseURLDic_Debug];
    [[self standardUserDefaults] synchronize];
#else
    [[self standardUserDefaults] setObject:baseURLDic
                                    forKey:kBaseURLDic_Release];
    [[self standardUserDefaults] synchronize];
#endif
}

#pragma mark - APNs PushToken
+ (NSString *)APNsPushToken
{
    return [[self standardUserDefaults] objectForKey:kPushToken];
}

+ (void)updateAPNsPushToken:(NSString *)pushToken
{
    [[self standardUserDefaults] setObject:pushToken
                                    forKey:kPushToken];
    [[self standardUserDefaults] synchronize];
}

#pragma mark - BaiduMap

//地图
+ (BOOL)isBaiduMap
{
    return [[[self standardUserDefaults] objectForKey:kMapStatus] boolValue];
}

+ (void)updateBaiduMap:(BOOL)isBiduMap
{
    [[self standardUserDefaults] setObject:@(isBiduMap)
                                    forKey:kMapStatus];
    [[self standardUserDefaults] synchronize];
}

#pragma mark - Password

//是否需要输入密码
+ (BOOL)needInputPassword
{
    if ([self loginStatus] == SRLoginStatus_Visitor) {
        return NO;
    } else if([self loginStatus] == SRLoginStatus_DidLogin){
        if ([[self standardUserDefaults] boolForKey:kLogin5mins]) {
            return NO;
        }
        if ([[[self standardUserDefaults] objectForKey:kPasswordAvoidStatus] boolValue]) {
            return NO;
        } else if ([[[self standardUserDefaults] objectForKey:kBackgroundLockStatus] boolValue]) {
            return YES;
        } else {
            return YES;
        }
        
    }else{
    
        return NO;
    }
    
}

+ (BOOL)passwordAvoidStatus
{
    return [[[self standardUserDefaults] objectForKey:kPasswordAvoidStatus] boolValue];
}

+ (void)updatePasswrodAvoidStatus:(BOOL)isAvoid
{
    [[self standardUserDefaults] setObject:@(isAvoid)
                                    forKey:kPasswordAvoidStatus];
    [[self standardUserDefaults] synchronize];
}

+ (void)updateLastResignActiveDate:(NSDate *)date
{
    if (!date) {
        [[self standardUserDefaults] removeObjectForKey:kResignActiveDate];
        [[self standardUserDefaults] synchronize];
        
    } else if (![[self standardUserDefaults] objectForKey:kResignActiveDate]) {
        //只保留最早的记录
        [[self standardUserDefaults] setObject:date
                                        forKey:kResignActiveDate];
        [[self standardUserDefaults] synchronize];
    }
}

+ (void)updateLastActiveDate:(NSDate *)date
{
    NSDate *last = [[self standardUserDefaults] objectForKey:kResignActiveDate];
    if (last && date && kPasswordAvoidTime <= fabs([last timeIntervalSinceDate:date])) {
        [[self standardUserDefaults] setObject:@(YES)
                                        forKey:kBackgroundLockStatus];
        [[self standardUserDefaults] synchronize];
    } else {
        [[self standardUserDefaults] setObject:@(NO)
                                        forKey:kBackgroundLockStatus];
        [[self standardUserDefaults] synchronize];
    }
}

+ (void)updateBackgroundLockStatus:(BOOL)isLock
{
    [[self standardUserDefaults] setObject:@(isLock)
                                    forKey:kBackgroundLockStatus];
    [[self standardUserDefaults] synchronize];
}

//+ (void)updateBackgroundLockStatus:(NSDate *)date
//{
//    NSDate *last = [[self standardUserDefaults] objectForKey:kResignActiveDate];
//    if (last && date && kPasswordAvoidTime <= fabs([last timeIntervalSinceDate:date])) {
//        [[self standardUserDefaults] setObject:@(YES)
//                                        forKey:kBackgroundLockStatus];
//        [[self standardUserDefaults] synchronize];
//    } else {
//        [[self standardUserDefaults] setObject:@(NO)
//                                        forKey:kBackgroundLockStatus];
//        [[self standardUserDefaults] synchronize];
//    }
//}

#pragma mark - Welcome

+ (BOOL)hasShowedWelcome
{
    SRLogDebug(@"-----%@-----", [[self standardUserDefaults] objectForKey:kVersion]);
    NSString *version = [[self standardUserDefaults] objectForKey:kVersion];
    if (!version || ![version isEqualToString:CurrentAPPVersion]) {
        return NO;
    } else {
        return YES;
    }
}

+ (void)showedWelcome
{
    [[self standardUserDefaults] setObject:CurrentAPPVersion
                                    forKey:kVersion];
    [[self standardUserDefaults] synchronize];
    
    SRLogDebug(@"-----%@-----", [[self standardUserDefaults] objectForKey:kVersion]);
}

#pragma mark - Maintain Dep CacheTime

//保养4S店时间戳
+ (NSString *)maintainDepCacheTime
{
    return [[self standardUserDefaults] objectForKey:kMaintainDepCacheTime];
}

+ (void)updateMaintainDepCacheTime:(NSString *)cacheTime
{
    if (!cacheTime) return;
    
    [[self standardUserDefaults] setObject:cacheTime
                                    forKey:kMaintainDepCacheTime];
    [[self standardUserDefaults] synchronize];
}

#pragma mark - TouchID

//TouchID
+ (BOOL)isTouchIDOpen
{
    return [[[self standardUserDefaults] objectForKey:kTouchID] boolValue];
}

+ (void)updateTouchID:(BOOL)isOpen
{
    [[self standardUserDefaults] setObject:@(isOpen)
                                    forKey:kTouchID];
    [[self standardUserDefaults] synchronize];
}

#pragma mark - DEBUG
+ (NSString *)macAddress
{
    return [[self standardUserDefaults] objectForKey:@"kMacAddress"] ;
}

+ (void)setMacAddress:(NSString *)macAddress
{
    [[self standardUserDefaults] setObject:macAddress
                                    forKey:@"kMacAddress"];
    [[self standardUserDefaults] synchronize];
}

+ (NSString *)idString
{
    return [[self standardUserDefaults] objectForKey:@"kIdString"] ;
}

+ (void)setIdString:(NSString *)idString
{
    [[self standardUserDefaults] setObject:idString
                                    forKey:@"kIdString"];
    [[self standardUserDefaults] synchronize];
}

+ (NSString *)keyString
{
    return [[self standardUserDefaults] objectForKey:@"kKeyString"] ;
}

+ (void)setKeyString:(NSString *)keyString
{
    [[self standardUserDefaults] setObject:keyString
                                    forKey:@"kKeyString"];
    [[self standardUserDefaults] synchronize];
}

@end

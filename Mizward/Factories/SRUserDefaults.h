//
//  JBUserDefaults.h
//  SiRuiV4.0
//
//  Created by zhangjunbo on 15/6/16.
//  Copyright (c) 2015年 SiRui. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString * const kVehicleBsicDic;

extern NSString * const kBaseURLPortal;
extern NSString * const kBaseURLPhoneApp;
extern NSString * const kBaseURLOnline;
extern NSString * const kTcpHost;
extern NSString * const kTcpPort;
extern NSString * const kBaseURLSLB_IP;
extern NSString * const kBaseURLSLB_DNS;

@interface SRUserDefaults : NSUserDefaults

//清空所有数据
+ (void)resetDefaults;

+ (BOOL)isExperienceUser;

//用户名 密码
+ (NSString *)userName;
+ (NSString *)password;
+ (void)updateUserName:(NSString *)userName password:(NSString *)password;

//流水号
+ (NSInteger)serialNumber;
+ (void)updateSerialNumber:(NSInteger)serialNumber;

//BLE流水号
+ (UInt16)bleSerialNumber;

//当前车辆ID
+ (NSInteger)currentVehicleID;
+ (void)updateCurrentVehicleID:(NSInteger)vehicleID;

//当前用户ID
+ (NSInteger)customerID;
+ (void)updateCustomerID:(NSInteger)customerID;

//展车用户
+ (void)visitorCustomerLoginTime:(NSDate *)date;
+ (BOOL)isVisitorOverTime:(NSDate *)date experienceMinutes:(NSInteger)minutes;

//hashCode
+ (NSString *)hashCode;
+ (void)updateHashCode:(NSString *)hashCode;

//登陆状态
+ (BOOL)isLogin;
+ (SRLoginStatus)loginStatus;
+ (void)updateLoginStatus:(SRLoginStatus)status;

//地址
+ (NSDictionary *)baseURLDic;
+ (void)updateBaseURLDic:(NSDictionary *)baseURLDic;

//APNs PushToken
+ (NSString *)APNsPushToken;
+ (void)updateAPNsPushToken:(NSString *)pushToken;

//地图
+ (BOOL)isBaiduMap;
+ (void)updateBaiduMap:(BOOL)isBiduMap;

//是否需要输入密码
+ (BOOL)needInputPassword;
+ (BOOL)passwordAvoidStatus;
+ (void)updatePasswrodAvoidStatus:(BOOL)isAvoid;
+ (void)updateLastResignActiveDate:(NSDate *)date;
+ (void)updateLastActiveDate:(NSDate *)date;
//+ (void)updateBackgroundLockStatus:(NSDate *)date;
+ (void)updateBackgroundLockStatus:(BOOL)isLock;

//欢迎页
+ (BOOL)hasShowedWelcome;
+ (void)showedWelcome;

//保养4S店时间戳
+ (NSString *)maintainDepCacheTime;
+ (void)updateMaintainDepCacheTime:(NSString *)cacheTime;

//TouchID
+ (BOOL)isTouchIDOpen;
+ (void)updateTouchID:(BOOL)isOpen;

#pragma mark - DEBUG
+ (NSString *)macAddress;
+ (void)setMacAddress:(NSString *)macAddress;
+ (NSString *)idString;
+ (void)setIdString:(NSString *)idString;
+ (NSString *)keyString;
+ (void)setKeyString:(NSString *)keyString;

@end

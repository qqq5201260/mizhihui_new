//
//  SRPortalRequest.h
//  SiRuiV4.0
//
//  Created by zhangjunbo on 15/6/18.
//  Copyright (c) 2015年 SiRui. All rights reserved.
//

#import "SREntity.h"

@class SRCustomer, SRVehicleBasicInfo;

extern NSString * const PortalRequestTrue;
extern NSString * const PortalRequestFalse;

extern NSString * const QueryAlarmsOperationRefresh;
extern NSString * const QueryAlarmsOperationHistory;

extern NSString * const SendAuthCodeToPhoneToChangePhoneNumber;

#pragma mark - Base

@interface SRPortalRequest : SREntity

@property (nonatomic, copy) NSString *conditionCode;
@property (nonatomic, copy) NSString *app;

@end

@interface SRPortalRequestRSAApend : SRPortalRequest

@property (nonatomic, copy) NSString *input1;
@property (nonatomic, copy) NSString *input2;

@end

@interface SRPortalRequestPage : SRPortalRequestRSAApend

@property (nonatomic, assign) NSInteger     pageIndex;
@property (nonatomic, assign) NSInteger     pageSize;

@end

#pragma mark - 注册

@interface SRPortalRequestRegist : SRPortalRequest

@property (nonatomic, copy)     NSString    *customerPassword;
@property (nonatomic, copy)     NSString    *customerPhone;
@property (nonatomic, copy)     NSString    *authcode;

@end

#pragma mark - 验证IMEI

@interface SRPortalRequestValidateIMEI : SRPortalRequest

@property (nonatomic, copy)     NSString    *imei;

@end

#pragma mark - 绑定终端

@interface SRPortalRequestBindTerminal : SRPortalRequestRSAApend

@property (nonatomic, copy)     NSString    *imei;
@property (nonatomic, assign)   NSInteger   vehicleModelID;

@end

#pragma mark - 登陆

@interface SRPortalRequestLogin : SRPortalRequest

@property (nonatomic, copy) NSString *userName;
@property (nonatomic, copy) NSString *passWord;

- (NSString *)passWordWithoutRSA;
- (NSString *)userNameWithoutRSA;

- (NSDictionary *)loginDic;

@end

#pragma mark - 游客登录

@interface SRPortalRequestExhibitionLogin : SRPortalRequest

@property (nonatomic, copy) NSString *userName;
@property (nonatomic, copy) NSString *passWord;
@property (nonatomic, copy) NSString *qrCodeID;

- (NSString *)passWordWithoutRSA;
- (NSString *)userNameWithoutRSA;

- (NSDictionary *)loginDic;

@end

#pragma mark - APP前后台切换

@interface SRPortalRequestUpdateAppStatus : SRPortalRequestRSAApend

@property (nonatomic, assign)   BOOL        isBackGround;

@end

#pragma mark - 注销

@interface SRPortalRequestLogout : SRPortalRequestRSAApend

@end

#pragma mark - 发送验证码到绑定手机（找回密码、更换手机）

@interface SRPortalRequestSendAuthCodeToUser : SRPortalRequest

@property (nonatomic, copy)     NSString    *userName;

@end

#pragma mark - 发送验证码到指定手机（注册）

@interface SRPortalRequestSendAuthCodeToPhone : SRPortalRequest

@property (nonatomic, copy)   NSString      *phone;

- (instancetype)initWithRegiste;

- (instancetype)initWithAccoutAppeal;

@end

#pragma mark - 查询品牌列表

@interface SRPortalRequestQueryBrandList : SRPortalRequest

@end

#pragma mark - 查询车系车型列表

@interface SRPortalRequestQuerySeriesModelTreeList : SRPortalRequest

@property (nonatomic, assign)   NSInteger   brandID;

@end

#pragma mark - 查询车辆档案

@interface SRPortalRequestQueryRecords : SRPortalRequestRSAApend

@end

#pragma mark - 车辆基本信息

@interface SRPortalRequestQueryCarBasicInfo : SRPortalRequestRSAApend

@property (nonatomic, copy)     NSString    *plateNumber;
@property (nonatomic, assign)   NSInteger   vehicleID;

- (NSDictionary *)parameter;

@end

#pragma mark - 车辆状态信息

@interface SRPortalRequestQueryCarStatusInfo : SRPortalRequestRSAApend

@property (nonatomic, copy)     NSString    *plateNumber;
@property (nonatomic, assign)   NSInteger   vehicleID;

@end

#pragma mark - 修改用户信息

@interface SRPortalRequestModifyUserRecord : SRPortalRequestRSAApend

@property (nonatomic, copy)   NSString      *name;
@property (nonatomic, assign) NSInteger     customerSex;
@property (nonatomic, copy)   NSString      *customerBirthday;
@property (nonatomic, copy)   NSString      *customerUserName;
@property (nonatomic, copy)   NSString      *customerPassword;
@property (nonatomic, copy)   NSString      *customerPhone;
@property (nonatomic, copy)   NSString      *customerEmail;
@property (nonatomic, copy)   NSString      *customerAddress;
@property (nonatomic, copy)   NSString      *customerIDNumber;

- (instancetype)initWithCustomer:(SRCustomer *)customer;

- (NSDictionary *)customerDictionaryValue;

@end

#pragma mark - 修改车辆信息

@interface SRPortalRequestModifyCarRecord : SRPortalRequestRSAApend

@property (nonatomic, assign) NSInteger     vehicleModelID;
@property (nonatomic, copy)   NSString      *plateNumber;
@property (nonatomic, copy)   NSString      *vin;

- (instancetype)initWithBasic:(SRVehicleBasicInfo *)basic;

- (NSInteger)entityID;

@end

#pragma mark - 查询轨迹列表

@interface SRPortalRequestQueryTrip : SRPortalRequestRSAApend

@property (nonatomic, assign) NSInteger     vehicleID;
@property (nonatomic, strong) NSDate        *date; //yyyy-mm-dd hh:mm:ss

@end

@interface SRPortalRequestQueryTripPage : SRPortalRequestQueryTrip

@property (nonatomic, assign) NSInteger     pageIndex;
@property (nonatomic, assign) NSInteger     pageSize;

- (instancetype)initWithRequest:(SRPortalRequestQueryTrip *)request;
- (NSDictionary *)customerDictionary;

@end

#pragma mark - 查询轨迹点

@interface SRPortalRequestQueryTripGPSPoints : SRPortalRequestRSAApend

@property (nonatomic, copy)   NSString      *tripID;

@end

@interface SRPortalRequestQueryTripGPSPointsPage : SRPortalRequestQueryTripGPSPoints

@property (nonatomic, assign) NSInteger     pageIndex;
@property (nonatomic, assign) NSInteger     pageSize;

- (instancetype)initWithRequest:(SRPortalRequestQueryTripGPSPoints *)request;

@end

#pragma mark - 删除轨迹

@interface SRPortalRequestDeleteTrip : SRPortalRequestRSAApend

- (void)setTripArray:(NSArray *)trips;

@end

#pragma mark - 查询SMS控制指令

@interface SRPortalRequestQuerySMSCommand : SRPortalRequestRSAApend

@end

#pragma mark - 隐藏行踪

@interface SRPortalRequestTripHidden : SRPortalRequestRSAApend

@property (nonatomic, assign) NSInteger vehicleID;
@property (nonatomic, assign) BOOL  isHidden;

@end

#pragma mark - 预约启动

@class SROrderStartInfo;

@interface SRPortalRequestQueryOrderStart : SRPortalRequestRSAApend

@end

@interface SRPortalRequestAddOrderStart : SRPortalRequestRSAApend

@property (nonatomic, assign)   NSInteger   type;
@property (nonatomic, assign)   NSInteger   vehicleID;
@property (nonatomic, copy)     NSString    *startTime;
@property (nonatomic, assign)   BOOL        isRepeat;
@property (nonatomic, assign)   NSInteger   startTimeLength;
@property (nonatomic, copy)     NSString    *repeatType;
@property (nonatomic, assign)   BOOL        isOpen;

- (instancetype)initWithOrderStartInfo:(SROrderStartInfo *)info;

@end

@interface SRPortalRequestUpdateOrderStart : SRPortalRequestRSAApend

@property (nonatomic, assign)   NSInteger   startClockID;
@property (nonatomic, assign)   NSInteger   type;
@property (nonatomic, assign)   NSInteger   vehicleID;
@property (nonatomic, copy)     NSString    *startTime;
@property (nonatomic, assign)   BOOL        isRepeat;
@property (nonatomic, assign)   NSInteger   startTimeLength;
@property (nonatomic, copy)     NSString    *repeatType;
@property (nonatomic, assign)   BOOL        isOpen;

- (instancetype)initWithOrderStartInfo:(SROrderStartInfo *)info;

@end

@interface SRPortalRequestDeleteOrderStart : SRPortalRequestRSAApend

@property (nonatomic, assign)   NSInteger   startClockID;

@end

@interface SRPortalRequestCloseOrderStartRemind : SRPortalRequest

@end

#pragma mark - IM

@interface SRPortalRequestSendIM : SRPortalRequestRSAApend

@property (nonatomic, copy) NSString *content;
@property (nonatomic, strong) UIImage *image;

- (NSDictionary *)parameter;

@end

@interface SRPortalRequestQueryIM : SRPortalRequestRSAApend

@property (nonatomic, copy) NSString *adddate;
@property (nonatomic, assign) NSInteger direction;

@end

@interface SRPortalRequestUnreadIM : SRPortalRequestRSAApend

@end

#pragma mark - 修改OBD状态

@interface SRPortalRequestUpdateObdStatus : SRPortalRequestRSAApend

@property (nonatomic, assign) NSInteger vehicleID;
@property (nonatomic, assign) BOOL openObd;

- (NSDictionary *)parameter;

@end

#pragma mark - 查询消息列表

@interface SRPortalRequestQueryMessagePage : SRPortalRequestRSAApend

@property (nonatomic, assign) NSInteger     type;
@property (nonatomic, assign) NSInteger     pageIndex;
@property (nonatomic, assign) NSInteger     pageSize;

@end

#pragma mark - 查询未读消息条数

@interface SRPortalRequestQueryMessageUnreadCount : SRPortalRequestRSAApend

@end

#pragma mark - 查询消息开关

@interface SRPortalRequestQueryMessageSwitch : SRPortalRequestRSAApend

@end

#pragma mark - 设置消息开关

@interface SRPortalRequestModifyMessageSwitch : SRPortalRequestRSAApend

@property (nonatomic, copy) NSString *config;

- (void)setConfigWithSwitchArray:(NSArray *)switchs;
- (NSArray *)getSwitchsFromConfig;

@end

#pragma mark - 查询用户信息

@interface SRPortalRequestQueryCustomer : SRPortalRequestRSAApend

@end

#pragma mark - 查询用户权限

@interface SRPortalRequestQueryPermission : SRPortalRequestRSAApend

@end

#pragma mark - 绑定手机

@interface SRPortalRequestBindPhone : SRPortalRequestRSAApend

@end

#pragma mark - 轨迹开关设置

@interface SRPortalRequestTripSwitch : SRPortalRequestRSAApend

@property (nonatomic, assign) BOOL isOpen;

@end

#pragma mark - 实名认证

@interface SRPortalRequestAuthentication : SRPortalRequestRSAApend

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *customerIDNumber;

@end

#pragma mark - 密码找回

@interface SRPortalRequestPhoneVerifyWithoutTernimal : SRPortalRequest

@property (nonatomic, copy) NSString *phone;

@end

@interface SRPortalRequestPhoneVerifyWithTernimal : SRPortalRequest

@property (nonatomic, copy) NSString *phone;
@property (nonatomic, copy) NSString *vin;

@end

@interface SRPortalRequestPhoneVerifyWithAuthcode : SRPortalRequest

@property (nonatomic, copy) NSString *phone;
@property (nonatomic, copy) NSString *authCode;

@end

#pragma mark - 密码重置

@interface SRPortalRequestResetPassword : SRPortalRequest

@property (nonatomic, copy)     NSString    *authCode;
@property (nonatomic, copy)     NSString    *phone;
@property (nonatomic, copy)     NSString    *password;

@end

#pragma mark - 账户申诉

@interface SRPortalRequestAccountAppeal : SRPortalRequest

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *vin;
@property (nonatomic, copy) NSString *phone;
@property (nonatomic, copy) NSString *idNumber;

@property (nonatomic, strong) UIImage *photoContent;

@end

#pragma mark - OBD诊断

@interface SRPortalRequestDtcInfo : SRPortalRequestRSAApend

@property (nonatomic, assign) NSInteger vehicleID;

@end

#pragma mark - 修改当前里程

@interface SRPortalRequestUpdateCurrentMileage : SRPortalRequestRSAApend

@property (nonatomic, assign) NSInteger vehicleID;
@property (nonatomic, assign) CGFloat   mileAge;

@end

#pragma mark - 修改下次保养里程

@interface SRPortalRequestUpdateNextMaintainMileage : SRPortalRequestRSAApend
@property (nonatomic, assign) NSInteger vehicleID;
@property (nonatomic, assign) CGFloat   nextMaintenMileage;
@end

#pragma mark - 更新蓝牙MAC地址

@interface SRPortalRequestUpdateBtInfo : SRPortalRequestRSAApend

@property (nonatomic, assign) NSInteger vehicleID;
@property (nonatomic, copy) NSString *macAddress;
@property (nonatomic, copy) NSString *moduleName;
@property (nonatomic, copy) NSString *softVersion;
@property (nonatomic, copy) NSString *hardVersion;

@end

#pragma mark - 更新密钥同步状态

@interface SRPortalRequestUpdateBtSyncStatus : SRPortalRequestRSAApend

@property (nonatomic, assign) NSInteger vehicleID;
@property (nonatomic, copy) NSString *bluetoothID;

@end

#pragma mark - 提交硬件信息

@interface SRPortalRequestUpdateDeviceInfo : SRPortalRequestRSAApend

@property (nonatomic, assign) NSInteger vehicleID;
@property (nonatomic, assign) NSInteger locID;
@property (nonatomic, copy) NSString *deviceInfo;

@end

#pragma mark - 更换或加装设备

@interface SRPortalRequestChangeOrAddDevice : SRPortalRequestRSAApend

@property (nonatomic, assign) NSInteger vehicleID;
@property (nonatomic, copy) NSString *imei;

@end


//
//  SRPortalRequest.m
//  SiRuiV4.0
//
//  Created by zhangjunbo on 15/6/18.
//  Copyright (c) 2015年 SiRui. All rights reserved.
//

#import "SRPortalRequest.h"
#import "SRKeychain.h"
#import "SRUserDefaults.h"
#import "SRCustomer.h"
#import "SRVehicleBasicInfo.h"
#import "SROrderStartInfo.h"
#import "SRMessageSwitchInfo.h"
#import "SRTripInfo.h"

#import <MJExtension/MJExtension.h>

#pragma mark - Base

@implementation SRPortalRequest

- (instancetype)init {
    if (self = [super init]) {
        _conditionCode = [SRKeychain UUID];
        _app = @"miz";
    }
    
    return self;
}

@end

@implementation SRPortalRequestRSAApend

- (instancetype)init {
    if (self = [super init]) {
        _input1 = [SRKeychain UserName].RSAEncode;
        _input2 = [SRKeychain Password].RSAEncode;
    }
    
    return self;
}

@end

@implementation SRPortalRequestPage

- (instancetype)init {
    if (self = [super init]) {
        _pageSize = 30;
        _pageIndex = 1;
    }
    
    return self;
}

@end

#pragma mark - 注册

@interface SRPortalRequestRegist ()

@property (nonatomic, copy)     NSString    *customerUserName;
@property (nonatomic, copy)     NSString    *customerConfirmPassword;

@end

@implementation SRPortalRequestRegist

- (void)setCustomerPassword:(NSString *)customerPassword
{
    _customerPassword = customerPassword;
    _customerConfirmPassword = customerPassword;
}

- (void)setCustomerPhone:(NSString *)customerPhone
{
    _customerPhone = customerPhone;
    _customerUserName = customerPhone;
}

@end

#pragma mark - 验证IMEI

@implementation SRPortalRequestValidateIMEI

@end

#pragma mark - 绑定终端

@implementation SRPortalRequestBindTerminal

@end

#pragma mark - 登陆

@interface SRPortalRequestLogin ()

@property (nonatomic, copy) NSString *version;
@property (nonatomic, assign) NSInteger phoneType;
@property (nonatomic, copy) NSString *phoneID;
@property (nonatomic, copy) NSString *phoneToken;
@property (nonatomic, copy) NSString *osVersion;

@property (nonatomic, copy) NSString *passWordWithoutRSA;
@property (nonatomic, copy) NSString *userNameWithoutRSA;

@end

@implementation SRPortalRequestLogin

- (instancetype)init {
    if (self = [super init]) {
        _phoneType = 1;
        _phoneID = [SRKeychain UUID];
        _osVersion = CurrentSystemVersion;
        _version = CurrentAPPVersion;
        _phoneToken = [SRUserDefaults APNsPushToken];
    }
    
    return self;
}

- (void)setUserName:(NSString *)userName {
    _userName = userName.RSAEncode;
    _userNameWithoutRSA = userName;
}

- (void)setPassWord:(NSString *)passWord {
    _passWord = passWord.RSAEncode;
    _passWordWithoutRSA = passWord;
}

- (NSDictionary *)loginDic
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:self.keyValues];
    [dic removeObjectsForKeys:@[@"passWordWithoutRSA", @"userNameWithoutRSA"]];
    return dic;
}

@end

#pragma mark - 游客登录

@interface SRPortalRequestExhibitionLogin ()

@property (nonatomic, copy) NSString *version;
@property (nonatomic, assign) NSInteger phoneType;
@property (nonatomic, copy) NSString *phoneID;
@property (nonatomic, copy) NSString *phoneToken;
@property (nonatomic, copy) NSString *osVersion;

@property (nonatomic, copy) NSString *passWordWithoutRSA;
@property (nonatomic, copy) NSString *userNameWithoutRSA;

@end

@implementation SRPortalRequestExhibitionLogin

- (instancetype)init {
    if (self = [super init]) {
        _phoneType = 1;
        _phoneID = [SRKeychain UUID];
        _osVersion = CurrentSystemVersion;
        _version = CurrentAPPVersion;
        _phoneToken = [SRUserDefaults APNsPushToken];
    }
    
    return self;
}

- (void)setUserName:(NSString *)userName {
    _userName = userName.RSAEncode;
    _userNameWithoutRSA = userName;
}

- (void)setPassWord:(NSString *)passWord {
    _passWord = passWord.RSAEncode;
    _passWordWithoutRSA = passWord;
}

- (NSDictionary *)loginDic
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:self.keyValues];
    [dic removeObjectsForKeys:@[@"passWordWithoutRSA", @"userNameWithoutRSA"]];
    return dic;
}

@end

#pragma mark - APP前后台切换

@interface SRPortalRequestUpdateAppStatus ()

@property (nonatomic, copy)     NSString    *deviceID;

@end

@implementation SRPortalRequestUpdateAppStatus

- (instancetype)init {
    if (self = [super init]) {
        _deviceID = [SRKeychain UUID];
    }
    
    return self;
}

@end

#pragma mark - 注销

@interface SRPortalRequestLogout ()

@property (nonatomic, copy)     NSString    *phoneID;

@end

@implementation SRPortalRequestLogout

- (instancetype)init {
    if (self = [super init]) {
        _phoneID = [SRUserDefaults APNsPushToken];
    }
    
    return self;
}

@end

#pragma mark - 发送验证码到绑定手机（找回密码、更换手机）

@implementation SRPortalRequestSendAuthCodeToUser

@end

#pragma mark - 发送验证码到指定手机（注册）

@interface SRPortalRequestSendAuthCodeToPhone ()

@property (nonatomic, copy)   NSString      *fromRegist;
@property (nonatomic, copy)   NSString      *type;

@end

@implementation SRPortalRequestSendAuthCodeToPhone

- (instancetype)init {
    if (self = [super init]) {
        _fromRegist = @"1";
        _type = @"updatePhone";
    }
    return self;
}

- (instancetype)initWithRegiste
{
    if (self = [super init]) {
        _fromRegist = @"1";
    }
    
    return self;
}

- (instancetype)initWithAccoutAppeal
{
    if (self = [super init]) {
        
    }
    
    return self;
}

@end

#pragma mark - 查询品牌列表

@implementation SRPortalRequestQueryBrandList

@end

#pragma mark - 查询车系车型列表

@implementation SRPortalRequestQuerySeriesModelTreeList

@end

#pragma mark - 查询车辆档案

@implementation SRPortalRequestQueryRecords

@end

#pragma mark - 车辆基本信息

@implementation SRPortalRequestQueryCarBasicInfo

- (NSDictionary *)parameter
{
    NSMutableDictionary *dic = self.keyValues;
    if (!dic[@"plateNumber"] || [dic[@"vehicleID"] integerValue] == 0) {
        [dic removeObjectForKey:@"plateNumber"];
        [dic removeObjectForKey:@"vehicleID"];
    }
    
    return dic;
}

@end

#pragma mark - 车辆状态信息

@implementation SRPortalRequestQueryCarStatusInfo

@end

#pragma mark - 修改用户信息

@interface SRPortalRequestModifyUserRecord ()
@property (nonatomic, copy)   NSString      *imei;
@property (nonatomic, copy)   NSString      *withEncrypt;
@property (nonatomic, copy)   NSString      *levelCode;
@end

@implementation SRPortalRequestModifyUserRecord

- (instancetype)init {
    if (self = [super init]) {
        _withEncrypt = @"1";
    }
    return self;
}

- (instancetype)initWithCustomer:(SRCustomer *)customer
{
    if (self = [super init]) {
        _withEncrypt = @"1";
        _levelCode = customer.levelCode;
        _name = customer.name;
        _customerSex = customer.customerSex;
        _customerBirthday = customer.customerBirthday;
        _customerPhone = customer.customerPhone;
        _customerEmail = customer.customerEmail;
        _customerAddress = customer.customerAddress;
        _customerIDNumber = customer.customerIDNumber;
        
        self.customerUserName = customer.customerUserName;
        self.customerPassword = [SRKeychain Password];
    }
    return self;
}

- (NSDictionary *)customerDictionaryValue {
    NSMutableDictionary *customer = [NSMutableDictionary dictionaryWithDictionary:self.keyValues];
    
    NSString *imei = [customer objectForKey:@"imei"];
    if (imei) {
        [customer setObject:imei forKey:@"Terminal.imei"];
        [customer removeObjectForKey:@"imei"];
    }
    
    [customer setObject:self.customerPassword.RSAEncode forKey:@"customerPassword"];
    
    return customer;
}

- (void)setCustomerUserName:(NSString *)customerUserName {
    _customerUserName = customerUserName;
    _imei = customerUserName;
}

//- (void)setCustomerPassword:(NSString *)customerPassword {
//    _customerPassword = customerPassword.RSAEncode;
//}

@end


#pragma mark - 修改车辆信息

@interface SRPortalRequestModifyCarRecord ()

@property (nonatomic, assign) NSInteger     entityID;
@property (nonatomic, copy)   NSString      *serialNumber;
@property (nonatomic, copy)   NSString      *msisdn;
@property (nonatomic, copy)   NSString      *barcode;
@property (nonatomic, copy)   NSString      *installDate;
@property (nonatomic, copy)   NSString      *color;
@property (nonatomic, copy)   NSString      *saleDate;

@end

@implementation SRPortalRequestModifyCarRecord

- (instancetype)initWithBasic:(SRVehicleBasicInfo *)basic
{
    if (self = [super init]) {
        _entityID = basic.vehicleID;
        _vehicleModelID = basic.vehicleModelID;
        _plateNumber = basic.plateNumber;
        _color = basic.color;
        _vin = basic.vin;
        _saleDate = basic.saleDate;
        _serialNumber = basic.serialNumber;
        _msisdn = basic.msisdn;
        _installDate = basic.insuranceSaleDate;
        _barcode = basic.barcode;
    }
    
    return self;
}

@end

#pragma mark - 查询轨迹列表

@interface SRPortalRequestQueryTrip ()

@property (nonatomic, copy)   NSString      *startTime;
@property (nonatomic, copy)   NSString      *endTime;

@end

@implementation SRPortalRequestQueryTrip

- (void)setDate:(NSDate *)date {
    _date = date;
    //local转UTC
    self.startTime = [NSString UTCTimeString_YYYYYMMddHHmmss:[NSString stringWithFormat:@"%@ 00:00:00", [date stringOfDateWithFormatYYYYMMdd]]];
    self.endTime = [NSString UTCTimeString_YYYYYMMddHHmmss:[NSString stringWithFormat:@"%@ 23:59:59", [date stringOfDateWithFormatYYYYMMdd]]];
}

@end

@implementation SRPortalRequestQueryTripPage

- (instancetype)init {
    if (self = [super init]) {
        _pageIndex = 1;
        _pageSize = 30;
    }
    
    return self;
}

- (instancetype)initWithRequest:(SRPortalRequestQueryTrip *)request
{
    if (self = [super init]) {
        self.vehicleID = request.vehicleID;
        self.startTime = request.startTime;
        self.endTime = request.endTime;
        _pageIndex = 1;
        _pageSize = 30;
    }
    
    return self;
}

- (NSDictionary *)customerDictionary
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:self.keyValues];
    [dic removeObjectForKey:@"date"];
    return dic;
}

@end

#pragma mark - 查询轨迹点

@implementation SRPortalRequestQueryTripGPSPoints

@end

@implementation SRPortalRequestQueryTripGPSPointsPage

- (instancetype)init {
    if (self = [super init]) {
        _pageIndex = 1;
        _pageSize = 3000;
    }
    return self;
}

- (instancetype)initWithRequest:(SRPortalRequestQueryTripGPSPoints *)request
{
    if (self = [super init]) {
        self.tripID = request.tripID;
        _pageIndex = 1;
        _pageSize = 3000;
    }
    return self;
}

@end

#pragma mark - 删除轨迹

@interface SRPortalRequestDeleteTrip ()

@property (nonatomic, copy) NSString *tripID;

@end

@implementation SRPortalRequestDeleteTrip

- (void)setTripArray:(NSArray *)trips
{
    NSMutableArray *array = [NSMutableArray array];
    [trips enumerateObjectsUsingBlock:^(SRTripInfo *obj, NSUInteger idx, BOOL *stop) {
        [array addObject:obj.tripID];
    }];
    
    self.tripID = [array componentsJoinedByString:@","];
}

@end


#pragma mark - 查询SMS控制指令

@implementation SRPortalRequestQuerySMSCommand

@end

#pragma mark - 隐藏行踪

@implementation SRPortalRequestTripHidden

@end

#pragma mark - 预约启动

@implementation SRPortalRequestQueryOrderStart

@end

@implementation SRPortalRequestAddOrderStart

- (instancetype)initWithOrderStartInfo:(SROrderStartInfo *)info
{
    if (self = [super init]) {
        _type = info.type;
        _vehicleID = info.vehicleID;
        _startTime = info.startTime;
        _isRepeat = info.isRepeat;
        _startTimeLength = info.startTimeLength;
        _repeatType = info.repeatType;
        _isOpen = YES;
    }
    
    return self;
}

@end

@implementation SRPortalRequestUpdateOrderStart

- (instancetype)initWithOrderStartInfo:(SROrderStartInfo *)info {
    if (self = [super init]) {
        _startClockID = info.startClockID;
        _type = info.type;
        _vehicleID = info.vehicleID;
        _startTime = info.startTime;
        _isRepeat = info.isRepeat;
        _startTimeLength = info.startTimeLength;
        _repeatType = info.repeatType;
        _isOpen = info.isOpen;
    }
    
    return self;
}

@end

@implementation SRPortalRequestDeleteOrderStart

@end

@interface SRPortalRequestCloseOrderStartRemind ()

@property (nonatomic, copy) NSString *cn;

@end

@implementation SRPortalRequestCloseOrderStartRemind

- (instancetype)init {
    if (self = [super init]) {
        _cn = [SRKeychain UserName];
    }
    
    return self;
}

@end

#pragma mark - IM

@interface SRPortalRequestSendIM ()

@property (nonatomic, copy) NSString *siruiService;

@end

@implementation SRPortalRequestSendIM

- (instancetype)init {
    if (self = [super init]) {
        _siruiService = @"from";
    }
    
    return self;
}

- (NSDictionary *)parameter
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:self.keyValues];
    if (dic[@"image"]) {
        [dic removeObjectForKey:@"image"];
    }
    
    return dic;
}

@end

@interface SRPortalRequestQueryIM ()

@property (nonatomic, assign) NSInteger rows;

@end

@implementation SRPortalRequestQueryIM

- (instancetype)init {
    if (self = [super init]) {
        _rows = 30;
    }
    
    return self;
}

@end

@implementation SRPortalRequestUnreadIM

@end

#pragma mark - 修改OBD状态

@implementation SRPortalRequestUpdateObdStatus

- (NSDictionary *)parameter
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:self.keyValues];
    [dic setObject:self.openObd?@"1":@"2" forKey:@"openObd"];
    
    return dic;
}

@end

#pragma mark - 查询消息列表

@implementation SRPortalRequestQueryMessagePage

- (instancetype)init {
    if (self = [super init]) {
        _pageIndex = 1;
        _pageSize = 30;
    }
    return self;
}

@end

#pragma mark - 查询未读消息条数

@implementation SRPortalRequestQueryMessageUnreadCount

@end

#pragma mark - 查询消息开关

@implementation SRPortalRequestQueryMessageSwitch

@end

#pragma mark - 设置消息开关

@implementation SRPortalRequestModifyMessageSwitch

- (void)setConfigWithSwitchArray:(NSArray *)switchs
{
    NSMutableArray *list = [NSMutableArray array];
    [switchs enumerateObjectsUsingBlock:^(SRMessageSwitchInfo *obj, NSUInteger idx, BOOL *stop) {
        [list addObject:[NSString stringWithFormat:@"%@:%@", @(obj.msgType), @(obj.isOpend)]];
    }];
    
    self.config = [list componentsJoinedByString:@";"];
}

- (NSArray *)getSwitchsFromConfig
{
    if (!self.config || self.config.length==0) return nil;
    
    NSArray *list = [self.config componentsSeparatedByString:@";"];
    if (!list || list.count==0) return nil;
    
    __block NSMutableArray *switchs = [NSMutableArray array];
    [list enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL *stop) {
        NSArray *temp = [obj componentsSeparatedByString:@":"];
        SRMessageSwitchInfo *info = [[SRMessageSwitchInfo alloc] initWithMsgType:((NSString *)temp[0]).integerValue
                                                                       andIsOpen:((NSString *)temp[1]).boolValue];
        [switchs addObject:info];
    }];
    
    return switchs;
}

@end

#pragma mark - 查询用户信息

@interface SRPortalRequestQueryCustomer ()

@property (nonatomic, copy) NSString *hashCode;

@end

@implementation SRPortalRequestQueryCustomer

- (instancetype)init {
    if (self = [super init]) {
        _hashCode = [SRUserDefaults hashCode];
    }
    
    return self;
}

@end

#pragma mark - 查询用户权限

@implementation SRPortalRequestQueryPermission

@end

#pragma mark - 绑定手机

@implementation SRPortalRequestBindPhone

@end

#pragma mark - 轨迹开关设置

@implementation SRPortalRequestTripSwitch

@end

#pragma mark - 实名认证

@implementation SRPortalRequestAuthentication 

@end

#pragma mark - 密码找回

@implementation SRPortalRequestPhoneVerifyWithoutTernimal

@end

@implementation SRPortalRequestPhoneVerifyWithTernimal

@end

@implementation SRPortalRequestPhoneVerifyWithAuthcode 

@end

#pragma mark - 密码重置

@interface SRPortalRequestResetPassword ()
@property (nonatomic, assign)   NSInteger   withEncrypt;
@end

@implementation SRPortalRequestResetPassword

- (instancetype)init {
    if (self = [super init]) {
        _withEncrypt = 1;
    }
    
    return self;
}

- (void)setPassword:(NSString *)password {
    _password = password.RSAEncode;
}

@end

#pragma mark - 账户申诉

@interface SRPortalRequestAccountAppeal ()

@property (nonatomic, copy) NSString *email;
@property (nonatomic, copy) NSString *msisdn;
@property (nonatomic, copy) NSString *plateNumber;

@end

@implementation SRPortalRequestAccountAppeal

@end

#pragma mark - OBD诊断

@implementation SRPortalRequestDtcInfo 

@end

#pragma mark - 修改当前里程

@implementation SRPortalRequestUpdateCurrentMileage

@end

#pragma mark - 修改下次保养里程

@implementation SRPortalRequestUpdateNextMaintainMileage

@end

#pragma mark - 更新蓝牙MAC地址

@implementation SRPortalRequestUpdateBtInfo

@end

#pragma mark - 更新密钥同步状态

@implementation SRPortalRequestUpdateBtSyncStatus 

@end

#pragma mark - 提交硬件信息

@implementation SRPortalRequestUpdateDeviceInfo

- (void)setDeviceInfo:(NSString *)deviceInfo {
    _deviceInfo = [deviceInfo stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
}

@end

#pragma mark - 更换或加装设备

@implementation SRPortalRequestChangeOrAddDevice 

@end

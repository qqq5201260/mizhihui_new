//
//  SRURLUtil.m
//  SiRuiV4.0
//
//  Created by zhangjunbo on 15/6/15.
//  Copyright (c) 2015年 SiRui. All rights reserved.
//

#import "SRURLUtil.h"
#import "SRKeychain.h"
#import "SRUserDefaults.h"

NSString * const appStore = @"itms-apps://itunes.apple.com/gb/app/mi-zhi-hui/id1032230657?mt=8";

//https://itunes.apple.com/us/app/mi-zhi-hui/id1032230657?l=zh&ls=1&mt=8

NSString * const appVersionCheckURL = @"http://itunes.apple.com/lookup?id=1032230657";

NSString * const defaultsSLBBaseURL_IP = @"http://121.40.136.68:8000";
//NSString * const defaultsSLBBaseURL_IP = @"http://192.168.8.7:8080";
NSString * const defaultsSLBBaseURL_DNS = @"http://phonedns.mysirui.com:8000";

NSString * const defaultsPortalBaseURL = @"http://42.120.61.246:80";
//NSString * const defaultsPortalBaseURL = @"http://192.168.8.101:8080/SiRui-4SPortal";
NSString * const defaultsPhoneAppBaseURL = @"http://42.120.61.246:2302";
NSString * const defaultsOnlineBaseURL = @"http://112.124.52.2:80";
NSString * const defaultsTcpHost = @"42.120.61.246";
const NSInteger  defaultsTcpPort = 3004;

/*SLB*/
NSString * const pathURL_SLB = @"/slb";

/*PhoneApp*/
NSString * const pathURL_Control = @"/phone/control";

/*Portal*/
NSString * const pathURL_Regist = @"/basic/customer/registerCustomer";
NSString * const pathURL_BindTerminal = @"/basic/customer/bindTerminal";
NSString * const pathURL_ValidateIMEI = @"/basic/terminal/validateIMEI";
NSString * const pathURL_AddReservation = @"/workorder/reservation/add";
NSString * const pathURL_UpdateReservation = @"/workorder/reservation/updateReservationInfo";
NSString * const pathURL_QueryReservation = @"/workorder/reservation/query";
NSString * const pathURL_Login = @"/basic/customer/login";
NSString * const pathURL_ExhibitionLogin = @"/basic/exhibition/login";
NSString * const pathURL_UpdateAppStatus = @"/basic/customer/runInBackground";
NSString * const pathURL_Logout = @"/basic/customer/phoneLogout";
NSString * const pathURL_SendAuthCodeToUser = @"/provider/testProvide/sendBingdingAuthCode";
NSString * const pathURL_QueryCarBasicInfo = @"/basic/car/infos";
NSString * const pathURL_ResetPassword = @"/basic/customer/changePwdByVersion4";
NSString * const pathURL_QueryCarStatusInfo = @"/basic/car/status";
NSString * const pathURL_QueryMessageList = @"/msg/msgList/getListByType";
NSString * const pathURL_QueryMessageUnreadCount = @"/msg/msgList/queryCount";
NSString * const pathURL_ModifyMessageSwitch = @"/msg/messageSwitch/set";
NSString * const pathURL_QueryMessageSwitch = @"/msg/messageSwitch/get";
NSString * const pathURL_ClearSubtotalMileage = @"/basic/car/clearSubtotalMileage";
NSString * const pathURL_QueryTotalStatistics = @"/basic/car/totalStatistics";
NSString * const pathURL_QueryDayStatistics = @"/basic/car/dayStatistics";
NSString * const pathURL_QueryMonthStatistics = @"/basic/car/monthStatistics";
NSString * const pathURL_QueryYearStatistics = @"/basic/car/yearStatistics";
NSString * const pathURL_QueryBrandList = @"/basic/car/toAdd";
NSString * const pathURL_QuerySeriesModelTreeList = @"/basic/vehicleModel/getSeriesModelTreeList";
NSString * const pathURL_QueryDepartmentList = @"/purview/department/query";
NSString * const pathURL_BrandImage = @"/basic/brand/getImage";
NSString * const pathURL_DepartmentLogo = @"/purview/department/get4sOnlineIMG";
NSString * const pathURL_QueryEvaluateDetail = @"/market/feedback/detail";
NSString * const pathURL_ModifyEvaluateDetail = @"/market/feedback/update";
NSString * const pathURL_QueryHasUnreadIM = @"/im/im/hasUnReadMsg";
NSString * const pathURL_QueryIM = @"/im/im/getMsg";
NSString * const pathURL_SendIM = @"/im/im/sendMsg_client";
NSString * const pathURL_QueryRecords = @"/basic/car/query";
NSString * const pathURL_SendAuthCodeToPhone = @"/provider/testProvide/sendAuthCode";
NSString * const pathURL_AuthCodeImage = @"/provider/testProvide/getAuthcodeIMGUrl";
NSString * const pathURL_ModifyUserRecord = @"/basic/customer/updateByPhone";
NSString * const pathURL_ModifyCarRecord = @"/basic/car/updateByPhone";
NSString * const pathURL_QueryTrip = @"/gateway/trip/query";
NSString * const pathURL_QueryTripGPSPoints = @"/gateway/trip/gpsPoints";
NSString * const pathURL_DeleteTrip = @"/gateway/trip/updateEffective";
NSString * const pathURL_QueryDtcInfo = @"/basic/car/dtcInfo";
NSString * const pathURL_Bind = @"/basic/customer/binding";
NSString * const pathURL_Unbind = @"/basic/customer/unbind";
NSString * const pathURL_HideTrip = @"/basic/car/hideTrip";
NSString * const pathURL_QueryModifyPermission = @"/basic/customer/getModifyPermission";
NSString * const pathURL_QuerySMSCommand = @"/basic/customer/querySmsCommandTemp";
NSString * const pathURL_ModifyObdCheckStatus = @"/basic/car/updateSyncObd";
NSString * const pathURL_QueryOrderStart = @"/basic/startClock/query";
NSString * const pathURL_AddOrderStart = @"/basic/startClock/add";
NSString * const pathURL_UpdateOrderStart = @"/basic/startClock/update";
NSString * const pathURL_DeleteOrderStart = @"/basic/startClock/delete";
NSString * const pathURL_CloseOrderStartRemind = @"/SiRui-4SPortal/OM/car/closeMsgPush.jsp";
NSString * const pathURL_QueryCustomer = @"/basic/customer/get";
NSString * const pathURL_OpenHiddenTrip = @"/basic/customer/openHiddenTrip";
NSString * const pathURL_RealNameAuthentication = @"/basic/customer/realNameAuthentication";
NSString * const pathURL_PhoneVerifyWithoutTernimal = @"/provider/testProvide/sendAuthCodeByPhone";
NSString * const pathURL_PhoneVerifyWithTernimal = @"/provider/testProvide/sendAuthCodeByVIN";
NSString * const pathURL_PhoneVerifyWithoutTernimalNoAuthcode = @"/provider/testProvide/sendSMSCodeByPhone";
NSString * const pathURL_PhoneVerifyWithTernimalNoAuthcode = @"/provider/testProvide/sendSMSCodeByVIN";
NSString * const pathURL_PhoneVerifyWithAuthcode = @"/provider/testProvide/validateCode";
NSString * const pathURL_AccountAppealSubmit = @"/basic/examinePsw/add";
NSString * const pathURL_StatusDetail = @"/OM/car/queryCarStatus4Phone";
NSString * const pathURL_FAQ = @"/basic/customer/faq";

NSString * const pathURL_MaintainQueryReserve = @"/workorder/maintenReservation/queryReserve";
NSString * const pathURL_MaintainQueryDep = @"/workorder/maintenReservation/queryDep";
NSString * const pathURL_MaintainAddReserve = @"/workorder/maintenReservation/reserve";
NSString * const pathURL_MaintainAddHistory = @"/workorder/mainten/save";
NSString * const pathURL_MaintainDeleteHistory = @"/workorder/maintenHis/deleteByCustomer";
NSString * const pathURL_MaintainQueryHistory = @"/workorder/maintenHis/queryHis";
NSString * const pathURL_MaintainUpdateHistory = @"/workorder/mainten/update";

NSString * const pathURL_UpdateCurrentMileage = @"/basic/car/updateMeliage4Mainten";
NSString * const pathURL_UpdateNextMaintainMileage = @"/basic/car/updateNextMeliage4Mainten";

NSString * const pathURL_UpdateBtInfo = @"/basic/car/updateBtInfo";
NSString * const pathURL_QueryTerminalUpdateInfo = @"/basic/car/getTerminalUpdateInfo";
NSString * const pathURL_UpdateBtSyncStatus = @"/basic/car/finishBtSync";
NSString * const pathURL_UpdateDeviceInfo = @"/basic/attachDevice/getDeviceInfo";
NSString * const pathURL_ChangeOrAddDevice = @"/basic/car/changeDevice";

NSString * const pathURL_AccountQuery = @"/basic/account/query";
NSString * const pathURL_SignDaily = @"/basic/customer/signDaily";
NSString * const pathURL_PointQuery = @"/basic/pointRecord/queryPointRecord";

static NSString *slbBaseURL_IP;
static NSString *slbBaseURL_DNS;

static NSString *onlineBaseURL;
static NSString *portalBaseURL;
static NSString *phoneAppBaseURL;

static NSString *tcpHost;
static NSInteger tcpPort;

static NSString *slbBaseURL_IP;
static NSString *slbBaseURL_DNS;

@implementation SRURLUtil

+ (void)load
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        NSDictionary *urlDic = [SRUserDefaults baseURLDic];
        if (urlDic) {
            slbBaseURL_IP = urlDic[kBaseURLSLB_IP];
            slbBaseURL_DNS = urlDic[kBaseURLSLB_DNS];
            
            onlineBaseURL = urlDic[kBaseURLOnline];
            portalBaseURL = urlDic[kBaseURLPortal];
            phoneAppBaseURL = urlDic[kBaseURLPhoneApp];
            
            tcpHost = urlDic[kTcpHost];
            tcpPort = [urlDic[kTcpPort] integerValue];
        } else {
            slbBaseURL_IP = defaultsSLBBaseURL_IP;
            slbBaseURL_DNS = defaultsSLBBaseURL_DNS;
            
            onlineBaseURL = defaultsOnlineBaseURL;
            portalBaseURL = defaultsPortalBaseURL;
            phoneAppBaseURL = defaultsPhoneAppBaseURL;
            
            tcpHost = defaultsTcpHost;
            tcpPort = defaultsTcpPort;
            [SRURLUtil saveBaseUrl];
        }
    });
}

+ (void)saveBaseUrl
{
    NSDictionary *configDic = @{kBaseURLSLB_IP  : slbBaseURL_IP,
                                kBaseURLSLB_DNS : slbBaseURL_DNS,
                                kBaseURLOnline  : onlineBaseURL,
                                kBaseURLPortal  : portalBaseURL,
                                kBaseURLPhoneApp : phoneAppBaseURL,
                                kTcpHost : tcpHost,
                                kTcpPort : [NSString stringWithFormat:@"%zd", tcpPort]};
    [SRUserDefaults updateBaseURLDic:configDic];
}

+ (void)resetURLs
{
    slbBaseURL_IP = defaultsSLBBaseURL_IP;
    slbBaseURL_DNS = defaultsSLBBaseURL_DNS;
    
    onlineBaseURL = defaultsOnlineBaseURL;
    portalBaseURL = defaultsPortalBaseURL;
    phoneAppBaseURL = defaultsPhoneAppBaseURL;
    
    tcpHost = defaultsTcpHost;
    tcpPort = defaultsTcpPort;
    [self saveBaseUrl];
}

+ (void)restTestURLs{

//    slbBaseURL_IP = defaultsSLBBaseURL_IP;
//    slbBaseURL_DNS = defaultsSLBBaseURL_DNS;
    
//    onlineBaseURL = defaultsOnlineBaseURL;
    portalBaseURL = @"http://192.168.6.52:8080";
    phoneAppBaseURL = @"http://192.168.6.52:2302/phone/control";
    
    tcpHost = @"192.168.6.52";
    tcpPort = defaultsTcpPort;
    [self saveBaseUrl];
    
}

#pragma mark - Setter

+ (void)setBaseURL_Online:(NSString *)url
{
    onlineBaseURL = url;
    [self saveBaseUrl];
}

+ (void)setBaseURL_Portal:(NSString *)url
{
    portalBaseURL = url;
    [self saveBaseUrl];
}

+ (void)setBaseURL_PhoneApp:(NSString *)url
{
    phoneAppBaseURL = url;
    [self saveBaseUrl];
}

+ (void)setTcpHost:(NSString *)host
{
    tcpHost = host;
    [self saveBaseUrl];
}

+ (void)setTcpPort:(NSInteger)port
{
    tcpPort = port;
    [self saveBaseUrl];
}

+ (void)setBaseURL_Slb_IP:(NSString *)url
{
    slbBaseURL_IP = url;
    [self saveBaseUrl];
}

+ (void)setBaseURL_Slb_DNS:(NSString *)url
{
    slbBaseURL_DNS = url;
    [self saveBaseUrl];
}

#pragma mark - Getter

+ (NSString *)BaseURL_Online
{
    return onlineBaseURL;
}

+ (NSString *)BaseURL_Portal
{
    return portalBaseURL;
}

+ (NSString *)BaseURL_PhoneApp
{
    return phoneAppBaseURL;
}

+ (NSString *)TcpHost
{
    return tcpHost;
}

+ (NSInteger)TcpPort
{
    return tcpPort;
}

+ (NSString *)BaseURL_Slb_IP
{
    return slbBaseURL_IP;
}

+ (NSString *)BaseURL_Slb_DNS
{
    return slbBaseURL_DNS;
}

#pragma mark - version

+ (NSString *)appVersionCheck
{
    return appVersionCheckURL;
}

#pragma mark - appStore

+ (NSString *)appStore
{
    return appStore;
}

#pragma mark - SLB
+ (NSString *)SLB_DNSUrl
{
    return [NSString stringWithFormat:@"%@%@", slbBaseURL_DNS, pathURL_SLB];
}

+ (NSString *)SLB_IPUrl
{
    return [NSString stringWithFormat:@"%@%@", slbBaseURL_IP, pathURL_SLB];
}

#pragma mark - PhoneApp
+ (NSString *)PhoneApp_ControlUrl
{
    return [NSString stringWithFormat:@"%@%@", phoneAppBaseURL, pathURL_Control];
}

#pragma mark - Portal

+ (NSString *)Portal_RegistUrl
{
    return [NSString stringWithFormat:@"%@%@", portalBaseURL, pathURL_Regist];
}

+ (NSString *)Portal_BindTerminal
{
    return [NSString stringWithFormat:@"%@%@", portalBaseURL, pathURL_BindTerminal];
}

//验证IMEI
+ (NSString *)Portal_ValidateIMEI
{
    return [NSString stringWithFormat:@"%@%@", portalBaseURL, pathURL_ValidateIMEI];
}

+ (NSString *)Portal_LoginUrl
{
    return [NSString stringWithFormat:@"%@%@", portalBaseURL, pathURL_Login];
}

//游客登陆
+ (NSString *)Portal_ExhibitionLoginUrl
{
    return [NSString stringWithFormat:@"%@%@", portalBaseURL, pathURL_ExhibitionLogin];
}

+ (NSString *)Portal_UpdateAppStatusUrl
{
    return [NSString stringWithFormat:@"%@%@", portalBaseURL, pathURL_UpdateAppStatus];
}

+ (NSString *)Portal_LogoutUrl
{
    return [NSString stringWithFormat:@"%@%@", portalBaseURL, pathURL_Logout];
}

+ (NSString *)Portal_SendAuthCodeToUserUrl
{
    return [NSString stringWithFormat:@"%@%@", portalBaseURL, pathURL_SendAuthCodeToUser];
}

+ (NSString *)Portal_QueryCarBasicInfoUrl
{
    return [NSString stringWithFormat:@"%@%@", portalBaseURL, pathURL_QueryCarBasicInfo];
}

+ (NSString *)Portal_ResetPasswordUrl
{
    return [NSString stringWithFormat:@"%@%@", portalBaseURL, pathURL_ResetPassword];
}

+ (NSString *)Portal_QueryCarStatusInfoUrl
{
    return [NSString stringWithFormat:@"%@%@", portalBaseURL, pathURL_QueryCarStatusInfo];
}

+ (NSString *)Portal_QueryMessageListUrl
{
    return [NSString stringWithFormat:@"%@%@", portalBaseURL, pathURL_QueryMessageList];
}

+ (NSString *)Portal_QueryMessageUnreadCountUrl
{
    return [NSString stringWithFormat:@"%@%@", portalBaseURL, pathURL_QueryMessageUnreadCount];
}

+ (NSString *)Portal_ClearSubtotalMileageUrl
{
    return [NSString stringWithFormat:@"%@%@", portalBaseURL, pathURL_ClearSubtotalMileage];
}

+ (NSString *)Portal_QueryTotalStatisticsUrl
{
    return [NSString stringWithFormat:@"%@%@", portalBaseURL, pathURL_QueryTotalStatistics];
}

+ (NSString *)Portal_QueryDayStatisticsUrl
{
    return [NSString stringWithFormat:@"%@%@", portalBaseURL, pathURL_QueryDayStatistics];
}

+ (NSString *)Portal_QueryMonthStatisticsUrl
{
    return [NSString stringWithFormat:@"%@%@", portalBaseURL, pathURL_QueryMonthStatistics];
}

+ (NSString *)Portal_QueryYearStatisticsUrl
{
    return [NSString stringWithFormat:@"%@%@", portalBaseURL, pathURL_QueryYearStatistics];
}

+ (NSString *)Portal_QueryBrandListUrl
{
    return [NSString stringWithFormat:@"%@%@", portalBaseURL, pathURL_QueryBrandList];
}

+ (NSString *)Portal_QuerySeriesModelTreeListUrl
{
    return [NSString stringWithFormat:@"%@%@", portalBaseURL, pathURL_QuerySeriesModelTreeList];
}

+ (NSString *)Portal_QueryDepartmentListUrl
{
    return [NSString stringWithFormat:@"%@%@", portalBaseURL, pathURL_QueryDepartmentList];
}

+ (NSString *)Portal_BrandImageUrl:(NSInteger)brandID
{
    return [NSString stringWithFormat:@"%@%@?entityID=%zd&conditionCode=%@", portalBaseURL, pathURL_BrandImage, brandID, [SRKeychain UUID]];
}

+ (NSString *)Portal_DepartmentLogoUrl:(NSString *)userName
{
    return [NSString stringWithFormat:@"%@%@?input1=%@", portalBaseURL, pathURL_DepartmentLogo, [userName RSAEncode]];
}

+ (NSString *)Portal_QueryEvaluateDetailUrl
{
    return [NSString stringWithFormat:@"%@%@", portalBaseURL, pathURL_QueryEvaluateDetail];
}

+ (NSString *)Portal_ModifyEvaluateDetailUrl
{
    return [NSString stringWithFormat:@"%@%@", portalBaseURL, pathURL_ModifyEvaluateDetail];
}

+ (NSString *)Portal_QueryHasUnreadIMUrl
{
    return [NSString stringWithFormat:@"%@%@", portalBaseURL, pathURL_QueryHasUnreadIM];
}

+ (NSString *)Portal_QueryIMUrl
{
    return [NSString stringWithFormat:@"%@%@", portalBaseURL, pathURL_QueryIM];
}

+ (NSString *)Portal_SendIMUrl
{
    return [NSString stringWithFormat:@"%@%@", portalBaseURL, pathURL_SendIM];
}

+ (NSString *)Portal_AddReservationUrl
{
    return [NSString stringWithFormat:@"%@%@", portalBaseURL, pathURL_AddReservation];
}

+ (NSString *)Portal_UpdateReservationUrl
{
    return [NSString stringWithFormat:@"%@%@", portalBaseURL, pathURL_UpdateReservation];
}

+ (NSString *)Portal_QueryReservationUrl
{
    return [NSString stringWithFormat:@"%@%@", portalBaseURL, pathURL_QueryReservation];
}

+ (NSString *)Portal_QueryRecordsUrl
{
    return [NSString stringWithFormat:@"%@%@", portalBaseURL, pathURL_QueryRecords];
}

+ (NSString *)Portal_SendAuthCodeToPhoneUrl
{
    return [NSString stringWithFormat:@"%@%@", portalBaseURL, pathURL_SendAuthCodeToPhone];
}

+ (NSString *)Portal_AuthCodeImageUrl:(NSString *)authCode
{
    return [NSString stringWithFormat:@"%@%@?authCode=%@&conditionCode=%@", portalBaseURL, pathURL_AuthCodeImage, authCode, [SRKeychain UUID]];
}

+ (NSString *)Portal_ModifyUserRecordUrl
{
    return [NSString stringWithFormat:@"%@%@", portalBaseURL, pathURL_ModifyUserRecord];
}

+ (NSString *)Portal_ModifyCarRecordUrl
{
    return [NSString stringWithFormat:@"%@%@", portalBaseURL, pathURL_ModifyCarRecord];
}

+ (NSString *)Portal_QueryTripUrl
{
    return [NSString stringWithFormat:@"%@%@", portalBaseURL, pathURL_QueryTrip];
}

+ (NSString *)Portal_QueryTripGPSPointsUrl
{
    return [NSString stringWithFormat:@"%@%@", portalBaseURL, pathURL_QueryTripGPSPoints];
}

+ (NSString *)Portal_DeleteTripUrl
{
    return [NSString stringWithFormat:@"%@%@", portalBaseURL, pathURL_DeleteTrip];
}

+ (NSString *)Portal_QueryDtcInfoUrl
{
    return [NSString stringWithFormat:@"%@%@", portalBaseURL, pathURL_QueryDtcInfo];
}

+ (NSString *)Portal_ModifyMessageSwitchUrl
{
    return [NSString stringWithFormat:@"%@%@", portalBaseURL, pathURL_ModifyMessageSwitch];
}

+ (NSString *)Portal_QueryMessageSwitchUrl
{
    return [NSString stringWithFormat:@"%@%@", portalBaseURL, pathURL_QueryMessageSwitch];
}

+ (NSString *)Portal_BindUrl
{
    return [NSString stringWithFormat:@"%@%@", portalBaseURL, pathURL_Bind];
}

+ (NSString *)Portal_UnbindUrl
{
    return [NSString stringWithFormat:@"%@%@", portalBaseURL, pathURL_Unbind];
}

+ (NSString *)Portal_HideTripUrl
{
    return [NSString stringWithFormat:@"%@%@", portalBaseURL, pathURL_HideTrip];
}

+ (NSString *)Portal_QueryModifyPermissionUrl
{
    return [NSString stringWithFormat:@"%@%@", portalBaseURL, pathURL_QueryModifyPermission];
}

+ (NSString *)Portal_QuerySMSCommandUrl
{
    return [NSString stringWithFormat:@"%@%@", portalBaseURL, pathURL_QuerySMSCommand];
}

+ (NSString *)Portal_ModifyObdCheckStatusUrl
{
    return [NSString stringWithFormat:@"%@%@", portalBaseURL, pathURL_ModifyObdCheckStatus];
}

//查询用户信息
+ (NSString *)Portal_QueryCustomerUrl
{
    return [NSString stringWithFormat:@"%@%@", portalBaseURL, pathURL_QueryCustomer];
}

//查询预约启动
+ (NSString *)Portal_QueryOrderStartUrl
{
    return [NSString stringWithFormat:@"%@%@", portalBaseURL, pathURL_QueryOrderStart];
}
//添加预约启动
+ (NSString *)Portal_AddOrderStartUrl
{
    return [NSString stringWithFormat:@"%@%@", portalBaseURL, pathURL_AddOrderStart];
}
//修改预约启动
+ (NSString *)Portal_UpdateOrderStartUrl
{
    return [NSString stringWithFormat:@"%@%@", portalBaseURL, pathURL_UpdateOrderStart];
}
//删除预约启动
+ (NSString *)Portal_DeleteOrderStartUrl
{
    return [NSString stringWithFormat:@"%@%@", portalBaseURL, pathURL_DeleteOrderStart];
}
//关闭预约启动新功能提示
+ (NSString *)Portal_CloseOrderStartRemindUrl
{
    return [NSString stringWithFormat:@"%@%@", portalBaseURL, pathURL_CloseOrderStartRemind];
}

//打开、关闭轨迹功能
+ (NSString *)Portal_OpenHiddenTrip
{
    return [NSString stringWithFormat:@"%@%@", portalBaseURL, pathURL_OpenHiddenTrip];
}

//实名认证
+ (NSString *)Portal_RealNameAuthentication
{
    return [NSString stringWithFormat:@"%@%@", portalBaseURL, pathURL_RealNameAuthentication];
}

//验证账号，无终端
+ (NSString *)Portal_PhoneVerifyWithoutTernimal
{
    return [NSString stringWithFormat:@"%@%@", portalBaseURL, pathURL_PhoneVerifyWithoutTernimal];
}

//验证账号，无终端，无验证码返回
+ (NSString *)Portal_PhoneVerifyWithoutTernimalNoAuthcode
{
    return [NSString stringWithFormat:@"%@%@", portalBaseURL, pathURL_PhoneVerifyWithoutTernimalNoAuthcode];
}

//验证账号，有终端
+ (NSString *)Portal_PhoneVerifyWithTernimal
{
    return [NSString stringWithFormat:@"%@%@", portalBaseURL, pathURL_PhoneVerifyWithTernimal];
}

//验证账号，有终端，无验证码返回
+ (NSString *)Portal_PhoneVerifyWithTernimalNoAuthcode
{
    return [NSString stringWithFormat:@"%@%@", portalBaseURL, pathURL_PhoneVerifyWithTernimalNoAuthcode];
}

//密码找回，验证短信验证码
+ (NSString *)Portal_PhoneVerifyWithAuthcode
{
    return [NSString stringWithFormat:@"%@%@", portalBaseURL, pathURL_PhoneVerifyWithAuthcode];
}

//账号申诉
+ (NSString *)Portal_AccountAppealSubmitUrl
{
    return [NSString stringWithFormat:@"%@%@", portalBaseURL, pathURL_AccountAppealSubmit];
}

//状态详情
+ (NSString *)Portal_StatusDetail
{
    return [NSString stringWithFormat:@"%@%@?vehicleID=%zd&input1=%@&input2=%@", portalBaseURL, pathURL_StatusDetail, [SRUserDefaults currentVehicleID], [SRKeychain UserName].RSAEncode.urlEncode, [SRKeychain Password].RSAEncode.urlEncode];
}

//常见问题（F&Q）
+ (NSString *)Portal_FAQUrl
{
    return [NSString stringWithFormat:@"%@%@", portalBaseURL, pathURL_FAQ];
}

#pragma mark - 预约保养
//查询下次保养项目
+ (NSString *)Portal_MaintainQueryReserveUrl
{
    return [NSString stringWithFormat:@"%@%@", portalBaseURL, pathURL_MaintainQueryReserve];
}

//查询4S店列表
+ (NSString *)Portal_MaintainQueryDepUrl
{
    return [NSString stringWithFormat:@"%@%@", portalBaseURL, pathURL_MaintainQueryDep];
}

//提交预约记录
+ (NSString *)Portal_MaintainAddReserveUrl
{
    return [NSString stringWithFormat:@"%@%@", portalBaseURL, pathURL_MaintainAddReserve];
}

//新增历史记录
+ (NSString *)Portal_MaintainAddHistoryUrl
{
    return [NSString stringWithFormat:@"%@%@", portalBaseURL, pathURL_MaintainAddHistory];
}

//删除历史记录
+ (NSString *)Portal_MaintainDeleteHistoryUrl
{
    return [NSString stringWithFormat:@"%@%@", portalBaseURL, pathURL_MaintainDeleteHistory];
}

//查询历史记录
+ (NSString *)Portal_MaintainQueryHistoryUrl
{
    return [NSString stringWithFormat:@"%@%@", portalBaseURL, pathURL_MaintainQueryHistory];
}

//修改历史记录
+ (NSString *)Portal_MaintainUpdateHistoryUrl
{
    return [NSString stringWithFormat:@"%@%@", portalBaseURL, pathURL_MaintainUpdateHistory];
}

//修改当前里程
+ (NSString *)Portal_UpdateCurrentMileageUrl
{
    return [NSString stringWithFormat:@"%@%@", portalBaseURL, pathURL_UpdateCurrentMileage];
}

//修改下次保养里程
+ (NSString *)Portal_UpdateNextMaintainMileageUrl
{
    return [NSString stringWithFormat:@"%@%@", portalBaseURL, pathURL_UpdateNextMaintainMileage];
}

#pragma mark - 蓝牙

//更新蓝牙MAC地址
+ (NSString *)Portal_UpdateBtInfo
{
    return [NSString stringWithFormat:@"%@%@", portalBaseURL, pathURL_UpdateBtInfo];
}

//查询终端升级信息
+ (NSString *)Portal_QueryTerminalUpdateInfo
{
    return [NSString stringWithFormat:@"%@%@", portalBaseURL, pathURL_QueryTerminalUpdateInfo];
}

//更新终端密钥同步状态
+ (NSString *)Portal_UpdateBtSyncStatus
{
    return [NSString stringWithFormat:@"%@%@", portalBaseURL, pathURL_UpdateBtSyncStatus];
}

//提交设备信息
+ (NSString *)Portal_UpdateDeviceInfo
{
    return [NSString stringWithFormat:@"%@%@", portalBaseURL, pathURL_UpdateDeviceInfo];
}

//更换或加装设备
+ (NSString *)Portal_ChangeOrAddDevice
{
    return [NSString stringWithFormat:@"%@%@", portalBaseURL, pathURL_ChangeOrAddDevice];
}

#pragma mark - 续费提现
+ (NSString *)Portal_AccountQuery
{
    return [NSString stringWithFormat:@"%@%@", portalBaseURL, pathURL_AccountQuery];
}

//签到
+ (NSString *)Portal_SiginDaily
{
    return [NSString stringWithFormat:@"%@%@", portalBaseURL, pathURL_SignDaily];
}

//积分列表
+ (NSString *)Portal_PointQuery
{
    return [NSString stringWithFormat:@"%@%@", portalBaseURL, pathURL_PointQuery];
}

@end

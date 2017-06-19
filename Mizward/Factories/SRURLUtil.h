//
//  SRURLUtil.h
//  SiRuiV4.0
//
//  Created by zhangjunbo on 15/6/15.
//  Copyright (c) 2015年 SiRui. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString * const defaultsSLBBaseURL_IP;
extern NSString * const defaultsSLBBaseURL_DNS;
extern NSString * const defaultsPortalBaseURL;
extern NSString * const defaultsPhoneAppBaseURL;
extern NSString * const defaultsOnlineBaseURL;
extern NSString * const defaultsTcpHost;
extern const NSInteger  defaultsTcpPort;

@interface SRURLUtil : NSObject

+ (void)saveBaseUrl;
+ (void)resetURLs;
+ (void)restTestURLs;

#pragma mark - setter
+ (void)setBaseURL_Online:(NSString *)url;
+ (void)setBaseURL_Portal:(NSString *)url;
+ (void)setBaseURL_PhoneApp:(NSString *)url;
+ (void)setTcpHost:(NSString *)host;
+ (void)setTcpPort:(NSInteger)port;
+ (void)setBaseURL_Slb_IP:(NSString *)url;
+ (void)setBaseURL_Slb_DNS:(NSString *)url;

#pragma mark - getter
+ (NSString *)BaseURL_Online;
+ (NSString *)BaseURL_Portal;
+ (NSString *)BaseURL_PhoneApp;
+ (NSString *)TcpHost;
+ (NSInteger) TcpPort;
+ (NSString *)BaseURL_Slb_IP;
+ (NSString *)BaseURL_Slb_DNS;

#pragma mark - version

+ (NSString *)appVersionCheck;

#pragma mark - appStore

+ (NSString *)appStore;

#pragma mark - SLB
+ (NSString *)SLB_DNSUrl;
+ (NSString *)SLB_IPUrl;

#pragma mark - PhoneApp
//控制
+ (NSString *)PhoneApp_ControlUrl;

#pragma mark - Portal
//注册
+ (NSString *)Portal_RegistUrl;
//绑定终端
+ (NSString *)Portal_BindTerminal;
//验证IMEI
+ (NSString *)Portal_ValidateIMEI;
//重置密码
+ (NSString *)Portal_ResetPasswordUrl;
//登陆
+ (NSString *)Portal_LoginUrl;
//游客登陆
+ (NSString *)Portal_ExhibitionLoginUrl;
//更新APP状态
+ (NSString *)Portal_UpdateAppStatusUrl;
//注销
+ (NSString *)Portal_LogoutUrl;
//发送验证码给用户
+ (NSString *)Portal_SendAuthCodeToUserUrl;
//查询车辆基本信息
+ (NSString *)Portal_QueryCarBasicInfoUrl;
//查询车辆状态信息
+ (NSString *)Portal_QueryCarStatusInfoUrl;
//查询车消息列表
+ (NSString *)Portal_QueryMessageListUrl;
//查询未读消息条数
+ (NSString *)Portal_QueryMessageUnreadCountUrl;
//修改消息开关
+ (NSString *)Portal_ModifyMessageSwitchUrl;
//查询消息开关
+ (NSString *)Portal_QueryMessageSwitchUrl;
//查询品牌列表
+ (NSString *)Portal_QueryBrandListUrl;
//查询车系车型列表
+ (NSString *)Portal_QuerySeriesModelTreeListUrl;
//查询部门列表
+ (NSString *)Portal_QueryDepartmentListUrl;
//获取品牌图片
+ (NSString *)Portal_BrandImageUrl:(NSInteger)brandID;
//查询是否有未读消息
+ (NSString *)Portal_QueryHasUnreadIMUrl;
//查询IM聊天记录
+ (NSString *)Portal_QueryIMUrl;
//发送IM信息
+ (NSString *)Portal_SendIMUrl;
//查询车辆档案
+ (NSString *)Portal_QueryRecordsUrl;
//发送验证码到手机
+ (NSString *)Portal_SendAuthCodeToPhoneUrl;
//获取验证码图片
+ (NSString *)Portal_AuthCodeImageUrl:(NSString *)authCode;
//修改用户信息
+ (NSString *)Portal_ModifyUserRecordUrl;
//修改车辆信息
+ (NSString *)Portal_ModifyCarRecordUrl;
//查询轨迹列表
+ (NSString *)Portal_QueryTripUrl;
//查询轨迹点
+ (NSString *)Portal_QueryTripGPSPointsUrl;
//删除轨迹
+ (NSString *)Portal_DeleteTripUrl;
//OBD错误码
+ (NSString *)Portal_QueryDtcInfoUrl;
//查询用户权限
+ (NSString *)Portal_QueryModifyPermissionUrl;
//查询短信控制指令
+ (NSString *)Portal_QuerySMSCommandUrl;
//绑定
+ (NSString *)Portal_BindUrl;
//解绑
+ (NSString *)Portal_UnbindUrl;
//隐藏行踪
+ (NSString *)Portal_HideTripUrl;
//设置OBD开关
+ (NSString *)Portal_ModifyObdCheckStatusUrl;
//查询用户信息
+ (NSString *)Portal_QueryCustomerUrl;

//查询预约启动
+ (NSString *)Portal_QueryOrderStartUrl;
//添加预约启动
+ (NSString *)Portal_AddOrderStartUrl;
//修改预约启动
+ (NSString *)Portal_UpdateOrderStartUrl;
//删除预约启动
+ (NSString *)Portal_DeleteOrderStartUrl;
//关闭预约启动新功能提示
+ (NSString *)Portal_CloseOrderStartRemindUrl;

//打开、关闭轨迹功能
+ (NSString *)Portal_OpenHiddenTrip;
//实名认证
+ (NSString *)Portal_RealNameAuthentication;

//验证账号，无终端
+ (NSString *)Portal_PhoneVerifyWithoutTernimal;
//验证账号，无终端，无验证码返回
+ (NSString *)Portal_PhoneVerifyWithoutTernimalNoAuthcode;
//验证账号，有终端
+ (NSString *)Portal_PhoneVerifyWithTernimal;
//验证账号，有终端，无验证码返回
+ (NSString *)Portal_PhoneVerifyWithTernimalNoAuthcode;
//密码找回，验证短信验证码
+ (NSString *)Portal_PhoneVerifyWithAuthcode;

//账号申诉
+ (NSString *)Portal_AccountAppealSubmitUrl;

//状态详情
+ (NSString *)Portal_StatusDetail;
//常见问题（F&Q）
+ (NSString *)Portal_FAQUrl;

#pragma mark - 预约保养
//查询下次保养项目
+ (NSString *)Portal_MaintainQueryReserveUrl;
//查询4S店列表
+ (NSString *)Portal_MaintainQueryDepUrl;
//提交预约记录
+ (NSString *)Portal_MaintainAddReserveUrl;
//新增历史记录
+ (NSString *)Portal_MaintainAddHistoryUrl;
//删除历史记录
+ (NSString *)Portal_MaintainDeleteHistoryUrl;
//查询历史记录
+ (NSString *)Portal_MaintainQueryHistoryUrl;
//修改历史记录
+ (NSString *)Portal_MaintainUpdateHistoryUrl;

//修改当前里程
+ (NSString *)Portal_UpdateCurrentMileageUrl;
//修改下次保养里程
+ (NSString *)Portal_UpdateNextMaintainMileageUrl;

#pragma mark - 蓝牙

//更新蓝牙信息
+ (NSString *)Portal_UpdateBtInfo;
//查询终端升级信息
+ (NSString *)Portal_QueryTerminalUpdateInfo;
//更新终端密钥同步状态
+ (NSString *)Portal_UpdateBtSyncStatus;
//提交设备信息
+ (NSString *)Portal_UpdateDeviceInfo;
//更换或加装设备
+ (NSString *)Portal_ChangeOrAddDevice;

#pragma mark - 续费提现
+ (NSString *)Portal_AccountQuery;

//签到
+ (NSString *)Portal_SiginDaily;

//积分列表
+ (NSString *)Portal_PointQuery;

@end

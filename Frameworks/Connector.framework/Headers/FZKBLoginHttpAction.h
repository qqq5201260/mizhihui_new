
//
//  FZKBLoginHttpAction.h
//
//
//  Created by mac on date.
//  Copyright © 2017年 chinapke. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FZKHttpWork.h"

@interface FZKBLoginHttpAction : FZKHttpWork
    
/**
 方法描述：
 登录服务器
 
 传入参数
input1:用户名称 （需要加密，详情见代码）
input2:用户密码

返回参数
ageFlag;//TODO不知道是什么
app;//app名称
brandID;//品牌ID
createTime;//TODO多余的属性
createUserID;//TODO多余的属性
customerBinded;//用户是否绑定
customerEmail;//用户邮件
customerID;//用户ID
customerIDNumberType;//用户ID类型
customerManagerID;//用户管理ID
customerPhone;//用户电话
customerSex;//性别1：男2：女
customerSexStr;//用户性别
customerType;//用户类型
customerUserName;//用户名字
depID;//部门ID
depName;//部门名称
entityID;//品牌ID（车辆品牌）
exhibtionID;//todo展车ID
isChild;//TODO多余的属性
isContainsChild;//TODO多余的属性
isFrozen;//TODO是否被冻结对app没用
isSecond;//todo多余的属性
isSelf;//todo多余的属性
isTop;//todo多余的属性
isTopSystem;//todo多余的属性
levelCode;//部门层级ID
name;//权限名称
openHiddenTrip;//TODO多余的属性
phoneID;//手机识别码（UUID）
phoneType;//终端类型1:Iphone2:Android3:浏览器端用户登录
querySub;//TODO多余的属性
realNameAuthentication;//TODO是否已经实名认证多余的属性
secondLevelCode;//TODO多余的属性
temporary;//TODO多余的属性
topLevelCode;//TODO多余的属性
topOrParentLevel;//TODO多余的属性
updateTime;//TODO多余的属性
updateUserID;//TODO多余的属性
vehicleModelID;//车型ID
List<Car>cars;//车辆集合

address;//地址
assistPhone;//救援电话
audierfaceSwitch;//TODOAudi界面开关(0没有设置1开2关)多余的属性
brandID;//经营品牌ID
createTime;//TODO多余的属性
createUserID;//TODO多余的属性
depID;//部门ID


DepPartAttrdepPartAttr;//TODO
DepPartAttrfDepPartAttr;//TODO父级-分离出来的属性多余的属性

depType;//部门类型
entityID;//品牌ID
extendLevelCode;//TODO权限继承多余的属性
extendOrderFlag;//TODO辅助字段，默认为0，不继承上级部门，页面选择了则为1多余的属性
extendOrderOpen;//TODO工单规则继承多余的属性
extendOrderRule;//TODO工单规则继承多余的属性


fExtendLevelCode;//TODO多余的属性
fExtendOrderOpen;//TODO多余的属性
fExtendOrderRule;//TODO多余的属性
fHas4sOnline;//TODO多余的属性
fHasOrderOpen;//TODO多余的属性
fLevelcode;//TODO多余的属性
gwstock;//TODO多余的属性
has4sOnline;//TODO多余的属性
hasOrderOpen;//TODO多余的属性
imgMathParam;//TODO多余的属性
isChild;//TODO多余的属性
isContainsChild;//TODO多余的属性
isCooperateMaen;//TODO多余的属性
isSecond;//TODO多余的属性
isSelf;//TODO多余的属性
isTop;//TODO多余的属性
isTopSystem;//TODO多余的属性
lat;//纬度
levelCode;//部门层级
lng;//精度
name;//TODO部门名字？是的
notifyDangerPhone;//报险电话
otustock;//TODO多余的属性

querySub;//TODO多余的属性
regionalismCode;//TODO所属行政区编码暂时无用多余的属性
secondLevelCode;//TODO多余的属性
serverPhone;//服务电话
siruiOnlineName;//4S在线广告语
storeOtuStock;//TODO多余的属性
storeWgStock;//TODO多余的属性
topLevelCode;//TODO多余的属性
topOrParentLevel;//TODO多余的属性
updateTime;//TODO多余的属性
updateUserID;////TODO多余的属性
userID;//用户id
view4SOnline;//TODO多余的属性
viewOrder;//TODO多余的属性

annualFee;//TODO
depID;//部门ID
isDirectSale;//TODO
isInstallationShop;//TODO
levelCode;//部门层级
parentDirectSaleDepID;//TODO

balance;//终端余额
barcode;//终端主机编码
brandID;//品牌ID
brandName;//品牌名称
confirmMaxAlarmID;//TODO多余的属性
createTime;//创建时间
createUserID;//创建用户ID
customerBinded;//用户是否已经绑定
customerBindedBy;//TODO不知道是什么认为对app是没用的
customerEmail;//用户邮箱
customerID;//用户ID
customerName;//用户名
customerPhone;//用户电话
customerSex;//性别1：男2：女
customerSex;//用户性别
customerUserName;//用户名字
depID;//部门ID
entityID;//品牌ID（车辆品牌）
from;//TODO不知道具体表示什么认为对app是无用的
giftMaenanceTimes;//TODO赠送的保养次数无用
groupID;//TODO分组ID无用
importExcelFlag;//TODO导出excel无用
isChild;//TODO无用
isContainsChild;//TODO无用
isOnline;//是否在线0:无效1:在线2:离线
isSecond;//TODO无用
isSelf;//TODO无用
isTop;//TODO无用
isTopSystem;//TODO无用
lastMessageTime;//TODO无用
levelCode;//部门层级ID
maenCount;//TODO保养次数无用
maenOrderCount;//TODO无用
mileAge;//里程KM
needMaen;//是否需要维修
nextBigMaenMileage;//下次最大保养里程
nextMaenMileage;//下次保养里程
oilSize;//邮箱容量(L)，负数表示无效
plateNumber;//车牌号
preMaenMileage;//上次保养里程
querySub;//TODO无用
renewServiceEndTime;//TODO续费服务到期时间无用
renewServiceStartTime;//TODO续费服务开始时间无用
search_star;//TODO无用
secondLevelCode;//TODO无用
serialNumber;//终端序列号
seriesID;//终端ID
serviceEndTime;//服务结束时间
star;//TODO
terminalID;//设备ID（终端ID）
terminal_status;//设备状态
toCustomerFenceRedius;//TODO无用
topLevelCode;//TODO无用
topOrParentLevel;//TODO无用
updateTime;//TODO无用
updateUserID;//TODO无用
vehicleID;//车辆ID
vehicleModelID;//车型ID
vehicleModelName;//车型名

preMaenMileage;//上次保养里程
controlSms;//通过sms控制
renewServiceStartTime;//TODO续费服务开始时间无用
customized;//车辆标志audi：奥迪null：普通
fenceCentralLng;//围栏中心点维度
tripHidden;//当前车辆是否隐藏轨迹0表示隐藏，1表示不隐藏
saleDate;//购车时间
goHomeTime;//回家时间
List<Abilities>abilities;
customerPhone;//用户电话
balance;//终端余额
brandID;//终端ID
saleDateStr;//购买车时间
insuranceSaleDate;//保险购买时间
isInFence;//是否在围栏内2表示不在围栏内，其他表示在围栏内
msisdn;//终端SIM卡号
barcode;//主机编码
brandName;//主机名字（设备）
product;//产品类型空表示思锐，yj表示云警
maxStartTimeLength;//TODO预约启动时长有用的
serialNumber;//终端IMEI
vehicleModelID;//车辆类型ID
List<Abilities_v2>abilities_v2;
nextMaenMileage;////下次保养里程
terminalID;//终端ID
plateNumber;//车牌号
vehicleModelName;//车辆类型名称
workTime;//TODO
customerName;//用户名字
renewServiceEndTime;//TODO续费服务到期时间无用
openObd;//OBD检测状态1：开启2：关闭
BlueToothbluetooth;//蓝牙信息
insuranceSaleDateStr;//TODO保单购买时间无用
insuranceSaleDateStrStr;//TODO无用
customerID;//用户ID
vehicleID;//车辆ID
controlBt;//TODO
fenceCentralLat;//围栏中心点经度
fenceRadius;//围栏半径

door;//主门开关状态0:无效1:开2:关
windowSky;//天窗0：未知1：开启2：关闭
startNumber;//GPS卫星数量
busyStatus;//设备忙闲状态0:闲置其它:忙
fenceCentralLng;//围栏中心点纬度
hasNotConfirmAlarm;////是否有未确认告警1表示有，2表示没有
defence;//防盗状态0:无效1:设防2:撤防
tirePressure;//胎压(KP)
isOnline;//是否在线1表示在线，其他表示不在线
speed;//速度
doorLB;//左后门0：未知1：开启2：关闭
sleepStatus;//TODOgps供电状态，应该有用，保留先
oil;//TODO剩余油量现在好像app没有这个功能，保留先
lightBig;//大灯0：未知1：开启2：关闭
doorRF;//右前门0：未知1：开启2：关闭
engineStatus;//引擎状态0:无效1:开2:关
gpsStatus;//GPS信号状态0:无效1:连通2:断开
doorLF;//左前门0：未知1：开启2：关闭
isInFence;//是否在围栏内2表示不在围栏内，其他表示在围栏内
lat;//经度
direction;//消息类型请求1请求应答2推送3推送应答4广播5广播应答6
windowRF;//右前窗0：未知1：开启2：关闭
ACC;//TODO可能有用，很久以前用来在主界面展示状态的(应该是跟启动有关)，现在不知道app用来干什么了
temp;//当前温度-274为无效
windowLB;//左后窗0：未知1：开启2：关闭
doorLock;//主门锁状态0:无效1:上锁2:未上锁
lng;//纬度
windowRB;//右后窗0：未知1：开启2：关闭
signalStrength;//信号强度
doorRB;//右后门0：未知1：开启2：关闭
electricity;//电瓶电量(伏)
oilSize;//邮箱容量(L)，负数表示无效
gpsTime;//GPS时间
trunkDoorLock;//附门锁状态0:无效1:上锁2:未上锁
windowLF;//左前窗0：未知1：开启2：关闭
oilLeft;//剩余油量(L)，负数表示无效
electricityStatus;//电瓶连通状态0:未检测1:正常2:亏电
lightSmall;//小灯0：未知1：开启2：关闭
tempStatus;//温度状态0:无效1:连通2:断开
trunkDoor;//后备箱0：未知1：开启2：关闭
fenceCentralLat;//围栏中心经度
fenceRadius;//围栏半径
mileAge;//里程KM
oilStatus;//油路连通状态0:无效1:连通2:断开

bindingStatus;//账户绑定状态0：未绑定1：已绑定，且当前用户为绑定用户

customerType;//账户类型0：正常用户2：体验用户
token;////APP登陆token，供4S在线接口使用
exhibitionExperienceTime;//体验用户使用时长
needChangeUserName;//是否需要修改用户名true：是false：否
customerID;//用户ID
controlSeries;//控制流水号

bluetoothID;//蓝牙ID
uuid;//蓝牙UUID
key;//钥匙
mac;//mac地址





 */
- (void)loginActionWithInput1:(NSString *)input1 input2:(NSString *)input2;

@end
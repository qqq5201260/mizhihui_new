
//
//  FZKBVehicleStatusHttpAction.h
//
//
//  Created by mac on date.
//  Copyright © 2017年 chinapke. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FZKHttpWork.h"

@interface FZKBVehicleStatusHttpAction : FZKHttpWork
    
/**
 方法描述：
 车辆状态信息
 
 传入参数：
vehicleID：车辆ID

返回参数

ACC:可能有用，很久以前用来在主界面展示状态的(应该是跟启动有关)，现在不知道app用来干什么了
busyStatus:0,设备忙闲状态 0:闲置 其它:忙
defence:防盗状态  0:无效 1:设防 2:撤防
direction:消息类型 请求1 请求应答2 推送3 推送应答4 广播5 广播应答
door: 主门开关状态    0:无效 1:开 2:关
doorLB: 左后门 0：未知 1：开启
doorLF: 左前门 0：未知 1：开启   2：关闭
doorLock: 主门锁状态 0:无效 1:上锁 2:未上锁
doorRB: 右后门 0：未知 1：开启   2：关闭
doorRF: 右前门 0：未知 1：开启   2：关闭
electricity: 电瓶电量(伏)
electricityStatus: 电瓶连通状态    0:未检测 1:正常 2:亏电
engineStatus: 引擎状态  0:无效 1:开 2:关
fenceCentralLat: 围栏中心经度
fenceCentralLng: 围栏中心点维度
fenceRadius: 围栏半径
gpsStatus: GPS信号状态   0:无效 1:连通 2:断开
gpsTime: GPS时间
hasNotConfirmAlarm: 是否有未确认告警 1表示有，2表示没有
isInFence: 是否在围栏内 2表示不在围栏内，其他表示在围栏内
isOnline: 是否在线 0:无效 1:在线 2:离线
lat: 经度
lightBig: 大灯 0：未知 1：开启   2：关闭
lightSmall: 小灯 0：未知 1：开启   2：关闭
lng: 纬度
mileAge: 里程 KM
oil:  剩余油量 现在好像app没有这个功能，保留先
oilLeft: 剩余油量(L)， 负数表示无效
oilSize: 邮箱容量(L)， 负数表示无效
oilStatus: 油路连通状态    0:无效 1:连通 2:断开
signalStrength: //信号强度
sleepStatus: gps供电状态，应该有用，保留先
speed: 速度
startNumber: GPS卫星数量
temp: 当前温度 -274为无效
tempStatus: 温度状态 0:无效 1:连通 2:断开
tirePressure: 胎压(KP)
trunkDoor: 后备箱 0：未知 1：开启   2：关闭
trunkDoorLock: 附门锁状态 0:无效 1:上锁 2:未上锁
windowLB: 左后窗 0：未知 1：开启   2：关闭
windowLF: 左前窗0：未知 1：开启   2：关闭
windowRB: 右后窗 0：未知 1：开启   2：关闭
windowRF: 右前窗 0：未知 1：开启   2：关闭
windowSky: 天窗 0：未知 1：开启   2：关闭

 */
- (void)vehicleStatusActionWithVehicleID:(NSString *)vehicleID;

@end
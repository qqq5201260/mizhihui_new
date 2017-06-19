
//
//  FZKBqueryCarInfoHttpAction.h
//
//
//  Created by mac on date.
//  Copyright © 2017年 chinapke. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FZKHttpWork.h"

@interface FZKBqueryCarInfoHttpAction : FZKHttpWork
    
/**
 方法描述：
 查询车辆信息
 
 传入参数：
input1：用户名（加密）
input2：密码（加密）
vehicleID：车辆id
返回参数：
 balance :终端余额
 barcode :终端主机编码
 brandID :品牌ID
 brandName :品牌名称
 controlBt : 0表示没有 
 controlSms : 通过sms控制 0表示没有
 customerID : 用户ID
 customerName :用户名
 customerPhone :用户手机号  
 customized :车辆标志audi：奥迪null：普通
 fenceCentralLat :  围栏中心点经度
 fenceCentralLng : 围栏中心点纬度
 fenceRadius : 围栏半径 
 goHomeTime :  回家时间
 gotBalance : 是否已经有了余额
 gotoV3 : 是否需要连接到新的网关平台
 has4SModule : 没用到 
 hasControlModule : 是否有控制权限（功能）
 hasOBDModule :是否有诊断功能
 insuranceSaleDate : 保险购买时间  
 insuranceSaleDateStr :保单购买时间无用
 insuranceSaleDateStrStr :没用 
 isInFence : 是否在围栏内2表示不在围栏内，其他表示在围栏内
 isPreciseFuelCons : 没用到
 maxStartTimeLength :预约启动时长有用的
 nextMaintenMileage : 下次维修里程
 openObd :OBD检测状态1：开启2：关闭
 plateNumber : 车牌号 
 preMaintenMileage : 上次维修里程 
 product : 产品类型空表示思锐，yj表示云警
 renewServiceEndTime :续费服务到期时间无用 
 renewServiceStartTime :续费服务开始时间无用
 saleDate : 购车时间
 saleDateStr :购买车时间
 serialNumber :终端IMEI
 terminalID :终端ID
 tripHidden :当前车辆是否隐藏轨迹0表示隐藏，1表示不隐藏
 vehicleID : 车辆id 
 vehicleModelID : 车辆类型ID
 vehicleModelName : 车辆类型名称  
 whetherExpire : 是否到期 
 workTime : 无用
 */
- (void)queryCarInfoActionWithInput1:(NSString *)input1 input2:(NSString *)input2 vehicleID:(NSString *)vehicleID;

@end
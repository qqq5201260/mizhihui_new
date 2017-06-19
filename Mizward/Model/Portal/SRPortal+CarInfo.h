//
//  SRPortal+CarInfo.h
//  SiRuiV4.0
//
//  Created by zhangjunbo on 15/6/25.
//  Copyright (c) 2015年 SiRui. All rights reserved.
//

#import "SRPortal.h"

@class SRPortalRequestQueryCarStatusInfo, SRPortalRequestQueryCarBasicInfo, SRPortalRequestModifyCarRecord, SRPortalRequestTripHidden, SRPortalRequestUpdateObdStatus, SRPortalRequestDtcInfo, SRPortalRequestUpdateCurrentMileage, SRPortalRequestUpdateNextMaintainMileage;

@interface SRPortal (CarInfo)

//获取车辆基本信息
+ (void)queryVehicleBasicInfoWithRequest:(SRPortalRequestQueryCarBasicInfo *)request andCompleteBlock:(CompleteBlock)completeBlock;

//获取车辆状态信息
+ (void)queryVehicleStatusInfoWithRequest:(SRPortalRequestQueryCarStatusInfo *)request andCompleteBlock:(CompleteBlock)completeBlock;

//修改车辆基本信息
+ (void)modifyCarRecordWthRequest:(SRPortalRequestModifyCarRecord *)request andCompleteBlock:(CompleteBlock)completeBlock;

//查询SMS控制命令
+ (void)querySMSCommandsWithCompleteBlock:(CompleteBlock)completeBlock;

//隐藏行踪
+ (void)hiddenTripWithRequest:(SRPortalRequestTripHidden *)request andCompleteBlock:(CompleteBlock)completeBlock;

//OBD诊断
+ (void)updateOBDStatusWithRequest:(SRPortalRequestUpdateObdStatus *)request andCompleteBlock:(CompleteBlock)completeBlock;

//OBD检测
+ (void)queryDtcInfosWithRequest:(SRPortalRequestDtcInfo *)request andCompleteBlock:(CompleteBlock)completeBlock;

//修改当前里程
+ (void)updateCurrentMileageWithRequest:(SRPortalRequestUpdateCurrentMileage *)request andCompleteBlock:(CompleteBlock)completeBlock;

//修改下次保养里程
+ (void)updateNextMaintainMileageWithRequest:(SRPortalRequestUpdateNextMaintainMileage *)request andCompleteBlock:(CompleteBlock)completeBlock;
@end

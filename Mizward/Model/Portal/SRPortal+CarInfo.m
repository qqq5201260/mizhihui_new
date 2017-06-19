//
//  SRPortal+CarInfo.m
//  SiRuiV4.0
//
//  Created by zhangjunbo on 15/6/25.
//  Copyright (c) 2015年 SiRui. All rights reserved.
//

#import "SRPortal+CarInfo.h"
#import "SRPortalRequest.h"
#import "SRPortalResponse.h"
#import "SRVehicleBasicInfo.h"
#import "SRVehicleStatusInfo.h"
#import "SRHttpUtil.h"
#import "SRURLUtil.h"
#import "SRDataBase+Vehicle.h"
#import "SRUserDefaults.h"
#import "SREventCenter.h"
#import "SRSMSCommandVos.h"
#import "SRDtcInfo.h"
#import "SRMaintainReserveInfo.h"
#import "SRDataBase+MaintainReserve.h"
#import <MJExtension/MJExtension.h>

@implementation SRPortal (CarInfo)

//获取车辆基本信息
+ (void)queryVehicleBasicInfoWithRequest:(SRPortalRequestQueryCarBasicInfo *)request andCompleteBlock:(CompleteBlock)completeBlock
{
    [SRHttpUtil POST :[SRURLUtil Portal_QueryCarBasicInfoUrl] WithParameter:request.parameter completeBlock:^(NSError *error, id responseObject) {
        
        if (error) {
            if (completeBlock) completeBlock(error, responseObject);
            return ;
        }
        
        SRPortalResponse *response = [SRPortalResponse objectWithKeyValues:responseObject];
        if (response.result.resultCode != SRHTTP_Success) {
            error = [NSError errorWithDomain:response.result.resultMessage
                                        code:response.result.resultCode
                                    userInfo:response.result.fieldErrors];
            if (completeBlock) completeBlock(error, nil);
            return;
        }
        
        @weakify(self)
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            @strongify(self)
            
            NSMutableDictionary *newVehicleDic = [NSMutableDictionary dictionary];
            
            NSArray *basicInfos = [SRVehicleBasicInfo objectArrayWithKeyValuesArray:response.entity];
            
            [basicInfos enumerateObjectsUsingBlock:^(SRVehicleBasicInfo *basicInfo, NSUInteger idx, BOOL *stop) {
                SRVehicleBasicInfo *localInfo = [[self sharedInterface] vehicleBasicInfoWithVehicleID:basicInfo.vehicleID];
                if (localInfo) {
                    basicInfo.smsCommands = localInfo.smsCommands;
                    basicInfo.status = localInfo.status;
                    basicInfo.orderStartList = localInfo.orderStartList;
                }
                
                [SRUserDefaults updateCustomerID:basicInfo.customerID];
                
                SRLogDebug(@"%@", basicInfo.keyValues);
                [newVehicleDic setObject:basicInfo forKey:@(basicInfo.vehicleID)];
            }];
//            @weakify(self)
//            dispatch_apply(basicInfos.count, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(size_t index) {
//                @strongify(self)
//                
//                SRVehicleBasicInfo *basicInfo = basicInfos[index];
//                SRVehicleBasicInfo *localInfo = [[self sharedInterface] vehicleBasicInfoWithVehicleID:basicInfo.vehicleID];
//                if (localInfo) {
//                    basicInfo.smsCommands = localInfo.smsCommands;
//                    basicInfo.status = localInfo.status;
//                    basicInfo.orderStartList = localInfo.orderStartList;
//                }
//                
//                [SRUserDefaults updateCustomerID:basicInfo.customerID];
//
//                SRLogDebug(@"%@", basicInfo.keyValues);
//                [newVehicleDic setObject:basicInfo forKey:@(basicInfo.vehicleID)];
//            });
            
            if (request.parameter[@"vehicleID"]) {
                //请求的是单台车辆
                SRVehicleBasicInfo *info = newVehicleDic.allValues.firstObject;
                [[self sharedInterface].vehicleDic setObject:info forKey:@(info.vehicleID)];
            } else {
                //请求的是全部车辆
                [self sharedInterface].vehicleDic = newVehicleDic;
            }
            
            
            //如果本地没有缓存当前车辆ID，将第一个车默认作为当前车辆
            if (![[self sharedInterface].vehicleDic objectForKey:@([SRUserDefaults currentVehicleID])]) {
                SRVehicleBasicInfo *info = [self sharedInterface].allVehicles.firstObject;
                [SRUserDefaults updateCurrentVehicleID:info.vehicleID];
            }
            
            //更新本地数据
            if (!request.parameter[@"vehicleID"]) {
                //如果是获取的全部车辆，先删除本地数据，再重新添加
                [[SRDataBase sharedInterface] deleteAllVehicleWithCompleteBlock:^(NSError *error, id responseObject) {
                    [[SREventCenter sharedInterface] vehicleListChange:[self sharedInterface].allVehicles];
                }];
            } else {
                [[SREventCenter sharedInterface] vehicleListChange:[self sharedInterface].allVehicles];
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                @strongify(self)
                if (completeBlock) completeBlock(error, [self sharedInterface].vehicleDic);
            });
        });
    }];
}

//获取车辆状态信息
+ (void)queryVehicleStatusInfoWithRequest:(SRPortalRequestQueryCarStatusInfo *)request andCompleteBlock:(CompleteBlock)completeBlock
{
    [SRHttpUtil POST :[SRURLUtil Portal_QueryCarStatusInfoUrl] WithParameter:request.keyValues completeBlock:^(NSError *error, id responseObject) {
        
        if (error) {
            if (completeBlock) completeBlock(error, responseObject);
            return ;
        }
        
        SRPortalResponse *response = [SRPortalResponse objectWithKeyValues:responseObject];
        if (response.result.resultCode != SRHTTP_Success) {
            error = [NSError errorWithDomain:response.result.resultMessage
                                        code:response.result.resultCode
                                    userInfo:response.result.fieldErrors];
            if (completeBlock) completeBlock(error, nil);
            return;
        }
        
        @weakify(self)
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            @strongify(self)
            
            SRVehicleStatusInfo *statusInfo = [SRVehicleStatusInfo objectWithKeyValues:response.entity];
            SRVehicleBasicInfo *localInfo = [[self sharedInterface] vehicleBasicInfoWithVehicleID:request.vehicleID];
            if (localInfo) {
                localInfo.status = statusInfo;
                [[SRDataBase sharedInterface] updateVehicleList:@[localInfo] withCompleteBlock:nil];
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                if (request.vehicleID == [SRUserDefaults currentVehicleID]) {
                    [[SREventCenter sharedInterface] currentVehicleChange:localInfo];
                }
                if (completeBlock) completeBlock(error, localInfo);
            });
        });
    }];
}

//修改车辆基本信息
+ (void)modifyCarRecordWthRequest:(SRPortalRequestModifyCarRecord *)request andCompleteBlock:(CompleteBlock)completeBlock
{
    [SRHttpUtil POST :[SRURLUtil Portal_ModifyCarRecordUrl] WithParameter:request.keyValues completeBlock:^(NSError *error, id responseObject) {
        
        if (error) {
            if (completeBlock) completeBlock(error, responseObject);
            return ;
        }
        
        SRPortalResponse *response = [SRPortalResponse objectWithKeyValues:responseObject];
        if (response.result.resultCode != SRHTTP_Success) {
            error = [NSError errorWithDomain:response.result.resultMessage
                                        code:response.result.resultCode
                                    userInfo:response.result.fieldErrors];
            if (completeBlock) completeBlock(error, nil);
        } else {
            SRVehicleBasicInfo *localInfo = [[self sharedInterface] vehicleBasicInfoWithVehicleID:request.entityID];
            if (localInfo) {
                localInfo.vehicleModelID = request.vehicleModelID;
                localInfo.plateNumber = request.plateNumber;
                localInfo.vin = request.vin;
                
                [[SRDataBase sharedInterface] updateVehicleList:@[localInfo] withCompleteBlock:nil];
            }
            
            
            if (completeBlock) completeBlock(nil, @(YES));
        }
    }];
}

+ (void)querySMSCommandsWithCompleteBlock:(CompleteBlock)completeBlock
{
    SRPortalRequestQuerySMSCommand *request = [[SRPortalRequestQuerySMSCommand alloc] init];
    
    @weakify(self)
    [SRHttpUtil POST :[SRURLUtil Portal_QuerySMSCommandUrl] WithParameter:request.keyValues completeBlock:^(NSError *error, id responseObject) {
        @strongify(self)
        
        if (error) {
            if (completeBlock) completeBlock(error, responseObject);
            return ;
        }
        
        SRPortalResponse *response = [SRPortalResponse objectWithKeyValues:responseObject];
        if (response.result.resultCode != SRHTTP_Success) {
            error = [NSError errorWithDomain:response.result.resultMessage
                                        code:response.result.resultCode
                                    userInfo:response.result.fieldErrors];
            if (completeBlock) completeBlock(error, nil);
        } else {
//            NSArray *smsCommands = [SRSMSCommandVos objectArrayWithKeyValuesArray:response.entity];
//            
//            @weakify(self)
//            dispatch_apply(smsCommands.count, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(size_t index) {
//                @strongify(self)
//                SRSMSCommandVos *smsCommand = smsCommands[index];
//                SRVehicleBasicInfo *basicInfo = [[self sharedInterface] vehicleBasicInfoWithVehicleID:smsCommand.vehicleID];
//                if (basicInfo) {
//                    basicInfo.smsCommands = smsCommand;
//                    [[SRDataBase sharedInterface] updateVehicleList:@[basicInfo] withCompleteBlock:nil];
//                }
//            });
//            
//            if (completeBlock) completeBlock(nil, @([response.result.resultMessage boolValue]));
            
            @weakify(self)
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                @strongify(self)
                
                NSArray *smsCommands = [SRSMSCommandVos objectArrayWithKeyValuesArray:response.entity];
                [smsCommands enumerateObjectsUsingBlock:^(SRSMSCommandVos *smsCommand, NSUInteger idx, BOOL *stop) {
                    SRVehicleBasicInfo *basicInfo = [[self sharedInterface] vehicleBasicInfoWithVehicleID:smsCommand.vehicleID];
                    if (basicInfo) {
                        basicInfo.smsCommands = smsCommand;
                        [[SRDataBase sharedInterface] updateVehicleList:@[basicInfo] withCompleteBlock:nil];
                    }
                }];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (completeBlock) completeBlock(nil, @([response.result.resultMessage boolValue]));
                });
            });
        }
    }];
}

//隐藏行踪
+ (void)hiddenTripWithRequest:(SRPortalRequestTripHidden *)request andCompleteBlock:(CompleteBlock)completeBlock
{
    [SRHttpUtil POST :[SRURLUtil Portal_HideTripUrl] WithParameter:request.keyValues completeBlock:^(NSError *error, id responseObject) {
        
        if (error) {
            if (completeBlock) completeBlock(error, responseObject);
            return ;
        }
        
        SRPortalResponse *response = [SRPortalResponse objectWithKeyValues:responseObject];
        if (response.result.resultCode != SRHTTP_Success) {
            error = [NSError errorWithDomain:response.result.resultMessage
                                        code:response.result.resultCode
                                    userInfo:response.result.fieldErrors];
            if (completeBlock) completeBlock(error, nil);
        } else {
            SRVehicleBasicInfo *info = [[self sharedInterface] vehicleBasicInfoWithVehicleID:request.vehicleID];
            info.tripHidden = request.isHidden?SRTrip_Hidden_Self:SRTrip_Unhidden;
            [[SRDataBase sharedInterface] updateVehicleList:@[info] withCompleteBlock:nil];
            if (completeBlock) completeBlock(nil, @(YES));
        }
    }];
}

//OBD诊断
+ (void)updateOBDStatusWithRequest:(SRPortalRequestUpdateObdStatus *)request andCompleteBlock:(CompleteBlock)completeBlock
{
    [SRHttpUtil POST :[SRURLUtil Portal_ModifyObdCheckStatusUrl] WithParameter:request.keyValues completeBlock:^(NSError *error, id responseObject) {
        
        if (error) {
            if (completeBlock) completeBlock(error, responseObject);
            return ;
        }
        
        SRPortalResponse *response = [SRPortalResponse objectWithKeyValues:responseObject];
        if (response.result.resultCode != SRHTTP_Success) {
            error = [NSError errorWithDomain:response.result.resultMessage
                                        code:response.result.resultCode
                                    userInfo:response.result.fieldErrors];
            if (completeBlock) completeBlock(error, nil);
        } else {
            SRVehicleBasicInfo *info = [[self sharedInterface] vehicleBasicInfoWithVehicleID:request.vehicleID];
            info.openObd = request.openObd?1:0;
            [[SRDataBase sharedInterface] updateVehicleList:@[info] withCompleteBlock:nil];
            if (completeBlock) completeBlock(nil, @(YES));
        }
    }];
}

//OBD检测
+ (void)queryDtcInfosWithRequest:(SRPortalRequestDtcInfo *)request andCompleteBlock:(CompleteBlock)completeBlock
{
    [SRHttpUtil POST :[SRURLUtil Portal_QueryDtcInfoUrl] WithParameter:request.keyValues completeBlock:^(NSError *error, id responseObject) {
        
        if (error) {
            if (completeBlock) completeBlock(error, responseObject);
            return ;
        }
        
        SRPortalResponse *response = [SRPortalResponse objectWithKeyValues:responseObject];
        if (response.result.resultCode != SRHTTP_Success) {
            error = [NSError errorWithDomain:response.result.resultMessage
                                        code:response.result.resultCode
                                    userInfo:response.result.fieldErrors];
            if (completeBlock) completeBlock(error, nil);
        } else {
            NSArray *dtcInfos = [SRDtcInfo objectArrayWithKeyValuesArray:response.pageResult.entityList];
            NSMutableArray *result = [NSMutableArray arrayWithArray:@[@(YES), @(YES), @(YES), @(YES)]];
            [dtcInfos enumerateObjectsUsingBlock:^(SRDtcInfo *obj, NSUInteger idx, BOOL *stop) {
                [result replaceObjectAtIndex:[obj systemType] withObject:@(NO)];
            }];

            if (completeBlock) completeBlock(nil, result);
        }
    }];
}

//修改当前里程
+ (void)updateCurrentMileageWithRequest:(SRPortalRequestUpdateCurrentMileage *)request andCompleteBlock:(CompleteBlock)completeBlock
{
    [SRHttpUtil POST :[SRURLUtil Portal_UpdateCurrentMileageUrl] WithParameter:request.keyValues completeBlock:^(NSError *error, id responseObject) {
        
        if (error) {
            if (completeBlock) completeBlock(error, responseObject);
            return ;
        }
        
        SRPortalResponse *response = [SRPortalResponse objectWithKeyValues:responseObject];
        if (response.result.resultCode != SRHTTP_Success) {
            error = [NSError errorWithDomain:response.result.resultMessage
                                        code:response.result.resultCode
                                    userInfo:response.result.fieldErrors];
            if (completeBlock) completeBlock(error, nil);
        } else {
            SRVehicleBasicInfo *basic = [[self sharedInterface] vehicleBasicInfoWithVehicleID:request.vehicleID];
            basic.status.mileAge = request.mileAge;
            [[SRDataBase sharedInterface] updateVehicleList:@[basic] withCompleteBlock:nil];
            
            SRMaintainReserveInfo *info = [SRMaintainReserveInfo objectWithKeyValues:response.entity];
            [[SRDataBase sharedInterface] updateMaintainReserveInfo:info withCompleteBlock:nil];
            
            if (completeBlock) completeBlock(nil, info);
        }
    }];
}

//修改下次保养里程
+ (void)updateNextMaintainMileageWithRequest:(SRPortalRequestUpdateNextMaintainMileage *)request andCompleteBlock:(CompleteBlock)completeBlock
{
    [SRHttpUtil POST :[SRURLUtil Portal_UpdateNextMaintainMileageUrl] WithParameter:request.keyValues completeBlock:^(NSError *error, id responseObject) {
        
        if (error) {
            if (completeBlock) completeBlock(error, responseObject);
            return ;
        }
        
        SRPortalResponse *response = [SRPortalResponse objectWithKeyValues:responseObject];
        if (response.result.resultCode != SRHTTP_Success) {
            error = [NSError errorWithDomain:response.result.resultMessage
                                        code:response.result.resultCode
                                    userInfo:response.result.fieldErrors];
            if (completeBlock) completeBlock(error, nil);
        } else {
            SRVehicleBasicInfo *basic = [[self sharedInterface] vehicleBasicInfoWithVehicleID:request.vehicleID];
            basic.nextMaintenMileage = request.nextMaintenMileage;
            [[SRDataBase sharedInterface] updateVehicleList:@[basic] withCompleteBlock:nil];
            
            SRMaintainReserveInfo *info = [SRMaintainReserveInfo objectWithKeyValues:response.entity];
            [[SRDataBase sharedInterface] updateMaintainReserveInfo:info withCompleteBlock:nil];
            
            if (completeBlock) completeBlock(nil, info);
        }
    }];
}

@end

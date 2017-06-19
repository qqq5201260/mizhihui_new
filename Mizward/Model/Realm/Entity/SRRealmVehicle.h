//
//  SRRealmVehicle.h
//  Mizward
//
//  Created by zhangjunbo on 15/9/1.
//  Copyright (c) 2015年 Mizward. All rights reserved.
//

#import <Realm/RLMObject.h>

@class SRVehicleBasicInfo;

@interface SRRealmVehicle : RLMObject

@property   NSString    *abilities_v2; //obj:SRTLV 0:无能力 1:有能力 2:可扩展
@property   CGFloat     balance;
@property   NSString    *balanceDate;
@property   NSString    *barcode;
@property   NSInteger   brandID;
@property   NSString    *brandName;
@property   NSString    *color;
@property   NSInteger   customerID;
@property   NSString    *customerName;
@property   NSString    *customerPhone;
@property   NSString    *customized;
@property   BOOL        gotBalance;
@property   NSString    *hardware;
@property   BOOL        has4SModule;
@property   BOOL        hasControlModule;
@property   BOOL        hasOBDModule;
@property   NSString    *insuranceSaleDate;
@property   NSString    *insuranceSaleDateStr;
@property   NSString    *msisdn;
@property   CGFloat     nextMaintenMileage;
@property   NSInteger   openObd;
@property   NSString    *plateNumber;
@property   CGFloat     preMaintenMileage;
@property   NSString    *saleDate;
@property   NSString    *saleDateStr;
@property   NSString    *serialNumber;
@property   NSString    *serviceCode;
@property   NSInteger   terminalID;
@property   NSInteger   tripHidden;
@property   NSInteger   vehicleID;
@property   NSInteger   vehicleModelID;
@property   NSString    *vehicleModelName;
@property   NSString    *vin;

@property   NSString    *workTime;
@property   NSString    *goHomeTime;
@property   NSInteger   maxStartTimeLength;

//2015-08-27新增蓝牙
@property   NSString    *bluetooth;

//自定义扩展字段
@property   NSString    *smsCommands;
@property   NSString    *status;

- (instancetype)initWithVehicleBasicInfo:(SRVehicleBasicInfo *)info;
- (SRVehicleBasicInfo *)vehicleBasicInfo;

@end

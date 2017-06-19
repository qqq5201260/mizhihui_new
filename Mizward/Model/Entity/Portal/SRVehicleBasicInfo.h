//
//  SRVehicleBasicInfo.h
//  SiRuiV4.0
//
//  Created by zhangjunbo on 15/6/16.
//  Copyright (c) 2015年 SiRui. All rights reserved.
//

#import "SREntity.h"

@class SRTLV, SRSMSCommandVos, SRVehicleStatusInfo, SRVehicleBluetoothInfo;

@interface SRVehicleBasicInfo : SREntity

@property (nonatomic, strong)   NSMutableArray     *abilities_v2; //obj:SRTLV 0:无能力 1:有能力 2:可扩展
@property (nonatomic, assign)   CGFloat     balance;
@property (nonatomic, copy)     NSString    *balanceDate;
@property (nonatomic, copy)     NSString    *barcode;
@property (nonatomic, assign)   NSInteger   brandID;
@property (nonatomic, copy)     NSString    *brandName;
@property (nonatomic, copy)     NSString    *color;
//@property (nonatomic, assign)   BOOL        controlBt;
//@property (nonatomic, assign)   BOOL        controlSms;
@property (nonatomic, assign)   NSInteger   customerID;
@property (nonatomic, copy)     NSString    *customerName;
@property (nonatomic, copy)     NSString    *customerPhone;
@property (nonatomic, copy)     NSString    *customized;
@property (nonatomic, assign)   BOOL        gotBalance;
//@property (nonatomic, assign)   BOOL        gotoV3;
@property (nonatomic, copy)     NSString    *hardware;
@property (nonatomic, assign)   BOOL        has4SModule;
@property (nonatomic, assign)   BOOL        hasControlModule;
@property (nonatomic, assign)   BOOL        hasOBDModule;
@property (nonatomic, copy)     NSString    *insuranceSaleDate;
@property (nonatomic, copy)     NSString    *insuranceSaleDateStr;
@property (nonatomic, copy)     NSString    *msisdn;
@property (nonatomic, assign)   CGFloat     nextMaintenMileage;
@property (nonatomic, assign)   NSInteger   openObd;
@property (nonatomic, copy)     NSString    *plateNumber;
@property (nonatomic, assign)   CGFloat     preMaintenMileage;
@property (nonatomic, copy)     NSString    *saleDate;
@property (nonatomic, copy)     NSString    *saleDateStr;
@property (nonatomic, copy)     NSString    *serialNumber;
@property (nonatomic, copy)     NSString    *serviceCode;
@property (nonatomic, assign)   NSInteger   terminalID;
@property (nonatomic, assign)   SRTripHiddenStatus   tripHidden;
@property (nonatomic, assign)   NSInteger   vehicleID;
@property (nonatomic, assign)   NSInteger   vehicleModelID;
@property (nonatomic, copy)     NSString    *vehicleModelName;
@property (nonatomic, copy)     NSString    *vin;

@property (nonatomic, copy)     NSString    *workTime;
@property (nonatomic, copy)     NSString    *goHomeTime;
@property (nonatomic, assign)   NSInteger   maxStartTimeLength;

//2015-08-27新增蓝牙
@property (nonatomic, strong)   SRVehicleBluetoothInfo *bluetooth;

//自定义扩展字段
@property (nonatomic, strong)   SRSMSCommandVos *smsCommands;
@property (nonatomic, strong)   SRVehicleStatusInfo *status;
@property (nonatomic, strong)   NSMutableArray *orderStartList;
@property (nonatomic, strong)   NSMutableArray *terminalVersionInfos;

- (BOOL)hasTerminal;
- (BOOL)isObdOpen;
- (BOOL)hasBluetooth;
- (BOOL)hasOST;
- (BOOL)onlyPPKE;

- (void)setAbilityWithTLV:(SRTLV *)tlv;
- (BOOL)hasAbilityWithTag:(SRTLVTag_Ability)tag;
- (SRControlAbilityType)abilityWithTag:(SRTLVTag_Ability)tag;

- (NSString *)bluetoothString;
- (void)setBluetoothWithString:(NSString *)string;

- (NSString *)abilitiesString;
- (void)setAbilitiesWithString:(NSString *)string;

- (NSString *)statusString;
- (void)setStatusWithString:(NSString *)string;

- (NSString *)smsCommandsString;
- (void)setSmsCommandsWithString:(NSString *)string;

- (NSString *)terminalVersionInfosString;
- (void)setTerminalVersionInfosWithString:(NSString *)string;

//- (NSString *)toString;
//- (instancetype)initWithString:(NSString *)aString;

@end

//
//  SRRealmVehicle.m
//  Mizward
//
//  Created by zhangjunbo on 15/9/1.
//  Copyright (c) 2015年 Mizward. All rights reserved.
//

#import "SRRealmVehicle.h"
#import "SRVehicleBasicInfo.h"

@implementation SRRealmVehicle

+ (nullable NSString *)primaryKey
{
    return @"vehicleID";
}

- (instancetype)initWithVehicleBasicInfo:(SRVehicleBasicInfo *)info
{
    if (self = [super init]) {
        _abilities_v2 = info.abilitiesString?info.abilitiesString:@"";
        _balance = info.balance;
        _balanceDate = info.balanceDate?info.balanceDate:@"";
        _barcode = info.barcode?info.barcode:@"";
        _brandID = info.brandID;
        _brandName = info.brandName?info.brandName:@"";
        _color = info.color?info.color:@"";
        _customerID = info.customerID;
        _customerName = info.customerName?info.customerName:@"";
        _customerPhone = info.customerPhone?info.customerPhone:@"";
        _customized = info.customized?info.customized:@"";
        _gotBalance = info.gotBalance;
        _hardware = info.hardware?info.hardware:@"";
        _has4SModule = info.has4SModule;
        _hasControlModule = info.hasControlModule;
        _hasOBDModule = info.hasOBDModule;
        _insuranceSaleDate = info.insuranceSaleDate?info.insuranceSaleDate:@"";
        _insuranceSaleDateStr = info.insuranceSaleDateStr?info.insuranceSaleDateStr:@"";
        _msisdn = info.msisdn?info.msisdn:@"";
        _nextMaintenMileage = info.nextMaintenMileage;
        _openObd = info.openObd;
        _plateNumber = info.plateNumber?info.plateNumber:@"";
        _preMaintenMileage = info.preMaintenMileage;
        _saleDate = info.saleDate?info.saleDate:@"";
        _saleDateStr = info.saleDateStr?info.saleDateStr:@"";
        _serialNumber = info.serialNumber?info.serialNumber:@"";
        _serviceCode = info.serviceCode?info.serviceCode:@"";
        _terminalID = info.terminalID;
        _tripHidden = info.tripHidden;
        _vehicleID = info.vehicleID;
        _vehicleModelID = info.vehicleModelID;
        _vehicleModelName = info.vehicleModelName?info.vehicleModelName:@"";
        _vin = info.vin?info.vin:@"";
        _workTime = info.workTime?info.workTime:@"";
        _goHomeTime = info.goHomeTime?info.goHomeTime:@"";
        _maxStartTimeLength = info.maxStartTimeLength;
        _bluetooth = info.bluetoothString?info.bluetoothString:@"";
        _smsCommands = info.smsCommandsString?info.smsCommandsString:@"";
        _status = info.statusString?info.statusString:@"";
    }
    return self;
}

- (SRVehicleBasicInfo *)vehicleBasicInfo
{
    SRVehicleBasicInfo *info = [[SRVehicleBasicInfo alloc] init];
    
    info.balance = self.balance;
    info.balanceDate = self.balanceDate;
    info.barcode = self.barcode;
    info.brandID = self.brandID;
    info.brandName = self.brandName;
    info.color = self.color;
    info.customerID = self.customerID;
    info.customerName = self.customerName;
    info.customerPhone = self.customerPhone;
    info.customized = self.customized;
    info.gotBalance = self.gotBalance;
    info.hardware = self.hardware;
    info.has4SModule = self.has4SModule;
    info.hasControlModule = self.hasControlModule;
    info.hasOBDModule = self.hasOBDModule;
    info.insuranceSaleDate = self.insuranceSaleDate;
    info.insuranceSaleDateStr = self.insuranceSaleDateStr;
    info.msisdn = self.msisdn;
    info.nextMaintenMileage = self.nextMaintenMileage;
    info.openObd = self.openObd;
    info.plateNumber = self.plateNumber;
    info.preMaintenMileage = self.preMaintenMileage;
    info.saleDate = self.saleDate;
    info.saleDateStr = self.saleDateStr;
    info.serialNumber = self.serialNumber;
    info.serviceCode = self.serviceCode;
    info.terminalID = self.terminalID;
    info.tripHidden = self.tripHidden;
    info.vehicleID = self.vehicleID;
    info.vehicleModelID = self.vehicleModelID;
    info.vehicleModelName = self.vehicleModelName;
    info.vin = self.vin;
    info.workTime = self.workTime;
    info.goHomeTime = self.goHomeTime;
    info.maxStartTimeLength = self.maxStartTimeLength;
    
    [info setAbilitiesWithString:self.abilities_v2];
    [info setBluetoothWithString:self.bluetooth];
    [info setSmsCommandsWithString:self.smsCommands];
    [info setStatusWithString:self.status];

    return info;
}

@end

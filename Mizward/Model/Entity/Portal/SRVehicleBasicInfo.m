//
//  SRVehicleBasicInfo.m
//  SiRuiV4.0
//
//  Created by zhangjunbo on 15/6/16.
//  Copyright (c) 2015年 SiRui. All rights reserved.
//

#import "SRVehicleBasicInfo.h"
#import "SRTLV.h"
#import "SRSMSCommandVos.h"
#import "SRVehicleStatusInfo.h"
#import "SRVehicleBluetoothInfo.h"
#import "SRVehicleTerminalVersionInfo.h"
#import "SRUserDefaults.h"
#import <MJExtension/MJExtension.h>

@implementation SRVehicleBasicInfo

- (NSMutableArray *)abilities_v2 {
    if ([SRUserDefaults isExperienceUser]) {
        NSMutableArray *array = [NSMutableArray array];
        for (NSInteger tag = TLVTag_Ability_Lock; tag <= TLVTag_Ability_SkyOpen; ++tag) {
            SRTLV *tlv = [[SRTLV alloc] init];
            tlv.tag = tag;
            tlv.value = [NSString stringWithFormat:@"%zd", SRControlAbilityType_Support];
            [array addObject:tlv];
        }
        return array;
    } else {
        return _abilities_v2;
    }
}

- (void)setAbilityWithTLV:(SRTLV *)tlv
{
    if (!_abilities_v2) {
        self.abilities_v2 = [NSMutableArray arrayWithObjects:tlv, nil];
    } else {
        __block BOOL hasAbilityTag = NO;
        [self.abilities_v2 enumerateObjectsUsingBlock:^(SRTLV *obj, NSUInteger idx, BOOL *stop) {
            if (obj.tag == tlv.tag) {
                obj.value = tlv.value;
                *stop = YES;
                hasAbilityTag = YES;
            }
        }];
        
        if (!hasAbilityTag) {
            [self.abilities_v2 addObject:tlv];
        }
    }
}

- (BOOL)hasAbilityWithTag:(SRTLVTag_Ability)tag
{
    if (!_abilities_v2) {
        return NO;
    }
    
    __block BOOL hasAbility = NO;
    [self.abilities_v2 enumerateObjectsUsingBlock:^(SRTLV *obj, NSUInteger idx, BOOL *stop) {
        if (obj.tag == tag) {
            *stop = YES;
            hasAbility = [obj.value integerValue]==SRControlAbilityType_Support;
        }
    }];
    return hasAbility;
}

- (SRControlAbilityType)abilityWithTag:(SRTLVTag_Ability)tag
{
    if (!_abilities_v2) {
        return SRControlAbilityType_Unsupport;
    }
    
    __block SRControlAbilityType type = SRControlAbilityType_Unsupport;
    [self.abilities_v2 enumerateObjectsUsingBlock:^(SRTLV *obj, NSUInteger idx, BOOL *stop) {
        if (obj.tag == tag) {
            *stop = YES;
            type = [obj.value integerValue];
        }
    }];
    return type;
}

- (BOOL)hasTerminal
{
//    return self.serialNumber && self.serialNumber.length>0;
    return self.terminalID>0 || self.bluetooth;
}

- (BOOL)isObdOpen
{
    return self.openObd == 1;
}

- (BOOL)hasBluetooth
{
    return self.bluetooth && self.bluetooth.hasBluetooth;
}

- (BOOL)hasOST
{
    return self.terminalID>0;
}

- (BOOL)onlyPPKE
{
    return self.terminalID<=0;
}

- (NSString *)bluetoothString
{
    if (!self.bluetooth) return nil;
    
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self.bluetooth.keyValues options:NSJSONWritingPrettyPrinted error:&error];
    if (error) {
        return nil;
    }
    
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    return jsonString;
}

- (void)setBluetoothWithString:(NSString *)string
{
    NSData *jsonData = [string dataUsingEncoding:NSUTF8StringEncoding];
    
    if (!jsonData) {
        self.bluetooth = [[SRVehicleBluetoothInfo alloc] init];
        return;
    }
    
    NSError *error = nil;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableLeaves error:&error];
    if (error) {
        return;
    }
    
    self.bluetooth = [SRVehicleBluetoothInfo objectWithKeyValues:dic];
}


- (NSString *)abilitiesString
{
    if (!self.abilities_v2 || self.abilities_v2.count == 0) return nil;
    
    NSMutableArray *array = [NSMutableArray array];
    [self.abilities_v2 enumerateObjectsUsingBlock:^(SRTLV *obj, NSUInteger idx, BOOL *stop) {
        NSError *error = nil;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:obj.keyValues options:NSJSONWritingPrettyPrinted error:&error];
        if (!error) {
            NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
            [array addObject:jsonString];
        }
    }];
    
    return [array componentsJoinedByString:@"*"];
}

- (void)setAbilitiesWithString:(NSString *)string
{
    NSArray *jsonArray = [string componentsSeparatedByString:@"*"];
    
    NSMutableArray *abilities = [NSMutableArray array];
    [jsonArray enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL *stop) {
        NSData *jsonData = [obj dataUsingEncoding:NSUTF8StringEncoding];
        NSError *error = nil;
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableLeaves error:&error];
        if (!error) {
            SRTLV *tlv = [SRTLV objectWithKeyValues:dic];
            [abilities addObject:tlv];
        }
    }];
    
    self.abilities_v2 = abilities;
}

- (NSString *)statusString
{
    if (!self.status) return nil;
    
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self.status.keyValues options:NSJSONWritingPrettyPrinted error:&error];
    if (error) {
        return nil;
    }
    
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    return jsonString;
}

- (void)setStatusWithString:(NSString *)string
{
    NSData *jsonData = [string dataUsingEncoding:NSUTF8StringEncoding];
    
    if (!jsonData) {
        self.status = [[SRVehicleStatusInfo alloc] init];
        return;
    }
    
    NSError *error = nil;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableLeaves error:&error];
    if (error) {
        return;
    }
    
    self.status = [SRVehicleStatusInfo objectWithKeyValues:dic];
    [self.status setGpsTimeLocal:dic[@"gpsTime"]];
}

- (NSString *)smsCommandsString
{
    if (!self.smsCommands) return nil;
    
    return self.smsCommands.stringValue;
}

- (void)setSmsCommandsWithString:(NSString *)string
{
    self.smsCommands = [[SRSMSCommandVos alloc] initWithString:string];
    self.smsCommands.vehicleID = self.vehicleID;
}

- (NSString *)terminalVersionInfosString
{
    if (!self.terminalVersionInfos || self.terminalVersionInfos.count == 0) return nil;
    
    NSMutableArray *array = [NSMutableArray array];
    [self.terminalVersionInfos enumerateObjectsUsingBlock:^(SRVehicleTerminalVersionInfo *obj, NSUInteger idx, BOOL *stop) {
        NSError *error = nil;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:obj.keyValues options:NSJSONWritingPrettyPrinted error:&error];
        if (!error) {
            NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
            [array addObject:jsonString];
        }
    }];
    
    return [array componentsJoinedByString:@"*"];
}

- (void)setTerminalVersionInfosWithString:(NSString *)string
{
    NSArray *jsonArray = [string componentsSeparatedByString:@"*"];
    
    NSMutableArray *abilities = [NSMutableArray array];
    [jsonArray enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL *stop) {
        NSData *jsonData = [obj dataUsingEncoding:NSUTF8StringEncoding];
        NSError *error = nil;
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableLeaves error:&error];
        if (!error) {
            SRVehicleTerminalVersionInfo *info = [SRVehicleTerminalVersionInfo objectWithKeyValues:dic];
            [abilities addObject:info];
        }
    }];
    
    self.terminalVersionInfos = abilities;
}

//- (void)toString
//{
//    SRLogDebug(@"%@", self.JSONString);
//    return
//}

//- (instancetype)initWithString:(NSString *)aString
//{
//
//}

@end

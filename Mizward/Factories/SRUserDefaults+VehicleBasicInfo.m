//
//  SRUserDefaults+VehicleBasicInfo.m
//  Mizward
//
//  Created by zhangjunbo on 15/12/7.
//  Copyright © 2015年 Mizward. All rights reserved.
//

#import "SRUserDefaults+VehicleBasicInfo.h"
#import "SRVehicleBasicInfo.h"
#import <MJExtension/MJExtension.h>

@implementation SRUserDefaults (VehicleBasicInfo)

#pragma mark -
#pragma mark vehicleBasicInfo

//+ (void)updateVehicleList:(NSArray *)list
//{
//    NSDictionary *dic = [[self standardUserDefaults] objectForKey:kVehicleBsicDic];
//    if (!dic) {
//        dic = @{@([self customerID]):[NSMutableDictionary dictionary]};
//    };
//    NSMutableDictionary *vehicleDic = dic[@([self customerID])];
//    if (!vehicleDic) {
//        vehicleDic = [NSMutableDictionary dictionary];
//    };
//    for (SRVehicleBasicInfo *info in list) {
//        if (vehicleDic[@(info.vehicleID)]) {
//            vehicleDic[@(info.vehicleID)] = info.JSONString;
//        } else {
//            [vehicleDic setObject:info.JSONString forKey:@(info.vehicleID)];
//        }
//    }
//    
//    [[self standardUserDefaults] setObject:dic.JSONData
//                                    forKey:kVehicleBsicDic];
//    [[self standardUserDefaults] synchronize];
//}
//
//+ (void)deleteVehicleByVehicleID:(NSInteger)vehicleID
//{
//    NSDictionary *dic = [[self standardUserDefaults] objectForKey:kVehicleBsicDic];
//    if (!dic) return;
//    NSMutableDictionary *vehicleDic = dic[@([self customerID])];
//    if (!vehicleDic) return;
//    [vehicleDic removeObjectForKey:@(vehicleID)];
//    
//    [[self standardUserDefaults] setObject:dic
//                                    forKey:kVehicleBsicDic];
//    [[self standardUserDefaults] synchronize];
//}
//
//+ (void)deleteVehicleByCustomerID:(NSInteger)customerID
//{
//    NSMutableDictionary *dic = [[self standardUserDefaults] objectForKey:kVehicleBsicDic];
//    if (!dic) return;
//    [dic removeObjectForKey:@(customerID)];
//    
//    [[self standardUserDefaults] setObject:dic
//                                    forKey:kVehicleBsicDic];
//    [[self standardUserDefaults] synchronize];
//}
//
//+ (void)deleteAllVehicle
//{
//    NSMutableDictionary *dic = [[self standardUserDefaults] objectForKey:kVehicleBsicDic];
//    if (!dic) return;
//    [dic removeAllObjects];
//    
//    [[self standardUserDefaults] setObject:dic
//                                    forKey:kVehicleBsicDic];
//    [[self standardUserDefaults] synchronize];
//}
//
//+ (SRVehicleBasicInfo *)queryVehicleByVehicleID:(NSInteger)vehicleID
//{
//    NSDictionary *dic = [[self standardUserDefaults] objectForKey:kVehicleBsicDic];
//    if (!dic) nil;
//    NSMutableDictionary *vehicleDic = dic[@([self customerID])];
//    if (!vehicleDic) nil;
//    
//    NSString *json = vehicleDic[@(vehicleID)];
//    SRVehicleBasicInfo *info = [SRVehicleBasicInfo objectWithKeyValues:json.JSONObject];
//    return info;
//}
//
//+ (NSMutableDictionary *)queryVehicleByCustomerID:(NSInteger)customerID
//{
//    NSDictionary *dic = [[self standardUserDefaults] objectForKey:kVehicleBsicDic];
//    if (!dic) nil;
//    NSMutableDictionary *vehicleDic = dic[@([self customerID])];
//    if (!vehicleDic) nil;
//
//    NSMutableDictionary *basicDic = [NSMutableDictionary dictionary];
//    for (NSString *json in vehicleDic.allValues) {
//        SRVehicleBasicInfo *info = [SRVehicleBasicInfo objectWithKeyValues:json.JSONObject];
//        [basicDic setObject:info forKey:@(info.vehicleID)];
//    }
//    return basicDic;
//}
//
//+ (NSArray *)queryAllVehicle
//{
//    NSDictionary *dic = [[self standardUserDefaults] objectForKey:kVehicleBsicDic];
//    if (!dic) nil;
//    
//    NSMutableArray *vehicleArray = [NSMutableArray array];
//    [dic.allValues enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL * _Nonnull stop) {
//        for (NSString *json in obj.allValues) {
//            SRVehicleBasicInfo *info = [SRVehicleBasicInfo objectWithKeyValues:json.JSONObject];
//            [vehicleArray addObject:info];
//        }
//    }];
//    
//    return vehicleArray;
//}

@end

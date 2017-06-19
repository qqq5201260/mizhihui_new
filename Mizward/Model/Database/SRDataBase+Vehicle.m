//
//  SRDataBase+VehicleBasic.m
//  SiRuiV4.0
//
//  Created by zhangjunbo on 15/6/16.
//  Copyright (c) 2015年 SiRui. All rights reserved.
//

#import "SRDataBase+Vehicle.h"
#import "SRVehicleBasicInfo.h"
#import "SRVehicleStatusInfo.h"
#import "SRSMSCommandVos.h"
#import "SRVehicleBluetoothInfo.h"
#import <FMDB/FMDB.h>
#import <MJExtension/MJExtension.h>

#import "SRUserDefaults+VehicleBasicInfo.h"

#import "SRRealm+Vehicle.h"

// DB Table
NSString * const SQL_TABLE_Vehicle = @"Vehicle";

//元素
NSString * const v_vehicleID            = @"vehicleID";

NSString * const v_abilities            = @"abilities";
NSString * const v_balance              = @"balance";
NSString * const v_balanceDate          = @"balanceDate";
NSString * const v_barcode              = @"barcode";
NSString * const v_brandID              = @"brandID";
NSString * const v_brandName            = @"brandName";
NSString * const v_color                = @"color";
NSString * const v_customerID           = @"customerID";
NSString * const v_customerName         = @"customerName";
NSString * const v_customerPhone        = @"customerPhone";
NSString * const v_customized           = @"customized";
NSString * const v_gotBalance           = @"gotBalance";
NSString * const v_hardware             = @"hardware";
NSString * const v_has4SModule          = @"has4SModule";
NSString * const v_hasControlModule     = @"hasControlModule";
NSString * const v_hasOBDModule         = @"hasOBDModule";
NSString * const v_insuranceSaleDate    = @"insuranceSaleDate";
NSString * const v_insuranceSaleDateStr = @"insuranceSaleDateStr";
NSString * const v_msisdn               = @"msisdn";
NSString * const v_nextMaintenMileage   = @"nextMaintenMileage";
NSString * const v_openObd              = @"openObd";
NSString * const v_plateNumber          = @"plateNumber";
NSString * const v_preMaintenMileage    = @"preMaintenMileage";
NSString * const v_saleDate             = @"saleDate";
NSString * const v_saleDateStr          = @"saleDateStr";
NSString * const v_serialNumber         = @"serialNumber";
NSString * const v_serviceCode          = @"serviceCode";
NSString * const v_terminalID           = @"terminalID";
NSString * const v_tripHidden           = @"tripHidden";
NSString * const v_vehicleModelID       = @"vehicleModelID";
NSString * const v_vehicleModelName     = @"vehicleModelName";
NSString * const v_vin                  = @"vin";
NSString * const v_workTime             = @"workTime";
NSString * const v_goHomeTime           = @"goHomeTime";
NSString * const v_maxStartTimeLength   = @"maxStartTimeLength";
NSString * const v_smsCommands          = @"smsCommands";
NSString * const v_status               = @"status";
//2015-08-27新增蓝牙
NSString * const v_bluetooth            = @"bluetooth";
//2015-09-16新增终端版本信息
NSString * const v_terminalVersionInfos = @"terminalVersionInfos";

//SQL 语句
static inline NSString * SQL_Creat_VehicleTable () {
    static NSMutableString * SQL_Creat_VehicleTable;
    if (SQL_Creat_VehicleTable) {
        return SQL_Creat_VehicleTable;
    }
    
    SQL_Creat_VehicleTable = [NSMutableString string];
    [SQL_Creat_VehicleTable appendFormat:@"CREATE TABLE IF NOT EXISTS %@ ", SQL_TABLE_Vehicle];
    [SQL_Creat_VehicleTable appendFormat:@"("];
    [SQL_Creat_VehicleTable appendFormat:@"%@ INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL ,", v_vehicleID];
    [SQL_Creat_VehicleTable appendFormat:@"%@ TEXT         , " , v_abilities];
    [SQL_Creat_VehicleTable appendFormat:@"%@ FLOAT        , " , v_balance];
    [SQL_Creat_VehicleTable appendFormat:@"%@ VARCHAR(64)  , " , v_balanceDate];
    [SQL_Creat_VehicleTable appendFormat:@"%@ VARCHAR(64)  , " , v_barcode];
    [SQL_Creat_VehicleTable appendFormat:@"%@ INTEGER      , " , v_brandID];
    [SQL_Creat_VehicleTable appendFormat:@"%@ VARCHAR(64)  , " , v_brandName];
    [SQL_Creat_VehicleTable appendFormat:@"%@ VARCHAR(64)  , " , v_color];
    [SQL_Creat_VehicleTable appendFormat:@"%@ INTEGER      , " , v_customerID];
    [SQL_Creat_VehicleTable appendFormat:@"%@ VARCHAR(64)  , " , v_customerName];
    [SQL_Creat_VehicleTable appendFormat:@"%@ VARCHAR(64)  , " , v_customerPhone];
    [SQL_Creat_VehicleTable appendFormat:@"%@ VARCHAR(64)  , " , v_customized];
    [SQL_Creat_VehicleTable appendFormat:@"%@ INTEGER      , " , v_gotBalance];
    [SQL_Creat_VehicleTable appendFormat:@"%@ VARCHAR(64)  , " , v_hardware];
    [SQL_Creat_VehicleTable appendFormat:@"%@ INTEGER      , " , v_has4SModule];
    [SQL_Creat_VehicleTable appendFormat:@"%@ INTEGER      , " , v_hasControlModule];
    [SQL_Creat_VehicleTable appendFormat:@"%@ INTEGER      , " , v_hasOBDModule];
    [SQL_Creat_VehicleTable appendFormat:@"%@ VARCHAR(64)  , " , v_insuranceSaleDate];
    [SQL_Creat_VehicleTable appendFormat:@"%@ VARCHAR(64)  , " , v_insuranceSaleDateStr];
    [SQL_Creat_VehicleTable appendFormat:@"%@ VARCHAR(64)  , " , v_msisdn];
    [SQL_Creat_VehicleTable appendFormat:@"%@ FLOAT        , " , v_nextMaintenMileage];
    [SQL_Creat_VehicleTable appendFormat:@"%@ INTEGER      , " , v_openObd];
    [SQL_Creat_VehicleTable appendFormat:@"%@ VARCHAR(256) , " , v_plateNumber];
    [SQL_Creat_VehicleTable appendFormat:@"%@ FLOAT        , " , v_preMaintenMileage];
    [SQL_Creat_VehicleTable appendFormat:@"%@ VARCHAR(64)  , " , v_saleDate];
    [SQL_Creat_VehicleTable appendFormat:@"%@ VARCHAR(64)  , " , v_saleDateStr];
    [SQL_Creat_VehicleTable appendFormat:@"%@ VARCHAR(64)  , " , v_serialNumber];
    [SQL_Creat_VehicleTable appendFormat:@"%@ VARCHAR(64)  , " , v_serviceCode];
    [SQL_Creat_VehicleTable appendFormat:@"%@ INTEGER      , " , v_terminalID];
    [SQL_Creat_VehicleTable appendFormat:@"%@ INTEGER      , " , v_tripHidden];
    [SQL_Creat_VehicleTable appendFormat:@"%@ INTEGER      , " , v_vehicleModelID];
    [SQL_Creat_VehicleTable appendFormat:@"%@ VARCHAR(64)  , " , v_vehicleModelName];
    [SQL_Creat_VehicleTable appendFormat:@"%@ VARCHAR(64)  , " , v_vin];
    [SQL_Creat_VehicleTable appendFormat:@"%@ VARCHAR(64)  , " , v_workTime];
    [SQL_Creat_VehicleTable appendFormat:@"%@ VARCHAR(64)  , " , v_goHomeTime];
    [SQL_Creat_VehicleTable appendFormat:@"%@ INTEGER      , " , v_maxStartTimeLength];
    [SQL_Creat_VehicleTable appendFormat:@"%@ TEXT         , " , v_smsCommands];
    [SQL_Creat_VehicleTable appendFormat:@"%@ TEXT         , " , v_bluetooth];
    [SQL_Creat_VehicleTable appendFormat:@"%@ TEXT         , " , v_terminalVersionInfos];
    [SQL_Creat_VehicleTable appendFormat:@"%@ TEXT           " , v_status];
    [SQL_Creat_VehicleTable appendFormat:@")"];
    
    return SQL_Creat_VehicleTable;
}

static inline NSString * SQL_Insert_Vehicle () {
    static NSMutableString * SQL_Insert_Vehicle;
    if (SQL_Insert_Vehicle) {
        return SQL_Insert_Vehicle;
    }
    
    SQL_Insert_Vehicle = [NSMutableString string];
    [SQL_Insert_Vehicle appendFormat:@"INSERT INTO %@ ", SQL_TABLE_Vehicle];
    [SQL_Insert_Vehicle appendFormat:@"("];
    [SQL_Insert_Vehicle appendFormat:@"%@ , " , v_vehicleID];
    [SQL_Insert_Vehicle appendFormat:@"%@ , " , v_abilities];
    [SQL_Insert_Vehicle appendFormat:@"%@ , " , v_balance];
    [SQL_Insert_Vehicle appendFormat:@"%@ , " , v_balanceDate];
    [SQL_Insert_Vehicle appendFormat:@"%@ , " , v_barcode];
    [SQL_Insert_Vehicle appendFormat:@"%@ , " , v_brandID];
    [SQL_Insert_Vehicle appendFormat:@"%@ , " , v_brandName];
    [SQL_Insert_Vehicle appendFormat:@"%@ , " , v_color];
    [SQL_Insert_Vehicle appendFormat:@"%@ , " , v_customerID];
    [SQL_Insert_Vehicle appendFormat:@"%@ , " , v_customerName];
    [SQL_Insert_Vehicle appendFormat:@"%@ , " , v_customerPhone];
    [SQL_Insert_Vehicle appendFormat:@"%@ , " , v_customized];
    [SQL_Insert_Vehicle appendFormat:@"%@ , " , v_gotBalance];
    [SQL_Insert_Vehicle appendFormat:@"%@ , " , v_hardware];
    [SQL_Insert_Vehicle appendFormat:@"%@ , " , v_has4SModule];
    [SQL_Insert_Vehicle appendFormat:@"%@ , " , v_hasControlModule];
    [SQL_Insert_Vehicle appendFormat:@"%@ , " , v_hasOBDModule];
    [SQL_Insert_Vehicle appendFormat:@"%@ , " , v_insuranceSaleDate];
    [SQL_Insert_Vehicle appendFormat:@"%@ , " , v_insuranceSaleDateStr];
    [SQL_Insert_Vehicle appendFormat:@"%@ , " , v_msisdn];
    [SQL_Insert_Vehicle appendFormat:@"%@ , " , v_nextMaintenMileage];
    [SQL_Insert_Vehicle appendFormat:@"%@ , " , v_openObd];
    [SQL_Insert_Vehicle appendFormat:@"%@ , " , v_plateNumber];
    [SQL_Insert_Vehicle appendFormat:@"%@ , " , v_preMaintenMileage];
    [SQL_Insert_Vehicle appendFormat:@"%@ , " , v_saleDate];
    [SQL_Insert_Vehicle appendFormat:@"%@ , " , v_saleDateStr];
    [SQL_Insert_Vehicle appendFormat:@"%@ , " , v_serialNumber];
    [SQL_Insert_Vehicle appendFormat:@"%@ , " , v_serviceCode];
    [SQL_Insert_Vehicle appendFormat:@"%@ , " , v_terminalID];
    [SQL_Insert_Vehicle appendFormat:@"%@ , " , v_tripHidden];
    [SQL_Insert_Vehicle appendFormat:@"%@ , " , v_vehicleModelID];
    [SQL_Insert_Vehicle appendFormat:@"%@ , " , v_vehicleModelName];
    [SQL_Insert_Vehicle appendFormat:@"%@ , " , v_vin];
    [SQL_Insert_Vehicle appendFormat:@"%@ , " , v_workTime];
    [SQL_Insert_Vehicle appendFormat:@"%@ , " , v_goHomeTime];
    [SQL_Insert_Vehicle appendFormat:@"%@ , " , v_maxStartTimeLength];
    [SQL_Insert_Vehicle appendFormat:@"%@ , " , v_smsCommands];
    [SQL_Insert_Vehicle appendFormat:@"%@ , " , v_bluetooth];
    [SQL_Insert_Vehicle appendFormat:@"%@ , " , v_terminalVersionInfos];
    [SQL_Insert_Vehicle appendFormat:@"%@   " , v_status];
    [SQL_Insert_Vehicle appendFormat:@")"];
    [SQL_Insert_Vehicle appendFormat:@"VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)"];
    
    return SQL_Insert_Vehicle;
}

static inline NSString * SQL_Update_Vehicle () {
    static NSMutableString * SQL_Update_Vehicle;
    if (SQL_Update_Vehicle) {
        return SQL_Update_Vehicle;
    }
    
    SQL_Update_Vehicle = [NSMutableString string];
    [SQL_Update_Vehicle appendFormat:@"UPDATE %@ SET ", SQL_TABLE_Vehicle];
    [SQL_Update_Vehicle appendFormat:@"%@ = ?, " , v_vehicleID];
    [SQL_Update_Vehicle appendFormat:@"%@ = ?, " , v_abilities];
    [SQL_Update_Vehicle appendFormat:@"%@ = ?, " , v_balance];
    [SQL_Update_Vehicle appendFormat:@"%@ = ?, " , v_balanceDate];
    [SQL_Update_Vehicle appendFormat:@"%@ = ?, " , v_barcode];
    [SQL_Update_Vehicle appendFormat:@"%@ = ?, " , v_brandID];
    [SQL_Update_Vehicle appendFormat:@"%@ = ?, " , v_brandName];
    [SQL_Update_Vehicle appendFormat:@"%@ = ?, " , v_color];
    [SQL_Update_Vehicle appendFormat:@"%@ = ?, " , v_customerID];
    [SQL_Update_Vehicle appendFormat:@"%@ = ?, " , v_customerName];
    [SQL_Update_Vehicle appendFormat:@"%@ = ?, " , v_customerPhone];
    [SQL_Update_Vehicle appendFormat:@"%@ = ?, " , v_customized];
    [SQL_Update_Vehicle appendFormat:@"%@ = ?, " , v_gotBalance];
    [SQL_Update_Vehicle appendFormat:@"%@ = ?, " , v_hardware];
    [SQL_Update_Vehicle appendFormat:@"%@ = ?, " , v_has4SModule];
    [SQL_Update_Vehicle appendFormat:@"%@ = ?, " , v_hasControlModule];
    [SQL_Update_Vehicle appendFormat:@"%@ = ?, " , v_hasOBDModule];
    [SQL_Update_Vehicle appendFormat:@"%@ = ?, " , v_insuranceSaleDate];
    [SQL_Update_Vehicle appendFormat:@"%@ = ?, " , v_insuranceSaleDateStr];
    [SQL_Update_Vehicle appendFormat:@"%@ = ?, " , v_msisdn];
    [SQL_Update_Vehicle appendFormat:@"%@ = ?, " , v_nextMaintenMileage];
    [SQL_Update_Vehicle appendFormat:@"%@ = ?, " , v_openObd];
    [SQL_Update_Vehicle appendFormat:@"%@ = ?, " , v_plateNumber];
    [SQL_Update_Vehicle appendFormat:@"%@ = ?, " , v_preMaintenMileage];
    [SQL_Update_Vehicle appendFormat:@"%@ = ?, " , v_saleDate];
    [SQL_Update_Vehicle appendFormat:@"%@ = ?, " , v_saleDateStr];
    [SQL_Update_Vehicle appendFormat:@"%@ = ?, " , v_serialNumber];
    [SQL_Update_Vehicle appendFormat:@"%@ = ?, " , v_serviceCode];
    [SQL_Update_Vehicle appendFormat:@"%@ = ?, " , v_terminalID];
    [SQL_Update_Vehicle appendFormat:@"%@ = ?, " , v_tripHidden];
    [SQL_Update_Vehicle appendFormat:@"%@ = ?, " , v_vehicleModelID];
    [SQL_Update_Vehicle appendFormat:@"%@ = ?, " , v_vehicleModelName];
    [SQL_Update_Vehicle appendFormat:@"%@ = ?, " , v_vin];
    [SQL_Update_Vehicle appendFormat:@"%@ = ?, " , v_workTime];
    [SQL_Update_Vehicle appendFormat:@"%@ = ?, " , v_goHomeTime];
    [SQL_Update_Vehicle appendFormat:@"%@ = ?, " , v_maxStartTimeLength];
    [SQL_Update_Vehicle appendFormat:@"%@ = ?, " , v_smsCommands];
    [SQL_Update_Vehicle appendFormat:@"%@ = ?, " , v_bluetooth];
    [SQL_Update_Vehicle appendFormat:@"%@ = ?, " , v_terminalVersionInfos];
    [SQL_Update_Vehicle appendFormat:@"%@ = ?  " , v_status];
    [SQL_Update_Vehicle appendFormat:@"WHERE %@ = ?" , v_vehicleID];
    
    return SQL_Update_Vehicle;
}

static inline NSString * SQL_Delete_Vehicle_By_VehicleID () {
    static NSMutableString * SQL_Delete_Vehicle_By_VehicleID;
    if (SQL_Delete_Vehicle_By_VehicleID) {
        return SQL_Delete_Vehicle_By_VehicleID;
    }
    
    SQL_Delete_Vehicle_By_VehicleID = [NSMutableString string];
    [SQL_Delete_Vehicle_By_VehicleID appendFormat:@"DELETE FROM %@ ", SQL_TABLE_Vehicle];
    [SQL_Delete_Vehicle_By_VehicleID appendFormat:@"WHERE %@ = ?", v_vehicleID];
    return SQL_Delete_Vehicle_By_VehicleID;
}

static inline NSString * SQL_Delete_Vehicle_By_CustomerID () {
    static NSMutableString * SQL_Delete_Vehicle_By_CustomerID;
    if (SQL_Delete_Vehicle_By_CustomerID) {
        return SQL_Delete_Vehicle_By_CustomerID;
    }
    
    SQL_Delete_Vehicle_By_CustomerID = [NSMutableString string];
    [SQL_Delete_Vehicle_By_CustomerID appendFormat:@"DELETE FROM %@ ", SQL_TABLE_Vehicle];
    [SQL_Delete_Vehicle_By_CustomerID appendFormat:@"WHERE %@ = ?", v_customerID];
    return SQL_Delete_Vehicle_By_CustomerID;
}

static inline NSString * SQL_Delete_Vehicle_All () {
    static NSMutableString * SQL_Delete_Vehicle_All;
    if (SQL_Delete_Vehicle_All) {
        return SQL_Delete_Vehicle_All;
    }
    
    SQL_Delete_Vehicle_All = [NSMutableString string];
    [SQL_Delete_Vehicle_All appendFormat:@"DELETE FROM %@ ", SQL_TABLE_Vehicle];
    return SQL_Delete_Vehicle_All;
}

static inline NSString * SQL_Query_Vehicle_By_VehicleID () {
    static NSMutableString * SQL_Query_Vehicle_By_VehicleID;
    if (SQL_Query_Vehicle_By_VehicleID) {
        return SQL_Query_Vehicle_By_VehicleID;
    }
    
    SQL_Query_Vehicle_By_VehicleID = [NSMutableString string];
    [SQL_Query_Vehicle_By_VehicleID appendFormat:@"SELECT * FROM %@ ", SQL_TABLE_Vehicle];
    [SQL_Query_Vehicle_By_VehicleID appendFormat:@"WHERE %@ = ?", v_vehicleID];
    return SQL_Query_Vehicle_By_VehicleID;
}

static inline NSString * SQL_Query_Vehicle_By_CustomerID () {
    static NSMutableString * SQL_Query_Vehicle_By_CustomerID;
    if (SQL_Query_Vehicle_By_CustomerID) {
        return SQL_Query_Vehicle_By_CustomerID;
    }
    
    SQL_Query_Vehicle_By_CustomerID = [NSMutableString string];
    [SQL_Query_Vehicle_By_CustomerID appendFormat:@"SELECT * FROM %@ ", SQL_TABLE_Vehicle];
    [SQL_Query_Vehicle_By_CustomerID appendFormat:@"WHERE %@ = ?", v_customerID];
    [SQL_Query_Vehicle_By_CustomerID appendFormat:@"ORDER BY %@ ASC", v_vehicleID]; //升序
    return SQL_Query_Vehicle_By_CustomerID;
}

static inline NSString * SQL_Query_Vehicle_All () {
    static NSMutableString * SQL_Query_Vehicle_All;
    if (SQL_Query_Vehicle_All) {
        return SQL_Query_Vehicle_All;
    }
    
    SQL_Query_Vehicle_All = [NSMutableString string];
    [SQL_Query_Vehicle_All appendFormat:@"SELECT * FROM %@ ", SQL_Query_Vehicle_All];
    [SQL_Query_Vehicle_All appendFormat:@"ORDER BY %@ ASC", v_vehicleID]; //升序
    return SQL_Query_Vehicle_All;
}

//2015-08-27新增蓝牙
static inline NSString * SQL_Add_Bluetooth_Column () {
    static NSMutableString * SQL_Add_Bluetooth_Column;
    if (SQL_Add_Bluetooth_Column) {
        return SQL_Add_Bluetooth_Column;
    }
    
    SQL_Add_Bluetooth_Column = [NSMutableString string];
    [SQL_Add_Bluetooth_Column appendFormat:@"ALTER TABLE %@ ADD %@ TEXT", SQL_TABLE_Vehicle, v_bluetooth];
    return SQL_Add_Bluetooth_Column;
}

//2015-09-16新增终端版本信息
static inline NSString * SQL_Add_terminalVersionInfos_Column () {
    static NSMutableString * SQL_Add_terminalVersionInfos_Column;
    if (SQL_Add_terminalVersionInfos_Column) {
        return SQL_Add_terminalVersionInfos_Column;
    }
    
    SQL_Add_terminalVersionInfos_Column = [NSMutableString string];
    [SQL_Add_terminalVersionInfos_Column appendFormat:@"ALTER TABLE %@ ADD %@ TEXT", SQL_TABLE_Vehicle, v_terminalVersionInfos];
    return SQL_Add_terminalVersionInfos_Column;
}

//static inline NSString * SQL_Drop_Test_Column () {
//    static NSMutableString * SQL_Drop_Test_Column;
//    if (SQL_Drop_Test_Column) {
//        return SQL_Drop_Test_Column;
//    }
//    
//    SQL_Drop_Test_Column = [NSMutableString string];
//    [SQL_Drop_Test_Column appendFormat:@"ALTER TABLE %@ DROP COLUMN %@ ", SQL_TABLE_Vehicle, v_test];
//    return SQL_Drop_Test_Column;
//}

@implementation SRDataBase (Vehicle)

- (void)createVehicleTable
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self.databaseQueue inDatabase:^(FMDatabase *db) {
#if DataBaseEncrypd
            [db setKey:DB_ENCRYP_KEY];
#endif
            [db setShouldCacheStatements:YES];
            
            if ([db tableExists:SQL_TABLE_Vehicle]) {
                [self checkVehicleColumn:db];
                return ;
            }
            
            if ([db executeUpdate:SQL_Creat_VehicleTable()]) {
                SRLogDebug(@"VehicleBasic 表创建成功");
            } else {
                SRLogError(@"VehicleBasic 表创建失败");
            }
        }];
        [self.databaseQueue close];
    });
}

- (void)checkVehicleColumn:(FMDatabase *)db
{
    //2015-08-27新增蓝牙
    if (![db columnExists:v_bluetooth inTableWithName:SQL_TABLE_Vehicle]) {
        [db executeUpdate:SQL_Add_Bluetooth_Column()];
    }
    
    //2015-09-16 新增终端升级信息
    if (![db columnExists:v_terminalVersionInfos inTableWithName:SQL_TABLE_Vehicle]) {
        [db executeUpdate:SQL_Add_terminalVersionInfos_Column()];
    }
    
//    if ([db columnExists:v_test inTableWithName:SQL_TABLE_Vehicle]) {
//        [db executeUpdate:SQL_Drop_Test_Column()];
//    }
}

- (void)updateVehicleList:(NSArray *)list withCompleteBlock:(CompleteBlock)completeBlock
{
    if (!list || list.count==0) {
        !completeBlock?:completeBlock(nil, @(YES));
        return;
    }
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
//        [SRUserDefaults updateVehicleList:list];
        
        NSError *error = nil;
        __block NSInteger index = 0;
        __block BOOL result = NO;
        [self.databaseQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
#if DataBaseEncrypd
            [db setKey:DB_ENCRYP_KEY];
#endif
            
            [list enumerateObjectsUsingBlock:^(SRVehicleBasicInfo *info, NSUInteger idx, BOOL *stop) {
                FMResultSet *resultSet = [db executeQuery:SQL_Query_Vehicle_By_VehicleID(), @(info.vehicleID)];
                if (resultSet.next) {
                    //                    SRLogDebug(@"存在相同数据，改为更新");
                    result = [db executeUpdate:SQL_Update_Vehicle(),
                              @(info.vehicleID),
                              info.abilitiesString,
                              @(info.balance),
                              info.balanceDate,
                              info.barcode,
                              @(info.brandID),
                              info.brandName,
                              info.color,
                              @(info.customerID),
                              info.customerName,
                              info.customerPhone,
                              info.customized,
                              @(info.gotBalance),
                              info.hardware,
                              @(info.has4SModule),
                              @(info.hasControlModule),
                              @(info.hasOBDModule),
                              info.insuranceSaleDate,
                              info.insuranceSaleDateStr,
                              info.msisdn,
                              @(info.nextMaintenMileage),
                              @(info.openObd),
                              info.plateNumber,
                              @(info.preMaintenMileage),
                              info.saleDate,
                              info.saleDateStr,
                              info.serialNumber,
                              info.serviceCode,
                              @(info.terminalID),
                              @(info.tripHidden),
                              @(info.vehicleModelID),
                              info.vehicleModelName,
                              info.vin,
                              info.workTime,
                              info.goHomeTime,
                              @(info.maxStartTimeLength),
                              info.smsCommandsString,
                              info.bluetoothString,
                              info.terminalVersionInfosString,
                              info.statusString,
                              @(info.vehicleID)];
                } else {
                    result = [db executeUpdate:SQL_Insert_Vehicle(),
                              @(info.vehicleID),
                              info.abilitiesString,
                              @(info.balance),
                              info.balanceDate,
                              info.barcode,
                              @(info.brandID),
                              info.brandName,
                              info.color,
                              @(info.customerID),
                              info.customerName,
                              info.customerPhone,
                              info.customized,
                              @(info.gotBalance),
                              info.hardware,
                              @(info.has4SModule),
                              @(info.hasControlModule),
                              @(info.hasOBDModule),
                              info.insuranceSaleDate,
                              info.insuranceSaleDateStr,
                              info.msisdn,
                              @(info.nextMaintenMileage),
                              @(info.openObd),
                              info.plateNumber,
                              @(info.preMaintenMileage),
                              info.saleDate,
                              info.saleDateStr,
                              info.serialNumber,
                              info.serviceCode,
                              @(info.terminalID),
                              @(info.tripHidden),
                              @(info.vehicleModelID),
                              info.vehicleModelName,
                              info.vin,
                              info.workTime,
                              info.goHomeTime,
                              @(info.maxStartTimeLength),
                              info.smsCommandsString,
                              info.bluetoothString,
                              info.terminalVersionInfosString,
                              info.statusString];
                }
                
                [resultSet close];
                
                if (result) return ;
                
                *stop = YES;
                index = idx;
                *rollback = YES;
            }];
        }];
        [self.databaseQueue close];
        if (!result) {
            error = [NSError errorWithDomain:@"更新失败" code:-1 userInfo:((SRVehicleBasicInfo *)list[index]).keyValues];
        } else {
            SRLogDebug(@"更新成功");
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            !completeBlock?:completeBlock(error, @(result));
        });
        
    });
    
#if RealmEnable
    [[SRRealm sharedInterface] updateVehicleList:list withCompleteBlock:nil];
#endif
}

- (void)deleteVehicleByVehicleID:(NSInteger)vehicleID withCompleteBlock:(CompleteBlock)completeBlock
{
    if (vehicleID <= 0) {
        SRLogError(@"vehicleID 不能为空");
        NSError *error = [NSError errorWithDomain:@"更新失败, vehicleID 不能为空" code:-1 userInfo:nil];
        !completeBlock?:completeBlock(error, @(NO));
        return;
    }
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
//        [SRUserDefaults deleteVehicleByVehicleID:vehicleID];
        
        NSError *error = nil;
        __block BOOL result = NO;
        [self.databaseQueue inDatabase:^(FMDatabase *db) {
#if DataBaseEncrypd
            [db setKey:DB_ENCRYP_KEY];
#endif
            result = [db executeUpdate:SQL_Delete_Vehicle_By_VehicleID(), @(vehicleID)];
        }];
        [self.databaseQueue close];
        if (!result) {
            error = [NSError errorWithDomain:[NSString stringWithFormat:@"删除失败 %zd", vehicleID]
                                        code:-1 userInfo:nil];
        } else {
            SRLogDebug(@"%zd 删除成功", vehicleID);
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            !completeBlock?:completeBlock(error, @(result));
        });
    
    });
    
#if RealmEnable
    [[SRRealm sharedInterface] deleteVehicleByVehicleID:vehicleID withCompleteBlock:nil];
#endif
}

- (void)deleteVehicleByCustomerID:(NSInteger)customerID withCompleteBlock:(CompleteBlock)completeBlock
{
    if (customerID <= 0) {
        SRLogError(@"customerID 不能为空");
        NSError *error = [NSError errorWithDomain:@"更新失败, customerID 不能为空" code:-1 userInfo:nil];
        !completeBlock?:completeBlock(error, @(NO));
        return;
    }
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
//        [SRUserDefaults deleteVehicleByCustomerID:customerID];
        
        NSError *error = nil;
        __block BOOL result = NO;
        [self.databaseQueue inDatabase:^(FMDatabase *db) {
#if DataBaseEncrypd
            [db setKey:DB_ENCRYP_KEY];
#endif
            result = [db executeUpdate:SQL_Delete_Vehicle_By_CustomerID(), @(customerID)];
        }];
        [self.databaseQueue close];
        if (!result) {
            error = [NSError errorWithDomain:[NSString stringWithFormat:@"删除失败 %zd", customerID]
                                        code:-1 userInfo:nil];
        } else {
            SRLogDebug(@"%zd 删除成功", customerID);
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            !completeBlock?:completeBlock(error, @(result));
        });
    
    });
    
#if RealmEnable
    [[SRRealm sharedInterface] deleteVehicleByCustomerID:customerID withCompleteBlock:nil];
#endif
}

- (void)deleteAllVehicleWithCompleteBlock:(CompleteBlock)completeBlock
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
//        [SRUserDefaults deleteAllVehicle];
        
        NSError *error = nil;
        __block BOOL result = NO;
        [self.databaseQueue inDatabase:^(FMDatabase *db) {
#if DataBaseEncrypd
            [db setKey:DB_ENCRYP_KEY];
#endif
            result = [db executeUpdate:SQL_Delete_Vehicle_All()];
        }];
        [self.databaseQueue close];
        if (!result) {
            error = [NSError errorWithDomain:@"删除失败"
                                        code:-1 userInfo:nil];
        } else {
            SRLogDebug(@"删除成功");
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            !completeBlock?:completeBlock(error, @(result));
        });
        
    });
    
#if RealmEnable
    [[SRRealm sharedInterface] deleteAllVehicleWithCompleteBlock:nil];
#endif
}

- (void)queryVehicleByVehicleID:(NSInteger)vehicleID withCompleteBlock:(CompleteBlock)completeBlock
{
    if (vehicleID <= 0) {
        SRLogError(@"vehicleID 不能为空");
        NSError *error = [NSError errorWithDomain:@"查询失败, vehicleID 不能为空" code:-1 userInfo:nil];
        !completeBlock?:completeBlock(error, @(NO));
        return;
    }
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        __block NSMutableArray *list = [NSMutableArray array];
        [self.databaseQueue inDatabase:^(FMDatabase *db) {
#if DataBaseEncrypd
            [db setKey:DB_ENCRYP_KEY];
#endif
            @autoreleasepool {
                FMResultSet *resultSet = [db executeQuery:SQL_Query_Vehicle_By_VehicleID(), @(vehicleID)];
                while ([resultSet next]) {
                    
                    SRVehicleBasicInfo *basic   = [[SRVehicleBasicInfo alloc] init];
                    basic.vehicleID             = [resultSet stringForColumn:v_vehicleID].integerValue;
                    basic.balance               = [resultSet stringForColumn:v_balance].floatValue;
                    basic.balanceDate           = [resultSet stringForColumn:v_balanceDate];
                    basic.barcode               = [resultSet stringForColumn:v_barcode];
                    basic.brandID               = [resultSet stringForColumn:v_brandID].integerValue;
                    basic.brandName             = [resultSet stringForColumn:v_brandName];
                    basic.color                 = [resultSet stringForColumn:v_color];
                    basic.customerID            = [resultSet stringForColumn:v_customerID].integerValue;
                    basic.customerName          = [resultSet stringForColumn:v_customerName];
                    basic.customerPhone         = [resultSet stringForColumn:v_customerPhone];
                    basic.customized            = [resultSet stringForColumn:v_customized];
                    basic.gotBalance            = [resultSet stringForColumn:v_gotBalance].boolValue;
                    basic.hardware              = [resultSet stringForColumn:v_hardware];
                    basic.has4SModule           = [resultSet stringForColumn:v_has4SModule].boolValue;
                    basic.hasControlModule      = [resultSet stringForColumn:v_hasControlModule].boolValue;
                    basic.hasOBDModule          = [resultSet stringForColumn:v_hasOBDModule].boolValue;
                    basic.insuranceSaleDate     = [resultSet stringForColumn:v_insuranceSaleDate];
                    basic.insuranceSaleDateStr  = [resultSet stringForColumn:v_insuranceSaleDateStr];
                    basic.msisdn                = [resultSet stringForColumn:v_msisdn];
                    basic.nextMaintenMileage    = [resultSet stringForColumn:v_nextMaintenMileage].floatValue;
                    basic.openObd               = [resultSet stringForColumn:v_openObd].boolValue;
                    basic.plateNumber           = [resultSet stringForColumn:v_plateNumber];
                    basic.preMaintenMileage     = [resultSet stringForColumn:v_preMaintenMileage].floatValue;
                    basic.saleDate              = [resultSet stringForColumn:v_saleDate];
                    basic.saleDateStr           = [resultSet stringForColumn:v_saleDateStr];
                    basic.serialNumber          = [resultSet stringForColumn:v_serialNumber];
                    basic.serviceCode           = [resultSet stringForColumn:v_serviceCode];
                    basic.terminalID            = [resultSet stringForColumn:v_terminalID].integerValue;
                    basic.tripHidden            = [resultSet stringForColumn:v_tripHidden].boolValue;
                    basic.vehicleModelID        = [resultSet stringForColumn:v_vehicleModelID].integerValue;
                    basic.vehicleModelName      = [resultSet stringForColumn:v_vehicleModelName];
                    basic.vin                   = [resultSet stringForColumn:v_vin];
                    basic.workTime              = [resultSet stringForColumn:v_workTime];
                    basic.goHomeTime            = [resultSet stringForColumn:v_goHomeTime];
                    basic.maxStartTimeLength    = [resultSet stringForColumn:v_maxStartTimeLength].integerValue;
                    
                    [basic setAbilitiesWithString:[resultSet stringForColumn:v_abilities]];
                    [basic setStatusWithString:[resultSet stringForColumn:v_status]];
                    [basic setBluetoothWithString:[resultSet stringForColumn:v_bluetooth]];
                    [basic setSmsCommandsWithString:[resultSet stringForColumn:v_smsCommands]];
                    [basic setTerminalVersionInfosWithString:[resultSet stringForColumn:v_terminalVersionInfos]];
                    
                    [list addObject:basic];
                }
                
                [resultSet close];
            }
            
        }];
        [self.databaseQueue close];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            !completeBlock?:completeBlock(nil, list);
        });
        
    });
    
#if RealmEnable
    [[SRRealm sharedInterface] queryVehicleByVehicleID:vehicleID withCompleteBlock:nil];
#endif

}

- (void)queryVehicleByCustomerID:(NSInteger)customerID withCompleteBlock:(CompleteBlock)completeBlock
{
    if (customerID <= 0) {
        SRLogError(@"customerID 不能为空");
        NSError *error = [NSError errorWithDomain:@"查询失败, customerID 不能为空" code:-1 userInfo:nil];
        !completeBlock?:completeBlock(error, @(NO));
        return;
    }
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        __block NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        [self.databaseQueue inDatabase:^(FMDatabase *db) {
#if DataBaseEncrypd
            [db setKey:DB_ENCRYP_KEY];
#endif
            @autoreleasepool {
                FMResultSet *resultSet = [db executeQuery:SQL_Query_Vehicle_By_CustomerID(), @(customerID)];
                while ([resultSet next]) {
                    
                    SRVehicleBasicInfo *basic   = [[SRVehicleBasicInfo alloc] init];
                    basic.vehicleID             = [resultSet stringForColumn:v_vehicleID].integerValue;
                    basic.balance               = [resultSet stringForColumn:v_balance].floatValue;
                    basic.balanceDate           = [resultSet stringForColumn:v_balanceDate];
                    basic.barcode               = [resultSet stringForColumn:v_barcode];
                    basic.brandID               = [resultSet stringForColumn:v_brandID].integerValue;
                    basic.brandName             = [resultSet stringForColumn:v_brandName];
                    basic.color                 = [resultSet stringForColumn:v_color];
                    basic.customerID            = [resultSet stringForColumn:v_customerID].integerValue;
                    basic.customerName          = [resultSet stringForColumn:v_customerName];
                    basic.customerPhone         = [resultSet stringForColumn:v_customerPhone];
                    basic.customized            = [resultSet stringForColumn:v_customized];
                    basic.gotBalance            = [resultSet stringForColumn:v_gotBalance].boolValue;
                    basic.hardware              = [resultSet stringForColumn:v_hardware];
                    basic.has4SModule           = [resultSet stringForColumn:v_has4SModule].boolValue;
                    basic.hasControlModule      = [resultSet stringForColumn:v_hasControlModule].boolValue;
                    basic.hasOBDModule          = [resultSet stringForColumn:v_hasOBDModule].boolValue;
                    basic.insuranceSaleDate     = [resultSet stringForColumn:v_insuranceSaleDate];
                    basic.insuranceSaleDateStr  = [resultSet stringForColumn:v_insuranceSaleDateStr];
                    basic.msisdn                = [resultSet stringForColumn:v_msisdn];
                    basic.nextMaintenMileage    = [resultSet stringForColumn:v_nextMaintenMileage].floatValue;
                    basic.openObd               = [resultSet stringForColumn:v_openObd].boolValue;
                    basic.plateNumber           = [resultSet stringForColumn:v_plateNumber];
                    basic.preMaintenMileage     = [resultSet stringForColumn:v_preMaintenMileage].floatValue;
                    basic.saleDate              = [resultSet stringForColumn:v_saleDate];
                    basic.saleDateStr           = [resultSet stringForColumn:v_saleDateStr];
                    basic.serialNumber          = [resultSet stringForColumn:v_serialNumber];
                    basic.serviceCode           = [resultSet stringForColumn:v_serviceCode];
                    basic.terminalID            = [resultSet stringForColumn:v_terminalID].integerValue;
                    basic.tripHidden            = [resultSet stringForColumn:v_tripHidden].boolValue;
                    basic.vehicleModelID        = [resultSet stringForColumn:v_vehicleModelID].integerValue;
                    basic.vehicleModelName      = [resultSet stringForColumn:v_vehicleModelName];
                    basic.vin                   = [resultSet stringForColumn:v_vin];
                    basic.workTime              = [resultSet stringForColumn:v_workTime];
                    basic.goHomeTime            = [resultSet stringForColumn:v_goHomeTime];
                    basic.maxStartTimeLength    = [resultSet stringForColumn:v_maxStartTimeLength].integerValue;
                    
                    [basic setAbilitiesWithString:[resultSet stringForColumn:v_abilities]];
                    [basic setStatusWithString:[resultSet stringForColumn:v_status]];
                    [basic setBluetoothWithString:[resultSet stringForColumn:v_bluetooth]];
                    [basic setSmsCommandsWithString:[resultSet stringForColumn:v_smsCommands]];
                    [basic setTerminalVersionInfosWithString:[resultSet stringForColumn:v_terminalVersionInfos]];
                    
                    [dic setObject:basic forKey:@(basic.vehicleID)];
                }
                
                [resultSet close];
            }
            
        }];
        [self.databaseQueue close];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            !completeBlock?:completeBlock(nil, dic);
        });
        
    });
#if RealmEnable
    [[SRRealm sharedInterface] queryVehicleByCustomerID:customerID withCompleteBlock:nil];
#endif
}

- (void)queryAllVehicleWithCompleteBlock:(CompleteBlock)completeBlock
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        __block NSMutableArray *list = [NSMutableArray array];
        [self.databaseQueue inDatabase:^(FMDatabase *db) {
#if DataBaseEncrypd
            [db setKey:DB_ENCRYP_KEY];
#endif
            @autoreleasepool {
                FMResultSet *resultSet = [db executeQuery:SQL_Query_Vehicle_All()];
                while ([resultSet next]) {
                    
                    SRVehicleBasicInfo *basic   = [[SRVehicleBasicInfo alloc] init];
                    basic.vehicleID             = [resultSet stringForColumn:v_vehicleID].integerValue;
                    basic.balance               = [resultSet stringForColumn:v_balance].floatValue;
                    basic.balanceDate           = [resultSet stringForColumn:v_balanceDate];
                    basic.barcode               = [resultSet stringForColumn:v_barcode];
                    basic.brandID               = [resultSet stringForColumn:v_brandID].integerValue;
                    basic.brandName             = [resultSet stringForColumn:v_brandName];
                    basic.color                 = [resultSet stringForColumn:v_color];
                    basic.customerID            = [resultSet stringForColumn:v_customerID].integerValue;
                    basic.customerName          = [resultSet stringForColumn:v_customerName];
                    basic.customerPhone         = [resultSet stringForColumn:v_customerPhone];
                    basic.customized            = [resultSet stringForColumn:v_customized];
                    basic.gotBalance            = [resultSet stringForColumn:v_gotBalance].boolValue;
                    basic.hardware              = [resultSet stringForColumn:v_hardware];
                    basic.has4SModule           = [resultSet stringForColumn:v_has4SModule].boolValue;
                    basic.hasControlModule      = [resultSet stringForColumn:v_hasControlModule].boolValue;
                    basic.hasOBDModule          = [resultSet stringForColumn:v_hasOBDModule].boolValue;
                    basic.insuranceSaleDate     = [resultSet stringForColumn:v_insuranceSaleDate];
                    basic.insuranceSaleDateStr  = [resultSet stringForColumn:v_insuranceSaleDateStr];
                    basic.msisdn                = [resultSet stringForColumn:v_msisdn];
                    basic.nextMaintenMileage    = [resultSet stringForColumn:v_nextMaintenMileage].floatValue;
                    basic.openObd               = [resultSet stringForColumn:v_openObd].boolValue;
                    basic.plateNumber           = [resultSet stringForColumn:v_plateNumber];
                    basic.preMaintenMileage     = [resultSet stringForColumn:v_preMaintenMileage].floatValue;
                    basic.saleDate              = [resultSet stringForColumn:v_saleDate];
                    basic.saleDateStr           = [resultSet stringForColumn:v_saleDateStr];
                    basic.serialNumber          = [resultSet stringForColumn:v_serialNumber];
                    basic.serviceCode           = [resultSet stringForColumn:v_serviceCode];
                    basic.terminalID            = [resultSet stringForColumn:v_terminalID].integerValue;
                    basic.tripHidden            = [resultSet stringForColumn:v_tripHidden].boolValue;
                    basic.vehicleModelID        = [resultSet stringForColumn:v_vehicleModelID].integerValue;
                    basic.vehicleModelName      = [resultSet stringForColumn:v_vehicleModelName];
                    basic.vin                   = [resultSet stringForColumn:v_vin];
                    basic.workTime              = [resultSet stringForColumn:v_workTime];
                    basic.goHomeTime            = [resultSet stringForColumn:v_goHomeTime];
                    basic.maxStartTimeLength    = [resultSet stringForColumn:v_maxStartTimeLength].integerValue;
                    
                    [basic setAbilitiesWithString:[resultSet stringForColumn:v_abilities]];
                    [basic setStatusWithString:[resultSet stringForColumn:v_status]];
                    [basic setBluetoothWithString:[resultSet stringForColumn:v_bluetooth]];
                    [basic setSmsCommandsWithString:[resultSet stringForColumn:v_smsCommands]];
                    [basic setTerminalVersionInfosWithString:[resultSet stringForColumn:v_terminalVersionInfos]];
                    
                    [list addObject:basic];
                }
                
                [resultSet close];
            }
            
        }];
        [self.databaseQueue close];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            !completeBlock?:completeBlock(nil, list);
        });
        
    });
    
#if RealmEnable
    [[SRRealm sharedInterface] queryAllVehicleWithCompleteBlock:nil];
#endif
}

@end

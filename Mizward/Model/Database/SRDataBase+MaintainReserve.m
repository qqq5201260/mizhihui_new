//
//  SRDataBase+MaintainReserve.m
//  SiRuiV4.0
//
//  Created by zhangjunbo on 15/7/28.
//  Copyright (c) 2015年 SiRui. All rights reserved.
//

#import "SRDataBase+MaintainReserve.h"
#import "SRMaintainReserveInfo.h"
#import <FMDB/FMDB.h>
#import <MJExtension/MJExtension.h>

#import "SRRealm+MaintainReserve.h"

// DB Table
NSString * const SQL_TABLE_Reserve = @"MaintainReserve";

//元素
NSString * const r_maintenReservationID     = @"maintenReservationID";
NSString * const r_maintenID                = @"maintenID";
NSString * const r_currentMileage           = @"currentMileage";
NSString * const r_nextMileage              = @"nextMileage";
NSString * const r_status                   = @"status";
NSString * const r_commonMaintenItemsTop    = @"commonMaintenItemsTop";
NSString * const r_commonMaintenItemsBottom = @"commonMaintenItemsBottom";
NSString * const r_uncommonMaintenItems     = @"uncommonMaintenItems";
NSString * const r_vehicleID                = @"vehicleID";
NSString * const r_customerID               = @"customerID";

//SQL 语句
static inline NSString * SQL_Creat_ReserveTable () {
    static NSMutableString * SQL_Creat_ReserveTable;
    if (SQL_Creat_ReserveTable) {
        return SQL_Creat_ReserveTable;
    }
    
    SQL_Creat_ReserveTable = [NSMutableString string];
    [SQL_Creat_ReserveTable appendFormat:@"CREATE TABLE IF NOT EXISTS %@ ", SQL_TABLE_Reserve];
    [SQL_Creat_ReserveTable appendFormat:@"("];
    [SQL_Creat_ReserveTable appendFormat:@"%@ INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL ,", r_vehicleID];
    [SQL_Creat_ReserveTable appendFormat:@"%@ INTEGER   , " , r_customerID];
    [SQL_Creat_ReserveTable appendFormat:@"%@ INTEGER   , " , r_maintenReservationID];
    [SQL_Creat_ReserveTable appendFormat:@"%@ INTEGER   , " , r_maintenID];
    [SQL_Creat_ReserveTable appendFormat:@"%@ FLOAT     , " , r_currentMileage];
    [SQL_Creat_ReserveTable appendFormat:@"%@ FLOAT     , " , r_nextMileage];
    [SQL_Creat_ReserveTable appendFormat:@"%@ INTEGER   , " , r_status];
    [SQL_Creat_ReserveTable appendFormat:@"%@ TEXT      , " , r_commonMaintenItemsTop];
    [SQL_Creat_ReserveTable appendFormat:@"%@ TEXT      , " , r_commonMaintenItemsBottom];
    [SQL_Creat_ReserveTable appendFormat:@"%@ TEXT        " , r_uncommonMaintenItems];
    
    [SQL_Creat_ReserveTable appendFormat:@")"];
    
    return SQL_Creat_ReserveTable;
}

static inline NSString * SQL_Insert_Reserve () {
    static NSMutableString * SQL_Insert_Reserve;
    if (SQL_Insert_Reserve) {
        return SQL_Insert_Reserve;
    }
    
    SQL_Insert_Reserve = [NSMutableString string];
    [SQL_Insert_Reserve appendFormat:@"INSERT INTO %@ ", SQL_TABLE_Reserve];
    [SQL_Insert_Reserve appendFormat:@"("];
    [SQL_Insert_Reserve appendFormat:@"%@ , " , r_vehicleID];
    [SQL_Insert_Reserve appendFormat:@"%@ , " , r_customerID];
    [SQL_Insert_Reserve appendFormat:@"%@ , " , r_maintenReservationID];
    [SQL_Insert_Reserve appendFormat:@"%@ , " , r_maintenID];
    [SQL_Insert_Reserve appendFormat:@"%@ , " , r_currentMileage];
    [SQL_Insert_Reserve appendFormat:@"%@ , " , r_nextMileage];
    [SQL_Insert_Reserve appendFormat:@"%@ , " , r_status];
    [SQL_Insert_Reserve appendFormat:@"%@ , " , r_commonMaintenItemsTop];
    [SQL_Insert_Reserve appendFormat:@"%@ , " , r_commonMaintenItemsBottom];
    [SQL_Insert_Reserve appendFormat:@"%@   " , r_uncommonMaintenItems];
    [SQL_Insert_Reserve appendFormat:@")"];
    [SQL_Insert_Reserve appendFormat:@"VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)"];
    
    return SQL_Insert_Reserve;
}

static inline NSString * SQL_Update_Reserve_By_VehicleID () {
    static NSMutableString * SQL_Update_Reserve_By_VehicleID;
    if (SQL_Update_Reserve_By_VehicleID) {
        return SQL_Update_Reserve_By_VehicleID;
    }
    
    SQL_Update_Reserve_By_VehicleID = [NSMutableString string];
    [SQL_Update_Reserve_By_VehicleID appendFormat:@"UPDATE %@ SET ", SQL_TABLE_Reserve];
    [SQL_Update_Reserve_By_VehicleID appendFormat:@"%@ = ?, " , r_vehicleID];
    [SQL_Update_Reserve_By_VehicleID appendFormat:@"%@ = ?, " , r_customerID];
    [SQL_Update_Reserve_By_VehicleID appendFormat:@"%@ = ?, " , r_maintenReservationID];
    [SQL_Update_Reserve_By_VehicleID appendFormat:@"%@ = ?, " , r_maintenID];
    [SQL_Update_Reserve_By_VehicleID appendFormat:@"%@ = ?, " , r_currentMileage];
    [SQL_Update_Reserve_By_VehicleID appendFormat:@"%@ = ?, " , r_nextMileage];
    [SQL_Update_Reserve_By_VehicleID appendFormat:@"%@ = ?, " , r_status];
    [SQL_Update_Reserve_By_VehicleID appendFormat:@"%@ = ?, " , r_commonMaintenItemsTop];
    [SQL_Update_Reserve_By_VehicleID appendFormat:@"%@ = ?, " , r_commonMaintenItemsBottom];
    [SQL_Update_Reserve_By_VehicleID appendFormat:@"%@ = ?  " , r_uncommonMaintenItems];
    [SQL_Update_Reserve_By_VehicleID appendFormat:@"WHERE %@ = ?  ", r_vehicleID];
    
    return SQL_Update_Reserve_By_VehicleID;
}

static inline NSString * SQL_Delete_Reserve_By_VehicleID () {
    static NSMutableString * SQL_Delete_Reserve_By_VehicleID;
    if (SQL_Delete_Reserve_By_VehicleID) {
        return SQL_Delete_Reserve_By_VehicleID;
    }
    
    SQL_Delete_Reserve_By_VehicleID = [NSMutableString string];
    [SQL_Delete_Reserve_By_VehicleID appendFormat:@"DELETE FROM %@ ", SQL_TABLE_Reserve];
    [SQL_Delete_Reserve_By_VehicleID appendFormat:@"WHERE %@ = ?", r_vehicleID];
    return SQL_Delete_Reserve_By_VehicleID;
}

static inline NSString * SQL_Delete_Reserve_All () {
    static NSMutableString * SQL_Delete_Reserve_All;
    if (SQL_Delete_Reserve_All) {
        return SQL_Delete_Reserve_All;
    }
    
    SQL_Delete_Reserve_All = [NSMutableString string];
    [SQL_Delete_Reserve_All appendFormat:@"DELETE FROM %@ ", SQL_TABLE_Reserve];
    return SQL_Delete_Reserve_All;
}

static inline NSString * SQL_Query_Reserve_By_VehicleID () {
    static NSMutableString * SQL_Query_Reserve_By_VehicleID;
    if (SQL_Query_Reserve_By_VehicleID) {
        return SQL_Query_Reserve_By_VehicleID;
    }
    
    SQL_Query_Reserve_By_VehicleID = [NSMutableString string];
    [SQL_Query_Reserve_By_VehicleID appendFormat:@"SELECT * FROM %@ ", SQL_TABLE_Reserve];
    [SQL_Query_Reserve_By_VehicleID appendFormat:@"WHERE %@ = ?", r_vehicleID];
    return SQL_Query_Reserve_By_VehicleID;
}

@implementation SRDataBase (MaintainReserve)

- (void)createMaintainReserveTable
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self.databaseQueue inDatabase:^(FMDatabase *db) {
#if DataBaseEncrypd
            [db setKey:DB_ENCRYP_KEY];
#endif
            [db setShouldCacheStatements:YES];
            
            if ([db tableExists:SQL_TABLE_Reserve]) {
                [self checkMaintainReserveColumn:db];
                return ;
            };
            
            if ([db executeUpdate:SQL_Creat_ReserveTable()]) {
                SRLogDebug(@"Reserve 表创建成功");
            } else {
                SRLogError(@"Reserve 表创建失败");
            }
        }];
        [self.databaseQueue close];
    });
}

- (void)checkMaintainReserveColumn:(FMDatabase *)db
{
    
}

- (void)updateMaintainReserveInfo:(SRMaintainReserveInfo *)info withCompleteBlock:(CompleteBlock)completeBlock
{
    if (!info) {
        SRLogError(@"info 不能为空");
        NSError *error = [NSError errorWithDomain:@"更新失败, info 不能为空" code:-1 userInfo:nil];
        !completeBlock?:completeBlock(error, @(NO));
        return;
    }
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSError *error = nil;
        __block BOOL result = NO;
        [self.databaseQueue inDatabase:^(FMDatabase *db) {
#if DataBaseEncrypd
            [db setKey:DB_ENCRYP_KEY];
#endif
            FMResultSet *resultSet = [db executeQuery:SQL_Query_Reserve_By_VehicleID(), @(info.vehicleID)];
            if (resultSet.next) {
                result = [db executeUpdate:SQL_Update_Reserve_By_VehicleID(),
                          @(info.vehicleID),
                          @(info.customerID),
                          @(info.maintenReservationID),
                          @(info.maintenID),
                          @(info.currentMileage),
                          @(info.nextMileage),
                          @(info.status),
                          info.commonMaintenItemsTopString,
                          info.commonMaintenItemsBottomString,
                          info.uncommonMaintenItemsString,
                          @(info.vehicleID)];
            } else {
                result = [db executeUpdate:SQL_Insert_Reserve(),
                          @(info.vehicleID),
                          @(info.customerID),
                          @(info.maintenReservationID),
                          @(info.maintenID),
                          @(info.currentMileage),
                          @(info.nextMileage),
                          @(info.status),
                          info.commonMaintenItemsTopString,
                          info.commonMaintenItemsBottomString,
                          info.uncommonMaintenItemsString];
            }
            [resultSet close];
        }];
        [self.databaseQueue close];
        if (!result) {
            error = [NSError errorWithDomain:@"更新失败" code:-1 userInfo:info.keyValues];
        } else {
            SRLogDebug(@"更新成功");
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            !completeBlock?:completeBlock(error, @(result));
        });
        
    });
    
#if RealmEnable
    [[SRRealm sharedInterface] updateMaintainReserveInfo:info withCompleteBlock:nil];
#endif
}

- (void)deleteAllMaintainReserveInfoWithCompleteBlock:(CompleteBlock)completeBlock;
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSError *error = nil;
        __block BOOL result = NO;
        [self.databaseQueue inDatabase:^(FMDatabase *db) {
#if DataBaseEncrypd
            [db setKey:DB_ENCRYP_KEY];
#endif
            result = [db executeUpdate:SQL_Delete_Reserve_All()];
        }];
        [self.databaseQueue close];
        if (!result) {
            error = [NSError errorWithDomain:[NSString stringWithFormat:@"删除失败"]
                                        code:-1 userInfo:nil];
        } else {
            SRLogDebug(@"删除成功");
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            !completeBlock?:completeBlock(error, @(result));
        });
        
    });
    
#if RealmEnable
    [[SRRealm sharedInterface] deleteAllMaintainReserveInfoWithCompleteBlock:nil];
#endif
}

- (void)deleteMaintainReserveInfoByVehicleID:(NSInteger)vehicleID withCompleteBlock:(CompleteBlock)completeBlock
{
    if (vehicleID <= 0) {
        SRLogError(@"vehicleID 不能为空");
        NSError *error = [NSError errorWithDomain:@"更新失败, vehicleID 不能为空" code:-1 userInfo:nil];
        !completeBlock?:completeBlock(error, @(NO));
        return;
    }
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSError *error = nil;
        __block BOOL result = NO;
        [self.databaseQueue inDatabase:^(FMDatabase *db) {
#if DataBaseEncrypd
            [db setKey:DB_ENCRYP_KEY];
#endif
            result = [db executeUpdate:SQL_Delete_Reserve_By_VehicleID(), @(vehicleID)];
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
    [[SRRealm sharedInterface] deleteMaintainReserveInfoByVehicleID:vehicleID withCompleteBlock:nil];
#endif
}

- (void)queryMaintainReserveInfoByVehicleID:(NSInteger)vehicleID withCompleteBlock:(CompleteBlock)completeBlock
{
    if (vehicleID <= 0) {
        SRLogError(@"vehicleID 不能为空");
        NSError *error = [NSError errorWithDomain:@"更新失败, vehicleID 不能为空" code:-1 userInfo:nil];
        !completeBlock?:completeBlock(error, nil);
        return;
    }
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        __block NSMutableArray *list = [NSMutableArray array];
        [self.databaseQueue inDatabase:^(FMDatabase *db) {
#if DataBaseEncrypd
            [db setKey:DB_ENCRYP_KEY];
#endif

            @autoreleasepool {
                FMResultSet *resultSet = [db executeQuery:SQL_Query_Reserve_By_VehicleID(), @(vehicleID)];
                while ([resultSet next]) {
                    SRMaintainReserveInfo *info = [[SRMaintainReserveInfo alloc] init];
                    info.maintenReservationID   = [resultSet intForColumn:r_maintenReservationID];
                    info.maintenID              = [resultSet intForColumn:r_maintenID];
                    info.currentMileage         = [resultSet doubleForColumn:r_currentMileage];
                    info.nextMileage            = [resultSet doubleForColumn:r_nextMileage];
                    info.status                 = [resultSet intForColumn:r_status];
                    info.vehicleID              = [resultSet intForColumn:r_vehicleID];
                    info.customerID             = [resultSet intForColumn:r_customerID];
                    
                    [info setCommonMaintenItemsTopWithString:[resultSet stringForColumn:r_commonMaintenItemsTop]];
                    [info setCommonMaintenItemsBottomWithString:[resultSet stringForColumn:r_commonMaintenItemsBottom]];
                    [info setUncommonMaintenItemsWithString:[resultSet stringForColumn:r_uncommonMaintenItems]];
                    
                    [list addObject:info];
                }
                [resultSet close];
            }
            
        }];
        [self.databaseQueue close];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            !completeBlock?:completeBlock(nil, list.count>0?[list firstObject]:nil);
        });
        
    });
    
#if RealmEnable
    [[SRRealm sharedInterface] queryMaintainReserveInfoByVehicleID:vehicleID withCompleteBlock:nil];
#endif

}

@end

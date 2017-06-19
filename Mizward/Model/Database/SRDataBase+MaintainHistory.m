//
//  SRDataBase+MaintainHistory.m
//  SiRuiV4.0
//
//  Created by zhangjunbo on 15/7/29.
//  Copyright (c) 2015年 SiRui. All rights reserved.
//

#import "SRDataBase+MaintainHistory.h"
#import "SRMaintainHistory.h"
#import <FMDB/FMDB.h>
#import <MJExtension/MJExtension.h>

#import "SRRealm+MaintainHistory.h"

// DB Table
NSString * const SQL_TABLE_History = @"MaintainHistory";

//元素
NSString * const h_maintenReservationID = @"maintenReservationID";
NSString * const h_maintenID            = @"maintenID";
NSString * const h_customerID           = @"customerID";
NSString * const h_vehicleID            = @"vehicleID";
NSString * const h_depID                = @"depID";
NSString * const h_depName              = @"depName";
NSString * const h_currentMileage       = @"currentMileage";
NSString * const h_fee                  = @"fee";
NSString * const h_status               = @"status";
NSString * const h_type                 = @"type";
NSString * const h_isIgnore             = @"isIgnore";
NSString * const h_startTimeStr         = @"startTimeStr";
NSString * const h_commonMaintenItems   = @"commonMaintenItems";
NSString * const h_uncommonMaintenItems = @"uncommonMaintenItems";
NSString * const h_defineMaintenItems   = @"defineMaintenItems";

//SQL 语句
static inline NSString * SQL_Creat_HistoryTable () {
    static NSMutableString * SQL_Creat_HistoryTable;
    if (SQL_Creat_HistoryTable) {
        return SQL_Creat_HistoryTable;
    }
    
    SQL_Creat_HistoryTable = [NSMutableString string];
    [SQL_Creat_HistoryTable appendFormat:@"CREATE TABLE IF NOT EXISTS %@ ", SQL_TABLE_History];
    [SQL_Creat_HistoryTable appendFormat:@"("];
    [SQL_Creat_HistoryTable appendFormat:@"%@ INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL ,", h_maintenReservationID];
    [SQL_Creat_HistoryTable appendFormat:@"%@ INTEGER       , " , h_maintenID];
    [SQL_Creat_HistoryTable appendFormat:@"%@ INTEGER       , " , h_customerID];
    [SQL_Creat_HistoryTable appendFormat:@"%@ INTEGER       , " , h_vehicleID];
    [SQL_Creat_HistoryTable appendFormat:@"%@ INTEGER       , " , h_depID];
    [SQL_Creat_HistoryTable appendFormat:@"%@ VARCHAR(256)  , " , h_depName];
    [SQL_Creat_HistoryTable appendFormat:@"%@ FLOAT         , " , h_currentMileage];
    [SQL_Creat_HistoryTable appendFormat:@"%@ FLOAT         , " , h_fee];
    [SQL_Creat_HistoryTable appendFormat:@"%@ INTEGER       , " , h_status];
    [SQL_Creat_HistoryTable appendFormat:@"%@ INTEGER       , " , h_type];
    [SQL_Creat_HistoryTable appendFormat:@"%@ BIT           , " , h_isIgnore];
    [SQL_Creat_HistoryTable appendFormat:@"%@ VARCHAR(256)  , " , h_startTimeStr];
    [SQL_Creat_HistoryTable appendFormat:@"%@ TEXT          , " , h_commonMaintenItems];
    [SQL_Creat_HistoryTable appendFormat:@"%@ TEXT          , " , h_uncommonMaintenItems];
    [SQL_Creat_HistoryTable appendFormat:@"%@ TEXT            " , h_defineMaintenItems];
    [SQL_Creat_HistoryTable appendFormat:@")"];
    
    return SQL_Creat_HistoryTable;
}

static inline NSString * SQL_Insert_History () {
    static NSMutableString * SQL_Insert_History;
    if (SQL_Insert_History) {
        return SQL_Insert_History;
    }
    
    SQL_Insert_History = [NSMutableString string];
    [SQL_Insert_History appendFormat:@"INSERT INTO %@ ", SQL_TABLE_History];
    [SQL_Insert_History appendFormat:@"("];
    [SQL_Insert_History appendFormat:@"%@ , " , h_maintenReservationID];
    [SQL_Insert_History appendFormat:@"%@ , " , h_maintenID];
    [SQL_Insert_History appendFormat:@"%@ , " , h_customerID];
    [SQL_Insert_History appendFormat:@"%@ , " , h_vehicleID];
    [SQL_Insert_History appendFormat:@"%@ , " , h_depID];
    [SQL_Insert_History appendFormat:@"%@ , " , h_depName];
    [SQL_Insert_History appendFormat:@"%@ , " , h_currentMileage];
    [SQL_Insert_History appendFormat:@"%@ , " , h_fee];
    [SQL_Insert_History appendFormat:@"%@ , " , h_status];
    [SQL_Insert_History appendFormat:@"%@ , " , h_type];
    [SQL_Insert_History appendFormat:@"%@ , " , h_isIgnore];
    [SQL_Insert_History appendFormat:@"%@ , " , h_startTimeStr];
    [SQL_Insert_History appendFormat:@"%@ , " , h_commonMaintenItems];
    [SQL_Insert_History appendFormat:@"%@ , " , h_uncommonMaintenItems];
    [SQL_Insert_History appendFormat:@"%@   " , h_defineMaintenItems];
    [SQL_Insert_History appendFormat:@")"];
    [SQL_Insert_History appendFormat:@"VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)"];
    
    return SQL_Insert_History;
}

static inline NSString * SQL_Update_History () {
    static NSMutableString * SQL_Update_History;
    if (SQL_Update_History) {
        return SQL_Update_History;
    }
    
    SQL_Update_History = [NSMutableString string];
    [SQL_Update_History appendFormat:@"UPDATE %@ SET ", SQL_TABLE_History];
    [SQL_Update_History appendFormat:@"%@ = ?, " , h_maintenReservationID];
    [SQL_Update_History appendFormat:@"%@ = ?, " , h_maintenID];
    [SQL_Update_History appendFormat:@"%@ = ?, " , h_customerID];
    [SQL_Update_History appendFormat:@"%@ = ?, " , h_vehicleID];
    [SQL_Update_History appendFormat:@"%@ = ?, " , h_depID];
    [SQL_Update_History appendFormat:@"%@ = ?, " , h_depName];
    [SQL_Update_History appendFormat:@"%@ = ?, " , h_currentMileage];
    [SQL_Update_History appendFormat:@"%@ = ?, " , h_fee];
    [SQL_Update_History appendFormat:@"%@ = ?, " , h_status];
    [SQL_Update_History appendFormat:@"%@ = ?, " , h_type];
    [SQL_Update_History appendFormat:@"%@ = ?, " , h_isIgnore];
    [SQL_Update_History appendFormat:@"%@ = ?, " , h_startTimeStr];
    [SQL_Update_History appendFormat:@"%@ = ?, " , h_commonMaintenItems];
    [SQL_Update_History appendFormat:@"%@ = ?, " , h_uncommonMaintenItems];
    [SQL_Update_History appendFormat:@"%@ = ?  " , h_defineMaintenItems];
    [SQL_Update_History appendFormat:@"WHERE %@ = ?  ", h_maintenReservationID];
    
    return SQL_Update_History;
}

static inline NSString * SQL_Delete_History_All () {
    static NSMutableString * SQL_Delete_History_All;
    if (SQL_Delete_History_All) {
        return SQL_Delete_History_All;
    }
    
    SQL_Delete_History_All = [NSMutableString string];
    [SQL_Delete_History_All appendFormat:@"DELETE FROM %@ ", SQL_TABLE_History];
    return SQL_Delete_History_All;
}

static inline NSString * SQL_Delete_History_By_ReservationID () {
    static NSMutableString * SQL_Delete_History_By_ReservationID;
    if (SQL_Delete_History_By_ReservationID) {
        return SQL_Delete_History_By_ReservationID;
    }
    
    SQL_Delete_History_By_ReservationID = [NSMutableString string];
    [SQL_Delete_History_By_ReservationID appendFormat:@"DELETE FROM %@ ", SQL_TABLE_History];
    [SQL_Delete_History_By_ReservationID appendFormat:@"WHERE %@ = ?", h_maintenReservationID];
    return SQL_Delete_History_By_ReservationID;
}

static inline NSString * SQL_Query_History_By_ReservationID () {
    static NSMutableString * SQL_Query_History_By_ReservationID;
    if (SQL_Query_History_By_ReservationID) {
        return SQL_Query_History_By_ReservationID;
    }
    
    SQL_Query_History_By_ReservationID = [NSMutableString string];
    [SQL_Query_History_By_ReservationID appendFormat:@"SELECT * FROM %@ ", SQL_TABLE_History];
    [SQL_Query_History_By_ReservationID appendFormat:@"WHERE %@ = ?", h_maintenReservationID];
    return SQL_Query_History_By_ReservationID;
}

static inline NSString * SQL_Query_History_By_VehicleID () {
    static NSMutableString * SQL_Query_History_By_VehicleID;
    if (SQL_Query_History_By_VehicleID) {
        return SQL_Query_History_By_VehicleID;
    }
    
    SQL_Query_History_By_VehicleID = [NSMutableString string];
    [SQL_Query_History_By_VehicleID appendFormat:@"SELECT * FROM %@ ", SQL_TABLE_History];
    [SQL_Query_History_By_VehicleID appendFormat:@"WHERE %@ = ? ", h_vehicleID];
    [SQL_Query_History_By_VehicleID appendFormat:@"ORDER BY %@ DESC, %@ DESC", h_startTimeStr, h_maintenReservationID]; //降序
    return SQL_Query_History_By_VehicleID;
}

@implementation SRDataBase (MaintainHistory)

- (void)createMaintainHistoryTable
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self.databaseQueue inDatabase:^(FMDatabase *db) {
#if DataBaseEncrypd
            [db setKey:DB_ENCRYP_KEY];
#endif
            [db setShouldCacheStatements:YES];
            
            if ([db tableExists:SQL_TABLE_History]) return ;
            
            if ([db executeUpdate:SQL_Creat_HistoryTable()]) {
                SRLogDebug(@"History 表创建成功");
            } else {
                SRLogError(@"History 表创建失败");
            }
        }];
        [self.databaseQueue close];
    });
}

- (void)updateMaintainHistoryList:(NSArray *)list withCompleteBlock:(CompleteBlock)completeBlock
{
    if (!list || list.count==0) {
        !completeBlock?:completeBlock(nil, @(YES));
        return;
    }
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSError *error = nil;
        __block NSInteger index = 0;
        __block BOOL result = NO;
        [self.databaseQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
#if DataBaseEncrypd
            [db setKey:DB_ENCRYP_KEY];
#endif
            
            [list enumerateObjectsUsingBlock:^(SRMaintainHistory *info, NSUInteger idx, BOOL *stop) {
                
                FMResultSet *resultSet = [db executeQuery:SQL_Query_History_By_ReservationID(), @(info.maintenReservationID)];
                if (resultSet.next) {
                    //                    SRLogDebug(@"存在相同数据，改为更新");
                    //更新
                    result = [db executeUpdate:SQL_Update_History(),
                              @(info.maintenReservationID),
                              @(info.maintenID),
                              @(info.customerID),
                              @(info.vehicleID),
                              @(info.depID),
                              info.depName,
                              @(info.currentMileage),
                              @(info.fee),
                              @(info.status),
                              @(info.type),
                              @(info.isIgnore),
                              info.startTimeStr,
                              info.commonMaintenItemsString,
                              info.uncommonMaintenItemsString,
                              info.defineMaintenItemsString,
                              @(info.maintenReservationID)];
                } else {
                    //插入
                    result = [db executeUpdate:SQL_Insert_History(),
                              @(info.maintenReservationID),
                              @(info.maintenID),
                              @(info.customerID),
                              @(info.vehicleID),
                              @(info.depID),
                              info.depName,
                              @(info.currentMileage),
                              @(info.fee),
                              @(info.status),
                               @(info.type),
                              @(info.isIgnore),
                              info.startTimeStr,
                              info.commonMaintenItemsString,
                              info.uncommonMaintenItemsString,
                              info.defineMaintenItemsString];
                }
                
                [resultSet close];
                
                if (result) return;
                
                *stop = YES;
                index = idx;
                *rollback = YES;
            }];
        }];
        [self.databaseQueue close];
        if (!result) {
            error = [NSError errorWithDomain:@"写入失败" code:-1 userInfo:((SRMaintainHistory *)list[index]).keyValues];
        } else {
            SRLogDebug(@"插入成功");
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            !completeBlock?:completeBlock(error, @(result));
        });
        
    });
    
#if RealmEnable
    [[SRRealm sharedInterface] updateMaintainHistoryList:list withCompleteBlock:nil];
#endif

}

- (void)deleteAllMaintainHistoryWithCompleteBlock:(CompleteBlock)completeBlock
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSError *error = nil;
        __block BOOL result = NO;
        [self.databaseQueue inDatabase:^(FMDatabase *db) {
#if DataBaseEncrypd
            [db setKey:DB_ENCRYP_KEY];
#endif
            result = [db executeUpdate:SQL_Delete_History_All()];
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
    [[SRRealm sharedInterface] deleteAllMaintainHistoryWithCompleteBlock:nil];
#endif
}

- (void)deleteMaintainHistoryByMaintenReservationID:(NSInteger)maintenReservationID withCompleteBlock:(CompleteBlock)completeBlock
{
    if (maintenReservationID <= 0) {
        SRLogError(@"maintenReservationID 不能为空");
        NSError *error = [NSError errorWithDomain:@"删除失败, maintenReservationID 不能为空" code:-1 userInfo:nil];
        !completeBlock?:completeBlock(error, nil);
        return;
    }
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSError *error = nil;
        __block BOOL result = NO;
        [self.databaseQueue inDatabase:^(FMDatabase *db) {
#if DataBaseEncrypd
            [db setKey:DB_ENCRYP_KEY];
#endif
            result = [db executeUpdate:SQL_Delete_History_By_ReservationID(), @(maintenReservationID)];
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
//    [[SRRealm sharedInterface] deleteAllMaintainHistoryWithCompleteBlock:nil];
#endif
}

- (void)queryAllMaintainHistoryByVehicleID:(NSInteger)vehicleID withCompleteBlock:(CompleteBlock)completeBlock
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
                FMResultSet *resultSet = [db executeQuery:SQL_Query_History_By_VehicleID(), @(vehicleID)];
                while ([resultSet next]) {
                    SRMaintainHistory *info     = [[SRMaintainHistory alloc] init];
                    info.maintenReservationID   = [resultSet intForColumn:h_maintenReservationID];
                    info.maintenID              = [resultSet intForColumn:h_maintenID];
                    info.customerID             = [resultSet intForColumn:h_customerID];
                    info.vehicleID              = [resultSet intForColumn:h_vehicleID];
                    info.depID                  = [resultSet intForColumn:h_depID];
                    info.depName                = [resultSet stringForColumn:h_depName];
                    info.currentMileage         = [resultSet doubleForColumn:h_currentMileage];
                    info.fee                    = [resultSet doubleForColumn:h_fee];
                    info.status                 = [resultSet intForColumn:h_status];
                    info.type                   = [resultSet intForColumn:h_type];
                    info.isIgnore               = [resultSet boolForColumn:h_isIgnore];
                    info.startTimeStr           = [resultSet stringForColumn:h_startTimeStr];
                    
                    [info setCommonMaintenItemsWithString:[resultSet stringForColumn:h_commonMaintenItems]];
                    [info setUncommonMaintenItemsWithString:[resultSet stringForColumn:h_uncommonMaintenItems]];
                    [info setDefineMaintenItemsWithString:[resultSet stringForColumn:h_defineMaintenItems]];
                    
                    [list addObject:info];
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
    [[SRRealm sharedInterface] queryAllMaintainHistoryByVehicleID:vehicleID withCompleteBlock:nil];
#endif

}

@end

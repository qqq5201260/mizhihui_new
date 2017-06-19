//
//  SRDataBase+Trip.m
//  SiRuiV4.0
//
//  Created by zhangjunbo on 15/6/16.
//  Copyright (c) 2015年 SiRui. All rights reserved.
//

#import "SRDataBase+Trip.h"
#import "SRTripInfo.h"
#import <DateTools/DateTools.h>
#import <FMDB/FMDB.h>
#import <MJExtension/MJExtension.h>

#import "SRRealm+Trip.h"

// DB Table
NSString * const SQL_TABLE_Trip = @"Trip";

//元素
NSString * const t_tripID       = @"tripID";

NSString * const t_startTime    = @"startTime";
NSString * const t_endTime      = @"endTime";
NSString * const t_mileage      = @"mileage";
NSString * const t_fuelCons     = @"fuelCons";
NSString * const t_avgFuelCons  = @"avgFuelCons";
NSString * const t_fee          = @"fee";
NSString * const t_startLat     = @"startLat";
NSString * const t_startLng     = @"startLng";
NSString * const t_endLat       = @"endLat";
NSString * const t_endLng       = @"endLng";
NSString * const t_vehicleID    = @"vehicleID";

//SQL 语句
static inline NSString * SQL_Creat_TripTable () {
    static NSMutableString * SQL_Creat_TripTable;
    if (SQL_Creat_TripTable) {
        return SQL_Creat_TripTable;
    }
    
    SQL_Creat_TripTable = [NSMutableString string];
    [SQL_Creat_TripTable appendFormat:@"CREATE TABLE IF NOT EXISTS %@ ", SQL_TABLE_Trip];
    [SQL_Creat_TripTable appendFormat:@"("];
    [SQL_Creat_TripTable appendFormat:@"%@ VARCHAR(256) PRIMARY KEY NOT NULL ,", t_tripID];
    [SQL_Creat_TripTable appendFormat:@"%@ VARCHAR(64)  , " , t_startTime];
    [SQL_Creat_TripTable appendFormat:@"%@ VARCHAR(64)  , " , t_endTime];
    [SQL_Creat_TripTable appendFormat:@"%@ FLOAT        , " , t_mileage];
    [SQL_Creat_TripTable appendFormat:@"%@ FLOAT        , " , t_fuelCons];
    [SQL_Creat_TripTable appendFormat:@"%@ FLOAT        , " , t_avgFuelCons];
    [SQL_Creat_TripTable appendFormat:@"%@ FLOAT        , " , t_fee];
    [SQL_Creat_TripTable appendFormat:@"%@ FLOAT        , " , t_startLat];
    [SQL_Creat_TripTable appendFormat:@"%@ FLOAT        , " , t_startLng];
    [SQL_Creat_TripTable appendFormat:@"%@ FLOAT        , " , t_endLat];
    [SQL_Creat_TripTable appendFormat:@"%@ FLOAT        , " , t_endLng];
    [SQL_Creat_TripTable appendFormat:@"%@ INTEGER        " , t_vehicleID];
    [SQL_Creat_TripTable appendFormat:@")"];
    
    return SQL_Creat_TripTable;
}

static inline NSString * SQL_Insert_Trip () {
    static NSMutableString * SQL_Insert_Trip;
    if (SQL_Insert_Trip) {
        return SQL_Insert_Trip;
    }
    
    SQL_Insert_Trip = [NSMutableString string];
    [SQL_Insert_Trip appendFormat:@"INSERT INTO %@ ", SQL_TABLE_Trip];
    [SQL_Insert_Trip appendFormat:@"("];
    [SQL_Insert_Trip appendFormat:@"%@ , " , t_tripID];
    [SQL_Insert_Trip appendFormat:@"%@ , " , t_startTime];
    [SQL_Insert_Trip appendFormat:@"%@ , " , t_endTime];
    [SQL_Insert_Trip appendFormat:@"%@ , " , t_mileage];
    [SQL_Insert_Trip appendFormat:@"%@ , " , t_fuelCons];
    [SQL_Insert_Trip appendFormat:@"%@ , " , t_avgFuelCons];
    [SQL_Insert_Trip appendFormat:@"%@ , " , t_fee];
    [SQL_Insert_Trip appendFormat:@"%@ , " , t_startLat];
    [SQL_Insert_Trip appendFormat:@"%@ , " , t_startLng];
    [SQL_Insert_Trip appendFormat:@"%@ , " , t_endLat];
    [SQL_Insert_Trip appendFormat:@"%@ , " , t_endLng];
    [SQL_Insert_Trip appendFormat:@"%@   " , t_vehicleID];
    [SQL_Insert_Trip appendFormat:@")"];
    [SQL_Insert_Trip appendFormat:@"VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)"];
    
    return SQL_Insert_Trip;
}

static inline NSString * SQL_Update_Trip () {
    static NSMutableString * SQL_Update_Trip;
    if (SQL_Update_Trip) {
        return SQL_Update_Trip;
    }
    
    SQL_Update_Trip = [NSMutableString string];
    [SQL_Update_Trip appendFormat:@"UPDATE %@ SET ", SQL_TABLE_Trip];
    [SQL_Update_Trip appendFormat:@"%@ = ?, " , t_tripID];
    [SQL_Update_Trip appendFormat:@"%@ = ?, " , t_startTime];
    [SQL_Update_Trip appendFormat:@"%@ = ?, " , t_endTime];
    [SQL_Update_Trip appendFormat:@"%@ = ?, " , t_mileage];
    [SQL_Update_Trip appendFormat:@"%@ = ?, " , t_fuelCons];
    [SQL_Update_Trip appendFormat:@"%@ = ?, " , t_avgFuelCons];
    [SQL_Update_Trip appendFormat:@"%@ = ?, " , t_fee];
    [SQL_Update_Trip appendFormat:@"%@ = ?, " , t_startLat];
    [SQL_Update_Trip appendFormat:@"%@ = ?, " , t_startLng];
    [SQL_Update_Trip appendFormat:@"%@ = ?, " , t_endLat];
    [SQL_Update_Trip appendFormat:@"%@ = ?, " , t_endLng];
    [SQL_Update_Trip appendFormat:@"%@ = ?  " , t_vehicleID];
    [SQL_Update_Trip appendFormat:@"WHERE %@ = ?" , t_tripID];
    
    return SQL_Update_Trip;
}


static inline NSString * SQL_Delete_Trip_By_VehicleID () {
    static NSMutableString * SQL_Delete_Trip_By_VehicleID;
    if (SQL_Delete_Trip_By_VehicleID) {
        return SQL_Delete_Trip_By_VehicleID;
    }
    
    SQL_Delete_Trip_By_VehicleID = [NSMutableString string];
    [SQL_Delete_Trip_By_VehicleID appendFormat:@"DELETE FROM %@ ", SQL_TABLE_Trip];
    [SQL_Delete_Trip_By_VehicleID appendFormat:@"WHERE %@ = ?", t_vehicleID];
    return SQL_Delete_Trip_By_VehicleID;
}

static inline NSString * SQL_Delete_Trip_By_TripID () {
    static NSMutableString * SQL_Delete_Trip_By_TripID;
    if (SQL_Delete_Trip_By_TripID) {
        return SQL_Delete_Trip_By_TripID;
    }
    
    SQL_Delete_Trip_By_TripID = [NSMutableString string];
    [SQL_Delete_Trip_By_TripID appendFormat:@"DELETE FROM %@ ", SQL_TABLE_Trip];
    [SQL_Delete_Trip_By_TripID appendFormat:@"WHERE %@ = ?", t_tripID];
    return SQL_Delete_Trip_By_TripID;
}

static inline NSString * SQL_Delete_Trip_All () {
    static NSMutableString * SQL_Delete_Trip_All;
    if (SQL_Delete_Trip_All) {
        return SQL_Delete_Trip_All;
    }
    
    SQL_Delete_Trip_All = [NSMutableString string];
    [SQL_Delete_Trip_All appendFormat:@"DELETE FROM %@ ", SQL_TABLE_Trip];
    return SQL_Delete_Trip_All;
}

static inline NSString * SQL_Delete_Trip_By_Date_VehicleID () {
    static NSMutableString * SQL_Delete_Trip_By_Date_VehicleID;
    if (SQL_Delete_Trip_By_Date_VehicleID) {
        return SQL_Delete_Trip_By_Date_VehicleID;
    }
    
    SQL_Delete_Trip_By_Date_VehicleID = [NSMutableString string];
    [SQL_Delete_Trip_By_Date_VehicleID appendFormat:@"DELETE FROM %@ ", SQL_TABLE_Trip];
    [SQL_Delete_Trip_By_Date_VehicleID appendFormat:@"WHERE %@ = ? ", t_vehicleID];
    [SQL_Delete_Trip_By_Date_VehicleID appendFormat:@"AND %@ >= ? ", t_startTime];
    [SQL_Delete_Trip_By_Date_VehicleID appendFormat:@"AND %@ < ? ", t_startTime];
    return SQL_Delete_Trip_By_Date_VehicleID;
}

static inline NSString * SQL_Query_Trip_By_Date_VehicleID () {
    static NSMutableString * SQL_Query_Trip_By_Date_VehicleID;
    if (SQL_Query_Trip_By_Date_VehicleID) {
        return SQL_Query_Trip_By_Date_VehicleID;
    }
    
    SQL_Query_Trip_By_Date_VehicleID = [NSMutableString string];
    [SQL_Query_Trip_By_Date_VehicleID appendFormat:@"SELECT * FROM %@ ", SQL_TABLE_Trip];
    [SQL_Query_Trip_By_Date_VehicleID appendFormat:@"WHERE %@ = ? ", t_vehicleID];
    [SQL_Query_Trip_By_Date_VehicleID appendFormat:@"AND %@ >= ? ", t_startTime];
    [SQL_Query_Trip_By_Date_VehicleID appendFormat:@"AND %@ < ? ", t_startTime];
    [SQL_Query_Trip_By_Date_VehicleID appendFormat:@"ORDER BY %@ ASC", t_startTime]; //升序
    return SQL_Query_Trip_By_Date_VehicleID;
}

static inline NSString * SQL_Query_Trip_By_TripID () {
    static NSMutableString * SQL_Query_Trip_By_TripID;
    if (SQL_Query_Trip_By_TripID) {
        return SQL_Query_Trip_By_TripID;
    }
    
    SQL_Query_Trip_By_TripID = [NSMutableString string];
    [SQL_Query_Trip_By_TripID appendFormat:@"SELECT * FROM %@ ", SQL_TABLE_Trip];
    [SQL_Query_Trip_By_TripID appendFormat:@"WHERE %@ = ? ", t_tripID];
    return SQL_Query_Trip_By_TripID;
}


@implementation SRDataBase (Trip)

- (void)createTripTable
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self.databaseQueue inDatabase:^(FMDatabase *db) {
#if DataBaseEncrypd
            [db setKey:DB_ENCRYP_KEY];
#endif
            [db setShouldCacheStatements:YES];
            
            if ([db tableExists:SQL_TABLE_Trip]) return ;
            
            if ([db executeUpdate:SQL_Creat_TripTable()]) {
                SRLogDebug(@"VehicleBasic 表创建成功");
            } else {
                SRLogError(@"VehicleBasic 表创建失败");
            }
        }];
        [self.databaseQueue close];
    });
}

- (void)updateTripList:(NSArray *)list withCompleteBlock:(CompleteBlock)completeBlock
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
            
            [list enumerateObjectsUsingBlock:^(SRTripInfo *info, NSUInteger idx, BOOL *stop) {
                
                FMResultSet *resultSet = [db executeQuery:SQL_Query_Trip_By_TripID(), info.tripID];
                if (resultSet.next) {
//                    SRLogDebug(@"存在相同数据，改为更新");
                    //更新
                    result = [db executeUpdate:SQL_Update_Trip(),
                              info.tripID,
                              info.startTime,
                              info.endTime,
                              @(info.mileage),
                              @(info.fuelCons),
                              @(info.avgFuelCons),
                              @(info.fee),
                              @(info.startLat),
                              @(info.startLng),
                              @(info.endLat),
                              @(info.endLng),
                              @(info.vehicleID),
                              info.tripID];
                } else {
                    //插入
                    result = [db executeUpdate:SQL_Insert_Trip(),
                              info.tripID,
                              info.startTime,
                              info.endTime,
                              @(info.mileage),
                              @(info.fuelCons),
                              @(info.avgFuelCons),
                              @(info.fee),
                              @(info.startLat),
                              @(info.startLng),
                              @(info.endLat),
                              @(info.endLng),
                              @(info.vehicleID)];
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
            error = [NSError errorWithDomain:@"写入失败" code:-1 userInfo:((SRTripInfo *)list[index]).keyValues];
        } else {
            SRLogDebug(@"插入成功");
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            !completeBlock?:completeBlock(error, @(result));
        });
        
    });
    
#if RealmEnable
    [[SRRealm sharedInterface] updateTripList:list withCompleteBlock:nil];
#endif
}

- (void)deleteTripByTripID:(NSString *)tripID withCompleteBlock:(CompleteBlock)completeBlock
{
    if (!tripID || tripID.length <= 0) {
        SRLogError(@"tripID 不能为空");
        NSError *error = [NSError errorWithDomain:@"更新失败, tripID 不能为空" code:-1 userInfo:nil];
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
            result = [db executeUpdate:SQL_Delete_Trip_By_TripID(), tripID];
        }];
        [self.databaseQueue close];
        if (!result) {
            error = [NSError errorWithDomain:[NSString stringWithFormat:@"删除失败 %@", tripID]
                                        code:-1 userInfo:nil];
        } else {
            SRLogDebug(@"%@ 删除成功", tripID);
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            !completeBlock?:completeBlock(error, @(result));
        });
        
    });
    
#if RealmEnable
    [[SRRealm sharedInterface] deleteTripByTripID:tripID withCompleteBlock:nil];
#endif
}

- (void)deleteTripByVehicleID:(NSInteger)vehicleID withCompleteBlock:(CompleteBlock)completeBlock
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
            result = [db executeUpdate:SQL_Delete_Trip_By_VehicleID(), @(vehicleID)];
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
    [[SRRealm sharedInterface] deleteTripByVehicleID:vehicleID withCompleteBlock:nil];
#endif
}

- (void)deleteAllTripWithCompleteBlock:(CompleteBlock)completeBlock
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSError *error = nil;
        __block BOOL result = NO;
        [self.databaseQueue inDatabase:^(FMDatabase *db) {
#if DataBaseEncrypd
            [db setKey:DB_ENCRYP_KEY];
#endif
            result = [db executeUpdate:SQL_Delete_Trip_All()];
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
    [[SRRealm sharedInterface] deleteAllTripWithCompleteBlock:nil];
#endif
}

- (void)deleteTripByDate:(NSDate *)date vehicleID:(NSInteger)vehicleID withCompleteBlock:(CompleteBlock)completeBlock
{
    if (vehicleID <= 0) {
        SRLogError(@"vehicleID 不能为空");
        NSError *error = [NSError errorWithDomain:@"删除失败, vehicleID 不能为空" code:-1 userInfo:nil];
        !completeBlock?:completeBlock(error, @(NO));
        return;
    }
    
    if (!date) {
        SRLogError(@"date 不能为空");
        NSError *error = [NSError errorWithDomain:@"删除失败, date 不能为空" code:-1 userInfo:nil];
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
            NSString *time = [date stringOfDateWithFormatYYYYMMdd];
            NSString *start = [NSString stringWithFormat:@"%@ 00:00:00", time];
            time = [[date dateByAddingDays:1] stringOfDateWithFormatYYYYMMdd];
            NSString *end = [NSString stringWithFormat:@"%@ 00:00:00", time];
            
            result = [db executeUpdate:SQL_Delete_Trip_By_Date_VehicleID(), @(vehicleID), start, end];
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
    [[SRRealm sharedInterface] deleteTripByDate:date vehicleID:vehicleID withCompleteBlock:nil];
#endif
}

- (void)queryTripByDate:(NSDate *)date vehicleID:(NSInteger)vehicleID withCompleteBlock:(CompleteBlock)completeBlock
{
    if (vehicleID <= 0) {
        SRLogError(@"vehicleID 不能为空");
        NSError *error = [NSError errorWithDomain:@"查询失败, vehicleID 不能为空" code:-1 userInfo:nil];
        !completeBlock?:completeBlock(error, @(NO));
        return;
    }
    if (!date) {
        SRLogError(@"date 不能为空");
        NSError *error = [NSError errorWithDomain:@"查询失败, date 不能为空" code:-1 userInfo:nil];
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
                NSString *time = [date stringOfDateWithFormatYYYYMMdd];
                NSString *start = [NSString stringWithFormat:@"%@ 00:00:00", time];
                time = [[date dateByAddingDays:1] stringOfDateWithFormatYYYYMMdd];
                NSString *end = [NSString stringWithFormat:@"%@ 00:00:00", time];
                
                FMResultSet *resultSet = [db executeQuery:SQL_Query_Trip_By_Date_VehicleID(), @(vehicleID), start, end];
                while ([resultSet next]) {
                    
                    SRTripInfo *trip   = [[SRTripInfo alloc] init];
                    trip.tripID        = [resultSet stringForColumn:t_tripID];
                    trip.mileage       = [resultSet stringForColumn:t_mileage].floatValue;
                    trip.fuelCons      = [resultSet stringForColumn:t_fuelCons].floatValue;
                    trip.avgFuelCons   = [resultSet stringForColumn:t_avgFuelCons].floatValue;
                    trip.fee           = [resultSet stringForColumn:t_fee].floatValue;
                    trip.startLat      = [resultSet stringForColumn:t_startLat].floatValue;
                    trip.startLng      = [resultSet stringForColumn:t_startLng].floatValue;
                    trip.endLat        = [resultSet stringForColumn:t_endLat].floatValue;
                    trip.endLng        = [resultSet stringForColumn:t_endLng].floatValue;
                    trip.vehicleID     = [resultSet stringForColumn:t_vehicleID].integerValue;
                    [trip setStartTimeLocal:[resultSet stringForColumn:t_startTime]];
                    [trip setEndTimeLocal:[resultSet stringForColumn:t_endTime]];
                    
                    [list addObject:trip];
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
    [[SRRealm sharedInterface] queryTripByDate:date vehicleID:vehicleID withCompleteBlock:nil];
#endif

}

@end

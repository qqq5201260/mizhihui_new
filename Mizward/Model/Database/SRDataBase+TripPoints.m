//
//  SRDataBase+TripPoints.m
//  Mizward
//
//  Created by zhangjunbo on 15/9/1.
//  Copyright (c) 2015年 Mizward. All rights reserved.
//

#import "SRDataBase+TripPoints.h"
#import "SRTripPoint.h"
#import <FMDB/FMDB.h>
#import <MJExtension/MJExtension.h>

#import "SRRealm+TripPoints.h"

// DB Table
NSString * const SQL_TABLE_TripPoints = @"TripPoints";

//元素
NSString * const tp_tripID       = @"tripID";
NSString * const tp_vehicleID    = @"vehicleID";

NSString * const tp_tripPoints    = @"tripPoints";

//SQL 语句
static inline NSString * SQL_Creat_TripPointsTable () {
    static NSMutableString * SQL_Creat_TripPointsTable;
    if (SQL_Creat_TripPointsTable) {
        return SQL_Creat_TripPointsTable;
    }
    
    SQL_Creat_TripPointsTable = [NSMutableString string];
    [SQL_Creat_TripPointsTable appendFormat:@"CREATE TABLE IF NOT EXISTS %@ ", SQL_TABLE_TripPoints];
    [SQL_Creat_TripPointsTable appendFormat:@"("];
    [SQL_Creat_TripPointsTable appendFormat:@"%@ TEXT PRIMARY KEY NOT NULL ,", tp_tripID];
    [SQL_Creat_TripPointsTable appendFormat:@"%@ INTEGER   , " , tp_vehicleID];
    [SQL_Creat_TripPointsTable appendFormat:@"%@ TEXT        " , tp_tripPoints];
    
    [SQL_Creat_TripPointsTable appendFormat:@")"];
    
    return SQL_Creat_TripPointsTable;
}

static inline NSString * SQL_Insert_TripPoints () {
    static NSMutableString * SQL_Insert_TripPoints;
    if (SQL_Insert_TripPoints) {
        return SQL_Insert_TripPoints;
    }
    
    SQL_Insert_TripPoints = [NSMutableString string];
    [SQL_Insert_TripPoints appendFormat:@"INSERT INTO %@ ", SQL_TABLE_TripPoints];
    [SQL_Insert_TripPoints appendFormat:@"("];
    [SQL_Insert_TripPoints appendFormat:@"%@ , " , tp_tripID];
    [SQL_Insert_TripPoints appendFormat:@"%@ , " , tp_vehicleID];
    [SQL_Insert_TripPoints appendFormat:@"%@   " , tp_tripPoints];
    [SQL_Insert_TripPoints appendFormat:@")"];
    [SQL_Insert_TripPoints appendFormat:@"VALUES (?, ?, ?)"];
    
    return SQL_Insert_TripPoints;
}

static inline NSString * SQL_Update_TripPoints () {
    static NSMutableString * SQL_Update_TripPoints;
    if (SQL_Update_TripPoints) {
        return SQL_Update_TripPoints;
    }
    
    SQL_Update_TripPoints = [NSMutableString string];
    [SQL_Update_TripPoints appendFormat:@"UPDATE %@ SET ", SQL_TABLE_TripPoints];
    [SQL_Update_TripPoints appendFormat:@"%@ = ?, " , tp_tripID];
    [SQL_Update_TripPoints appendFormat:@"%@ = ?, " , tp_vehicleID];
    [SQL_Update_TripPoints appendFormat:@"%@ = ?  " , tp_tripPoints];
    [SQL_Update_TripPoints appendFormat:@"WHERE %@ = ?" , tp_tripID];
    
    return SQL_Update_TripPoints;
}

static inline NSString * SQL_Delete_TripPoints_By_TripID () {
    static NSMutableString * SQL_Delete_TripPoints_By_TripID;
    if (SQL_Delete_TripPoints_By_TripID) {
        return SQL_Delete_TripPoints_By_TripID;
    }
    
    SQL_Delete_TripPoints_By_TripID = [NSMutableString string];
    [SQL_Delete_TripPoints_By_TripID appendFormat:@"DELETE FROM %@ ", SQL_TABLE_TripPoints];
    [SQL_Delete_TripPoints_By_TripID appendFormat:@"WHERE %@ = ?", tp_tripID];
    return SQL_Delete_TripPoints_By_TripID;
}

static inline NSString * SQL_Delete_TripPoints_All () {
    static NSMutableString * SQL_Delete_TripPoints_All;
    if (SQL_Delete_TripPoints_All) {
        return SQL_Delete_TripPoints_All;
    }
    
    SQL_Delete_TripPoints_All = [NSMutableString string];
    [SQL_Delete_TripPoints_All appendFormat:@"DELETE FROM %@ ", SQL_TABLE_TripPoints];
    return SQL_Delete_TripPoints_All;
}

static inline NSString * SQL_Query_TripPoints_By_TripID () {
    static NSMutableString * SQL_Query_TripPoints_By_TripID;
    if (SQL_Query_TripPoints_By_TripID) {
        return SQL_Query_TripPoints_By_TripID;
    }
    
    SQL_Query_TripPoints_By_TripID = [NSMutableString string];
    [SQL_Query_TripPoints_By_TripID appendFormat:@"SELECT * FROM %@ ", SQL_TABLE_TripPoints];
    [SQL_Query_TripPoints_By_TripID appendFormat:@"WHERE %@ = ? ", tp_tripID];
    return SQL_Query_TripPoints_By_TripID;
}


@implementation SRDataBase (TripPoints)

- (void)createTripPointsTable
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self.databaseQueue inDatabase:^(FMDatabase *db) {
#if DataBaseEncrypd
            [db setKey:DB_ENCRYP_KEY];
#endif
            [db setShouldCacheStatements:YES];
            
            if ([db tableExists:SQL_TABLE_TripPoints]) return ;
            
            if ([db executeUpdate:SQL_Creat_TripPointsTable()]) {
                SRLogDebug(@"VehicleBasic 表创建成功");
            } else {
                SRLogError(@"VehicleBasic 表创建失败");
            }
        }];
        [self.databaseQueue close];
    });

}

- (void)updateTripPoints:(NSArray *)list tripID:(NSString *)tripID andVehicleID:(NSInteger)vehicleID withCompleteBlock:(CompleteBlock)completeBlock
{
    if (!list || list.count==0) {
        !completeBlock?:completeBlock(nil, @(YES));
        return;
    }
    
    if (!tripID || tripID.length==0) {
        !completeBlock?:completeBlock(nil, @(YES));
        return;
    }
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSError *error = nil;
        __block BOOL result = NO;
        [self.databaseQueue inDatabase:^(FMDatabase *db) {
#if DataBaseEncrypd
            [db setKey:DB_ENCRYP_KEY];
#endif
            NSString *pointsString = [self listToString:list];
            
            FMResultSet *resultSet = [db executeQuery:SQL_Query_TripPoints_By_TripID(), tripID];
            if (resultSet.next) {
                result = [db executeUpdate:SQL_Update_TripPoints(),
                          tripID,
                          @(vehicleID),
                          pointsString,
                          @(vehicleID)];
            } else {
                result = [db executeUpdate:SQL_Insert_TripPoints(),
                          tripID,
                          @(vehicleID),
                          pointsString];
            }
            [resultSet close];
        }];
        [self.databaseQueue close];
        if (!result) {
            error = [NSError errorWithDomain:@"更新失败" code:-1 userInfo:nil];
        } else {
            SRLogDebug(@"更新成功");
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            !completeBlock?:completeBlock(error, @(result));
        });
        
    });
    
#if RealmEnable
    [[SRRealm sharedInterface] updateTripPoints:list tripID:tripID andVehicleID:vehicleID withCompleteBlock:nil];
#endif

}

- (void)deleteTripPointsByTripID:(NSString *)tripID withCompleteBlock:(CompleteBlock)completeBlock
{
    if (tripID.length <= 0) {
        SRLogError(@"tripID 不能为空");
        NSError *error = [NSError errorWithDomain:@"删除失败, tripID 不能为空" code:-1 userInfo:nil];
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
            result = [db executeUpdate:SQL_Delete_TripPoints_By_TripID(), tripID];
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
    [[SRRealm sharedInterface] deleteTripPointsByTripID:tripID withCompleteBlock:nil];
#endif
}

- (void)deleteAllTripPointsWithCompleteBlock:(CompleteBlock)completeBlock
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSError *error = nil;
        __block BOOL result = NO;
        [self.databaseQueue inDatabase:^(FMDatabase *db) {
#if DataBaseEncrypd
            [db setKey:DB_ENCRYP_KEY];
#endif
            result = [db executeUpdate:SQL_Delete_TripPoints_All()];
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
    [[SRRealm sharedInterface] deleteAllTripPointsWithCompleteBlock:nil];
#endif
}

- (void)queryTripPointsByTripID:(NSString *)tripID withCompleteBlock:(CompleteBlock)completeBlock
{
    if (!tripID || tripID.length == 0) {
        SRLogError(@"tripID 不能为空");
        NSError *error = [NSError errorWithDomain:@"更新失败, tripID 不能为空" code:-1 userInfo:nil];
        !completeBlock?:completeBlock(error, nil);
        return;
    }
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        __block NSArray *list;
        [self.databaseQueue inDatabase:^(FMDatabase *db) {
#if DataBaseEncrypd
            [db setKey:DB_ENCRYP_KEY];
#endif
            
            @autoreleasepool {
                FMResultSet *resultSet = [db executeQuery:SQL_Query_TripPoints_By_TripID(), tripID];
                while ([resultSet next]) {
                    NSString *pointsString = [resultSet stringForColumn:tp_tripPoints];
                
                    list = [self stringToList:pointsString];
                }
                [resultSet close];
            }
            
        }];
        [self.databaseQueue close];
        
//        [self.databaseQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
//#if DataBaseEncrypd
//            [db setKey:DB_ENCRYP_KEY];
//#endif
//            
//            @autoreleasepool {
//                FMResultSet *resultSet = [db executeQuery:SQL_Query_TripPoints_By_TripID(), tripID];
//                while ([resultSet next]) {
//                    NSString *pointsString = [resultSet stringForColumn:tp_tripPoints];
//                    
//                    list = [self stringToList:pointsString];
//                }
//                [resultSet close];
//            }
//        }];
//        [self.databaseQueue close];

        
        dispatch_async(dispatch_get_main_queue(), ^{
            !completeBlock?:completeBlock(nil, list);
        });

    });
    
#if RealmEnable
    [[SRRealm sharedInterface] queryTripPointsByTripID:tripID withCompleteBlock:completeBlock];
#endif

}

- (NSString *)listToString:(NSArray *)list {
    if (!list || list == 0) return nil;
    
    NSMutableArray *array = [NSMutableArray array];
    [list enumerateObjectsUsingBlock:^(SRTripPoint *obj, NSUInteger idx, BOOL *stop) {
        @autoreleasepool {
            NSError *error = nil;
            NSData *jsonData = [NSJSONSerialization dataWithJSONObject:obj.customerDictionaryValue options:NSJSONWritingPrettyPrinted error:&error];
            if (!error) {
                NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
                [array addObject:jsonString];
            }
        }
    }];
    
    return [array componentsJoinedByString:@"*"];
}

- (NSArray *)stringToList:(NSString *)string {
    NSArray *jsonArray = [string componentsSeparatedByString:@"*"];
    
    NSMutableArray *points = [NSMutableArray array];
    [jsonArray enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL *stop) {
        @autoreleasepool {
            NSData *jsonData = [obj dataUsingEncoding:NSUTF8StringEncoding];
            NSError *error = nil;
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableLeaves error:&error];
            if (!error) {
                SRTripPoint *point = [SRTripPoint objectWithKeyValues:dic];
                [points addObject:point];
            }
        }
    }];
    
    return points;
}

@end

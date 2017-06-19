//
//  SRDataBase+OrderStart.m
//  SiRuiV4.0
//
//  Created by zhangjunbo on 15/6/17.
//  Copyright (c) 2015年 SiRui. All rights reserved.
//

#import "SRDataBase+OrderStart.h"
#import "SROrderStartInfo.h"
#import <FMDB/FMDB.h>
#import <MJExtension/MJExtension.h>

#import "SRRealm+OrderStart.h"

// DB Table
NSString * const SQL_TABLE_OrderStart = @"OrderStart";

//元素
NSString * const o_startClockID    = @"startClockID";

NSString * const o_type            = @"type";
NSString * const o_vehicleID       = @"vehicleID";
NSString * const o_startTime       = @"startTime";
NSString * const o_isRepeat        = @"isRepeat";
NSString * const o_startTimeLength = @"startTimeLength";
NSString * const o_repeatType      = @"repeatType";
NSString * const o_isOpen          = @"isOpen";
NSString * const o_customerID      = @"customerID";

//SQL 语句
static inline NSString * SQL_Creat_OrderStartTable () {
    static NSMutableString * SQL_Creat_OrderStart;
    if (SQL_Creat_OrderStart) {
        return SQL_Creat_OrderStart;
    }
    
    SQL_Creat_OrderStart = [NSMutableString string];
    [SQL_Creat_OrderStart appendFormat:@"CREATE TABLE IF NOT EXISTS %@ ", SQL_TABLE_OrderStart];
    [SQL_Creat_OrderStart appendFormat:@"("];
    [SQL_Creat_OrderStart appendFormat:@"%@ INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL ,", o_startClockID];
    [SQL_Creat_OrderStart appendFormat:@"%@ INTEGER     , " , o_type];
    [SQL_Creat_OrderStart appendFormat:@"%@ INTEGER     , " , o_vehicleID];
    [SQL_Creat_OrderStart appendFormat:@"%@ VARCHAR(64) , " , o_startTime];
    [SQL_Creat_OrderStart appendFormat:@"%@ INTEGER     , " , o_isRepeat];
    [SQL_Creat_OrderStart appendFormat:@"%@ INTEGER     , " , o_startTimeLength];
    [SQL_Creat_OrderStart appendFormat:@"%@ VARCHAR(64) , " , o_repeatType];
    [SQL_Creat_OrderStart appendFormat:@"%@ INTEGER     , " , o_customerID];
    [SQL_Creat_OrderStart appendFormat:@"%@ INTEGER       " , o_isOpen];
    [SQL_Creat_OrderStart appendFormat:@")"];
    
    return SQL_Creat_OrderStart;
}

static inline NSString * SQL_Insert_OrderStart () {
    static NSMutableString * SQL_Insert_OrderStart;
    if (SQL_Insert_OrderStart) {
        return SQL_Insert_OrderStart;
    }
    
    SQL_Insert_OrderStart = [NSMutableString string];
    [SQL_Insert_OrderStart appendFormat:@"INSERT INTO %@ ", SQL_TABLE_OrderStart];
    [SQL_Insert_OrderStart appendFormat:@"("];
    [SQL_Insert_OrderStart appendFormat:@"%@ , " , o_startClockID];
    [SQL_Insert_OrderStart appendFormat:@"%@ , " , o_type];
    [SQL_Insert_OrderStart appendFormat:@"%@ , " , o_vehicleID];
    [SQL_Insert_OrderStart appendFormat:@"%@ , " , o_startTime];
    [SQL_Insert_OrderStart appendFormat:@"%@ , " , o_isRepeat];
    [SQL_Insert_OrderStart appendFormat:@"%@ , " , o_startTimeLength];
    [SQL_Insert_OrderStart appendFormat:@"%@ , " , o_repeatType];
    [SQL_Insert_OrderStart appendFormat:@"%@ , " , o_customerID];
    [SQL_Insert_OrderStart appendFormat:@"%@   " , o_isOpen];
    [SQL_Insert_OrderStart appendFormat:@")"];
    [SQL_Insert_OrderStart appendFormat:@"VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)"];
    
    return SQL_Insert_OrderStart;
}

static inline NSString * SQL_Update_OrderStart () {
    static NSMutableString * SQL_Update_OrderStart;
    if (SQL_Update_OrderStart) {
        return SQL_Update_OrderStart;
    }
    
    SQL_Update_OrderStart = [NSMutableString string];
    [SQL_Update_OrderStart appendFormat:@"UPDATE %@ SET ", SQL_TABLE_OrderStart];
    [SQL_Update_OrderStart appendFormat:@"%@ = ?, " , o_startClockID];
    [SQL_Update_OrderStart appendFormat:@"%@ = ?, " , o_type];
    [SQL_Update_OrderStart appendFormat:@"%@ = ?, " , o_vehicleID];
    [SQL_Update_OrderStart appendFormat:@"%@ = ?, " , o_startTime];
    [SQL_Update_OrderStart appendFormat:@"%@ = ?, " , o_isRepeat];
    [SQL_Update_OrderStart appendFormat:@"%@ = ?, " , o_startTimeLength];
    [SQL_Update_OrderStart appendFormat:@"%@ = ?, " , o_repeatType];
    [SQL_Update_OrderStart appendFormat:@"%@ = ?, " , o_customerID];
    [SQL_Update_OrderStart appendFormat:@"%@ = ?  " , o_isOpen];
    [SQL_Update_OrderStart appendFormat:@"WHERE %@ = ?" , o_startClockID];
    
    return SQL_Update_OrderStart;
}

static inline NSString * SQL_Delete_OrderStart_By_VehicleID () {
    static NSMutableString * SQL_Delete_OrderStart_By_VehicleID;
    if (SQL_Delete_OrderStart_By_VehicleID) {
        return SQL_Delete_OrderStart_By_VehicleID;
    }
    
    SQL_Delete_OrderStart_By_VehicleID = [NSMutableString string];
    [SQL_Delete_OrderStart_By_VehicleID appendFormat:@"DELETE FROM %@ ", SQL_TABLE_OrderStart];
    [SQL_Delete_OrderStart_By_VehicleID appendFormat:@"WHERE %@ = ?", o_vehicleID];
    return SQL_Delete_OrderStart_By_VehicleID;
}

static inline NSString * SQL_Delete_OrderStart_By_StartClockID () {
    static NSMutableString * SQL_Delete_OrderStart_By_StartClockID;
    if (SQL_Delete_OrderStart_By_StartClockID) {
        return SQL_Delete_OrderStart_By_StartClockID;
    }
    
    SQL_Delete_OrderStart_By_StartClockID = [NSMutableString string];
    [SQL_Delete_OrderStart_By_StartClockID appendFormat:@"DELETE FROM %@ ", SQL_TABLE_OrderStart];
    [SQL_Delete_OrderStart_By_StartClockID appendFormat:@"WHERE %@ = ?", o_startClockID];
    return SQL_Delete_OrderStart_By_StartClockID;
}

static inline NSString * SQL_Delete_OrderStart_By_CustomerID () {
    static NSMutableString * SQL_Delete_OrderStart_By_CustomerID;
    if (SQL_Delete_OrderStart_By_CustomerID) {
        return SQL_Delete_OrderStart_By_CustomerID;
    }
    
    SQL_Delete_OrderStart_By_CustomerID = [NSMutableString string];
    [SQL_Delete_OrderStart_By_CustomerID appendFormat:@"DELETE FROM %@ ", SQL_TABLE_OrderStart];
    [SQL_Delete_OrderStart_By_CustomerID appendFormat:@"WHERE %@ = ?", o_customerID];
    return SQL_Delete_OrderStart_By_CustomerID;
}

static inline NSString * SQL_Delete_OrderStart_All () {
    static NSMutableString * SQL_Delete_OrderStart_All;
    if (SQL_Delete_OrderStart_All) {
        return SQL_Delete_OrderStart_All;
    }
    
    SQL_Delete_OrderStart_All = [NSMutableString string];
    [SQL_Delete_OrderStart_All appendFormat:@"DELETE FROM %@ ", SQL_TABLE_OrderStart];
    return SQL_Delete_OrderStart_All;
}

static inline NSString * SQL_Query_OrderStart_By_VehicleID () {
    static NSMutableString * SQL_Query_OrderStart_By_VehicleID;
    if (SQL_Query_OrderStart_By_VehicleID) {
        return SQL_Query_OrderStart_By_VehicleID;
    }
    
    SQL_Query_OrderStart_By_VehicleID = [NSMutableString string];
    [SQL_Query_OrderStart_By_VehicleID appendFormat:@"SELECT * FROM %@ ", SQL_TABLE_OrderStart];
    [SQL_Query_OrderStart_By_VehicleID appendFormat:@"WHERE %@ = ?", o_vehicleID];
    return SQL_Query_OrderStart_By_VehicleID;
}

static inline NSString * SQL_Query_OrderStart_By_StartClockID () {
    static NSMutableString * SQL_Query_OrderStart_By_StartClockID;
    if (SQL_Query_OrderStart_By_StartClockID) {
        return SQL_Query_OrderStart_By_StartClockID;
    }
    
    SQL_Query_OrderStart_By_StartClockID = [NSMutableString string];
    [SQL_Query_OrderStart_By_StartClockID appendFormat:@"SELECT * FROM %@ ", SQL_TABLE_OrderStart];
    [SQL_Query_OrderStart_By_StartClockID appendFormat:@"WHERE %@ = ?", o_startClockID];
    return SQL_Query_OrderStart_By_StartClockID;
}

static inline NSString * SQL_Query_OrderStart_By_CustomerID () {
    static NSMutableString * SQL_Query_OrderStart_By_CustomerID;
    if (SQL_Query_OrderStart_By_CustomerID) {
        return SQL_Query_OrderStart_By_CustomerID;
    }
    
    SQL_Query_OrderStart_By_CustomerID = [NSMutableString string];
    [SQL_Query_OrderStart_By_CustomerID appendFormat:@"SELECT * FROM %@ ", SQL_TABLE_OrderStart];
    [SQL_Query_OrderStart_By_CustomerID appendFormat:@"WHERE %@ = ?", o_customerID];
    return SQL_Query_OrderStart_By_CustomerID;
}

static inline NSString * SQL_Query_OrderStart_All () {
    static NSMutableString * SQL_Query_OrderStart_All;
    if (SQL_Query_OrderStart_All) {
        return SQL_Query_OrderStart_All;
    }
    
    SQL_Query_OrderStart_All = [NSMutableString string];
    [SQL_Query_OrderStart_All appendFormat:@"SELECT * FROM %@ ", SQL_TABLE_OrderStart];
    return SQL_Query_OrderStart_All;
}


@implementation SRDataBase (OrderStart)

- (void)createOrderStartTable
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self.databaseQueue inDatabase:^(FMDatabase *db) {
#if DataBaseEncrypd
            [db setKey:DB_ENCRYP_KEY];
#endif
            [db setShouldCacheStatements:YES];
            
            if ([db tableExists:SQL_TABLE_OrderStart]) return ;
            
            if ([db executeUpdate:SQL_Creat_OrderStartTable()]) {
                SRLogDebug(@"VehicleBasic 表创建成功");
            } else {
                SRLogError(@"VehicleBasic 表创建失败");
            }
        }];
        [self.databaseQueue close];
    });
}

- (void)updateOrderStartList:(NSArray *)list withCompleteBlock:(CompleteBlock)completeBlock
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
            
            [list enumerateObjectsUsingBlock:^(SROrderStartInfo *info, NSUInteger idx, BOOL *stop) {
                FMResultSet *resultSet = [db executeQuery:SQL_Query_OrderStart_By_StartClockID(), @(info.startClockID)];
                if (resultSet.next) {
                    result = [db executeUpdate:SQL_Update_OrderStart(),
                              @(info.startClockID),
                              @(info.type),
                              @(info.vehicleID),
                              info.startTime,
                              @(info.isRepeat),
                              @(info.startTimeLength),
                              info.repeatType,
                              @(info.customerID),
                              @(info.isOpen),
                              @(info.startClockID)];
                } else {
                    result = [db executeUpdate:SQL_Insert_OrderStart(),
                              @(info.startClockID),
                              @(info.type),
                              @(info.vehicleID),
                              info.startTime,
                              @(info.isRepeat),
                              @(info.startTimeLength),
                              info.repeatType,
                              @(info.customerID),
                              @(info.isOpen)];
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
            error = [NSError errorWithDomain:@"更新失败" code:-1 userInfo:((SROrderStartInfo *)list[index]).keyValues];
        } else {
            SRLogDebug(@"更新成功");
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            !completeBlock?:completeBlock(error, @(result));
        });
        
    });
    
#if RealmEnable
    [[SRRealm sharedInterface] updateOrderStartList:list withCompleteBlock:nil];
#endif

}

- (void)deleteOrderStartByVehicleID:(NSInteger)vehicleID withCompleteBlock:(CompleteBlock)completeBlock
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
            result = [db executeUpdate:SQL_Delete_OrderStart_By_VehicleID(), @(vehicleID)];
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
    [[SRRealm sharedInterface] deleteOrderStartByVehicleID:vehicleID withCompleteBlock:nil];
#endif
}

- (void)deleteOrderStartByStartClockID:(NSInteger)startClockID withCompleteBlock:(CompleteBlock)completeBlock
{
    if (startClockID <= 0) {
        SRLogError(@"startClockID 不能为空");
        NSError *error = [NSError errorWithDomain:@"更新失败, startClockID 不能为空" code:-1 userInfo:nil];
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
            result = [db executeUpdate:SQL_Delete_OrderStart_By_StartClockID(), @(startClockID)];
        }];
        [self.databaseQueue close];
        if (!result) {
            error = [NSError errorWithDomain:[NSString stringWithFormat:@"删除失败 %zd", startClockID]
                                        code:-1 userInfo:nil];
        } else {
            SRLogDebug(@"%zd 删除成功", startClockID);
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            !completeBlock?:completeBlock(error, @(result));
        });
        
    });
    
#if RealmEnable
    [[SRRealm sharedInterface] deleteOrderStartByStartClockID:startClockID withCompleteBlock:nil];
#endif
}

- (void)deleteOrderStartByCustomerID:(NSInteger)customerID withCompleteBlock:(CompleteBlock)completeBlock
{
    if (customerID <= 0) {
        SRLogError(@"customerID 不能为空");
        NSError *error = [NSError errorWithDomain:@"更新失败, customerID 不能为空" code:-1 userInfo:nil];
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
            result = [db executeUpdate:SQL_Delete_OrderStart_By_CustomerID(), @(customerID)];
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
    [[SRRealm sharedInterface] deleteOrderStartByCustomerID:customerID withCompleteBlock:nil];
#endif
}

- (void)deleteAllOrderStartWithCompleteBlock:(CompleteBlock)completeBlock
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSError *error = nil;
        __block BOOL result = NO;
        [self.databaseQueue inDatabase:^(FMDatabase *db) {
#if DataBaseEncrypd
            [db setKey:DB_ENCRYP_KEY];
#endif
            result = [db executeUpdate:SQL_Delete_OrderStart_All()];
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
    [[SRRealm sharedInterface] deleteAllOrderStartWithCompleteBlock:nil];
#endif
}

- (void)queryOrderStartByVehicleID:(NSInteger)vehicleID withCompleteBlock:(CompleteBlock)completeBlock
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
                FMResultSet *resultSet = [db executeQuery:SQL_Query_OrderStart_By_VehicleID(), @(vehicleID)];
                while ([resultSet next]) {
                    
                    SROrderStartInfo *info   = [[SROrderStartInfo alloc] init];
                    info.startClockID        = [resultSet stringForColumn:o_startClockID].integerValue;
                    info.type                = [resultSet stringForColumn:o_type].integerValue;
                    info.vehicleID           = [resultSet stringForColumn:o_vehicleID].integerValue;
                    info.startTime           = [resultSet stringForColumn:o_startTime];
                    info.isRepeat            = [resultSet stringForColumn:o_isRepeat].boolValue;
                    info.startTimeLength     = [resultSet stringForColumn:o_startTimeLength].integerValue;
                    info.repeatType          = [resultSet stringForColumn:o_repeatType];
                    info.isOpen              = [resultSet stringForColumn:o_isOpen].boolValue;
                    
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
    [[SRRealm sharedInterface] queryOrderStartByVehicleID:vehicleID withCompleteBlock:nil];
#endif

}

- (void)queryOrderStartByStartClockID:(NSInteger)startClockID withCompleteBlock:(CompleteBlock)completeBlock
{
    if (startClockID <= 0) {
        SRLogError(@"startClockID 不能为空");
        NSError *error = [NSError errorWithDomain:@"查询失败, startClockID 不能为空" code:-1 userInfo:nil];
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
                FMResultSet *resultSet = [db executeQuery:SQL_Query_OrderStart_By_StartClockID(), @(startClockID)];
                while ([resultSet next]) {
                    
                    SROrderStartInfo *info   = [[SROrderStartInfo alloc] init];
                    info.startClockID        = [resultSet stringForColumn:o_startClockID].integerValue;
                    info.type                = [resultSet stringForColumn:o_type].integerValue;
                    info.vehicleID           = [resultSet stringForColumn:o_vehicleID].integerValue;
                    info.startTime           = [resultSet stringForColumn:o_startTime];
                    info.isRepeat            = [resultSet stringForColumn:o_isRepeat].boolValue;
                    info.startTimeLength     = [resultSet stringForColumn:o_startTimeLength].integerValue;
                    info.repeatType          = [resultSet stringForColumn:o_repeatType];
                    info.isOpen              = [resultSet stringForColumn:o_isOpen].boolValue;
                    
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
    [[SRRealm sharedInterface] queryOrderStartByStartClockID:startClockID withCompleteBlock:nil];
#endif
}

- (void)queryOrderStartByCustomerID:(NSInteger)customerID withCompleteBlock:(CompleteBlock)completeBlock;
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
                FMResultSet *resultSet = [db executeQuery:SQL_Query_OrderStart_By_CustomerID(), @(customerID)];
                while ([resultSet next]) {
                    
                    SROrderStartInfo *info   = [[SROrderStartInfo alloc] init];
                    info.startClockID        = [resultSet stringForColumn:o_startClockID].integerValue;
                    info.type                = [resultSet stringForColumn:o_type].integerValue;
                    info.vehicleID           = [resultSet stringForColumn:o_vehicleID].integerValue;
                    info.startTime           = [resultSet stringForColumn:o_startTime];
                    info.isRepeat            = [resultSet stringForColumn:o_isRepeat].boolValue;
                    info.startTimeLength     = [resultSet stringForColumn:o_startTimeLength].integerValue;
                    info.repeatType          = [resultSet stringForColumn:o_repeatType];
                    info.isOpen              = [resultSet stringForColumn:o_isOpen].boolValue;
                    
                    NSMutableArray *list = dic[@(info.vehicleID)];
                    if (!list) {
                        list = [NSMutableArray array];
                        [dic setObject:list forKey:@(info.vehicleID)];
                    }
                    [list addObject:info];
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
    [[SRRealm sharedInterface] queryOrderStartByCustomerID:customerID withCompleteBlock:nil];
#endif
}

- (void)queryAllOrderStartWithCompleteBlock:(CompleteBlock)completeBlock
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        __block NSMutableArray *list = [NSMutableArray array];
        [self.databaseQueue inDatabase:^(FMDatabase *db) {
#if DataBaseEncrypd
            [db setKey:DB_ENCRYP_KEY];
#endif
            @autoreleasepool {
                FMResultSet *resultSet = [db executeQuery:SQL_Query_OrderStart_All()];
                while ([resultSet next]) {
                    
                    SROrderStartInfo *info   = [[SROrderStartInfo alloc] init];
                    info.startClockID        = [resultSet stringForColumn:o_startClockID].integerValue;
                    info.type                = [resultSet stringForColumn:o_type].integerValue;
                    info.vehicleID           = [resultSet stringForColumn:o_vehicleID].integerValue;
                    info.startTime           = [resultSet stringForColumn:o_startTime];
                    info.isRepeat            = [resultSet stringForColumn:o_isRepeat].boolValue;
                    info.startTimeLength     = [resultSet stringForColumn:o_startTimeLength].integerValue;
                    info.repeatType          = [resultSet stringForColumn:o_repeatType];
                    info.isOpen              = [resultSet stringForColumn:o_isOpen].boolValue;
                    
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
    [[SRRealm sharedInterface] queryAllOrderStartWithCompleteBlock:nil];
#endif
}

@end

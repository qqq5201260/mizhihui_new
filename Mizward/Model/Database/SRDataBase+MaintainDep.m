//
//  SRDataBase+MaintainDep.m
//  SiRuiV4.0
//
//  Created by zhangjunbo on 15/7/28.
//  Copyright (c) 2015年 SiRui. All rights reserved.
//

#import "SRDataBase+MaintainDep.h"
#import "SRMaintainDepInfo.h"
#import "SRPortal.h"
#import "SRCustomer.h"
#import <FMDB/FMDB.h>
#import <MJExtension/MJExtension.h>

#import "SRRealm+MaintainDep.h"

// DB Table
NSString * const SQL_TABLE_Dep = @"MaintainDep";

//元素
NSString * const d_depID    = @"depID";
NSString * const d_name     = @"name";
NSString * const d_lat      = @"lat";
NSString * const d_lng      = @"lng";
NSString * const d_address  = @"address";
NSString * const d_phone    = @"phone";

//SQL 语句
static inline NSString * SQL_Creat_DepTable () {
    static NSMutableString * SQL_Creat_DepTable;
    if (SQL_Creat_DepTable) {
        return SQL_Creat_DepTable;
    }
    
    SQL_Creat_DepTable = [NSMutableString string];
    [SQL_Creat_DepTable appendFormat:@"CREATE TABLE IF NOT EXISTS %@ ", SQL_TABLE_Dep];
    [SQL_Creat_DepTable appendFormat:@"("];
    [SQL_Creat_DepTable appendFormat:@"%@ INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL ,", d_depID];
    [SQL_Creat_DepTable appendFormat:@"%@ VARCHAR(256) , " , d_name];
    [SQL_Creat_DepTable appendFormat:@"%@ FLOAT        , " , d_lat];
    [SQL_Creat_DepTable appendFormat:@"%@ FLOAT        , " , d_lng];
    [SQL_Creat_DepTable appendFormat:@"%@ VARCHAR(256) , " , d_address];
    [SQL_Creat_DepTable appendFormat:@"%@ VARCHAR(256)   " , d_phone];
    [SQL_Creat_DepTable appendFormat:@")"];
    
    return SQL_Creat_DepTable;
}

static inline NSString * SQL_Insert_Dep () {
    static NSMutableString * SQL_Insert_Dep;
    if (SQL_Insert_Dep) {
        return SQL_Insert_Dep;
    }
    
    SQL_Insert_Dep = [NSMutableString string];
    [SQL_Insert_Dep appendFormat:@"INSERT INTO %@ ", SQL_TABLE_Dep];
    [SQL_Insert_Dep appendFormat:@"("];
    [SQL_Insert_Dep appendFormat:@"%@ , " , d_depID];
    [SQL_Insert_Dep appendFormat:@"%@ , " , d_name];
    [SQL_Insert_Dep appendFormat:@"%@ , " , d_lat];
    [SQL_Insert_Dep appendFormat:@"%@ , " , d_lng];
    [SQL_Insert_Dep appendFormat:@"%@ , " , d_address];
    [SQL_Insert_Dep appendFormat:@"%@   " , d_phone];
    [SQL_Insert_Dep appendFormat:@")"];
    [SQL_Insert_Dep appendFormat:@"VALUES (?, ?, ?, ?, ?, ?)"];
    
    return SQL_Insert_Dep;
}

static inline NSString * SQL_Update_Dep () {
    static NSMutableString * SQL_Update_Dep;
    if (SQL_Update_Dep) {
        return SQL_Update_Dep;
    }
    
    SQL_Update_Dep = [NSMutableString string];
    [SQL_Update_Dep appendFormat:@"UPDATE %@ SET ", SQL_TABLE_Dep];
    [SQL_Update_Dep appendFormat:@"%@ = ?, " , d_depID];
    [SQL_Update_Dep appendFormat:@"%@ = ?, " , d_name];
    [SQL_Update_Dep appendFormat:@"%@ = ?, " , d_lat];
    [SQL_Update_Dep appendFormat:@"%@ = ?, " , d_lng];
    [SQL_Update_Dep appendFormat:@"%@ = ?, " , d_address];
    [SQL_Update_Dep appendFormat:@"%@ = ?  " , d_phone];
    [SQL_Update_Dep appendFormat:@"WHERE %@ = ?  ", d_depID];
    
    return SQL_Update_Dep;
}

static inline NSString * SQL_Delete_Dep_All () {
    static NSMutableString * SQL_Delete_Dep_All;
    if (SQL_Delete_Dep_All) {
        return SQL_Delete_Dep_All;
    }
    
    SQL_Delete_Dep_All = [NSMutableString string];
    [SQL_Delete_Dep_All appendFormat:@"DELETE FROM %@ ", SQL_TABLE_Dep];
    return SQL_Delete_Dep_All;
}

static inline NSString * SQL_Query_Dep_By_DepID () {
    static NSMutableString * SQL_Query_Dep_By_DepID;
    if (SQL_Query_Dep_By_DepID) {
        return SQL_Query_Dep_By_DepID;
    }
    
    SQL_Query_Dep_By_DepID = [NSMutableString string];
    [SQL_Query_Dep_By_DepID appendFormat:@"SELECT * FROM %@ ", SQL_TABLE_Dep];
    [SQL_Query_Dep_By_DepID appendFormat:@"WHERE %@ = ?", d_depID];
    return SQL_Query_Dep_By_DepID;
}

static inline NSString * SQL_Query_Dep_All () {
    static NSMutableString * SQL_Query_Dep_All;
    if (SQL_Query_Dep_All) {
        return SQL_Query_Dep_All;
    }
    
    SQL_Query_Dep_All = [NSMutableString string];
    [SQL_Query_Dep_All appendFormat:@"SELECT * FROM %@ ", SQL_TABLE_Dep];
    return SQL_Query_Dep_All;
}

static inline NSString * SQL_Query_Dep_Like_Name (NSString *name) {
    
    NSMutableString *SQL_Query_Dep_Like_Name = [NSMutableString string];
    [SQL_Query_Dep_Like_Name appendFormat:@"SELECT * FROM %@ ", SQL_TABLE_Dep];
    [SQL_Query_Dep_Like_Name appendFormat:@"WHERE %@ ", d_name];
    [SQL_Query_Dep_Like_Name appendFormat:@"LIKE '%%%@%%'", name];
    return SQL_Query_Dep_Like_Name;
}

@implementation SRDataBase (MaintainDep)

- (void)createMaintainDepTable
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self.databaseQueue inDatabase:^(FMDatabase *db) {
#if DataBaseEncrypd
            [db setKey:DB_ENCRYP_KEY];
#endif
            [db setShouldCacheStatements:YES];
            
            if ([db tableExists:SQL_TABLE_Dep]) {
                [self checkMaintainDepColumn:db];
                return ;
            };
            
            if ([db executeUpdate:SQL_Creat_DepTable()]) {
                SRLogDebug(@"Customer 表创建成功");
            } else {
                SRLogError(@"Customer 表创建失败");
            }
        }];
        [self.databaseQueue close];
    });
}

- (void)checkMaintainDepColumn:(FMDatabase *)db
{
    
}

- (void)updateMaintainDeps:(NSArray *)list withCompleteBlock:(CompleteBlock)completeBlock
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
            
            [list enumerateObjectsUsingBlock:^(SRMaintainDepInfo *info, NSUInteger idx, BOOL *stop) {
                FMResultSet *resultSet = [db executeQuery:SQL_Query_Dep_By_DepID(), @(info.depID)];
                if (resultSet.next) {
                    //                    SRLogDebug(@"存在相同数据，改为更新");
                    result = [db executeUpdate:SQL_Update_Dep(),
                              @(info.depID),
                              info.name,
                              @(info.lat),
                              @(info.lng),
                              info.address,
                              info.phone,
                              @(info.depID)];
                } else {
                    result = [db executeUpdate:SQL_Insert_Dep(),
                              @(info.depID),
                              info.name,
                              @(info.lat),
                              @(info.lng),
                              info.address,
                              info.phone];
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
            error = [NSError errorWithDomain:@"更新失败" code:-1 userInfo:((SRMaintainDepInfo *)list[index]).keyValues];
        } else {
            SRLogDebug(@"更新成功");
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            !completeBlock?:completeBlock(error, @(result));
        });
        
    });
    
#if RealmEnable
    [[SRRealm sharedInterface] updateMaintainDeps:list withCompleteBlock:nil];
#endif

}

- (void)deleteAllMaintainDepsWithCompleteBlock:(CompleteBlock)completeBlock
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSError *error = nil;
        __block BOOL result = NO;
        [self.databaseQueue inDatabase:^(FMDatabase *db) {
#if DataBaseEncrypd
            [db setKey:DB_ENCRYP_KEY];
#endif
            result = [db executeUpdate:SQL_Delete_Dep_All()];
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
    [[SRRealm sharedInterface] deleteAllMaintainDepsWithCompleteBlock:nil];
#endif
}

- (void)queryMaintainDepByDepID:(NSInteger)depID withCompleteBlock:(CompleteBlock)completeBlock
{
    if (depID <= 0) {
        SRLogError(@"depID 不能为空");
        NSError *error = [NSError errorWithDomain:@"更新失败, depID 不能为空" code:-1 userInfo:nil];
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
                FMResultSet *resultSet = [db executeQuery:SQL_Query_Dep_By_DepID(), @(depID)];
                while ([resultSet next]) {
                    SRMaintainDepInfo *info = [[SRMaintainDepInfo alloc] init];
                    info.depID              = [resultSet intForColumn:d_depID];
                    info.name               = [resultSet stringForColumn:d_name];
                    info.lat                = [resultSet doubleForColumn:d_lat];
                    info.lng                = [resultSet doubleForColumn:d_lng];
                    info.address            = [resultSet stringForColumn:d_address];
                    info.phone              = [resultSet stringForColumn:d_phone];
                    
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
    [[SRRealm sharedInterface] queryMaintainDepByDepID:depID withCompleteBlock:nil];
#endif

}

- (void)queryAllMaintainDepsWithCompleteBlock:(CompleteBlock)completeBlock
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        __block NSMutableArray *list = [NSMutableArray array];
        [self.databaseQueue inDatabase:^(FMDatabase *db) {
#if DataBaseEncrypd
            [db setKey:DB_ENCRYP_KEY];
#endif
            @autoreleasepool {
                FMResultSet *resultSet = [db executeQuery:SQL_Query_Dep_All()];
                while ([resultSet next]) {
                    
                    SRMaintainDepInfo *info = [[SRMaintainDepInfo alloc] init];
                    info.depID              = [resultSet intForColumn:d_depID];
                    info.name               = [resultSet stringForColumn:d_name];
                    info.lat                = [resultSet doubleForColumn:d_lat];
                    info.lng                = [resultSet doubleForColumn:d_lng];
                    info.address            = [resultSet stringForColumn:d_address];
                    info.phone              = [resultSet stringForColumn:d_phone];
                    
                    //默认将用户所在4S店放在第一
                    if (info.depID == [SRPortal sharedInterface].customer.depID) {
                        [list insertObject:info atIndex:0];
                    } else {
                        [list addObject:info];
                    }
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
    [[SRRealm sharedInterface] queryAllMaintainDepsWithCompleteBlock:nil];
#endif
}

- (void)queryAllMaintainDepsNameLike:(NSString *)name withCompleteBlock:(CompleteBlock)completeBlock
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        __block NSMutableArray *list = [NSMutableArray array];
        [self.databaseQueue inDatabase:^(FMDatabase *db) {
#if DataBaseEncrypd
            [db setKey:DB_ENCRYP_KEY];
#endif
            @autoreleasepool {
                FMResultSet *resultSet = [db executeQuery:SQL_Query_Dep_Like_Name(name)];
                while ([resultSet next]) {
                    
                    SRMaintainDepInfo *info = [[SRMaintainDepInfo alloc] init];
                    info.depID              = [resultSet intForColumn:d_depID];
                    info.name               = [resultSet stringForColumn:d_name];
                    info.lat                = [resultSet doubleForColumn:d_lat];
                    info.lng                = [resultSet doubleForColumn:d_lng];
                    info.address            = [resultSet stringForColumn:d_address];
                    info.phone              = [resultSet stringForColumn:d_phone];
                    
                    //默认将用户所在4S店放在第一
                    if (info.depID == [SRPortal sharedInterface].customer.depID) {
                        [list insertObject:info atIndex:0];
                    } else {
                        [list addObject:info];
                    }
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
    [[SRRealm sharedInterface] queryAllMaintainDepsNameLike:name withCompleteBlock:nil];
#endif
}

@end

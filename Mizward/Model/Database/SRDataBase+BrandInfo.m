//
//  SRDataBase+BrandInfo.m
//  SiRuiV4.0
//
//  Created by zhangjunbo on 15/7/28.
//  Copyright (c) 2015年 SiRui. All rights reserved.
//

#import "SRDataBase+BrandInfo.h"
#import "SRBrandInfo.h"
#import <FMDB/FMDB.h>
#import <MJExtension/MJExtension.h>

#import "SRRealm+BrandInfo.h"

// DB Table
NSString * const SQL_TABLE_Brand = @"Brand";

//元素
NSString * const b_entityID         = @"entityID";
NSString * const b_name             = @"name";
NSString * const b_brandFirstLetter = @"brandFirstLetter";
NSString * const b_seriesList       = @"seriesList";

//SQL 语句
static inline NSString * SQL_Creat_BrandTable () {
    static NSMutableString * SQL_Creat_BrandTable;
    if (SQL_Creat_BrandTable) {
        return SQL_Creat_BrandTable;
    }
    
    SQL_Creat_BrandTable = [NSMutableString string];
    [SQL_Creat_BrandTable appendFormat:@"CREATE TABLE IF NOT EXISTS %@ ", SQL_TABLE_Brand];
    [SQL_Creat_BrandTable appendFormat:@"("];
    [SQL_Creat_BrandTable appendFormat:@"%@ INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL ,", b_entityID];
    [SQL_Creat_BrandTable appendFormat:@"%@ VARCHAR(256) , " , b_name];
    [SQL_Creat_BrandTable appendFormat:@"%@ VARCHAR(16)  , " , b_brandFirstLetter];
    [SQL_Creat_BrandTable appendFormat:@"%@ TEXT           " , b_seriesList];
    [SQL_Creat_BrandTable appendFormat:@")"];
    
    return SQL_Creat_BrandTable;
}

static inline NSString * SQL_Insert_Brand () {
    static NSMutableString * SQL_Insert_Brand;
    if (SQL_Insert_Brand) {
        return SQL_Insert_Brand;
    }
    
    SQL_Insert_Brand = [NSMutableString string];
    [SQL_Insert_Brand appendFormat:@"INSERT INTO %@ ", SQL_TABLE_Brand];
    [SQL_Insert_Brand appendFormat:@"("];
    [SQL_Insert_Brand appendFormat:@"%@ , " , b_entityID];
    [SQL_Insert_Brand appendFormat:@"%@ , " , b_name];
    [SQL_Insert_Brand appendFormat:@"%@ , " , b_brandFirstLetter];
    [SQL_Insert_Brand appendFormat:@"%@   " , b_seriesList];
    [SQL_Insert_Brand appendFormat:@")"];
    [SQL_Insert_Brand appendFormat:@"VALUES (?, ?, ?, ?)"];
    
    return SQL_Insert_Brand;
}

static inline NSString * SQL_Update_Brand () {
    static NSMutableString * SQL_Update_Brand;
    if (SQL_Update_Brand) {
        return SQL_Update_Brand;
    }
    
    SQL_Update_Brand = [NSMutableString string];
    [SQL_Update_Brand appendFormat:@"UPDATE %@ SET ", SQL_TABLE_Brand];
    [SQL_Update_Brand appendFormat:@"%@ = ?, " , b_entityID];
    [SQL_Update_Brand appendFormat:@"%@ = ?, " , b_name];
    [SQL_Update_Brand appendFormat:@"%@ = ?, " , b_brandFirstLetter];
    [SQL_Update_Brand appendFormat:@"%@ = ?  " , b_seriesList];
    [SQL_Update_Brand appendFormat:@"WHERE %@ = ?  ", b_entityID];
    
    return SQL_Update_Brand;
}

static inline NSString * SQL_Update_Brand_Without_SeriesList () {
    static NSMutableString * SQL_Update_Brand;
    if (SQL_Update_Brand) {
        return SQL_Update_Brand;
    }
    
    SQL_Update_Brand = [NSMutableString string];
    [SQL_Update_Brand appendFormat:@"UPDATE %@ SET ", SQL_TABLE_Brand];
    [SQL_Update_Brand appendFormat:@"%@ = ?, " , b_entityID];
    [SQL_Update_Brand appendFormat:@"%@ = ?, " , b_name];
    [SQL_Update_Brand appendFormat:@"%@ = ?  " , b_brandFirstLetter];
    [SQL_Update_Brand appendFormat:@"WHERE %@ = ?  ", b_entityID];
    
    return SQL_Update_Brand;
}

static inline NSString * SQL_Delete_Brand_All () {
    static NSMutableString * SQL_Delete_Brand_All;
    if (SQL_Delete_Brand_All) {
        return SQL_Delete_Brand_All;
    }
    
    SQL_Delete_Brand_All = [NSMutableString string];
    [SQL_Delete_Brand_All appendFormat:@"DELETE FROM %@ ", SQL_TABLE_Brand];
    return SQL_Delete_Brand_All;
}

static inline NSString * SQL_Query_Brand_By_BrandID () {
    static NSMutableString * SQL_Query_Brand_By_BrandID;
    if (SQL_Query_Brand_By_BrandID) {
        return SQL_Query_Brand_By_BrandID;
    }
    
    SQL_Query_Brand_By_BrandID = [NSMutableString string];
    [SQL_Query_Brand_By_BrandID appendFormat:@"SELECT * FROM %@ ", SQL_TABLE_Brand];
    [SQL_Query_Brand_By_BrandID appendFormat:@"WHERE %@ = ?", b_entityID];
    return SQL_Query_Brand_By_BrandID;
}

static inline NSString * SQL_Query_Brand_All () {
    static NSMutableString * SQL_Query_Brand_All;
    if (SQL_Query_Brand_All) {
        return SQL_Query_Brand_All;
    }
    
    SQL_Query_Brand_All = [NSMutableString string];
    [SQL_Query_Brand_All appendFormat:@"SELECT * FROM %@ ", SQL_TABLE_Brand];
    [SQL_Query_Brand_All appendFormat:@"ORDER BY %@ ASC", b_entityID]; //升序
    return SQL_Query_Brand_All;
}


@implementation SRDataBase (BrandInfo)

- (void)createBrandInfoTable
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self.databaseQueue inDatabase:^(FMDatabase *db) {
#if DataBaseEncrypd
            [db setKey:DB_ENCRYP_KEY];
#endif
            [db setShouldCacheStatements:YES];
            
            if ([db tableExists:SQL_TABLE_Brand]) {
                [self checkBrandColumn:db];
                return ;
            };
            
            if ([db executeUpdate:SQL_Creat_BrandTable()]) {
                SRLogDebug(@"Customer 表创建成功");
            } else {
                SRLogError(@"Customer 表创建失败");
            }
        }];
        [self.databaseQueue close];
    });
}

- (void)checkBrandColumn:(FMDatabase *)db
{
    
}

- (void)updateBrandInfos:(NSArray *)list withCompleteBlock:(CompleteBlock)completeBlock
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
            
            [list enumerateObjectsUsingBlock:^(SRBrandInfo *info, NSUInteger idx, BOOL *stop) {
                FMResultSet *resultSet = [db executeQuery:SQL_Query_Brand_By_BrandID(), @(info.entityID)];
                if (resultSet.next) {
                    if (info.seriesList && info.seriesList.count > 0) {
                        result = [db executeUpdate:SQL_Update_Brand(),
                                  @(info.entityID),
                                  info.name,
                                  info.brandFirstLetter,
                                  info.seriesListString,
                                  @(info.entityID)];
                    } else {
                        result = [db executeUpdate:SQL_Update_Brand_Without_SeriesList(),
                                  @(info.entityID),
                                  info.name,
                                  info.brandFirstLetter,
                                  @(info.entityID)];
                    }
                    
                } else {
                    result = [db executeUpdate:SQL_Insert_Brand(),
                              @(info.entityID),
                              info.name,
                              info.brandFirstLetter,
                              info.seriesListString,
                              @(info.entityID)];
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
            error = [NSError errorWithDomain:@"更新失败" code:-1 userInfo:((SRBrandInfo *)list[index]).keyValues];
        } else {
            SRLogDebug(@"更新成功");
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            !completeBlock?:completeBlock(error, @(result));
        });
    });
    
#if RealmEnable
    [[SRRealm sharedInterface] updateBrandInfos:list withCompleteBlock:nil];
#endif

}

- (void)deleteAllBrandInfosWithCompleteBlock:(CompleteBlock)completeBlock
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSError *error = nil;
        __block BOOL result = NO;
        [self.databaseQueue inDatabase:^(FMDatabase *db) {
#if DataBaseEncrypd
            [db setKey:DB_ENCRYP_KEY];
#endif
            result = [db executeUpdate:SQL_Delete_Brand_All()];
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
    [[SRRealm sharedInterface] deleteAllBrandInfosWithCompleteBlock:nil];
#endif
}

- (void)queryBrandInfoByBrandID:(NSInteger)brandID withCompleteBlock:(CompleteBlock)completeBlock
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        __block NSMutableArray *list = [NSMutableArray array];
        [self.databaseQueue inDatabase:^(FMDatabase *db) {
#if DataBaseEncrypd
            [db setKey:DB_ENCRYP_KEY];
#endif
            
            @autoreleasepool {
                FMResultSet *resultSet = [db executeQuery:SQL_Query_Brand_By_BrandID(), @(brandID)];
                while ([resultSet next]) {
                    
                    SRBrandInfo *info       = [[SRBrandInfo alloc] init];
                    info.entityID           = [resultSet intForColumn:b_entityID];
                    info.name               = [resultSet stringForColumn:b_name];
                    info.brandFirstLetter   = [resultSet stringForColumn:b_brandFirstLetter];
                    
                    [info setSeriesListWithString:[resultSet stringForColumn:b_seriesList]];
                    
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
    [[SRRealm sharedInterface] queryAllBrandInfosWithCompleteBlock:nil];
#endif
}

- (void)queryAllBrandInfosWithCompleteBlock:(CompleteBlock)completeBlock
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        __block NSMutableArray *list = [NSMutableArray array];
//        [self.databaseQueue inDatabase:^(FMDatabase *db) {
//#if DataBaseEncrypd
//            [db setKey:DB_ENCRYP_KEY];
//#endif
//            
//            @autoreleasepool {
//                FMResultSet *resultSet = [db executeQuery:SQL_Query_Brand_All()];
//                while ([resultSet next]) {
//                    
//                    SRBrandInfo *info       = [[SRBrandInfo alloc] init];
//                    info.entityID           = [resultSet intForColumn:b_entityID];
//                    info.name               = [resultSet stringForColumn:b_name];
//                    info.brandFirstLetter   = [resultSet stringForColumn:b_brandFirstLetter];
//                    
//                    [info setSeriesListWithString:[resultSet stringForColumn:b_seriesList]];
//                    
//                    [list addObject:info];
//                }
//                [resultSet close];
//            }
//
//        }];
//        [self.databaseQueue close];
        
        [self.databaseQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
#if DataBaseEncrypd
            [db setKey:DB_ENCRYP_KEY];
#endif
            
            @autoreleasepool {
                FMResultSet *resultSet = [db executeQuery:SQL_Query_Brand_All()];
                while ([resultSet next]) {
                    
                    SRBrandInfo *info       = [[SRBrandInfo alloc] init];
                    info.entityID           = [resultSet intForColumn:b_entityID];
                    info.name               = [resultSet stringForColumn:b_name];
                    info.brandFirstLetter   = [resultSet stringForColumn:b_brandFirstLetter];
                    
                    [info setSeriesListWithString:[resultSet stringForColumn:b_seriesList]];
                    
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
    [[SRRealm sharedInterface] queryAllBrandInfosWithCompleteBlock:nil];
#endif
}

@end

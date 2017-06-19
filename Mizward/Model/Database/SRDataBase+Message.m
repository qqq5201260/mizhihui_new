//
//  SRDataBase+Message.m
//  
//
//  Created by zhangjunbo on 15/6/16.
//
//

#import "SRDataBase+Message.h"
#import "SRMessageInfo.h"
#import "SRUserDefaults.h"
#import <FMDB/FMDB.h>
#import <MJExtension/MJExtension.h>

#import "SRRealm+Message.h"

// DB Table
NSString * const SQL_TABLE_Message = @"Message";

//元素
NSString * const m_type     = @"type";
NSString * const m_msgtype  = @"msgtype";
NSString * const m_msgid    = @"msgid";
NSString * const m_customerid = @"customerid";
NSString * const m_vehicleid  = @"vehicleid";
NSString * const m_message    = @"message";
NSString * const m_time     = @"time";

//SQL 语句
static inline NSString * SQL_Create_MessageTable () {
    static NSMutableString * _SQL_Create_MessageTable;
    if (_SQL_Create_MessageTable) {
        return _SQL_Create_MessageTable;
    }
    
    _SQL_Create_MessageTable = [NSMutableString string];
    [_SQL_Create_MessageTable appendFormat:@"CREATE TABLE IF NOT EXISTS %@ ", SQL_TABLE_Message];
    [_SQL_Create_MessageTable appendFormat:@"("];
    [_SQL_Create_MessageTable appendFormat:@"%@ INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL ,", m_msgid];
    [_SQL_Create_MessageTable appendFormat:@"%@ INTEGER      , " , m_type];
    [_SQL_Create_MessageTable appendFormat:@"%@ INTEGER      , " , m_msgtype];
    [_SQL_Create_MessageTable appendFormat:@"%@ INTEGER      , " , m_customerid];
    [_SQL_Create_MessageTable appendFormat:@"%@ INTEGER      , " , m_vehicleid];
    [_SQL_Create_MessageTable appendFormat:@"%@ TEXT         , " , m_message];
    [_SQL_Create_MessageTable appendFormat:@"%@ VARCHAR(64)    " , m_time];
    [_SQL_Create_MessageTable appendFormat:@")"];
    
    return _SQL_Create_MessageTable;
}

static inline NSString * SQL_Insert_Message () {
    static NSMutableString * _SQL_Insert_Message;
    if (_SQL_Insert_Message) {
        return _SQL_Insert_Message;
    }
    
    _SQL_Insert_Message = [NSMutableString string];
    [_SQL_Insert_Message appendFormat:@"INSERT INTO %@ ", SQL_TABLE_Message];
    [_SQL_Insert_Message appendFormat:@"("];
    [_SQL_Insert_Message appendFormat:@"%@ , " , m_msgid];
    [_SQL_Insert_Message appendFormat:@"%@ , " , m_type];
    [_SQL_Insert_Message appendFormat:@"%@ , " , m_msgtype];
    [_SQL_Insert_Message appendFormat:@"%@ , " , m_customerid];
    [_SQL_Insert_Message appendFormat:@"%@ , " , m_vehicleid];
    [_SQL_Insert_Message appendFormat:@"%@ , " , m_message];
    [_SQL_Insert_Message appendFormat:@"%@   " , m_time];
    [_SQL_Insert_Message appendFormat:@")"];
    [_SQL_Insert_Message appendFormat:@"VALUES (?, ?, ?, ?, ?, ?, ?)"];
    
    return _SQL_Insert_Message;
}

static inline NSString * SQL_Update_Message () {
    static NSMutableString * _SQL_Update_Message;
    if (_SQL_Update_Message) {
        return _SQL_Update_Message;
    }
    
    _SQL_Update_Message = [NSMutableString string];
    [_SQL_Update_Message appendFormat:@"UPDATE %@ SET ", SQL_TABLE_Message];
    [_SQL_Update_Message appendFormat:@"%@ = ?, " , m_msgid];
    [_SQL_Update_Message appendFormat:@"%@ = ?, " , m_type];
    [_SQL_Update_Message appendFormat:@"%@ = ?, " , m_msgtype];
    [_SQL_Update_Message appendFormat:@"%@ = ?, " , m_customerid];
    [_SQL_Update_Message appendFormat:@"%@ = ?, " , m_vehicleid];
    [_SQL_Update_Message appendFormat:@"%@ = ?, " , m_message];
    [_SQL_Update_Message appendFormat:@"%@ = ?  " , m_time];
    [_SQL_Update_Message appendFormat:@"WHERE %@ = ?  ", m_msgid];
    
    return _SQL_Update_Message;
}

static inline NSString * SQL_Delete_Message () {
    static NSMutableString * _SQL_Delete_Message;
    if (_SQL_Delete_Message) {
        return _SQL_Delete_Message;
    }
    
    _SQL_Delete_Message = [NSMutableString string];
    [_SQL_Delete_Message appendFormat:@"DELETE FROM %@ ", SQL_TABLE_Message];
    [_SQL_Delete_Message appendFormat:@"WHERE %@ = ?", m_msgid];
    return _SQL_Delete_Message;
}

static inline NSString * SQL_Delete_Message_By_Type () {
    static NSMutableString * _SQL_Delete_Message_By_Type;
    if (_SQL_Delete_Message_By_Type) {
        return _SQL_Delete_Message_By_Type;
    }
    
    _SQL_Delete_Message_By_Type = [NSMutableString string];
    [_SQL_Delete_Message_By_Type appendFormat:@"DELETE FROM %@ ", SQL_TABLE_Message];
    [_SQL_Delete_Message_By_Type appendFormat:@"WHERE %@ = ?", m_type];
    return _SQL_Delete_Message_By_Type;
}

static inline NSString * SQL_Delete_All () {
    static NSMutableString * _SQL_Delete_All;
    if (_SQL_Delete_All) {
        return _SQL_Delete_All;
    }
    
    _SQL_Delete_All = [NSMutableString string];
    [_SQL_Delete_All appendFormat:@"DELETE FROM %@ ", SQL_TABLE_Message];
    return _SQL_Delete_All;
}

static inline NSString * SQL_Query_All () {
    static NSMutableString * _SQL_Query_All;
    if (_SQL_Query_All) {
        return _SQL_Query_All;
    }
    
    _SQL_Query_All = [NSMutableString string];
    [_SQL_Query_All appendFormat:@"SELECT * FROM %@ ", SQL_TABLE_Message];
    [_SQL_Query_All appendFormat:@"ORDER BY %@ DESC", m_msgid];
    
    return _SQL_Query_All;
}

static inline NSString * SQL_Query_Message_By_Type_Customer () {
    static NSMutableString * _SQL_Query_Message_By_Type_Customer_Veshicle;
    if (_SQL_Query_Message_By_Type_Customer_Veshicle) {
        return _SQL_Query_Message_By_Type_Customer_Veshicle;
    }
    
    _SQL_Query_Message_By_Type_Customer_Veshicle = [NSMutableString string];
    [_SQL_Query_Message_By_Type_Customer_Veshicle appendFormat:@"SELECT * FROM %@ ", SQL_TABLE_Message];
    [_SQL_Query_Message_By_Type_Customer_Veshicle appendFormat:@"WHERE %@ = ?", m_type];
    [_SQL_Query_Message_By_Type_Customer_Veshicle appendFormat:@"AND   %@ = ?", m_customerid];
    [_SQL_Query_Message_By_Type_Customer_Veshicle appendFormat:@"ORDER BY %@ DESC", m_msgid]; //降序 ASC升序
    
    return _SQL_Query_Message_By_Type_Customer_Veshicle;
}

static inline NSString * SQL_Query_Message_By_MessageID () {
    static NSMutableString * _SQL_Query_Message_By_MessageID;
    if (_SQL_Query_Message_By_MessageID) {
        return _SQL_Query_Message_By_MessageID;
    }
    
    _SQL_Query_Message_By_MessageID = [NSMutableString string];
    [_SQL_Query_Message_By_MessageID appendFormat:@"SELECT * FROM %@ ", SQL_TABLE_Message];
    [_SQL_Query_Message_By_MessageID appendFormat:@"WHERE %@ = ?", m_msgid];
    
    return _SQL_Query_Message_By_MessageID;
}

@implementation SRDataBase (Message)

- (void)createMessageTable {
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self.databaseQueue inDatabase:^(FMDatabase *db) {
#if DataBaseEncrypd
            [db setKey:DB_ENCRYP_KEY];
#endif
            [db setShouldCacheStatements:YES];
            if ([db executeUpdate:SQL_Create_MessageTable()]) {
                SRLogDebug(@"Message 表创建成功");
            } else {
                SRLogError(@"Message 表创建失败");
            }
        }];
        [self.databaseQueue close];
    });
}

- (void)updateMessageInfo:(SRMessageInfo *)info withCompleteBlock:(CompleteBlock)completeBlock
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSError *error = nil;
        __block BOOL result = NO;
        [self.databaseQueue inDatabase:^(FMDatabase *db) {
#if DataBaseEncrypd
            [db setKey:DB_ENCRYP_KEY];
#endif
            FMResultSet *resultSet = [db executeQuery:SQL_Query_Message_By_MessageID(), @(info.msgid)];
            if (resultSet.next) {
                result = [db executeUpdate:SQL_Update_Message(),
                          @(info.msgid),
                          @(info.type),
                          @(info.msgtype),
                          @(info.customerid),
                          @(info.vehicleid),
                          info.message,
                          info.time,
                          @(info.msgid)];
            } else {
                result = [db executeUpdate:SQL_Insert_Message(),
                          @(info.msgid),
                          @(info.type),
                          @(info.msgtype),
                          @(info.customerid),
                          @(info.vehicleid),
                          info.message,
                          info.time];
            }
            [resultSet close];
        }];
        [self.databaseQueue close];
        if (!result) {
            error = [NSError errorWithDomain:@"更新失败" code:-1 userInfo:info.keyValues];
        } else {
            SRLogDebug(@"%@ 更新成功", info.keyValues);
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            !completeBlock?:completeBlock(error, @(result));
        });
        
    });
    
#if RealmEnable
    [[SRRealm sharedInterface] updateMessageInfo:info withCompleteBlock:nil];
#endif
    
}

- (void)updateMessageInfos:(NSArray *)infos withCompleteBlock:(CompleteBlock)completeBlock
{
    if (!infos || infos.count==0) {
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
            
            [infos enumerateObjectsUsingBlock:^(SRMessageInfo *info, NSUInteger idx, BOOL *stop) {
                FMResultSet *resultSet = [db executeQuery:SQL_Query_Message_By_MessageID(), @(info.msgid)];
                if (resultSet.next) {
                    result = [db executeUpdate:SQL_Update_Message(),
                              @(info.msgid),
                              @(info.type),
                              @(info.msgtype),
                              @(info.customerid),
                              @(info.vehicleid),
                              info.message,
                              info.time,
                              @(info.msgid)];
                } else {
                    result = [db executeUpdate:SQL_Insert_Message(),
                              @(info.msgid),
                              @(info.type),
                              @(info.msgtype),
                              @(info.customerid),
                              @(info.vehicleid),
                              info.message,
                              info.time];
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
            error = [NSError errorWithDomain:@"写入失败" code:-1 userInfo:((SRMessageInfo *)infos[index]).keyValues];
        } else {
            SRLogDebug(@"插入成功");
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            !completeBlock?:completeBlock(error, @(result));
        });
        
    });
    
#if RealmEnable
    [[SRRealm sharedInterface] updateMessageInfos:infos withCompleteBlock:nil];
#endif
}

- (void)deleteMessageInfo:(SRMessageInfo *)info withCompleteBlock:(CompleteBlock)completeBlock
{
    if (!info) {
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
            result = [db executeUpdate:SQL_Delete_Message(), @(info.msgid)];
        }];
        [self.databaseQueue close];
        if (!result) {
            error = [NSError errorWithDomain:@"删除失败" code:-1 userInfo:info.keyValues];
        } else {
            SRLogDebug(@"%@ 删除成功", info.keyValues);
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            !completeBlock?:completeBlock(error, @(result));
        });
        
    });
    
#if RealmEnable
    [[SRRealm sharedInterface] deleteMessageInfo:info withCompleteBlock:nil];
#endif
}

- (void)deleteMessageInfoWithMessageType:(SRMessageType)messageType CompleteBlock:(CompleteBlock)completeBlock
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSError *error = nil;
        __block BOOL result = NO;
        [self.databaseQueue inDatabase:^(FMDatabase *db) {
#if DataBaseEncrypd
            [db setKey:DB_ENCRYP_KEY];
#endif
            result = [db executeUpdate:SQL_Delete_Message_By_Type(),@(messageType)];
        }];
        [self.databaseQueue close];
        if (!result) {
            error = [NSError errorWithDomain:@"删除失败" code:-1 userInfo:nil];
        } else {
            SRLogDebug(@"删除成功");
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            !completeBlock?:completeBlock(error, @(result));
        });
        
    });
    
#if RealmEnable
    [[SRRealm sharedInterface] deleteMessageInfoWithMessageType:messageType CompleteBlock:nil];
#endif
}

- (void)deleteAllMessageInfosWithCompleteBlock:(CompleteBlock)completeBlock
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSError *error = nil;
        __block BOOL result = NO;
        [self.databaseQueue inDatabase:^(FMDatabase *db) {
#if DataBaseEncrypd
            [db setKey:DB_ENCRYP_KEY];
#endif
            result = [db executeUpdate:SQL_Delete_All()];
        }];
        [self.databaseQueue close];
        
        if (!result) {
            error = [NSError errorWithDomain:@"删除失败" code:-1 userInfo:nil];
        } else {
            SRLogDebug(@"删除成功");
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            !completeBlock?:completeBlock(error, @(result));
        });
        
    });
    
#if RealmEnable
    [[SRRealm sharedInterface] deleteAllMessageInfosWithCompleteBlock:nil];
#endif
}

- (void)queryMessageInfoWithVehicleID:(NSInteger)vehicleID customerID:(NSInteger)customerID messageType:(SRMessageType)messageType CompleteBlock:(CompleteBlock)completeBlock
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        __block NSMutableArray *list = [NSMutableArray array];
        [self.databaseQueue inDatabase:^(FMDatabase *db) {
#if DataBaseEncrypd
            [db setKey:DB_ENCRYP_KEY];
#endif
            @autoreleasepool {
                FMResultSet *resultSet = [db executeQuery:SQL_Query_Message_By_Type_Customer(), @(messageType), @(customerID)];
                while ([resultSet next]) {
                    SRMessageInfo *info = [[SRMessageInfo alloc] init];
                    info.type       = [resultSet stringForColumn:m_type].integerValue;
                    info.msgtype    = [resultSet stringForColumn:m_msgtype].integerValue;
                    info.msgid      = [resultSet stringForColumn:m_msgid].integerValue;
                    info.customerid = [resultSet stringForColumn:m_customerid].integerValue;
                    info.vehicleid  = [resultSet stringForColumn:m_vehicleid].integerValue;
                    info.message    = [resultSet stringForColumn:m_message];
                    info.time       = [resultSet stringForColumn:m_time];
                    
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
    [[SRRealm sharedInterface] queryMessageInfoWithVehicleID:vehicleID customerID:customerID messageType:messageType CompleteBlock:nil];
#endif
}

- (void)queryMessageInfoWithMessageType:(SRMessageType)messageType CompleteBlock:(CompleteBlock)completeBlock
{
    [self queryMessageInfoWithVehicleID:[SRUserDefaults currentVehicleID]
                             customerID:[SRUserDefaults customerID]
                            messageType:messageType
                          CompleteBlock:completeBlock];
}

- (void)queryMessageInfoWithMessageID:(NSInteger)msgID CompleteBlock:(CompleteBlock)completeBlock
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        __block NSMutableArray *list = [NSMutableArray array];
        [self.databaseQueue inDatabase:^(FMDatabase *db) {
#if DataBaseEncrypd
            [db setKey:DB_ENCRYP_KEY];
#endif
            @autoreleasepool {
                FMResultSet *resultSet = [db executeQuery:SQL_Query_Message_By_MessageID(), @(msgID)];
                while ([resultSet next]) {
                    SRMessageInfo *info = [[SRMessageInfo alloc] init];
                    info.type       = [resultSet stringForColumn:m_type].integerValue;
                    info.msgtype    = [resultSet stringForColumn:m_msgtype].integerValue;
                    info.msgid      = [resultSet stringForColumn:m_msgid].integerValue;
                    info.customerid = [resultSet stringForColumn:m_customerid].integerValue;
                    info.vehicleid  = [resultSet stringForColumn:m_vehicleid].integerValue;
                    info.message    = [resultSet stringForColumn:m_message];
                    info.time       = [resultSet stringForColumn:m_time];
                    
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
    [[SRRealm sharedInterface] queryMessageInfoWithMessageID:msgID CompleteBlock:nil];
#endif
}

- (void)queryAllMessageInfosWithCompleteBlock:(CompleteBlock)completeBlock
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        __block NSMutableArray *list = [NSMutableArray array];
        [self.databaseQueue inDatabase:^(FMDatabase *db) {
#if DataBaseEncrypd
            [db setKey:DB_ENCRYP_KEY];
#endif
            @autoreleasepool {
                FMResultSet *resultSet = [db executeQuery:SQL_Query_All()];
                while ([resultSet next]) {
                    SRMessageInfo *info = [[SRMessageInfo alloc] init];
                    info.type       = [resultSet stringForColumn:m_type].integerValue;
                    info.msgtype    = [resultSet stringForColumn:m_msgtype].integerValue;
                    info.msgid      = [resultSet stringForColumn:m_msgid].integerValue;
                    info.customerid = [resultSet stringForColumn:m_customerid].integerValue;
                    info.vehicleid  = [resultSet stringForColumn:m_vehicleid].integerValue;
                    info.message    = [resultSet stringForColumn:m_message];
                    info.time       = [resultSet stringForColumn:m_time];
                    
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
    [[SRRealm sharedInterface] queryAllMessageInfosWithCompleteBlock:nil];
#endif
}


@end

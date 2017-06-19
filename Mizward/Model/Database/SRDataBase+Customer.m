
//
//  SRDataBase+Customer.m
//  SiRuiV4.0
//
//  Created by zhangjunbo on 15/6/16.
//  Copyright (c) 2015年 SiRui. All rights reserved.
//

#import "SRDataBase+Customer.h"
#import "SRCustomer.h"
#import <FMDB/FMDB.h>
#import <MJExtension/MJExtension.h>

#import "SRRealm+Customer.h"

// DB Table
NSString * const SQL_TABLE_Customer = @"Customer";

//元素
NSString * const c_customerID           = @"customerID";
NSString * const c_hashCode             = @"hashCode";
NSString * const c_customerIDNumber     = @"customerIDNumber";
NSString * const c_customerUserName     = @"customerUserName";
NSString * const c_name                 = @"name";
NSString * const c_customerSex          = @"customerSex";
NSString * const c_customerBirthday     = @"customerBirthday";
NSString * const c_customerPhone        = @"customerPhone";
NSString * const c_customerEmail        = @"customerEmail";
NSString * const c_customerAddress      = @"customerAddress";
NSString * const c_depID                = @"depID";
NSString * const c_depName              = @"depName";
NSString * const c_levelCode            = @"levelCode";
NSString * const c_bindingStatus        = @"bindingStatus";
NSString * const c_openHiddenTrip       = @"openHiddenTrip";
NSString * const c_realNameAuthentication       = @"realNameAuthentication";
NSString * const c_customerType         = @"customerType";
NSString * const c_exhibitionExperienceTime     = @"exhibitionExperienceTime";
NSString * const c_permissions          = @"permissions";
NSString * const c_messageSwitchs       = @"messageSwitchs";
NSString * const c_messageUnread        = @"messageUnread";

//2015-12-11 新增
NSString * const c_accountCash          = @"accountCash";
NSString * const c_hasCarNeedRenew      = @"hasCarNeedRenew";
NSString * const c_hasTodaySign         = @"hasTodaySign";
NSString * const c_continuousSignDay    = @"continuousSignDay";
NSString * const c_point                = @"point";
NSString * const c_headImg              = @"headImg";
NSString * const c_signedDate           = @"signedDate";

//SQL 语句
static inline NSString * SQL_Creat_CustomerTable () {
    static NSMutableString * SQL_Creat_CustomerTable;
    if (SQL_Creat_CustomerTable) {
        return SQL_Creat_CustomerTable;
    }
    
    SQL_Creat_CustomerTable = [NSMutableString string];
    [SQL_Creat_CustomerTable appendFormat:@"CREATE TABLE IF NOT EXISTS %@ ", SQL_TABLE_Customer];
    [SQL_Creat_CustomerTable appendFormat:@"("];
    [SQL_Creat_CustomerTable appendFormat:@"%@ INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL ,", c_customerID];
    [SQL_Creat_CustomerTable appendFormat:@"%@ VARCHAR(256) , " , c_hashCode];
    [SQL_Creat_CustomerTable appendFormat:@"%@ VARCHAR(64)  , " , c_customerIDNumber];
    [SQL_Creat_CustomerTable appendFormat:@"%@ VARCHAR(64)  , " , c_customerUserName];
    [SQL_Creat_CustomerTable appendFormat:@"%@ VARCHAR(64)  , " , c_name];
    [SQL_Creat_CustomerTable appendFormat:@"%@ INTEGER      , " , c_customerSex];
    [SQL_Creat_CustomerTable appendFormat:@"%@ VARCHAR(64)  , " , c_customerBirthday];
    [SQL_Creat_CustomerTable appendFormat:@"%@ VARCHAR(64)  , " , c_customerPhone];
    [SQL_Creat_CustomerTable appendFormat:@"%@ VARCHAR(64)  , " , c_customerEmail];
    [SQL_Creat_CustomerTable appendFormat:@"%@ VARCHAR(256) , " , c_customerAddress];
    [SQL_Creat_CustomerTable appendFormat:@"%@ INTEGER      , " , c_depID];
    [SQL_Creat_CustomerTable appendFormat:@"%@ VARCHAR(64)  , " , c_depName];
    [SQL_Creat_CustomerTable appendFormat:@"%@ VARCHAR(64)  , " , c_levelCode];
    [SQL_Creat_CustomerTable appendFormat:@"%@ INTEGER      , " , c_bindingStatus];
    [SQL_Creat_CustomerTable appendFormat:@"%@ BIT          , " , c_openHiddenTrip];
    [SQL_Creat_CustomerTable appendFormat:@"%@ INTEGER      , " , c_realNameAuthentication];
    [SQL_Creat_CustomerTable appendFormat:@"%@ INTEGER      , " , c_customerType];
    [SQL_Creat_CustomerTable appendFormat:@"%@ INTEGER      , " , c_exhibitionExperienceTime];
    [SQL_Creat_CustomerTable appendFormat:@"%@ TEXT         , " , c_permissions];
    [SQL_Creat_CustomerTable appendFormat:@"%@ TEXT         , " , c_messageSwitchs];
    [SQL_Creat_CustomerTable appendFormat:@"%@ TEXT         , " , c_messageUnread];
    
    [SQL_Creat_CustomerTable appendFormat:@"%@ FLOAT        , " , c_accountCash];
    [SQL_Creat_CustomerTable appendFormat:@"%@ BIT          , " , c_hasCarNeedRenew];
    [SQL_Creat_CustomerTable appendFormat:@"%@ BIT          , " , c_hasTodaySign];
    [SQL_Creat_CustomerTable appendFormat:@"%@ INTEGER      , " , c_continuousSignDay];
    [SQL_Creat_CustomerTable appendFormat:@"%@ INTEGER      , " , c_point];
    [SQL_Creat_CustomerTable appendFormat:@"%@ TEXT         , " , c_headImg];
    [SQL_Creat_CustomerTable appendFormat:@"%@ INTEGER        " , c_signedDate];
    [SQL_Creat_CustomerTable appendFormat:@")"];
    
    return SQL_Creat_CustomerTable;
}

static inline NSString * SQL_Insert_Customer () {
    static NSMutableString * SQL_Insert_Customer;
    if (SQL_Insert_Customer) {
        return SQL_Insert_Customer;
    }
    
    SQL_Insert_Customer = [NSMutableString string];
    [SQL_Insert_Customer appendFormat:@"INSERT INTO %@ ", SQL_TABLE_Customer];
    [SQL_Insert_Customer appendFormat:@"("];
    [SQL_Insert_Customer appendFormat:@"%@ , " , c_customerID];
    [SQL_Insert_Customer appendFormat:@"%@ , " , c_hashCode];
    [SQL_Insert_Customer appendFormat:@"%@ , " , c_customerIDNumber];
    [SQL_Insert_Customer appendFormat:@"%@ , " , c_customerUserName];
    [SQL_Insert_Customer appendFormat:@"%@ , " , c_name];
    [SQL_Insert_Customer appendFormat:@"%@ , " , c_customerSex];
    [SQL_Insert_Customer appendFormat:@"%@ , " , c_customerBirthday];
    [SQL_Insert_Customer appendFormat:@"%@ , " , c_customerPhone];
    [SQL_Insert_Customer appendFormat:@"%@ , " , c_customerEmail];
    [SQL_Insert_Customer appendFormat:@"%@ , " , c_customerAddress];
    [SQL_Insert_Customer appendFormat:@"%@ , " , c_depID];
    [SQL_Insert_Customer appendFormat:@"%@ , " , c_depName];
    [SQL_Insert_Customer appendFormat:@"%@ , " , c_levelCode];
    [SQL_Insert_Customer appendFormat:@"%@ , " , c_bindingStatus];
    [SQL_Insert_Customer appendFormat:@"%@ , " , c_openHiddenTrip];
    [SQL_Insert_Customer appendFormat:@"%@ , " , c_realNameAuthentication];
    [SQL_Insert_Customer appendFormat:@"%@ , " , c_customerType];
    [SQL_Insert_Customer appendFormat:@"%@ , " , c_exhibitionExperienceTime];
    [SQL_Insert_Customer appendFormat:@"%@ , " , c_permissions];
    [SQL_Insert_Customer appendFormat:@"%@ , " , c_messageSwitchs];
    [SQL_Insert_Customer appendFormat:@"%@ , " , c_messageUnread];
    
    [SQL_Insert_Customer appendFormat:@"%@ , " , c_accountCash];
    [SQL_Insert_Customer appendFormat:@"%@ , " , c_hasCarNeedRenew];
    [SQL_Insert_Customer appendFormat:@"%@ , " , c_hasTodaySign];
    [SQL_Insert_Customer appendFormat:@"%@ , " , c_continuousSignDay];
    [SQL_Insert_Customer appendFormat:@"%@ , " , c_point];
    [SQL_Insert_Customer appendFormat:@"%@ , " , c_headImg];
    [SQL_Insert_Customer appendFormat:@"%@   " , c_signedDate];
    [SQL_Insert_Customer appendFormat:@")"];
    [SQL_Insert_Customer appendFormat:@"VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)"];
    
    return SQL_Insert_Customer;
}

static inline NSString * SQL_Update_Customer () {
    static NSMutableString * SQL_Update_Customer;
    if (SQL_Update_Customer) {
        return SQL_Update_Customer;
    }
    
    SQL_Update_Customer = [NSMutableString string];
    [SQL_Update_Customer appendFormat:@"UPDATE %@ SET ", SQL_TABLE_Customer];
    [SQL_Update_Customer appendFormat:@"%@ = ?, " , c_customerID];
    [SQL_Update_Customer appendFormat:@"%@ = ?, " , c_hashCode];
    [SQL_Update_Customer appendFormat:@"%@ = ?, " , c_customerIDNumber];
    [SQL_Update_Customer appendFormat:@"%@ = ?, " , c_customerUserName];
    [SQL_Update_Customer appendFormat:@"%@ = ?, " , c_name];
    [SQL_Update_Customer appendFormat:@"%@ = ?, " , c_customerSex];
    [SQL_Update_Customer appendFormat:@"%@ = ?, " , c_customerBirthday];
    [SQL_Update_Customer appendFormat:@"%@ = ?, " , c_customerPhone];
    [SQL_Update_Customer appendFormat:@"%@ = ?, " , c_customerEmail];
    [SQL_Update_Customer appendFormat:@"%@ = ?, " , c_customerAddress];
    [SQL_Update_Customer appendFormat:@"%@ = ?, " , c_depID];
    [SQL_Update_Customer appendFormat:@"%@ = ?, " , c_depName];
    [SQL_Update_Customer appendFormat:@"%@ = ?, " , c_levelCode];
    [SQL_Update_Customer appendFormat:@"%@ = ?, " , c_bindingStatus];
    [SQL_Update_Customer appendFormat:@"%@ = ?, " , c_openHiddenTrip];
    [SQL_Update_Customer appendFormat:@"%@ = ?, " , c_realNameAuthentication];
    [SQL_Update_Customer appendFormat:@"%@ = ?, " , c_customerType];
    [SQL_Update_Customer appendFormat:@"%@ = ?, " , c_exhibitionExperienceTime];
    [SQL_Update_Customer appendFormat:@"%@ = ?, " , c_permissions];
    [SQL_Update_Customer appendFormat:@"%@ = ?, " , c_messageSwitchs];
    [SQL_Update_Customer appendFormat:@"%@ = ?, " , c_messageUnread];
    [SQL_Update_Customer appendFormat:@"%@ = ?, " , c_accountCash];
    [SQL_Update_Customer appendFormat:@"%@ = ?, " , c_hasCarNeedRenew];
    [SQL_Update_Customer appendFormat:@"%@ = ?, " , c_hasTodaySign];
    [SQL_Update_Customer appendFormat:@"%@ = ?, " , c_continuousSignDay];
    [SQL_Update_Customer appendFormat:@"%@ = ?, " , c_point];
    [SQL_Update_Customer appendFormat:@"%@ = ?, " , c_headImg];
    [SQL_Update_Customer appendFormat:@"%@ = ?  " , c_signedDate];
    [SQL_Update_Customer appendFormat:@"WHERE %@ = ?  ", c_customerID];
    
    return SQL_Update_Customer;
}

static inline NSString * SQL_Delete_Customer_By_ID () {
    static NSMutableString * SQL_Delete_Customer_By_ID;
    if (SQL_Delete_Customer_By_ID) {
        return SQL_Delete_Customer_By_ID;
    }
    
    SQL_Delete_Customer_By_ID = [NSMutableString string];
    [SQL_Delete_Customer_By_ID appendFormat:@"DELETE FROM %@ ", SQL_TABLE_Customer];
    [SQL_Delete_Customer_By_ID appendFormat:@"WHERE %@ = ?", c_customerID];
    return SQL_Delete_Customer_By_ID;
}

static inline NSString * SQL_Delete_Customer_By_UserName () {
    static NSMutableString * SQL_Delete_Customer_By_UserName;
    if (SQL_Delete_Customer_By_UserName) {
        return SQL_Delete_Customer_By_UserName;
    }
    
    SQL_Delete_Customer_By_UserName = [NSMutableString string];
    [SQL_Delete_Customer_By_UserName appendFormat:@"DELETE FROM %@ ", SQL_TABLE_Customer];
    [SQL_Delete_Customer_By_UserName appendFormat:@"WHERE %@ = ?", c_customerUserName];
    return SQL_Delete_Customer_By_UserName;
}

static inline NSString * SQL_Delete_Customer_All () {
    static NSMutableString * SQL_Delete_Customer_All;
    if (SQL_Delete_Customer_All) {
        return SQL_Delete_Customer_All;
    }
    
    SQL_Delete_Customer_All = [NSMutableString string];
    [SQL_Delete_Customer_All appendFormat:@"DELETE FROM %@ ", SQL_TABLE_Customer];
    return SQL_Delete_Customer_All;
}

static inline NSString * SQL_Query_Customer_By_ID () {
    static NSMutableString * SQL_Query_Customer_By_ID;
    if (SQL_Query_Customer_By_ID) {
        return SQL_Query_Customer_By_ID;
    }
    
    SQL_Query_Customer_By_ID = [NSMutableString string];
    [SQL_Query_Customer_By_ID appendFormat:@"SELECT * FROM %@ ", SQL_TABLE_Customer];
    [SQL_Query_Customer_By_ID appendFormat:@"WHERE %@ = ?", c_customerID];
    return SQL_Query_Customer_By_ID;
}

static inline NSString * SQL_Query_Customer_By_UserName () {
    static NSMutableString * SQL_Query_Customer_By_UserName;
    if (SQL_Query_Customer_By_UserName) {
        return SQL_Query_Customer_By_UserName;
    }
    
    SQL_Query_Customer_By_UserName = [NSMutableString string];
    [SQL_Query_Customer_By_UserName appendFormat:@"SELECT * FROM %@ ", SQL_TABLE_Customer];
    [SQL_Query_Customer_By_UserName appendFormat:@"WHERE %@ = ?", c_customerUserName];
    return SQL_Query_Customer_By_UserName;
}

static inline NSString * SQL_Query_Customer_All () {
    static NSMutableString * SQL_Query_Customer_All;
    if (SQL_Query_Customer_All) {
        return SQL_Query_Customer_All;
    }
    
    SQL_Query_Customer_All = [NSMutableString string];
    [SQL_Query_Customer_All appendFormat:@"SELECT * FROM %@ ", SQL_TABLE_Customer];
    return SQL_Query_Customer_All;
}

//2015-12-11新增
static inline NSString * SQL_Add_AccountCash_Column () {
    static NSMutableString * SQL_Add_AccountCash_Column;
    if (SQL_Add_AccountCash_Column) {
        return SQL_Add_AccountCash_Column;
    }
    
    SQL_Add_AccountCash_Column = [NSMutableString string];
    [SQL_Add_AccountCash_Column appendFormat:@"ALTER TABLE %@ ADD %@ FLOAT",
            SQL_TABLE_Customer, c_accountCash];
    return SQL_Add_AccountCash_Column;
}
static inline NSString * SQL_Add_HasCarNeedRenew_Column () {
    static NSMutableString * SQL_Add_HasCarNeedRenew_Column;
    if (SQL_Add_HasCarNeedRenew_Column) {
        return SQL_Add_HasCarNeedRenew_Column;
    }
    
    SQL_Add_HasCarNeedRenew_Column = [NSMutableString string];
    [SQL_Add_HasCarNeedRenew_Column appendFormat:@"ALTER TABLE %@ ADD %@ BIT",
     SQL_TABLE_Customer, c_hasCarNeedRenew];
    return SQL_Add_HasCarNeedRenew_Column;
}
static inline NSString * SQL_Add_HasTodaySign_Column () {
    static NSMutableString * SQL_Add_HasTodaySign_Column;
    if (SQL_Add_HasTodaySign_Column) {
        return SQL_Add_HasTodaySign_Column;
    }
    
    SQL_Add_HasTodaySign_Column = [NSMutableString string];
    [SQL_Add_HasTodaySign_Column appendFormat:@"ALTER TABLE %@ ADD %@ BIT",
     SQL_TABLE_Customer, c_hasTodaySign];
    return SQL_Add_HasTodaySign_Column;
}
static inline NSString * SQL_Add_ContinuousSignDay_Column () {
    static NSMutableString * SQL_Add_ContinuousSignDay_Column;
    if (SQL_Add_ContinuousSignDay_Column) {
        return SQL_Add_ContinuousSignDay_Column;
    }
    
    SQL_Add_ContinuousSignDay_Column = [NSMutableString string];
    [SQL_Add_ContinuousSignDay_Column appendFormat:@"ALTER TABLE %@ ADD %@ INTEGER",
     SQL_TABLE_Customer, c_continuousSignDay];
    return SQL_Add_ContinuousSignDay_Column;
}
static inline NSString * SQL_Add_Point_Column () {
    static NSMutableString * SQL_Add_Point_Column;
    if (SQL_Add_Point_Column) {
        return SQL_Add_Point_Column;
    }
    
    SQL_Add_Point_Column = [NSMutableString string];
    [SQL_Add_Point_Column appendFormat:@"ALTER TABLE %@ ADD %@ INTEGER",
     SQL_TABLE_Customer, c_point];
    return SQL_Add_Point_Column;
}
static inline NSString * SQL_Add_HeadImg_Column () {
    static NSMutableString * SQL_Add_HeadImg_Column;
    if (SQL_Add_HeadImg_Column) {
        return SQL_Add_HeadImg_Column;
    }
    
    SQL_Add_HeadImg_Column = [NSMutableString string];
    [SQL_Add_HeadImg_Column appendFormat:@"ALTER TABLE %@ ADD %@ TEXT",
     SQL_TABLE_Customer, c_headImg];
    return SQL_Add_HeadImg_Column;
}
static inline NSString * SQL_Add_SignedDate_Column () {
    static NSMutableString * SQL_Add_SignedDate_Column;
    if (SQL_Add_SignedDate_Column) {
        return SQL_Add_SignedDate_Column;
    }
    
    SQL_Add_SignedDate_Column = [NSMutableString string];
    [SQL_Add_SignedDate_Column appendFormat:@"ALTER TABLE %@ ADD %@ INTEGER",
     SQL_TABLE_Customer, c_signedDate];
    return SQL_Add_SignedDate_Column;
}

@implementation SRDataBase (Customer)

- (void)createCustomerTable
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self.databaseQueue inDatabase:^(FMDatabase *db) {
#if DataBaseEncrypd
            [db setKey:DB_ENCRYP_KEY];
#endif
            [db setShouldCacheStatements:YES];
            
            if ([db tableExists:SQL_TABLE_Customer]) {
                [self checkCustomerColumn:db];
                return ;
            };
            
            if ([db executeUpdate:SQL_Creat_CustomerTable()]) {
                SRLogDebug(@"Customer 表创建成功");
            } else {
                SRLogError(@"Customer 表创建失败");
            }
        }];
        [self.databaseQueue close];
    });
}

- (void)checkCustomerColumn:(FMDatabase *)db
{
    //2015-12-11新增签到
    if (![db columnExists:c_accountCash inTableWithName:SQL_TABLE_Customer]) {
        [db executeUpdate:SQL_Add_AccountCash_Column()];
    }
    if (![db columnExists:c_hasCarNeedRenew inTableWithName:SQL_TABLE_Customer]) {
        [db executeUpdate:SQL_Add_HasCarNeedRenew_Column()];
    }
    if (![db columnExists:c_hasTodaySign inTableWithName:SQL_TABLE_Customer]) {
        [db executeUpdate:SQL_Add_HasTodaySign_Column()];
    }
    if (![db columnExists:c_continuousSignDay inTableWithName:SQL_TABLE_Customer]) {
        [db executeUpdate:SQL_Add_ContinuousSignDay_Column()];
    }
    if (![db columnExists:c_point inTableWithName:SQL_TABLE_Customer]) {
        [db executeUpdate:SQL_Add_Point_Column()];
    }
    if (![db columnExists:c_headImg inTableWithName:SQL_TABLE_Customer]) {
        [db executeUpdate:SQL_Add_HeadImg_Column()];
    }
    if (![db columnExists:c_signedDate inTableWithName:SQL_TABLE_Customer]) {
        [db executeUpdate:SQL_Add_SignedDate_Column()];
    }
}

- (void)updateCustomer:(SRCustomer *)customer withCompleteBlock:(CompleteBlock)completeBlock
{
    if (!customer) {
        SRLogError(@"customer 不能为空");
        NSError *error = [NSError errorWithDomain:@"更新失败, customer 不能为空" code:-1 userInfo:nil];
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
            FMResultSet *resultSet = [db executeQuery:SQL_Query_Customer_By_ID(), @(customer.customerID)];
            if (resultSet.next) {
                result = [db executeUpdate:SQL_Update_Customer(),
                          @(customer.customerID),
                          customer.hashCode,
                          customer.customerIDNumber,
                          customer.customerUserName,
                          customer.name,
                          @(customer.customerSex),
                          customer.customerBirthday,
                          customer.customerPhone,
                          customer.customerEmail,
                          customer.customerAddress,
                          @(customer.depID),
                          customer.depName,
                          customer.levelCode,
                          @(customer.bindingStatus),
                          @(customer.openHiddenTrip),
                          @(customer.realNameAuthentication),
                          @(customer.customerType),
                          @(customer.exhibitionExperienceTime),
                          customer.permissionsString,
                          customer.messageSwitchString,
                          customer.messageUnreadString,
                          @(customer.accountCash),
                          @(customer.hasCarNeedRenew),
                          @(customer.hasTodaySign),
                          @(customer.continuousSignDay),
                          @(customer.point),
                          customer.headImg,
                          @([customer.signedDate timeIntervalSince1970]),
                          @(customer.customerID)];
            } else {
                result = [db executeUpdate:SQL_Insert_Customer(),
                          @(customer.customerID),
                          customer.hashCode,
                          customer.customerIDNumber,
                          customer.customerUserName,
                          customer.name,
                          @(customer.customerSex),
                          customer.customerBirthday,
                          customer.customerPhone,
                          customer.customerEmail,
                          customer.customerAddress,
                          @(customer.depID),
                          customer.depName,
                          customer.levelCode,
                          @(customer.bindingStatus),
                          @(customer.openHiddenTrip),
                          @(customer.realNameAuthentication),
                          @(customer.customerType),
                          @(customer.exhibitionExperienceTime),
                          customer.permissionsString,
                          customer.messageSwitchString,
                          customer.messageUnreadString,
                          @(customer.accountCash),
                          @(customer.hasCarNeedRenew),
                          @(customer.hasTodaySign),
                          @(customer.continuousSignDay),
                          @(customer.point),
                          customer.headImg,
                          @([customer.signedDate timeIntervalSince1970])];
            }
            [resultSet close];
        }];
        [self.databaseQueue close];
        if (!result) {
            error = [NSError errorWithDomain:@"更新失败" code:-1 userInfo:customer.keyValues];
        } else {
            SRLogDebug(@"更新成功");
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            !completeBlock?:completeBlock(error, @(result));
        });
        
    });
    
#if RealmEnable
    [[SRRealm sharedInterface] updateCustomer:customer withCompleteBlock:nil];
#endif
}

- (void)deleteCustomerByID:(NSInteger)customerID withCompleteBlock:(CompleteBlock)completeBlock
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
            result = [db executeUpdate:SQL_Delete_Customer_By_ID(), @(customerID)];
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
    [[SRRealm sharedInterface] deleteCustomerByID:customerID withCompleteBlock:nil];
#endif
}

- (void)deleteCustomerByUserName:(NSString *)userName withCompleteBlock:(CompleteBlock)completeBlock
{
    if (!userName || userName.length==0) {
        SRLogError(@"userName 不能为空");
        NSError *error = [NSError errorWithDomain:@"更新失败, userName 不能为空" code:-1 userInfo:nil];
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
            result = [db executeUpdate:SQL_Delete_Customer_By_UserName(), userName];
        }];
        [self.databaseQueue close];
        if (!result) {
            error = [NSError errorWithDomain:[NSString stringWithFormat:@"删除失败 %@", userName]
                                        code:-1 userInfo:nil];
        } else {
            SRLogDebug(@"%@ 删除成功", userName);
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            !completeBlock?:completeBlock(error, @(result));
        });
        
    });
    
#if RealmEnable
    [[SRRealm sharedInterface] deleteCustomerByUserName:userName withCompleteBlock:nil];
#endif
}

- (void)deleteAllCustomerWithCompleteBlock:(CompleteBlock)completeBlock
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSError *error = nil;
        __block BOOL result = NO;
        [self.databaseQueue inDatabase:^(FMDatabase *db) {
#if DataBaseEncrypd
            [db setKey:DB_ENCRYP_KEY];
#endif
            result = [db executeUpdate:SQL_Delete_Customer_All()];
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
    [[SRRealm sharedInterface] deleteAllCustomerWithCompleteBlock:nil];
#endif
}

- (void)queryCustomerByID:(NSInteger)customerID withCompleteBlock:(CompleteBlock)completeBlock
{
    if (customerID <= 0) {
        SRLogError(@"customerID 不能为空");
        NSError *error = [NSError errorWithDomain:@"更新失败, customerID 不能为空" code:-1 userInfo:nil];
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
                FMResultSet *resultSet = [db executeQuery:SQL_Query_Customer_By_ID(), @(customerID)];
                while ([resultSet next]) {
                    SRCustomer *customer            = [[SRCustomer alloc] init];
                    customer.customerID             = [resultSet stringForColumn:c_customerID].integerValue;
                    customer.hashCode               = [resultSet stringForColumn:c_hashCode];
                    customer.customerIDNumber       = [resultSet stringForColumn:c_customerIDNumber];
                    customer.customerUserName       = [resultSet stringForColumn:c_customerUserName];
                    customer.name                   = [resultSet stringForColumn:c_name];
                    customer.customerSex            = [resultSet stringForColumn:c_customerSex].integerValue;
                    customer.customerBirthday       = [resultSet stringForColumn:c_customerBirthday];
                    customer.customerPhone          = [resultSet stringForColumn:c_customerPhone];
                    customer.customerEmail          = [resultSet stringForColumn:c_customerEmail];
                    customer.customerAddress        = [resultSet stringForColumn:c_customerAddress];
                    customer.depID                  = [resultSet stringForColumn:c_depID].integerValue;
                    customer.depName                = [resultSet stringForColumn:c_depName];
                    customer.levelCode              = [resultSet stringForColumn:c_levelCode];
                    customer.bindingStatus          = [resultSet stringForColumn:c_bindingStatus].integerValue;
                    customer.openHiddenTrip         = [resultSet boolForColumn:c_openHiddenTrip];
                    customer.realNameAuthentication = [resultSet intForColumn:c_realNameAuthentication];
                    customer.customerType           = [resultSet intForColumn:c_customerType];
                    customer.exhibitionExperienceTime = [resultSet intForColumn:c_exhibitionExperienceTime];
                    
                    customer.accountCash            = [resultSet doubleForColumn:c_accountCash];
                    customer.hasCarNeedRenew        = [resultSet boolForColumn:c_hasCarNeedRenew];
                    customer.hasTodaySign           = [resultSet boolForColumn:c_hasTodaySign];
                    customer.continuousSignDay      = [resultSet intForColumn:c_continuousSignDay];
                    customer.point                  = [resultSet intForColumn:c_point];
                    customer.headImg                = [resultSet stringForColumn:c_headImg];
                    customer.signedDate             = [resultSet dateForColumn:c_signedDate];
                    
                    [customer setPermissionsWithString:[resultSet stringForColumn:c_permissions]];
                    [customer setMessageSwitchsWithString:[resultSet stringForColumn:c_messageSwitchs]];
                    [customer setMessageUnreadWithString:[resultSet stringForColumn:c_messageUnread]];
                    
                    [list addObject:customer];
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
    [[SRRealm sharedInterface] queryCustomerByID:customerID withCompleteBlock:nil];
#endif
}

- (void)queryCustomerByUserName:(NSString *)userName withCompleteBlock:(CompleteBlock)completeBlock
{
    if (!userName || userName.length==0) {
        SRLogError(@"userName 不能为空");
        NSError *error = [NSError errorWithDomain:@"更新失败, userName 不能为空" code:-1 userInfo:nil];
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
                FMResultSet *resultSet = [db executeQuery:SQL_Query_Customer_By_UserName(), userName];
                while ([resultSet next]) {
                    SRCustomer *customer            = [[SRCustomer alloc] init];
                    customer.customerID             = [resultSet stringForColumn:c_customerID].integerValue;
                    customer.hashCode               = [resultSet stringForColumn:c_hashCode];
                    customer.customerIDNumber       = [resultSet stringForColumn:c_customerIDNumber];
                    customer.customerUserName       = [resultSet stringForColumn:c_customerUserName];
                    customer.name                   = [resultSet stringForColumn:c_name];
                    customer.customerSex            = [resultSet stringForColumn:c_customerSex].integerValue;
                    customer.customerBirthday       = [resultSet stringForColumn:c_customerBirthday];
                    customer.customerPhone          = [resultSet stringForColumn:c_customerPhone];
                    customer.customerEmail          = [resultSet stringForColumn:c_customerEmail];
                    customer.customerAddress        = [resultSet stringForColumn:c_customerAddress];
                    customer.depID                  = [resultSet stringForColumn:c_depID].integerValue;
                    customer.depName                = [resultSet stringForColumn:c_depName];
                    customer.levelCode              = [resultSet stringForColumn:c_levelCode];
                    customer.bindingStatus          = [resultSet stringForColumn:c_bindingStatus].integerValue;
                    customer.openHiddenTrip         = [resultSet boolForColumn:c_openHiddenTrip];
                    customer.realNameAuthentication = [resultSet intForColumn:c_realNameAuthentication];
                    customer.customerType           = [resultSet intForColumn:c_customerType];
                    customer.exhibitionExperienceTime = [resultSet intForColumn:c_exhibitionExperienceTime];
                    
                    customer.accountCash            = [resultSet doubleForColumn:c_accountCash];
                    customer.hasCarNeedRenew        = [resultSet boolForColumn:c_hasCarNeedRenew];
                    customer.hasTodaySign           = [resultSet boolForColumn:c_hasTodaySign];
                    customer.continuousSignDay      = [resultSet intForColumn:c_continuousSignDay];
                    customer.point                  = [resultSet intForColumn:c_point];
                    customer.headImg                = [resultSet stringForColumn:c_headImg];
                    customer.signedDate             = [resultSet dateForColumn:c_signedDate];
                    
                    [customer setPermissionsWithString:[resultSet stringForColumn:c_permissions]];
                    [customer setMessageSwitchsWithString:[resultSet stringForColumn:c_messageSwitchs]];
                    [customer setMessageUnreadWithString:[resultSet stringForColumn:c_messageUnread]];
                    
                    [list addObject:customer];
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
    [[SRRealm sharedInterface] queryCustomerByUserName:userName withCompleteBlock:nil];
#endif
}

- (void)queryAllCustomerWithCompleteBlock:(CompleteBlock)completeBlock
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        __block NSMutableArray *list = [NSMutableArray array];
        [self.databaseQueue inDatabase:^(FMDatabase *db) {
#if DataBaseEncrypd
            [db setKey:DB_ENCRYP_KEY];
#endif
      
            @autoreleasepool {
                FMResultSet *resultSet = [db executeQuery:SQL_Query_Customer_All()];
                while ([resultSet next]) {
                    SRCustomer *customer            = [[SRCustomer alloc] init];
                    customer.customerID             = [resultSet stringForColumn:c_customerID].integerValue;
                    customer.hashCode               = [resultSet stringForColumn:c_hashCode];
                    customer.customerIDNumber       = [resultSet stringForColumn:c_customerIDNumber];
                    customer.customerUserName       = [resultSet stringForColumn:c_customerUserName];
                    customer.name                   = [resultSet stringForColumn:c_name];
                    customer.customerSex            = [resultSet stringForColumn:c_customerSex].integerValue;
                    customer.customerBirthday       = [resultSet stringForColumn:c_customerBirthday];
                    customer.customerPhone          = [resultSet stringForColumn:c_customerPhone];
                    customer.customerEmail          = [resultSet stringForColumn:c_customerEmail];
                    customer.customerAddress        = [resultSet stringForColumn:c_customerAddress];
                    customer.depID                  = [resultSet stringForColumn:c_depID].integerValue;
                    customer.depName                = [resultSet stringForColumn:c_depName];
                    customer.levelCode              = [resultSet stringForColumn:c_levelCode];
                    customer.bindingStatus          = [resultSet stringForColumn:c_bindingStatus].integerValue;
                    customer.openHiddenTrip         = [resultSet boolForColumn:c_openHiddenTrip];
                    customer.realNameAuthentication = [resultSet intForColumn:c_realNameAuthentication];
                    customer.customerType           = [resultSet intForColumn:c_customerType];
                    customer.exhibitionExperienceTime = [resultSet intForColumn:c_exhibitionExperienceTime];
                    
                    customer.accountCash            = [resultSet doubleForColumn:c_accountCash];
                    customer.hasCarNeedRenew        = [resultSet boolForColumn:c_hasCarNeedRenew];
                    customer.hasTodaySign           = [resultSet boolForColumn:c_hasTodaySign];
                    customer.continuousSignDay      = [resultSet intForColumn:c_continuousSignDay];
                    customer.point                  = [resultSet intForColumn:c_point];
                    customer.headImg                = [resultSet stringForColumn:c_headImg];
                    customer.signedDate             = [resultSet dateForColumn:c_signedDate];
                    
                    [customer setPermissionsWithString:[resultSet stringForColumn:c_permissions]];
                    [customer setMessageSwitchsWithString:[resultSet stringForColumn:c_messageSwitchs]];
                    [customer setMessageUnreadWithString:[resultSet stringForColumn:c_messageUnread]];
                    
                    [list addObject:customer];
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
    [[SRRealm sharedInterface] queryAllCustomerWithCompleteBlock:nil];
#endif
}

@end

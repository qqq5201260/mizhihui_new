//
//  SRDataBase.m
//  SiRuiV4.0
//
//  Created by zhangjunbo on 15/6/15.
//  Copyright (c) 2015年 SiRui. All rights reserved.
//

#import "SRDataBase.h"
#import "SRDataBase+Customer.h"
#import "SRDataBase+Vehicle.h"
#import "SRDataBase+Trip.h"
#import "SRDataBase+TripPoints.h"
#import "SRDataBase+OrderStart.h"
#import "SRDataBase+Message.h"
#import "SRDataBase+MaintainReserve.h"
#import "SRDataBase+MaintainDep.h"
#import "SRDataBase+MaintainHistory.h"
#import "SRDataBase+BrandInfo.h"
#import <FMDB/FMDB.h>

NSString * const DB_FILE_NAME = @"SiRui.sqlite";

//数据库加密密钥
NSString * const DB_ENCRYP_KEY = @"00_I_Love_SiRui_@*&#(*&";

//数据库存储路径
static inline NSString * database_file_path() {
    static NSString * sr_database_file_path;
    if (sr_database_file_path) {
        return sr_database_file_path;
    }
    
    NSString *directorPath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"DataBase"];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    //db是否存在，若不存在则创建相应的DB目录
    BOOL isDirector = NO;
    BOOL isExiting = [fileManager fileExistsAtPath:directorPath isDirectory:&isDirector];
    
    if (!(isExiting && isDirector)) {
        BOOL createDirection = [fileManager createDirectoryAtPath:directorPath
                                      withIntermediateDirectories:YES
                                                       attributes:nil
                                                            error:nil];
        if (!createDirection) {
            SRLogError(@"创建DB目录 - 失败");
        } else {
            SRLogDebug(@"创建DB目录 - 成功");
        }
    }
    
    sr_database_file_path = [directorPath stringByAppendingPathComponent:DB_FILE_NAME];
    
    return sr_database_file_path;
}

@interface SRDataBase ()

@property (nonatomic, strong) FMDatabaseQueue *databaseQueue;

@end

@implementation SRDataBase

Singleton_Implementation(SRDataBase)

//+ (void)load
//{
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        [self sharedInterface];
//    });
//}

- (void)dealloc {
    [self.databaseQueue close];
    self.databaseQueue = nil;
}

- (instancetype)init {
    if (self = [super init]) {
        //初始化数据库
        [self dbInit];
    }
    
    return self;
}

- (void)dbInit
{
    _databaseQueue = [FMDatabaseQueue databaseQueueWithPath:database_file_path()];
    if (!_databaseQueue) {
        SRLogError(@"数据库打开 - 失败");
    } else {
        SRLogDebug(@"数据库打开 - 成功！");
        [self createBrandInfoTable];
        
        [self createCustomerTable];
        [self createVehicleTable];
        [self createTripTable];
        [self createTripPointsTable];
        [self createMessageTable];
        [self createOrderStartTable];
        [self createMaintainReserveTable];
        [self createMaintainDepTable];
        [self createMaintainHistoryTable];
    }
}

- (void)clearData
{
    [self deleteAllCustomerWithCompleteBlock:nil];
    [self deleteAllVehicleWithCompleteBlock:nil];
    [self deleteAllTripWithCompleteBlock:nil];
    [self deleteAllTripPointsWithCompleteBlock:nil];
    [self deleteAllMessageInfosWithCompleteBlock:nil];
    [self deleteAllOrderStartWithCompleteBlock:nil];
    [self deleteAllMaintainReserveInfoWithCompleteBlock:nil];
    [self deleteAllMaintainDepsWithCompleteBlock:nil];
    [self deleteAllMaintainHistoryWithCompleteBlock:nil];
}

@end

//
//  SRDataBase.h
//  SiRuiV4.0
//
//  Created by zhangjunbo on 15/6/15.
//  Copyright (c) 2015年 SiRui. All rights reserved.
//

#import <Foundation/Foundation.h>

@class FMDatabaseQueue;

extern NSString * const DB_ENCRYP_KEY;

@interface SRDataBase : NSObject

Singleton_Interface(SRDataBase)

//操作队列
- (FMDatabaseQueue *)databaseQueue;
//清空数据
- (void)clearData;

@end

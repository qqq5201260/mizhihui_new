//
//  SRRealm.m
//  Mizward
//
//  Created by zhangjunbo on 15/9/1.
//  Copyright (c) 2015年 Mizward. All rights reserved.
//

#import "SRRealm.h"
#import <Realm/Realm.h>
#import "SRRealmOrderStart.h"

@implementation SRRealm

Singleton_Implementation(SRRealm)

//+ (void)load
//{
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        [self sharedInterface];
//    });
//}


- (instancetype)init {
    if (self = [super init]) {
        [self configuration];
    }
    
    return self;
}

- (void)configuration {
    RLMRealmConfiguration *configuration = [RLMRealmConfiguration defaultConfiguration];
    configuration.schemaVersion = 1;
//    configuration.encryptionKey = [self getKey];
//    configuration.path = @"DataBase/test.realm";
    RLMMigrationBlock migrationBlock = ^(RLMMigration *migration, uint64_t oldSchemaVersion) {
        [migration enumerateObjects:SRRealmOrderStart.className block:^(RLMObject *oldObject, RLMObject *newObject) {
//            newObject[@"_ID"] = @(100 - [newObject[@"_id"] integerValue]);
        }];
        NSLog(@"Migration complete.");
    };
    configuration.migrationBlock = migrationBlock;
    
    _realm = [RLMRealm realmWithConfiguration:configuration
                                            error:nil];
    
//    _realm = [RLMRealm defaultRealm];
}

@end

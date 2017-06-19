//
//  SRKeychain.m
//  SiRuiV4.0
//
//  Created by zhangjunbo on 15/6/15.
//  Copyright (c) 2015年 SiRui. All rights reserved.
//

#import "SRKeychain.h"
#import "SRUserDefaults.h"
#import <Fabric/Fabric.h>

NSString * const SRKeychainService = @"com.million.mizward";
NSString * const SRKeychainAccountUUID = @"UUID";
NSString * const SRKeychainAccountUserName = @"UserName";
NSString * const SRKeychainAccountPassword = @"Password";

static NSString *UUID = nil;
static NSString *UserName = nil;
static NSString *Password = nil;

@implementation SRKeychain

+ (NSString *)UUID
{
    if (UUID) {
        return UUID;
    }
    
    UUID = [self passwordForService:SRKeychainService
                            account:SRKeychainAccountUUID];
    if (!UUID || UUID.length == 0) {
        CFUUIDRef uuidRef = CFUUIDCreate(kCFAllocatorDefault);
        UUID = (NSString *)CFBridgingRelease(CFUUIDCreateString (kCFAllocatorDefault,uuidRef));
        [self updateUUID:UUID];
        CFBridgingRelease(uuidRef);
    }
    return UUID;
}

+ (void)updateUUID:(NSString *)uuid
{
    [self setPassword:uuid
           forService:SRKeychainService
              account:SRKeychainAccountUUID];
}

+ (NSString *)UserName
{
#if DEBUG
    NSLog(@"username<<<<<<<<<<<<<<<<<<<<<<%@", UserName);
#endif
    
    if (UserName) {
        return UserName;
    }
    
    UserName = [self passwordForService:SRKeychainService
                                account:SRKeychainAccountUserName];
    
    if (!UserName) {
        UserName = [SRUserDefaults userName];
        if (UserName) {
            [self updateUserName:UserName];
        }
    }
    
#if DEBUG
    NSLog(@"username<<<<<<<<<<<<<<<<<<<<<<%@", UserName);
#endif
    
    return UserName;
}

+ (void)updateUserName:(NSString *)userName
{
#if DEBUG
    NSLog(@"username>>>>>>>>>>>>>>>>>>>>>%@", userName);
#endif
    UserName = userName;
    
    [SRUserDefaults updateUserName:userName password:[self Password]];
    if ([self setPassword:userName
               forService:SRKeychainService
                  account:SRKeychainAccountUserName]) {
#if DEBUG
        NSLog(@"username<<<<<<<<<<<<<<<<<<<<<<%@", [self passwordForService:SRKeychainService
                                                                   account:SRKeychainAccountUserName]);
#endif
    }
}

+ (NSString *)Password
{
#if DEBUG
    NSLog(@"password<<<<<<<<<<<<<<<<<<<<<<%@", Password);
#endif
    
    if (Password) {
        return Password;
    }
    
    Password = [self passwordForService:SRKeychainService
                                account:SRKeychainAccountPassword];
    
    if (!Password) {
        Password = [SRUserDefaults password];
        if (Password) {
            [self updatePassword:Password];
        }
    }
    
#if DEBUG
    NSLog(@"password<<<<<<<<<<<<<<<<<<<<<<%@", Password);
#endif
    
//    NSArray *test = [self allAccounts];
    
    return Password;
}

+ (void)updatePassword:(NSString *)password
{
#if DEBUG
    NSLog(@"password>>>>>>>>>>>>>>>>>>>>>%@", password);
#endif
    Password = password;
    [SRUserDefaults updateUserName:[self UserName] password:password];
    if ([self setPassword:password
               forService:SRKeychainService
                  account:SRKeychainAccountPassword]) {
#if DEBUG
        NSLog(@"password<<<<<<<<<<<<<<<<<<<<<<%@", [self passwordForService:SRKeychainService
                                                                   account:SRKeychainAccountPassword]);
#endif
    }
}


@end

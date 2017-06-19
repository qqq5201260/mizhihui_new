//
//  SRKeychain.h
//  SiRuiV4.0
//
//  Created by zhangjunbo on 15/6/15.
//  Copyright (c) 2015年 SiRui. All rights reserved.
//

#import "SSKeychain.h"

@interface SRKeychain : SSKeychain

+ (NSString *)UUID;

+ (NSString *)UserName;
+ (void)updateUserName:(NSString *)userName;

+ (NSString *)Password;
+ (void)updatePassword:(NSString *)password;

@end

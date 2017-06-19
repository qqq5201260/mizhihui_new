//
//  FZKBKeychain.h
//  Business
//
//  Created by 宋搏 on 2017/4/14.
//  Copyright © 2017年 chinapke. All rights reserved.
//

#import <SSKeychain/SSKeychain.h>

@interface FZKBKeychain : SSKeychain

+ (NSString *)UUID;
+ (NSString *)UserName;
+ (void)updateUserName:(NSString *)userName;

+ (NSString *)Password;
+ (void)updatePassword:(NSString *)password;
+(void)deletePassword;

@end

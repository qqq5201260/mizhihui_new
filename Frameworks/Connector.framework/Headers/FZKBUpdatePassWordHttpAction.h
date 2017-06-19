
//
//  FZKBUpdatePassWordHttpAction.h
//
//
//  Created by mac on date.
//  Copyright © 2017年 chinapke. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FZKHttpWork.h"

@interface FZKBUpdatePassWordHttpAction : FZKHttpWork
    
/**
 方法描述：
 设置密码
 
 传入参数：
userName：用户名
authCode：验证码
password：密码
withEncrypt： 目前暂定是加密的意思，1表示加密（晚点和server确认）

返回参数：

resultCode:0表示成功

 */
- (void)updatePassWordActionWithUserName:(NSString *)userName authCode:(NSString *)authCode password:(NSString *)password withEncrypt:(NSString *)withEncrypt;

@end
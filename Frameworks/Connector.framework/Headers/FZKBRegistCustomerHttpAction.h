
//
//  FZKBRegistCustomerHttpAction.h
//
//
//  Created by mac on date.
//  Copyright © 2017年 chinapke. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FZKHttpWork.h"

@interface FZKBRegistCustomerHttpAction : FZKHttpWork
    
/**
 方法描述：
 新版app用户注册
 
 传入参数：
customerUserName：用户名
customerPassword：用户密码
customerPhone：用户手机号
authcode：验证码
返回参数：
resultCode：0表示成功，其他表示失败
 */
- (void)registCustomerActionWithCustomerPassword:(NSString *)customerPassword customerPhone:(NSString *)customerPhone authcode:(NSString *)authcode customerUserName:(NSString *)customerUserName;

@end
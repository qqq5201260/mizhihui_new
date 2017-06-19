
//
//  FZKBUpdateSubmissionHttpAction.h
//
//
//  Created by mac on date.
//  Copyright © 2017年 chinapke. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FZKHttpWork.h"

@interface FZKBUpdateSubmissionHttpAction : FZKHttpWork
    
/**
 方法描述：
 修改手机号，修改用户名，修改密码提交接口
 
 传入参数：
authCode：验证码
customerUserName：修改的用户名或者用户名
customerPassword：用户密码，或者修改的用户密码
withEncrypt：标志服务端解密密码传1
customerPhone：用户手机号或者修改手机号
返回参数：
resultCode：0表示成功


 */
- (void)updateSubmissionActionWithAuthCode:(NSString *)authCode customerUserName:(NSString *)customerUserName customerPassword:(NSString *)customerPassword withEncrypt:(NSString *)withEncrypt customerPhone:(NSString *)customerPhone;

@end
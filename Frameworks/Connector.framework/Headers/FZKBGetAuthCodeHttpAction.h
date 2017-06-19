
//
//  FZKBGetAuthCodeHttpAction.h
//
//
//  Created by mac on date.
//  Copyright © 2017年 chinapke. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FZKHttpWork.h"

@interface FZKBGetAuthCodeHttpAction : FZKHttpWork
    
/**
 方法描述：
 获取验证码（备注一下：当发送短信失败但确实获取到验证码，时调用http://223.6.255.5/provider/testProvide/getAuthcodeIMGUrl?authCode=获取的验证码    得到web图片）
 
 传入参数：
userName：用户名
phone：接手短信的手机（用户绑定的手机）
type:业务类型：注册不写，updateUserName，
updatePassword，updatePhone，


返回参数：
authCode：验证码
phone：用户手机号
 */
- (void)getAuthCodeActionWithUserName:(NSString *)userName phone:(NSString *)phone type:(NSString *)type;

@end
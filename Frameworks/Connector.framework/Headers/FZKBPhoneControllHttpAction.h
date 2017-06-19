
//
//  FZKBPhoneControllHttpAction.h
//
//
//  Created by mac on date.
//  Copyright © 2017年 chinapke. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FZKHttpWork.h"

@interface FZKBPhoneControllHttpAction : FZKHttpWork
    
/**
 方法描述：
 发送车控制指令给服务器
 
 传入参数:


input1:车id_命令号_用户名。
input2:用户密码。
input3:手机uuid。
app:app名称
 */
- (void)phoneControllActionWithInput1:(NSString *)input1 input2:(NSString *)input2 input3:(NSString *)input3 input4:(NSString *)input4 app:(NSString *)app;

@end

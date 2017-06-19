
//
//  FZKBConfirmWarningHttpAction.h
//
//
//  Created by mac on date.
//  Copyright © 2017年 chinapke. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FZKHttpWork.h"

@interface FZKBConfirmWarningHttpAction : FZKHttpWork
    
/**
 方法描述：
 告警消息
 
 输入参数
input1:用户名（需加密）
input2:用户密码（需加密）
返回值：
resultCode:结果码
resultMessage：结果信息
 */
- (void)confirmWarningActionWithInput1:(NSString *)input1 input2:(NSString *)input2;

@end
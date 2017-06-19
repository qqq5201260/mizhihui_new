
//
//  FZKBMessageSetSwitchHttpAction.h
//
//
//  Created by mac on date.
//  Copyright © 2017年 chinapke. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FZKHttpWork.h"

@interface FZKBMessageSetSwitchHttpAction : FZKHttpWork
    
/**
 方法描述：
 信息中心控制器
 
 传入参数：
type：状态
isOpen：是否打开
input1：用户名（需加密）
input2：用户密码（需加密）
返回值：
resultCode：结果码
resultMessage：返回结果信息
 */
- (void)messageSetSwitchActionWithType:(NSString *)type isOpen:(NSString *)isOpen input1:(NSString *)input1 input2:(NSString *)input2;

@end
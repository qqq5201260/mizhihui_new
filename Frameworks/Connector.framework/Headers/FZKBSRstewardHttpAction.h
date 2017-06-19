
//
//  FZKBSRstewardHttpAction.h
//
//
//  Created by mac on date.
//  Copyright © 2017年 chinapke. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FZKHttpWork.h"

@interface FZKBSRstewardHttpAction : FZKHttpWork
    
/**
 方法描述：
 思锐管家（在线客服）提示语
 
 传入参数：
input1:用户名
input2：密码

返回参数：

firstMsg：提示语
resultCode 0表示成功，其他表示失败

resultMessage：主要是在失败的时候返回失败原因
 */
- (void)sRstewardActionWithInput1:(NSString *)input1 input2:(NSString *)input2;

@end
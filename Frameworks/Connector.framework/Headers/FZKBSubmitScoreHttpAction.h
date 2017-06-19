
//
//  FZKBSubmitScoreHttpAction.h
//
//
//  Created by mac on date.
//  Copyright © 2017年 chinapke. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FZKHttpWork.h"

@interface FZKBSubmitScoreHttpAction : FZKHttpWork
    
/**
 方法描述：
 提交评分
 
 传入参数
input1：用户名（需加密）
input2：用户密码（需加密）
quality：产品质量
attitude：服务态度
phoneVersion:手机版本号
返回值

resultCode：返回结果码 0表示成功 其它表示失败
resultMessage：结果码对应信息
 */
- (void)submitScoreActionWithInput1:(NSString *)input1 input2:(NSString *)input2 attitude:(NSString *)attitude quality:(NSString *)quality phoneVersion:(NSString *)phoneVersion;

@end
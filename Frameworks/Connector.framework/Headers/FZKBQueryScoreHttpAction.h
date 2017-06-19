
//
//  FZKBQueryScoreHttpAction.h
//
//
//  Created by mac on date.
//  Copyright © 2017年 chinapke. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FZKHttpWork.h"

@interface FZKBQueryScoreHttpAction : FZKHttpWork
    
/**
 方法描述：
 评分查询
 
 传入参数
input1:用户名（需加密）
input2:用户密码（需加密）
attitude:服务态度
quality：产品质量
createTime：时间

返回值
attitude：服务态度
quality：产品质量
createTime：时间
customerID：用户id
resultCode:结果码 0表示成功 其它表示不成功
resultMessage：结果码对应消息
 */
- (void)queryScoreActionWithInput1:(NSString *)input1 input2:(NSString *)input2 attitude:(NSString *)attitude quality:(NSString *)quality createTime:(NSString *)createTime;

@end
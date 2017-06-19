
//
//  FZKBGetWarningMessageHttpAction.h
//
//
//  Created by mac on date.
//  Copyright © 2017年 chinapke. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FZKHttpWork.h"

@interface FZKBGetWarningMessageHttpAction : FZKHttpWork
    
/**
 方法描述：
 获取告警、提醒消息
 
 传入参数
input1：用户名（需加密）
input2：用户密码（需加密）
type：类型 1：告警类消息 2：提醒类消息
pageSize：每一页多少条消息数据
返回值
message：消息
vehicleid：车id
time:时间
msgid：消息id
customerid：用户id
msgtype:消息类型（具体看代码 meeagetypecode）
enmessage：英语消息
type：类型




 */
- (void)getWarningMessageActionWithInput1:(NSString *)input1 input2:(NSString *)input2 type:(NSString *)type pageSize:(NSString *)pageSize;

@end
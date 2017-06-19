
//
//  FZKBInitializeDetailSwitchHttpAction.h
//
//
//  Created by mac on date.
//  Copyright © 2017年 chinapke. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FZKHttpWork.h"

@interface FZKBInitializeDetailSwitchHttpAction : FZKHttpWork
    
/**
 方法描述：
 消息中心控制器初始化
 
 传入参数
input1：用户名（需加密）
input2：用户密码（需加密）
返回值
createTime：时间
customerID：用户id
isAllOpen：是否全部打开
isOpen：是否打开
switchID：开关id
type：状态
vehicleID：车辆id
 */
- (void)initializeDetailSwitchActionWithInput1:(NSString *)input1 input2:(NSString *)input2;

@end
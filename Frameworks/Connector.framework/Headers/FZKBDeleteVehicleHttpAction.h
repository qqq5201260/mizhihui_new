
//
//  FZKBDeleteVehicleHttpAction.h
//
//
//  Created by mac on date.
//  Copyright © 2017年 chinapke. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FZKHttpWork.h"

@interface FZKBDeleteVehicleHttpAction : FZKHttpWork
    
/**
 方法描述：
 删除车辆
 
 传入参数
input1：用户名（需加密）
input2：用户密码（需加密）
vehicleID：车id
返回值
resultCode:返回结果码 0表示成功 其他表示失败
 */
- (void)deleteVehicleActionWithInput1:(NSString *)input1 input2:(NSString *)input2 vehicleID:(NSString *)vehicleID;

@end
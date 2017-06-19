
//
//  FZKBChangeDeviceHttpAction.h
//
//
//  Created by mac on date.
//  Copyright © 2017年 chinapke. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FZKHttpWork.h"

@interface FZKBChangeDeviceHttpAction : FZKHttpWork
    
/**
 方法描述：
 我的爱车（绑定或更换蓝牙）(绑定或更换终端)
 
 传入参数：
input1：用户名（需加密）
input2：用户密码（需加密）
vehicleID：车辆id
imei：蓝牙或者终端有各自的对应的imei号
返回值：
resultCode：结果码 0表示成功 其它表示失败
 */
- (void)changeDeviceActionWithInput1:(NSString *)input1 input2:(NSString *)input2 vehicleID:(NSString *)vehicleID imei:(NSString *)imei;

@end

//
//  FZKBBindTerminalHttpAction.h
//
//
//  Created by mac on date.
//  Copyright © 2017年 chinapke. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FZKHttpWork.h"

@interface FZKBBindTerminalHttpAction : FZKHttpWork
    
/**
 方法描述：
 添加车辆
 
 传入参数
 vehicleModelID：车型
 imei：终端imei
 vin:车架号（可以为null）
 plateNumber：车牌号（可以为null）
 
 返回值：
 resultCode：结果码 0表示成功 其它表示失败
 */
- (void)bindTerminalActionWithVehicleModelID:(NSString *)vehicleModelID imei:(NSString *)imei vin:(NSString *)vin plateNumber:(NSString *)plateNumber input1:(NSString *)input1 input2:(NSString *)input2;

@end

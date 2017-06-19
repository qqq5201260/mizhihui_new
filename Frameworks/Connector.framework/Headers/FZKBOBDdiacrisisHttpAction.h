
//
//  FZKBOBDdiacrisisHttpAction.h
//
//
//  Created by mac on date.
//  Copyright © 2017年 chinapke. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FZKHttpWork.h"

@interface FZKBOBDdiacrisisHttpAction : FZKHttpWork
    
/**
 方法描述：
 OBD诊断（只是给一个在发指令，和指令响应的效果）
 
 传入参数：
vehicleID：车辆ID

返回参数：

resultCode：0表示成功
其他参数在此接口中没有意义（用不到）

 */
- (void)oBDdiacrisisActionWithVehicleID:(NSString *)vehicleID;

@end
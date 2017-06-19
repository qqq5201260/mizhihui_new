
//
//  FZKBAddNewCarHttpAction.h
//
//
//  Created by mac on date.
//  Copyright © 2017年 chinapke. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FZKHttpWork.h"

@interface FZKBAddNewCarHttpAction : FZKHttpWork
    
/**
 方法描述：
 添加车辆（按操作流程获取参数）
 
 传入参数：
vehicleModelID：车辆实例ID
imei：终端编号
返回参数：
resultCode：0表示成功
 */
- (void)addNewCarActionWithVehicleModelID:(NSString *)vehicleModelID imei:(NSString *)imei;

@end

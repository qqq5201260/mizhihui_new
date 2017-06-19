
//
//  FZKBObdSetHttpAction.h
//
//
//  Created by mac on date.
//  Copyright © 2017年 chinapke. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FZKHttpWork.h"

@interface FZKBObdSetHttpAction : FZKHttpWork
    
/**
 方法描述：
 诊断设置
 
 传入参数：
vehicleID：车辆ID
openObd：1表示开启，2表示关闭


返回参数：
resultCode：0表示成功，其他表示失败
 */
- (void)obdSetActionWithVehicleID:(NSString *)vehicleID openObd:(NSString *)openObd;

@end
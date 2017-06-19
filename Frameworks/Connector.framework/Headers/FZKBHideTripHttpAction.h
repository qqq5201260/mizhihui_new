
//
//  FZKBHideTripHttpAction.h
//
//
//  Created by mac on date.
//  Copyright © 2017年 chinapke. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FZKHttpWork.h"

@interface FZKBHideTripHttpAction : FZKHttpWork
    
/**
 方法描述：
 隐藏行踪
 
 传入参数：
vehicleID：车辆ID
isHidden：0表示显示，1表示隐藏
返回参数
resultMessage：返回结果信息
resultCode：0表示成功，其他表示失败
 */
- (void)hideTripActionWithVehicleID:(NSString *)vehicleID isHidden:(NSString *)isHidden;

@end
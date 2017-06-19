
//
//  FZKBQueryFenceHttpAction.h
//
//
//  Created by mac on date.
//  Copyright © 2017年 chinapke. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FZKHttpWork.h"

@interface FZKBQueryFenceHttpAction : FZKHttpWork
    
/**
 方法描述：
 查询围栏
 
 传入参数：
input1:用户名
input2:密码
vehicleID:车辆ID


返回参数：
isInFence：是否在围栏内 2表示不在围栏内，其他表示在围栏内
fenceCentralLng：围栏中心点纬度
fenceCentralLat：围栏中心点经度
resultCode：返回结果code 0表示成功
resultMessage：返回结果信息
 */
- (void)queryFenceActionWithInput1:(NSString *)input1 input2:(NSString *)input2 vehicleID:(NSString *)vehicleID;

@end
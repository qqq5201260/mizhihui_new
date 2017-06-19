
//
//  FZKBUpdateFenceHttpAction.h
//
//
//  Created by mac on date.
//  Copyright © 2017年 chinapke. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FZKHttpWork.h"

@interface FZKBUpdateFenceHttpAction : FZKHttpWork
    
/**
 方法描述：
 更新围栏半径
 
 传入参数：
input1：用户名
input2：密码
vehicleID：车辆ID
radius：围栏半径
返回参数
resultCode： 0表示成功，其他表示失败
 */
- (void)updateFenceActionWithInput1:(NSString *)input1 input2:(NSString *)input2 vehicleID:(NSString *)vehicleID radius:(NSString *)radius;

@end
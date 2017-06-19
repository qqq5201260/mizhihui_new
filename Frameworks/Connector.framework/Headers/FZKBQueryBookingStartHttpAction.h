
//
//  FZKBQueryBookingStartHttpAction.h
//
//
//  Created by mac on date.
//  Copyright © 2017年 chinapke. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FZKHttpWork.h"

@interface FZKBQueryBookingStartHttpAction : FZKHttpWork
    
/**
 方法描述：
 查询预约启动车辆信息
 
 返回值：
customerID：用户ID
isOpen：是否开启启动功能（true false）
isRepeat：是否重复（就像闹钟一样，ture false）
repeatType：重复类型(0000000，7位，分别表示周一到周日，0为关闭，1为开启)
startClockID：闹钟ID
startTime：开启时间
startTimeLength：启动时长（多久之后启动）
type：0.自定义 1.上班 2.回家
vehicleID：车辆ID
pageIndex：页面索引(1) 
pageSize：没用到
totalCount：item数目
totalPage：没用到
resultCode：0表示成功
 */
- (void)queryBookingStartAction;

@end

//
//  FZKBUpdateBookingStartHttpAction.h
//
//
//  Created by mac on date.
//  Copyright © 2017年 chinapke. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FZKHttpWork.h"

@interface FZKBUpdateBookingStartHttpAction : FZKHttpWork
    
/**
 方法描述：
 修改预约启动
 
 传入参数：
startClockID：闹钟ID
type：0.自定义 1.上班 2.回家
vehicleID：车辆ID
startTime：开启时间
isRepeat：是否重复
startTimeLength：启动时长
repeatType：/重复类型(0000000，7位，分别表示周一到周日，0为关闭，1为开启)
isOpen：是否开启

返回参数：
resultCode：0表示成功



 */
- (void)updateBookingStartActionWithStartClockID:(NSString *)startClockID type:(NSString *)type vehicleID:(NSString *)vehicleID startTime:(NSString *)startTime isRepeat:(NSString *)isRepeat startTimeLength:(NSString *)startTimeLength repeatType:(NSString *)repeatType isOpen:(NSString *)isOpen;

@end
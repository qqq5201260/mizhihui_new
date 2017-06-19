
//
//  FZKBDeleteBookingStartHttpAction.h
//
//
//  Created by mac on date.
//  Copyright © 2017年 chinapke. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FZKHttpWork.h"

@interface FZKBDeleteBookingStartHttpAction : FZKHttpWork
    
/**
 方法描述：
 删除预约启动
 
 传入参数：
startClockID：需要删除的闹钟的ID

返回参数：
resultCode：0表示成功
 */
- (void)deleteBookingStartActionWithStartClockID:(NSString *)startClockID;

@end
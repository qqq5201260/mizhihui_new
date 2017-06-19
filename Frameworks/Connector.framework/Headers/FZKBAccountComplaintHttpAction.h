
//
//  FZKBAccountComplaintHttpAction.h
//
//
//  Created by mac on date.
//  Copyright © 2017年 chinapke. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FZKHttpWork.h"

@interface FZKBAccountComplaintHttpAction : FZKHttpWork
    
/**
 方法描述：
 账号申诉
 
 传入参数：
name：用户姓名
phone：用户手机号
email：用户邮箱
idNumber：身份证号
plateNumber：车牌号
vin：车架号
picUrl：（传入一张图片）

返回参数：
resultCode：0表示成功
 */
- (void)accountComplaintActionWithName:(NSString *)name phone:(NSString *)phone email:(NSString *)email idNumber:(NSString *)idNumber plateNumber:(NSString *)plateNumber vin:(NSString *)vin;

@end
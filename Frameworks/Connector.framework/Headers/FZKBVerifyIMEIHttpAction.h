
//
//  FZKBVerifyIMEIHttpAction.h
//
//
//  Created by mac on date.
//  Copyright © 2017年 chinapke. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FZKHttpWork.h"

@interface FZKBVerifyIMEIHttpAction : FZKHttpWork
    
/**
 方法描述：
 验证IMEI（符合服务端规则才能通过）
 
 
 传入参数：
 imei：终端IMEI号（服务端给予）
 
 返回参数：
 resultCode：0表示成功
 platenumber：车牌号
 vin：车架号
 bname：品牌名
 bid：品牌编号
 vmname：系列名
 vmid：系列编号
 sname：车型名
 sid：车型id
 
 */

- (void)verifyIMEIActionWithImei:(NSString *)imei;

@end

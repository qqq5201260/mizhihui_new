
//
//  FZKBValidateImeiHttpAction.h
//
//
//  Created by mac on date.
//  Copyright © 2017年 chinapke. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FZKHttpWork.h"

@interface FZKBValidateImeiHttpAction : FZKHttpWork
    
/**
 方法描述：
 用户注册验证imei号
 
 传入参数
imei：设备唯一识别码
version：APP版本号
返回值
resultCode：结果码,0表示验证成功，其它表示获取失败

 */
- (void)validateImeiActionWithImei:(NSString *)imei version:(NSString *)version;

@end
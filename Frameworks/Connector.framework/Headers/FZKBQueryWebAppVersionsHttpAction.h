
//
//  FZKBQueryWebAppVersionsHttpAction.h
//
//
//  Created by mac on date.
//  Copyright © 2017年 chinapke. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FZKHttpWork.h"

@interface FZKBQueryWebAppVersionsHttpAction : FZKHttpWork
    
/**
 方法描述：
 查询WebApp版本号
 
 传入参数
input1：账号
input2：密码（都需加密）
返回值：
adddate:时间
attrNames:属性名
attrValues：属性值
TITLE：标题
titleImgUrl：图片url地址
zipFileURI:文件地址
 */
- (void)queryWebAppVersionsActionWithInput1:(NSString *)input1 input2:(NSString *)input2;

@end
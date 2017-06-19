
//
//  FZKBSRstewardListHttpAction.h
//
//
//  Created by mac on date.
//  Copyright © 2017年 chinapke. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FZKHttpWork.h"

@interface FZKBSRstewardListHttpAction : FZKHttpWork
    
/**
 方法描述：
 思锐管家列表（在线客服，聊天记录）
 
 传入参数：
rows:查找条数
adddate：加载时间（传入当前时间）
direction：0表示上拉加载最新，1表示下拉加载更多

返回参数：
adddate：加载时间
content：内容
customerID：用户ID
id：每条信息ID
isImg：信息是否是图片
isRead：false表示用户发的，true表示思锐发的
name：用户名字
type：类型（都是传0）



 */
- (void)sRstewardListActionWithRows:(NSString *)rows adddate:(NSString *)adddate direction:(NSString *)direction;

@end
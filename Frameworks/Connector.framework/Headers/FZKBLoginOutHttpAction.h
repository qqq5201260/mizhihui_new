
//
//  FZKBLoginOutHttpAction.h
//
//
//  Created by mac on date.
//  Copyright © 2017年 chinapke. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FZKHttpWork.h"

@interface FZKBLoginOutHttpAction : FZKHttpWork
    
/**
 方法描述：
 登出（安全退出）
 
 返回参数
resultCode：0表示成功
 */
- (void)loginOutAction;

@end
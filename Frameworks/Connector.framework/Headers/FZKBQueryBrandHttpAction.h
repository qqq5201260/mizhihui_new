
//
//  FZKBQueryBrandHttpAction.h
//
//
//  Created by mac on date.
//  Copyright © 2017年 chinapke. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FZKHttpWork.h"

@interface FZKBQueryBrandHttpAction : FZKHttpWork
    
/**
 方法描述：
 查询车辆品牌（流程：添加车辆流程，第一步查询所有车辆品牌，第二步选择一个品牌，第三步根据品牌查询车辆）
 
 传入参数：

返回参数：
alterImageCount：（未用到）
brandid：（未用到）
createTime：创建时间
createUserID：（未用到）
depID：（未用到）
enName：（未用到）
entityID：品牌ID（相当于brandID）（重点获取）
firstLetter：所属字母级/首字母（比如A级）
firstSpellByName：品牌名首单词（如ALPINA）
imgMathParam：图标数字参数
isOpen4I18N：是否是打开
logoUrl：图标加载地址
memo：（未用到）
name：品牌名
updateTime：修改时间
updateUserID：修改ID
 */
- (void)queryBrandAction;

@end
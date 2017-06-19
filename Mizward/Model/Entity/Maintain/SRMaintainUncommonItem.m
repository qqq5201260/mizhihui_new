//
//  SRMaintainUncommonItem.m
//  SiRuiV4.0
//
//  Created by zhangjunbo on 15/7/27.
//  Copyright (c) 2015年 SiRui. All rights reserved.
//

#import "SRMaintainUncommonItem.h"
#import "SRMaintainReserveInfo.h"

@implementation SRMaintainUncommonItem

- (SRMaintainSpecialType)specialType
{
    return [[SRMaintainReserveInfo uncommonMaintainTypeDic][self.name] integerValue];
}

- (CGFloat)remainMileage
{
    return self.nextMileage - self.lastMileage;
}

@end

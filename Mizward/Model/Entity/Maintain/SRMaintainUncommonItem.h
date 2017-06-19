//
//  SRMaintainUncommonItem.h
//  SiRuiV4.0
//
//  Created by zhangjunbo on 15/7/27.
//  Copyright (c) 2015年 SiRui. All rights reserved.
//

#import "SREntity.h"

@interface SRMaintainUncommonItem : SREntity

@property (nonatomic, assign) NSInteger maintenID;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, assign) BOOL isIgnore;
@property (nonatomic, assign) CGFloat lastMileage;
@property (nonatomic, assign) CGFloat nextMileage;
@property (nonatomic, assign) CGFloat intervalMile;

- (SRMaintainSpecialType)specialType;

- (CGFloat)remainMileage;

@end

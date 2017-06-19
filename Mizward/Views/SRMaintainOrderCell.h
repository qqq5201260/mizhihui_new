//
//  SRMaintainOrderCell.h
//  SiRuiV4.0
//
//  Created by zhangjunbo on 15/7/18.
//  Copyright (c) 2015年 SiRui. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SRTableViewCell.h"

@class SRMaintainReserveInfo;

@interface SRMaintainOrderCell : SRTableViewCell

@property (nonatomic, strong) SRMaintainReserveInfo *reserveInfo;

@property (nonatomic, copy) void(^orderPressedBlock)();
@property (nonatomic, copy) void(^recordPressedBlock)();

+ (CGFloat)heightWithSpecialTypes:(BOOL)withSpecialTypes;

@end

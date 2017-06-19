//
//  SRMaintainStoreCell.h
//  SiRuiV4.0
//
//  Created by zhangjunbo on 15/7/20.
//  Copyright (c) 2015年 SiRui. All rights reserved.
//

#import "SRTableViewCell.h"

@class SRMaintainDepInfo;

@interface SRMaintainStoreCell : SRTableViewCell

@property (nonatomic, strong) SRMaintainDepInfo *depInfo;

- (void)setDefault;

@end

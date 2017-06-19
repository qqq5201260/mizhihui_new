//
//  SRMessageCell.h
//  SiRuiV4.0
//
//  Created by zhangjunbo on 15/7/13.
//  Copyright (c) 2015年 SiRui. All rights reserved.
//

#import "SRTableViewCell.h"

extern UIImage * imageForMessageSubType(SRMessageSubType subType);

@class SRMessageInfo;

@interface SRMessageCell : SRTableViewCell

@property (nonatomic, strong) SRMessageInfo *info;

@end

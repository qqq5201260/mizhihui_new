//
//  SROrderStartSettingsViewController.h
//  SiRuiV4.0
//
//  Created by zhangjunbo on 15/6/15.
//  Copyright (c) 2015年 SiRui. All rights reserved.
//

#import "SRBaseViewController.h"

@class SROrderStartInfo;

@interface SROrderStartSettingsViewController : SRBaseViewController

@property (nonatomic, strong) SROrderStartInfo *info;
@property (nonatomic, strong) NSNumber *type;

@end

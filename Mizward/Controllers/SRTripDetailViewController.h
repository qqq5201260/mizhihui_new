//
//  SRTripDetailViewController.h
//  SiRuiV4.0
//
//  Created by zhangjunbo on 15/6/24.
//  Copyright (c) 2015年 SiRui. All rights reserved.
//

#import "SRBaseViewController.h"

@class SRTripInfo;

@interface SRTripDetailViewController : SRBaseViewController

@property (nonatomic, strong) SRTripInfo *tripInfo;

@property (nonatomic, strong) NSArray *tripPoints;

@end

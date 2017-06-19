//
//  SRMessageViewController.h
//  SiRuiV4.0
//
//  Created by zhangjunbo on 15/6/29.
//  Copyright (c) 2015年 SiRui. All rights reserved.
//

#import "SRBaseViewController.h"

@interface SRMessageViewController : SRBaseViewController

@property (nonatomic, assign) SRMessageType type;

- (instancetype)initWithType:(SRMessageType)type;

@end

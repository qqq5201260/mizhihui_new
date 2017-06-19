//
//  SRMaintainCheckingView.h
//  SiRuiV4.0
//
//  Created by zhangjunbo on 15/7/17.
//  Copyright (c) 2015年 SiRui. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SRMaintainCheckingView : UIView

@property (nonatomic, assign) BOOL isOK;

@property (nonatomic, assign) SRSystemType type;

@property (nonatomic, assign) CGFloat duration;

- (void)startAnimation;
- (void)endAnimation;

- (void)reset;

@end

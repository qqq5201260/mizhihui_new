//
//  SRMaintainProgressView.h
//  SiRuiV4.0
//
//  Created by zhangjunbo on 15/7/17.
//  Copyright (c) 2015年 SiRui. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SRMaintainProgressView : UIView

@property (nonatomic, assign) CGFloat innerRadius;
@property (nonatomic, assign) CGFloat innerWidth;

@property (nonatomic, assign) CGFloat outerRadius;
@property (nonatomic, assign) CGFloat outerWidth;

@property (nonatomic, strong) UIColor *colorDefault;
@property (nonatomic, strong) UIColor *colorHighlighted;

@property (nonatomic, assign) CGFloat triangleSide;

@property (nonatomic, assign) CGFloat progress;

@end

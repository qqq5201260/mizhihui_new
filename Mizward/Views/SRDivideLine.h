//
//  SRDivideLine.h
//  SiRuiV4.0
//
//  Created by zhangjunbo on 15/7/10.
//  Copyright (c) 2015年 SiRui. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SRDivideLine : UIView

@property (nonatomic, strong) UIColor *lineColor;
@property (nonatomic, assign) BOOL     isVertical;
@property (nonatomic, assign) CGFloat  space;
@property (nonatomic, assign) CGFloat  lineWidth;
@property (nonatomic, assign) CGFloat  lineHeight;

@end

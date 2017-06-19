//
//  UIView+Additions.h
//  SiRuiV4.0
//
//  Created by zhangjunbo on 15/7/10.
//  Copyright (c) 2015年 SiRui. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Additions)

- (UIImage *)sr_takeSnapshot;

- (void)setBackgroundImage:(UIImage *)image;
- (void)clearBackgroundImage;

- (void)displayAllViews;

- (void)topLine;
- (void)bottomLine;

/**
 *  当前对应的点是否是透明的
 */
- (BOOL)isTansparentOfPoint:(CGPoint)point;

@end

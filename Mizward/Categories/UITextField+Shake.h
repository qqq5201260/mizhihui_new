//
//  UITextField+Shake.h
//  SiRuiV4.0
//
//  Created by zhangjunbo on 15/7/22.
//  Copyright (c) 2015年 SiRui. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, ShakeDirection) {
    ShakeDirectionHorizontal = 0,
    ShakeDirectionVertical
};

@interface UITextField (Shake)

- (void)shake:(NSInteger)times withDelta:(CGFloat)delta;

- (void)shake:(NSInteger)times withDelta:(CGFloat)delta andSpeed:(NSTimeInterval)interval;

- (void)shake:(NSInteger)times withDelta:(CGFloat)delta andSpeed:(NSTimeInterval)interval shakeDirection:(ShakeDirection)shakeDirection;

@end

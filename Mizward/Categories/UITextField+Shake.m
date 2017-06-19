//
//  UITextField+Shake.m
//  SiRuiV4.0
//
//  Created by zhangjunbo on 15/7/22.
//  Copyright (c) 2015年 SiRui. All rights reserved.
//

#import "UITextField+Shake.h"

@implementation UITextField (Shake)

- (void)shake:(NSInteger)times withDelta:(CGFloat)delta
{
    [self _shake:times
       direction:ShakeDirectionVertical
    currentTimes:0
       withDelta:delta
        andSpeed:0.03
  shakeDirection:ShakeDirectionHorizontal];
}

- (void)shake:(NSInteger)times withDelta:(CGFloat)delta andSpeed:(NSTimeInterval)interval
{
    [self _shake:times
       direction:ShakeDirectionVertical
    currentTimes:0
       withDelta:delta
        andSpeed:interval
  shakeDirection:ShakeDirectionHorizontal];
}

- (void)shake:(NSInteger)times withDelta:(CGFloat)delta andSpeed:(NSTimeInterval)interval shakeDirection:(ShakeDirection)shakeDirection
{
    [self _shake:times
       direction:ShakeDirectionVertical
    currentTimes:0
       withDelta:delta
        andSpeed:interval
  shakeDirection:shakeDirection];
}

- (void)_shake:(NSInteger)times direction:(NSInteger)direction currentTimes:(int)current withDelta:(CGFloat)delta andSpeed:(NSTimeInterval)interval shakeDirection:(ShakeDirection)shakeDirection
{
    [UIView animateWithDuration:interval animations:^{
        self.transform = (shakeDirection == ShakeDirectionHorizontal) ? CGAffineTransformMakeTranslation(delta * direction, 0) : CGAffineTransformMakeTranslation(0, delta * direction);
    } completion:^(BOOL finished) {
        if(current >= times) {
            self.transform = CGAffineTransformIdentity;
            return;
        }
        [self _shake:(times - 1)
           direction:direction * -1
        currentTimes:current + 1
           withDelta:delta
            andSpeed:interval
      shakeDirection:shakeDirection];
    }];
}


@end

//
//  SRAlphaButton.m
//  SiRuiV4.0
//
//  Created by zhangjunbo on 15/7/24.
//  Copyright (c) 2015年 SiRui. All rights reserved.
//

#import "SRAlphaButton.h"

@implementation SRAlphaButton

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.isIgnoreTouchInTransparentPoint = YES;
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        self.isIgnoreTouchInTransparentPoint = YES;
    }
    return self;
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    BOOL result = [super pointInside:point withEvent:event];
    if (!self.isIgnoreTouchInTransparentPoint) {
        return result;
    }
    
    if (result) {
        return ![self isTansparentOfPoint:point];
    }
    return NO;
}


@end

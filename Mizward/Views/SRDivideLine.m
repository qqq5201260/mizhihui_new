//
//  SRDivideLine.m
//  SiRuiV4.0
//
//  Created by zhangjunbo on 15/7/10.
//  Copyright (c) 2015年 SiRui. All rights reserved.
//

#import "SRDivideLine.h"

@implementation SRDivideLine

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        self.backgroundColor = [UIColor clearColor];
        _lineColor = [UIColor defaultColor];
        _isVertical = YES;
        _lineWidth = 1.0;
        _lineHeight = 2.0;
        _space = 1.5;
    }
    
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        _lineColor = [UIColor defaultColor];
        _isVertical = YES;
        _lineWidth = 1.0;
        _lineHeight = 2.0;
        _space = 1.5;
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    // Drawing code
    NSInteger count = 0;
    if(!self.isVertical){
        count = self.width/(self.lineWidth + self.space);
    }else{
        count = self.height/(self.lineHeight + self.space);
    }
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, self.isVertical?self.lineWidth:self.lineHeight);
    
    CGFloat drawWidth = 0;
    
    NSInteger index = 0;
    while (index < count) {
        if(self.isVertical){
            CGContextMoveToPoint(context, (self.width - self.lineWidth)/2, drawWidth);
        }else{
            CGContextMoveToPoint(context, drawWidth, (self.height - self.lineHeight)/2);
        }
        
        CGContextSetStrokeColorWithColor(context, self.lineColor.CGColor);
        
        if(self.isVertical){
            CGContextAddLineToPoint(context, (self.width - self.lineWidth)/2, drawWidth);
            CGContextAddLineToPoint(context, (self.width - self.lineWidth)/2, drawWidth + self.lineHeight);
        }else{
            CGContextAddLineToPoint(context, drawWidth, (self.height - self.lineHeight)/2);
            CGContextAddLineToPoint(context, drawWidth + self.lineWidth, (self.height - self.lineHeight)/2);
        }
        CGContextStrokePath(context);
        drawWidth += self.space + (self.isVertical?self.lineHeight:self.lineWidth);
        ++index;
    }
}

- (void)setLineColor:(UIColor *)lineColor {
    _lineColor = lineColor;
    [self setNeedsDisplay];
}

- (void)setIsVertical:(BOOL)isVertical {
    _isVertical = isVertical;
    [self setNeedsDisplay];
}

- (void)setSpace:(CGFloat)space {
    _space = space;
    [self setNeedsDisplay];
}

- (void)setLineHeight:(CGFloat)lineHeight {
    _lineHeight = lineHeight;
    [self setNeedsDisplay];
}

- (void)setLineWidth:(CGFloat)lineWidth {
    _lineWidth = lineWidth;
    [self setNeedsDisplay];
}


@end

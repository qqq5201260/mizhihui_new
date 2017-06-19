//
//  SRMaintainSpecialProgress.m
//  SiRuiV4.0
//
//  Created by zhangjunbo on 15/7/18.
//  Copyright (c) 2015年 SiRui. All rights reserved.
//

#import "SRMaintainSpecialProgress.h"

@interface SRMaintainSpecialProgress ()

@property (nonatomic, strong) UIColor *progressColor;
@property (nonatomic, strong) UIColor *progressBackgroundColor;
@property (nonatomic, assign) CGFloat lineHeight;
@property (nonatomic, assign) CGFloat radius;

@end

@implementation SRMaintainSpecialProgress

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        [self defaultValue];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self defaultValue];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self defaultValue];
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect
{
    //获取当前(View)上下文以便于之后的绘画，这个是一个离屏。
    CGContextRef context = UIGraphicsGetCurrentContext() ;
    
    CGContextSetLineCap(context, kCGLineCapSquare);
    CGContextSetLineWidth(context, self.lineHeight);
    CGContextSetStrokeColorWithColor(context, self.progressBackgroundColor.CGColor);
    CGContextBeginPath(context);
    CGContextMoveToPoint(context, 0, self.middleY);
    CGContextAddLineToPoint(context, self.width, self.middleY);
    CGContextStrokePath(context);
    
    CGContextSetLineCap(context, kCGLineCapSquare);
    CGContextSetLineWidth(context, self.lineHeight);
    CGContextSetStrokeColorWithColor(context, self.progressColor.CGColor);
    CGContextBeginPath(context);
    CGContextMoveToPoint(context, 0, self.middleY);
    CGContextAddLineToPoint(context, self.width*self.progress, self.middleY);
    CGContextStrokePath(context);

    CGFloat y = self.width*self.progress;
    y = MAX(y, self.radius);
    y = MIN(y, self.width - self.radius);
    CGContextAddArc(context, y, self.middleY, self.radius, 0, 2*M_PI, 0);
    CGContextSetFillColorWithColor(context, self.progressColor.CGColor);
    CGContextSetStrokeColorWithColor(context, self.progressColor.CGColor);
    CGContextDrawPath(context, kCGPathFillStroke);
}

#pragma mark - Setter

- (void)setProgress:(CGFloat)progress {
    _progress = progress;
    [self setNeedsDisplay];
}

#pragma mark - 私有方法

- (void)defaultValue
{
    self.progressColor = [UIColor defaultColor];
    self.progressBackgroundColor = [UIColor darkGrayColor];
    self.lineHeight = 0.5f;
    self.radius = 2.0f;
    
//    self.progress = 0.5f;
    
    self.backgroundColor = [UIColor clearColor];
}

#pragma mark - Setter

@end

//
//  SRMaintainProgressView.m
//  SiRuiV4.0
//
//  Created by zhangjunbo on 15/7/17.
//  Copyright (c) 2015年 SiRui. All rights reserved.
//

#import "SRMaintainProgressView.h"
#import <CoreText/CoreText.h>

@interface SRMaintainProgressView ()


@end

@implementation SRMaintainProgressView

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
    
    /*  外圆  */
    
    CGContextSetLineJoin(context, kCGLineJoinRound);
    CGContextSetFlatness(context, 2.0);
    CGContextSetAllowsAntialiasing(context, true);
    CGContextSetShouldAntialias(context, true);
    CGContextSetInterpolationQuality(context, kCGInterpolationHigh);
    
    CGContextSetLineWidth(context,1.0f);     //设置线条宽度
    
    CGFloat deltaRadian = 0.05f;
    CGFloat endRadian = self.progress * M_PI * 2;
    CGFloat actualEndRadian = 0;
    
    CGFloat radian = 0;
    while (radian < M_PI * 2) {
        CGContextMoveToPoint(context, self.middleX, self.middleY);
        CGFloat x = self.middleX + self.outerRadius*sinf(radian);
        CGFloat y = self.middleY - self.outerRadius*cosf(radian);
        CGContextAddLineToPoint(context, x, y);
        
        actualEndRadian = radian<=endRadian?radian:actualEndRadian;
        
        CGColorRef color = radian<=endRadian?self.colorHighlighted.CGColor:self.colorDefault.CGColor;
        
        CGContextSetStrokeColorWithColor(context, color);   //设置颜色
        CGContextSetFillColorWithColor(context, color);
        CGContextDrawPath(context, kCGPathFillStroke);
        
        radian += deltaRadian;
    }
    
    //画圆覆盖内部线条
    CGContextAddArc(context, self.middleX, self.middleY, self.outerRadius-self.outerWidth, 0, 2*M_PI, 0);
    CGContextSetFillColorWithColor(context, CGColorCreateCopy(self.backgroundColor.CGColor));
    CGContextSetStrokeColorWithColor(context, [UIColor clearColor].CGColor);
    CGContextDrawPath(context, kCGPathFillStroke);
    
    /*  内圆  */
    
    //画笔线的颜色
    CGContextSetStrokeColorWithColor(context, self.colorHighlighted.CGColor);
    //线的宽度
    CGContextSetLineWidth(context, self.innerWidth);
    //添加一个圆 x, y, radius, startAngle, endAngle, clockwise 0为顺时针，1为逆时针
    CGContextAddArc(context, self.middleX, self.middleY, self.innerRadius, 0, 2*M_PI, 0);
    //绘制路径
    CGContextDrawPath(context, kCGPathStroke);
    
    /*  三角形  */
    
    //三角形高
    CGFloat trangleHigh = self.triangleSide * sqrtf(3.0) / 2.0;
    //三角形中心半径
    CGFloat radius = self.innerRadius + (self.outerRadius - self.outerWidth - self.innerRadius)/2;
    
    CGPoint sPoints[3];//坐标点
    
    //坐标1
    sPoints[0] = CGPointMake(self.middleX + (radius + trangleHigh*2/3)*sinf(actualEndRadian),
                             self.middleY - (radius + trangleHigh*2/3)*cosf(actualEndRadian));
    
    CGFloat delta = atanf(0.5*self.triangleSide/(radius-trangleHigh/3));
    
    CGFloat baseRadius = sqrtf(powf(self.triangleSide/2, 2) + powf(radius-trangleHigh/3, 2));
    
    sPoints[1] = CGPointMake(self.middleX + baseRadius*sinf(actualEndRadian-delta),
                             self.middleY - baseRadius*cosf(actualEndRadian-delta));
    
    sPoints[2] = CGPointMake(self.middleX + baseRadius*sinf(actualEndRadian+delta),
                             self.middleY - baseRadius*cosf(actualEndRadian+delta));
    
    //添加线
    CGContextAddLines(context, sPoints, 3);
    //封起来
    CGContextClosePath(context);
    //设置填充色
    CGContextSetFillColorWithColor(context, self.colorHighlighted.CGColor);
    //设置边框颜色
    CGContextSetStrokeColorWithColor(context, self.colorHighlighted.CGColor);
    //根据坐标绘制路径
    CGContextDrawPath(context, kCGPathFillStroke);
    
    /*  文字  */
    
    NSString *str = [NSString stringWithFormat:@"%zd%%", (NSInteger)(self.progress*100)];
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:str];
    //字体
    UIFont *font = [UIFont boldSystemFontOfSize:30.0f];
    CTFontRef fontRef = CTFontCreateWithName((CFStringRef)font.fontName, font.pointSize, NULL);
    [attributedString addAttribute:(NSString *)kCTFontAttributeName value:(__bridge id)fontRef
                             range:NSMakeRange(0, [attributedString length])];
    //颜色
    [attributedString addAttribute:(NSString *)kCTForegroundColorAttributeName
                             value:(id)self.colorDefault.CGColor
                             range:NSMakeRange(0, [attributedString length])];
    //计算大小
    CGRect strRect = [attributedString boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT)
                                                    options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                                    context:nil];
    NSInteger height = (NSInteger)(strRect.size.height + 0.5);
    CGRect strFrame = CGRectMake((self.width - strRect.size.width)/2 ,
                                 -(self.height - strRect.size.height)/2,
                                 strRect.size.width, height);
    //排版
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)attributedString);
    CGMutablePathRef Path = CGPathCreateMutable();
    CGPathAddRect(Path, NULL , strFrame);
    CTFrameRef ctFrame = CTFramesetterCreateFrame(framesetter,CFRangeMake(0, 0), Path, NULL);
    //翻转坐标系
    CGContextSetTextMatrix(context, CGAffineTransformIdentity);
    CGContextTranslateCTM(context, 0, height);
    CGContextScaleCTM(context, 1.0, -1.0);
    //画出文本
    CTFrameDraw(ctFrame, context);
    
    //释放
    CGPathRelease(Path);
    CFRelease(framesetter);
    CFRelease(fontRef);
}

#pragma mark - 私有方法

- (void)defaultValue
{
    self.innerRadius = 45.0f * iPhoneScale;
    self.innerWidth = 1.0f;
    self.outerRadius = 70.0f  * iPhoneScale;
    self.outerWidth = 8.0f * iPhoneScale;
//    self.progress = 0.3f;
    
    self.triangleSide = 10.0f;
    
    self.colorDefault = [UIColor colorWithWhite:1.0 alpha:0.4];
    self.colorHighlighted = [UIColor whiteColor];
    
    self.backgroundColor = [UIColor defaultColor];
}

#pragma mark - Setter

- (void)setProgress:(CGFloat)progress {
    _progress = progress;
    [self setNeedsDisplay];
}

@end

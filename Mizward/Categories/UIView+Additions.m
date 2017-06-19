//
//  UIView+Additions.m
//  SiRuiV4.0
//
//  Created by zhangjunbo on 15/7/10.
//  Copyright (c) 2015年 SiRui. All rights reserved.
//

#import "UIView+Additions.h"

@implementation UIView (Additions)

- (UIImage *)sr_takeSnapshot
{
    CGRect rect = [self bounds];
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, [[UIScreen mainScreen] scale]);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(context, rect.origin.x, rect.origin.y);
    [[self layer] renderInContext:context];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

- (void)setBackgroundImage:(UIImage *)image
{
    self.layer.contents = (id) image.CGImage; // 如果需要背景透明加上下面这句
    self.backgroundColor = [UIColor clearColor];
}

- (void)clearBackgroundImage {
    self.layer.contents = nil;
}

- (void)dumpView:(UIView *)aView atIndent:(int)indent into:(NSMutableString *)outstring
{
    for (int i = 0; i < indent; i++) [outstring appendString:@"--"];
    [outstring appendFormat:@"[%2d] %@ %@ %@\n", indent, [[aView class] description], aView, NSStringFromCGRect(aView.bounds)];
    
    for (UIView *view in [aView subviews])
        [self dumpView:view atIndent:indent + 1 into:outstring];
}

- (void)displayAllViews
{
    NSMutableString *outstring = [[NSMutableString alloc] init];
    [self dumpView: self atIndent:0 into:outstring];
    NSLog(@"\n%@", outstring);
}

- (void)topLine
{
    UIView *line = [[UIView alloc] initWithFrame:CGRectZero];
    line.backgroundColor = [UIColor separatorColor];
    [self addSubview:line];
    [line makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self);
        make.height.equalTo(1.0f);
    }];
}

- (void)bottomLine
{
    UIView *line = [[UIView alloc] initWithFrame:CGRectZero];
    line.backgroundColor = [UIColor separatorColor];
    [self addSubview:line];
    [line makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self);
        make.height.equalTo(1.0f);
    }];
}

#pragma mark -
#pragma mark 当前对应的点是否是透明的

- (void)RGBA:(unsigned char[4])pixel ofPoint:(CGPoint)point
{
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    
    CGContextRef context = CGBitmapContextCreate(pixel, 1, 1, 8, 4, colorSpace, kCGBitmapAlphaInfoMask & kCGImageAlphaPremultipliedLast);
    
    CGContextTranslateCTM(context, -point.x, -point.y);
    
    [self.layer renderInContext:context];
    
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
}

- (BOOL)isTansparentOfPoint:(CGPoint)point
{
    unsigned char pixel[4] = {0};
    
    //为什么这里不使用kCGImageAlphaOnly，因为我发现它得到的结果是不经过layer.mask处理的
    //所以不可取，还是获取RGBA吧
    [self RGBA:pixel ofPoint:point];
    
    //    NSLog(@"pixel: %d %d %d %d", pixel[0], pixel[1], pixel[2], pixel[3]);
    
    //这里认为只要alpha值为0就是透明。和clearColor还是有区别的
    return pixel[3]==0;
}


@end

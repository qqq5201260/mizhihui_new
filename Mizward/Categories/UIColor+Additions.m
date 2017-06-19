//
//  UIColor+Additions.m
//  SiRuiV4.0
//
//  Created by zhangjunbo on 15/6/29.
//  Copyright (c) 2015年 SiRui. All rights reserved.
//

#import "UIColor+Additions.h"

@implementation UIColor (Additions)

+ (UIColor *)randomColor
{
    CGFloat hue = ( arc4random() % 256 / 256.0 );  //  0.0 to 1.0
    CGFloat saturation = ( arc4random() % 128 / 256.0 ) + 0.5;  //  0.5 to 1.0, away from white
    CGFloat brightness = ( arc4random() % 128 / 256.0 ) + 0.5;  //  0.5 to 1.0, away from black
    return [UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:1];
}

+ (UIColor *)separatorColor
{
    return [UIColor colorWithRed:227.0f/256.0f green:226.0f/256.0f blue:229.0f/256.0f alpha:1.0];
}

+ (UIColor *)defaultNavBarTintColor
{
    return [UIColor colorWithRed:53.0f/256.0f green:113.0f/256.0f blue:255.0f/256.0f alpha:1.0];
}

+ (UIColor *)defaultColor
{
    return [UIColor colorWithRed:81.0f/256.0f green:132.0f/256.0f blue:252.0f/256.0f alpha:1.0];
}

+ (UIColor *)defaultBackgroundColor
{
    return [UIColor colorWithRed:243.0f/256.0f green:244.0f/256.0f blue:246.0f/256.0f alpha:1.0];
}

+ (UIColor *)disableColor
{
     return [UIColor colorWithRed:204.0f/256.0f green:204.0f/256.0f blue:204.0f/256.0f alpha:1.0];
}

+ (UIColor *)pageIndicatorTintColor
{
    return [UIColor colorWithRed:1.0f green:1.0f blue:1.0f alpha:0.2f];
}

+ (UIColor *)currentPageIndicatorTintColor
{
    return [UIColor whiteColor];
}

+ (UIColor *)warningColor
{
    return [UIColor colorWithRed:255.0f/256.0f green:133.0f/256.0f blue:66.0f/256.0f alpha:1.0f];
}

+ (UIColor *)goodColor
{
    return [UIColor colorWithRed:57.0f/256.0f green:192.0f/256.0f blue:106.0f/256.0f alpha:1.0f];
}

+ (UIColor *)inputErrorColor
{
    return [UIColor colorWithRed:255.0f/256.0f green:85.0f/256.0f blue:141.0f/256.0f alpha:1.0f];
}

@end

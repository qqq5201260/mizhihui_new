//
//  UIButton+Additions.m
//  Mizward
//
//  Created by zhangjunbo on 15/11/5.
//  Copyright © 2015年 Mizward. All rights reserved.
//

#import "UIButton+Additions.h"

const int DEFAULT_SPACING = 6.0f;

@implementation UIButton (Additions)

- (void)centerImageAndTitle:(float)spacing
{
    // get the size of the elements here for readability
    CGSize imageSize = self.imageView.frame.size;
    CGSize titleSize = self.titleLabel.frame.size;
    
    // get the height they will take up as a unit
    CGFloat totalHeight = (imageSize.height + titleSize.height + spacing);
    
    // raise the image and push it right to center it
    self.imageEdgeInsets = UIEdgeInsetsMake(- (totalHeight - imageSize.height), 0.0, 0.0, - titleSize.width);
    
    // lower the text and push it left to center it
    self.titleEdgeInsets = UIEdgeInsetsMake(0.0, - imageSize.width, - (totalHeight - titleSize.height),0.0);
}

- (void)centerImageAndTitle
{
    [self centerImageAndTitle:DEFAULT_SPACING];
}

@end

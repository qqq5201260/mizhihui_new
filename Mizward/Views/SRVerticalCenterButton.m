//
//  SRVerticalCenterButton.m
//  Mizward
//
//  Created by zhangjunbo on 15/11/5.
//  Copyright © 2015年 Mizward. All rights reserved.
//

#import "SRVerticalCenterButton.h"

const CGFloat DefaltSpacing = 6.0f;

@implementation SRVerticalCenterButton

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        self.spacing = DefaltSpacing;
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.spacing = DefaltSpacing;
    }
    return self;
}

-(void)layoutSubviews {
    [super layoutSubviews];
    
    // Center image
    self.imageView.center = CGPointMake(self.center.x,
                                        self.center.y - (self.imageView.height+self.spacing)/2);
    
    //Center text
    self.titleLabel.center = CGPointMake(self.center.x,
                                         self.center.y + (self.titleLabel.height+self.spacing)/2);
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
}

@end

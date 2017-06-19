//
//  SRWelcomePage3.h
//  SiRuiV4.0
//
//  Created by zhangjunbo on 15/8/1.
//  Copyright (c) 2015年 SiRui. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SRWelcomePage3 : UIView

@property (nonatomic, strong) VoidBlock buttonPressed;

+ (SRWelcomePage3 *)instanceWelcomePage3;

- (void)easeInAndOutIsIn:(BOOL)isIn;

- (void)reset;

@end

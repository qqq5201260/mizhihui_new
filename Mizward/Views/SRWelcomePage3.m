//
//  SRWelcomePage3.m
//  SiRuiV4.0
//
//  Created by zhangjunbo on 15/8/1.
//  Copyright (c) 2015年 SiRui. All rights reserved.
//

#import "SRWelcomePage3.h"
#import <pop/POP.h>

@interface SRWelcomePage3 ()
@property (weak, nonatomic) IBOutlet UIImageView *title;
@property (weak, nonatomic) IBOutlet UIImageView *button;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *button_bottom;

@end

@implementation SRWelcomePage3
{
    CGFloat title_top;
}

+ (SRWelcomePage3 *)instanceWelcomePage3
{
    NSArray *nibView = [[NSBundle mainBundle] loadNibNamed:@"SRWelcomePage3" owner:nil options:nil];
    return [nibView objectAtIndex:0];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.backgroundColor = [UIColor clearColor];
    
    [self.button bk_whenTapped:^{
        if (self.buttonPressed) {
            self.buttonPressed();
        }
    }];
    
    self.button_bottom.constant *= iPhoneScale;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self reset];
    
    title_top = self.title.top;
}

#pragma mark - Public

- (void)easeInAndOutIsIn:(BOOL)isIn {
    
    if (isIn) {
        [self reset];
    } else {
        [self clearAnimations];
    }
    
//    NSLog(@"page2 %@", isIn?@"EaseIn":@"EaseOut");
    
    POPBasicAnimation *title_AlphaAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerOpacity];
    title_AlphaAnimation.fromValue = isIn?@(0.0):@(1.0);
    title_AlphaAnimation.toValue = isIn?@(1.0):@(0.0);
    title_AlphaAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    title_AlphaAnimation.duration = 0.35;
    title_AlphaAnimation.beginTime = CACurrentMediaTime() + (isIn?0:0.35);
    title_AlphaAnimation.completionBlock = ^(POPAnimation *anim, BOOL finished){
        if (isIn) return ;
        [self reset];
    };
    [self.title.layer pop_addAnimation:title_AlphaAnimation forKey:@"title_AlphaAnimation"];
    
    POPBasicAnimation *title_PositionAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerPositionY];
    title_PositionAnimation.fromValue = isIn?@(title_top+30):@(title_top);
    title_PositionAnimation.toValue = isIn?@(title_top):@(title_top+30);
    title_PositionAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    title_PositionAnimation.duration = 0.35;
    title_PositionAnimation.beginTime = CACurrentMediaTime() + (isIn?0:0.35);
    [self.title.layer pop_addAnimation:title_PositionAnimation forKey:@"title_PositionAnimation"];
    
    POPBasicAnimation *button_AlphaAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerOpacity];
    button_AlphaAnimation.fromValue = isIn?@(0.0):@(1.0);
    button_AlphaAnimation.toValue = isIn?@(1.0):@(0.0);
    button_AlphaAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    button_AlphaAnimation.duration = 0.35;
    button_AlphaAnimation.beginTime = CACurrentMediaTime() + (isIn?0.35:0);
    [self.button.layer pop_addAnimation:button_AlphaAnimation forKey:@"button_AlphaAnimation"];
    
}

- (void)reset {
//    NSLog(@"Page3 Reset");
    self.title.alpha = 0.0f;
    self.button.alpha = 0.0f;
    
    [self clearAnimations];
}

#pragma mark Private

- (void)clearAnimations {
    [self.title.layer pop_removeAllAnimations];
    [self.button.layer pop_removeAllAnimations];
}



@end

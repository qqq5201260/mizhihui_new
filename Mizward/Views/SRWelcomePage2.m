//
//  SRWelcomePage2.m
//  SiRuiV4.0
//
//  Created by zhangjunbo on 15/8/1.
//  Copyright (c) 2015年 SiRui. All rights reserved.
//

#import "SRWelcomePage2.h"
#import <pop/POP.h>

//const CGFloat deltaY11111 = 55.0f;
//const CGFloat totalDuration = 1.4f;

const CGFloat bubble_0_Duration = 0.35f;
const CGFloat bubble_Duration = 0.25f;

const CGSize startScale = {0.2f, 0.2f};
const CGSize endScale   = {1.0f, 1.0f};

//show
const CGFloat bubble_0_start_S = 0.0f;
const CGFloat bubble_1_start_S = 0.2f;
const CGFloat bubble_2_start_S = 0.3f;
const CGFloat bubble_3_start_S = 0.4f;
const CGFloat bubble_4_start_S = 0.5f;
const CGFloat bubble_5_start_S = 0.6f;
const CGFloat bubble_6_start_S = 0.7f;

//dismiss
const CGFloat bubble_6_start_D = 0.0f;
const CGFloat bubble_5_start_D = 0.1f;
const CGFloat bubble_4_start_D = 0.2f;
const CGFloat bubble_3_start_D = 0.3f;
const CGFloat bubble_2_start_D = 0.4f;
const CGFloat bubble_1_start_D = 0.5f;
const CGFloat bubble_0_start_D = 0.6f;

@interface SRWelcomePage2 ()
@property (weak, nonatomic) IBOutlet UIImageView *bubble_0;
@property (weak, nonatomic) IBOutlet UIImageView *bubble_1;
@property (weak, nonatomic) IBOutlet UIImageView *bubble_2;
@property (weak, nonatomic) IBOutlet UIImageView *bubble_3;
@property (weak, nonatomic) IBOutlet UIImageView *bubble_4;
@property (weak, nonatomic) IBOutlet UIImageView *bubble_5;
@property (weak, nonatomic) IBOutlet UIImageView *bubble_6;

@end

@implementation SRWelcomePage2
{
    CGPoint center_0;
    CGPoint center_1;
    CGPoint center_2;
    CGPoint center_3;
    CGPoint center_4;
    CGPoint center_5;
    CGPoint center_6;
}

+ (SRWelcomePage2 *)instanceWelcomePage2
{
    NSArray *nibView = [[NSBundle mainBundle] loadNibNamed:@"SRWelcomePage2" owner:nil options:nil];
    return [nibView objectAtIndex:0];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.backgroundColor = [UIColor clearColor];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self reset];
    
    center_0 = self.bubble_0.center;
    center_1 = self.bubble_1.center;
    center_2 = self.bubble_2.center;
    center_3 = self.bubble_3.center;
    center_4 = self.bubble_4.center;
    center_5 = self.bubble_5.center;
    center_6 = self.bubble_6.center;
}

#pragma mark - Public

- (void)easeInAndOutIsIn:(BOOL)isIn {
    
    if (isIn) {
        [self reset];
    } else {
        [self clearAnimations];
    }
    
//    NSLog(@"page2 %@", isIn?@"EaseIn":@"EaseOut");
    
    POPBasicAnimation *bubble_0_AlphaAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerOpacity];
    bubble_0_AlphaAnimation.fromValue = isIn?@(0.0):@(1.0);
    bubble_0_AlphaAnimation.toValue = isIn?@(1.0):@(0.0);
    bubble_0_AlphaAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    bubble_0_AlphaAnimation.duration = bubble_0_Duration;
    bubble_0_AlphaAnimation.beginTime = CACurrentMediaTime() + (isIn?bubble_0_start_S:bubble_0_start_D);
    bubble_0_AlphaAnimation.completionBlock = ^(POPAnimation *anim, BOOL finished){
        if (isIn) return ;
        [self reset];
    };
    [self.bubble_0.layer pop_addAnimation:bubble_0_AlphaAnimation forKey:@"bubble_0_AlphaAnimation"];
    
    POPBasicAnimation *bubble_0_ScaleAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerScaleXY];
    bubble_0_ScaleAnimation.fromValue = [NSValue valueWithCGSize:isIn?startScale:endScale];
    bubble_0_ScaleAnimation.toValue = [NSValue valueWithCGSize:isIn?endScale:startScale];
    bubble_0_ScaleAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    bubble_0_ScaleAnimation.duration = bubble_0_Duration;
    bubble_0_ScaleAnimation.beginTime = CACurrentMediaTime() + (isIn?bubble_0_start_S:bubble_0_start_D);
    [self.bubble_0.layer pop_addAnimation:bubble_0_ScaleAnimation forKey:@"bubble_0_ScaleAnimation"];
    
    for (NSInteger index = 0; index <= 5; ++index) {
        [self popAnimationWithIndex:index andIsIn:isIn];
    }
}

- (void)reset {
//    NSLog(@"Page2 Reset");
    self.bubble_0.alpha = 0.0f;
    self.bubble_1.alpha = 0.0f;
    self.bubble_2.alpha = 0.0f;
    self.bubble_3.alpha = 0.0f;
    self.bubble_4.alpha = 0.0f;
    self.bubble_5.alpha = 0.0f;
    self.bubble_6.alpha = 0.0f;
    
    [self clearAnimations];
}

#pragma mark Private

- (void)clearAnimations {
    [self.bubble_0.layer pop_removeAllAnimations];
    [self.bubble_1.layer pop_removeAllAnimations];
    [self.bubble_2.layer pop_removeAllAnimations];
    [self.bubble_3.layer pop_removeAllAnimations];
    [self.bubble_4.layer pop_removeAllAnimations];
    [self.bubble_5.layer pop_removeAllAnimations];
    [self.bubble_6.layer pop_removeAllAnimations];
}

- (void)popAnimationWithIndex:(NSInteger)index andIsIn:(BOOL)isIn
{
    NSArray *pop = @[self.bubble_1, self.bubble_2, self.bubble_3, self.bubble_4, self.bubble_5, self.bubble_6];
    CGFloat showTime[] = {bubble_1_start_S, bubble_2_start_S, bubble_3_start_S, bubble_4_start_S, bubble_5_start_S, bubble_6_start_S};
    CGFloat dismissTime[] = {bubble_1_start_S, bubble_2_start_S, bubble_3_start_S, bubble_4_start_S, bubble_5_start_S, bubble_6_start_S};
    CGPoint position[] = {center_1, center_2, center_3, center_4, center_5, center_6};
    
    POPBasicAnimation *pop_CenterAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPViewCenter];
    pop_CenterAnimation.fromValue = [NSValue valueWithCGPoint:isIn?center_0:position[index]];
    pop_CenterAnimation.toValue = [NSValue valueWithCGPoint:isIn?position[index]:center_0];
    pop_CenterAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    pop_CenterAnimation.duration = bubble_Duration;
    pop_CenterAnimation.beginTime = CACurrentMediaTime() + (isIn?showTime[index]:dismissTime[index]);
    [(UIImageView *)pop[index] pop_addAnimation:pop_CenterAnimation forKey:@"pop_CenterAnimation"];
    
    POPBasicAnimation *pop_AlphaAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerOpacity];
    pop_AlphaAnimation.fromValue = isIn?@(0.0):@(1.0);
    pop_AlphaAnimation.toValue = isIn?@(1.0):@(0.0);
    pop_AlphaAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    pop_AlphaAnimation.duration = bubble_Duration;
    pop_AlphaAnimation.beginTime = CACurrentMediaTime() + (isIn?showTime[index]:dismissTime[index]);
    [[(UIImageView *)pop[index] layer] pop_addAnimation:pop_AlphaAnimation forKey:@"pop_AlphaAnimation"];
    
    POPBasicAnimation *pop_ScaleAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerScaleXY];
    pop_ScaleAnimation.fromValue = [NSValue valueWithCGSize:isIn?startScale:endScale];
    pop_ScaleAnimation.toValue = [NSValue valueWithCGSize:isIn?endScale:startScale];
    pop_ScaleAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    pop_ScaleAnimation.duration = bubble_Duration;
    pop_ScaleAnimation.beginTime = CACurrentMediaTime() + (isIn?showTime[index]:dismissTime[index]);
    [[(UIImageView *)pop[index] layer] pop_addAnimation:pop_ScaleAnimation forKey:@"pop_ScaleAnimation"];
}


@end

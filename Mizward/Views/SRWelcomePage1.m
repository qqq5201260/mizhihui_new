//
//  SRWelcomePage1.m
//  SiRuiV4.0
//
//  Created by zhangjunbo on 15/7/31.
//  Copyright (c) 2015年 SiRui. All rights reserved.
//

#import "SRWelcomePage1.h"
#import <pop/POP.h>

const CGFloat deltaY = 55.0f;
const CGFloat totalDuration = 1.4f;

const CGFloat phoneDuration = 0.35f;
const CGFloat popDuration = 0.25f;

const CGSize smallScale = {0.5f, 0.5f};
const CGSize bigScale   = {1.0f, 1.0f};

//show
const CGFloat phoneStartTime_S = 0.0f;
const CGFloat pop_0_start_S = 0.25f;
const CGFloat pop_1_start_S = 0.35f;
const CGFloat pop_2_start_S = 0.45f;
const CGFloat pop_3_start_S = 0.55f;
const CGFloat pop_4_start_S = 0.65f;
const CGFloat pop_5_start_S = 0.75f;
const CGFloat pop_6_start_S = 0.85f;

//dismiss
const CGFloat pop_6_start_D = 0.0f;
const CGFloat pop_5_start_D = 0.1f;
const CGFloat pop_4_start_D = 0.2f;
const CGFloat pop_3_start_D = 0.3f;
const CGFloat pop_2_start_D = 0.4f;
const CGFloat pop_1_start_D = 0.5f;
const CGFloat pop_0_start_D = 0.6f;
const CGFloat phoneStartTime_D = 0.75f;

@interface SRWelcomePage1 ()
@property (weak, nonatomic) IBOutlet UIImageView *phone;
@property (weak, nonatomic) IBOutlet UIImageView *pop_0;
@property (weak, nonatomic) IBOutlet UIImageView *pop_1;
@property (weak, nonatomic) IBOutlet UIImageView *pop_2;
@property (weak, nonatomic) IBOutlet UIImageView *pop_3;
@property (weak, nonatomic) IBOutlet UIImageView *pop_4;
@property (weak, nonatomic) IBOutlet UIImageView *pop_5;
@property (weak, nonatomic) IBOutlet UIImageView *pop_6;

@end

@implementation SRWelcomePage1
{
    CGFloat phoneY;
    CGFloat pop_0_Y;
    CGFloat pop_1_Y;
    CGFloat pop_2_Y;
    CGFloat pop_3_Y;
    CGFloat pop_4_Y;
    CGFloat pop_5_Y;
    CGFloat pop_6_Y;
}

+ (SRWelcomePage1 *)instanceWelcomePage1
{
    NSArray *nibView = [[NSBundle mainBundle] loadNibNamed:@"SRWelcomePage1" owner:nil options:nil];
    return [nibView objectAtIndex:0];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.backgroundColor = [UIColor clearColor];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self reset];
    
    phoneY = self.phone.top;
    pop_0_Y = self.pop_0.top - deltaY;
    pop_1_Y = self.pop_1.top - deltaY;
    pop_2_Y = self.pop_2.top - deltaY;
    pop_3_Y = self.pop_3.top - deltaY;
    pop_4_Y = self.pop_4.top - deltaY;
    pop_5_Y = self.pop_5.top - deltaY;
    pop_6_Y = self.pop_6.top - deltaY;
}

#pragma mark - Public 

- (void)easeInAndOutIsIn:(BOOL)isIn {
    
    if (isIn) {
        [self reset];
    } else {
        [self clearAnimations];
    }
    
//    NSLog(@"%@", isIn?@"EaseIn":@"EaseOut");
    //手机
    POPBasicAnimation *phone_PositionAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerPositionY];
    phone_PositionAnimation.fromValue = isIn?@(phoneY+deltaY):@(phoneY);
    phone_PositionAnimation.toValue = isIn?@(phoneY):@(phoneY+deltaY);
    phone_PositionAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    phone_PositionAnimation.duration = phoneDuration;
    phone_PositionAnimation.beginTime = CACurrentMediaTime() + (isIn?phoneStartTime_S:phoneStartTime_D);
    [self.phone.layer pop_addAnimation:phone_PositionAnimation forKey:@"phone_PositionAnimation"];
    
    POPBasicAnimation *phone_AlphaAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerOpacity];
    phone_AlphaAnimation.fromValue = isIn?@(0.0):@(1.0);
    phone_AlphaAnimation.toValue = isIn?@(1.0):@(0.0);
    phone_AlphaAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    phone_AlphaAnimation.duration = phoneDuration;
    phone_AlphaAnimation.beginTime = CACurrentMediaTime() + (isIn?phoneStartTime_S:phoneStartTime_D);
    phone_AlphaAnimation.completionBlock = ^(POPAnimation *anim, BOOL finished){
        if (isIn) return ;
        [self reset];
    };
    [self.phone.layer pop_addAnimation:phone_AlphaAnimation forKey:@"phone_AlphaAnimation"];
    
    for (NSInteger index = 0; index <= 6; ++index) {
        [self popAnimationWithIndex:index andIsIn:isIn];
    }
}

- (void)reset {
//    NSLog(@"Reset");
    self.phone.alpha = 0.0f;
    self.pop_0.alpha = 0.0f;
    self.pop_1.alpha = 0.0f;
    self.pop_2.alpha = 0.0f;
    self.pop_3.alpha = 0.0f;
    self.pop_4.alpha = 0.0f;
    self.pop_5.alpha = 0.0f;
    self.pop_6.alpha = 0.0f;
    
    [self clearAnimations];
}

#pragma mark Private

- (void)clearAnimations {
    [self.phone.layer pop_removeAllAnimations];
    [self.pop_0.layer pop_removeAllAnimations];
    [self.pop_1.layer pop_removeAllAnimations];
    [self.pop_2.layer pop_removeAllAnimations];
    [self.pop_3.layer pop_removeAllAnimations];
    [self.pop_4.layer pop_removeAllAnimations];
    [self.pop_5.layer pop_removeAllAnimations];
    [self.pop_6.layer pop_removeAllAnimations];
}

- (void)popAnimationWithIndex:(NSInteger)index andIsIn:(BOOL)isIn
{
    NSArray *pop = @[self.pop_0, self.pop_1, self.pop_2, self.pop_3, self.pop_4, self.pop_5, self.pop_6];
    CGFloat showTime[] = {pop_0_start_S, pop_1_start_S, pop_2_start_S, pop_3_start_S, pop_4_start_S, pop_5_start_S, pop_6_start_S};
    CGFloat dismissTime[] = {pop_0_start_D, pop_1_start_D, pop_2_start_D, pop_3_start_D, pop_4_start_D, pop_5_start_D, pop_6_start_D};
    CGFloat position[] = {pop_0_Y, pop_1_Y, pop_2_Y, pop_3_Y, pop_4_Y, pop_5_Y, pop_6_Y};
    
    POPBasicAnimation *pop_PositionAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerPositionY];
    pop_PositionAnimation.fromValue = isIn?@(position[index] + deltaY):@(position[index]);
    pop_PositionAnimation.toValue = isIn?@(position[index]):@(position[index]+deltaY);
    pop_PositionAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    pop_PositionAnimation.duration = popDuration;
    pop_PositionAnimation.beginTime = CACurrentMediaTime() + (isIn?showTime[index]:dismissTime[index]);
    [[(UIImageView *)pop[index] layer] pop_addAnimation:pop_PositionAnimation forKey:@"pop_PositionAnimation"];
    
    POPBasicAnimation *pop_AlphaAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerOpacity];
    pop_AlphaAnimation.fromValue = isIn?@(0.0):@(1.0);
    pop_AlphaAnimation.toValue = isIn?@(1.0):@(0.0);
    pop_AlphaAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    pop_AlphaAnimation.duration = popDuration;
    pop_AlphaAnimation.beginTime = CACurrentMediaTime() + (isIn?showTime[index]:dismissTime[index]);
    [[(UIImageView *)pop[index] layer] pop_addAnimation:pop_AlphaAnimation forKey:@"pop_AlphaAnimation"];
    
    POPBasicAnimation *pop_ScaleAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerScaleXY];
    pop_ScaleAnimation.fromValue = [NSValue valueWithCGSize:isIn?smallScale:bigScale];
    pop_ScaleAnimation.toValue = [NSValue valueWithCGSize:isIn?bigScale:smallScale];
    pop_ScaleAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    pop_ScaleAnimation.duration = popDuration;
    pop_ScaleAnimation.beginTime = CACurrentMediaTime() + (isIn?showTime[index]:dismissTime[index]);
    [[(UIImageView *)pop[index] layer] pop_addAnimation:pop_ScaleAnimation forKey:@"pop_ScaleAnimation"];
}

@end

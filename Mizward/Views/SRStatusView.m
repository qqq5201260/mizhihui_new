//
//  SRStatusView.m
//  SiRuiV4.0
//
//  Created by zhangjunbo on 15/7/24.
//  Copyright (c) 2015年 SiRui. All rights reserved.
//

#import "SRStatusView.h"
#import "SRVehicleStatusInfo.h"
#import "SRAlertImageView.h"

const NSInteger kIconStatusStartTag = 100;
const CGFloat kBottomPadding = 17.0f;

@interface SRStatusView ()

@property (weak, nonatomic) IBOutlet UIButton *s_1;
@property (weak, nonatomic) IBOutlet UIButton *s_2;
@property (weak, nonatomic) IBOutlet UIButton *s_3;
@property (weak, nonatomic) IBOutlet UIButton *s_4;
@property (weak, nonatomic) IBOutlet UIButton *s_5;
@property (weak, nonatomic) IBOutlet UIButton *s_6;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *s_1_top;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bg_status_top;

@property (weak, nonatomic) IBOutlet SRAlertImageView *im_animation;

@end

@implementation SRStatusView
{
    NSInteger currentLines;
}

+ (SRStatusView *)instanceStatusView
{
    NSArray *nibView = [[NSBundle mainBundle] loadNibNamed:@"SRStatusView" owner:nil options:nil];
    return [nibView objectAtIndex:0];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.backgroundColor = [UIColor clearColor];

    self.s_1_top.constant *= iPhoneScale;
    
    currentLines = 3;
}

#pragma mark - Public

- (void)updateStatusInfo:(SRVehicleStatusInfo *)info
{
    if (info.isOnline == 1
        &&( info.doorRF == 1 || info.doorRB == 1
           || info.windowRF == 1 || info.windowRB == 1
           || info.trunkDoor == 1 || info.windowSky == 1)) {
        self.hidden = NO;
        [self updateViewWithStatusInfo:info];
        [self.im_animation startAnimations];
    } else {
        self.hidden = YES;
        [self.im_animation stopAnimations];
    }
}

- (void)stopAnimations
{
    if (!self.hidden) {
        [self.im_animation stopAnimations];
    }
}

- (void)startAnimations
{
    if (!self.hidden) {
        [self.im_animation startAnimations];
    }
}

#pragma mark - 私有方法

- (void)updateViewWithStatusInfo:(SRVehicleStatusInfo *)info
{
    NSMutableArray *array = [NSMutableArray array];
    if (info.doorRF == 1) {
        [array addObject:@{@"前门":[UIImage imageNamed:@"ic_right_front_door"]}];
    }
    
    if (info.doorRB == 1) {
        [array addObject:@{@"后门":[UIImage imageNamed:@"ic_right_back_door"]}];
    }
    
    if (info.windowRF == 1) {
        [array addObject:@{@"前窗":[UIImage imageNamed:@"ic_right_front_window"]}];
    }
    
    if (info.windowRB == 1) {
        [array addObject:@{@"后窗":[UIImage imageNamed:@"ic_right_back_window"]}];
    }
    
    if (info.windowSky == 1) {
        [array addObject:@{@"天窗":[UIImage imageNamed:@"ic_skylight"]}];
    }
    
    if (info.trunkDoor == 1) {
        [array addObject:@{@"尾箱":[UIImage imageNamed:@"ic_truck"]}];
    }
    
    NSInteger startTag = kIconStatusStartTag;
    if (array.count <= 2) {
        startTag = kIconStatusStartTag + 4;
    } else if (array.count <= 4) {
        startTag = kIconStatusStartTag + 2;
    } else {
        startTag = kIconStatusStartTag;
    }
    
    for (NSInteger index = kIconStatusStartTag; index <= kIconStatusStartTag + 6; ++index) {
        UIButton *button = (UIButton *)[self viewWithTag:index];
        button.hidden = YES;
    }
    
    [array enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL *stop) {
        UIButton *button = (UIButton *)[self viewWithTag:startTag + idx];
        button.hidden = NO;
        [button setImage:[obj.allValues firstObject] forState:UIControlStateNormal];
        [button setTitle:[obj.allKeys firstObject] forState:UIControlStateNormal];
    }];

    NSInteger lines = (array.count+1)/2;
    self.bg_status_top.constant = (3-lines)*self.s_1.height;
    [self.superview setNeedsUpdateConstraints];
    [self.superview  updateConstraintsIfNeeded];
}

@end

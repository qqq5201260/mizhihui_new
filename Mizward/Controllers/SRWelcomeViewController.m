//
//  SRWelcomeViewController.m
//  SiRuiV4.0
//
//  Created by zhangjunbo on 15/7/13.
//  Copyright (c) 2015年 SiRui. All rights reserved.
//

#import "SRWelcomeViewController.h"
#import "SRUIUtil.h"
#import "SRDivideLine.h"
#import <pop/POP.h>

#import "SRWelcomePage1.h"
#import "SRWelcomePage2.h"
#import "SRWelcomePage3.h"

@interface SRWelcomeViewController ()

@property (nonatomic, strong) UIView *ground;
@property (nonatomic, strong) SRDivideLine *groundLine;
@property (nonatomic, strong) UIImageView *building;

@property (nonatomic, strong) UIView *moon;

@property (nonatomic, strong) UIImageView *car;
@property (nonatomic, strong) UIImageView *frontTire;
@property (nonatomic, strong) UIImageView *backTire;

//第一页
@property (nonatomic, strong) UIImageView *imTitle0;

//第二页
@property (nonatomic, strong) SRWelcomePage1 *page1;
//第三页
@property (nonatomic, strong) SRWelcomePage2 *page2;

//第四页
@property (nonatomic, strong) SRWelcomePage3 *page3;

@property (nonatomic, copy) VoidBlock dismissBlock;

@end

@implementation SRWelcomeViewController

- (NSUInteger)numberOfPages {
    return 4;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.scrollView.bounces = NO;
    self.scrollView.pagingEnabled = YES;
    
    @weakify(self)
    self.dismissBlock = ^(){
        @strongify(self)
        if (self.delegate) {
            [self.delegate dismissViewController:self];
        } else {
            [UIView transitionWithView:self.navigationController.view duration:1.0 options:UIViewAnimationCurveEaseInOut|UIViewAnimationOptionTransitionCrossDissolve animations:^{
                [[SRUIUtil rootViewController] dismissViewControllerAnimated:NO completion:nil];
            } completion:NULL];
        }
    };
    
    [self configureViews];
    [self configureAnimations];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UIScrollViewDelegate

CGFloat startContentOffsetX;
CGFloat willEndContentOffsetX;

//开始拖动
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    NSInteger page = scrollView.contentOffsetX/scrollView.width;
//    NSLog(@"开始拖动 scrollViewWillBeginDragging %@", @(page));
    
    switch (page) {
        case 0:
            [self.page1 reset];
            break;
        case 1:
            [self.page1 easeInAndOutIsIn:NO];
            [self.page2 reset];
            break;
        case 2:
            [self.page2 easeInAndOutIsIn:NO];
            [self.page3 reset];
            break;
        case 3:
//            [self.page3 easeInAndOutIsIn:NO];
            break;
            
        default:
            break;
    }
    
    startContentOffsetX = scrollView.contentOffset.x;
}

//将要结束拖动
- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
{
//    NSInteger page = scrollView.contentOffsetX/scrollView.width;
//    NSLog(@"将要结束拖动 scrollViewWillEndDragging %@", @(page));
    
    willEndContentOffsetX = scrollView.contentOffset.x;
}

//停止拖动
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    NSInteger page = scrollView.contentOffsetX/scrollView.width;
//    NSLog(@"停止拖动 scrollViewDidEndDragging %@", @(page));
    
    CGFloat endContentOffsetX = scrollView.contentOffset.x;
    
    //最后一页，继续左滑
    if (endContentOffsetX >= willEndContentOffsetX
        && willEndContentOffsetX >= startContentOffsetX
        && page ==3) {
        self.dismissBlock();
    }
}

//开始减速
- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView
{
//    NSInteger page = scrollView.contentOffsetX/scrollView.width;
//    NSLog(@"开始减速 scrollViewWillBeginDecelerating %@", @(page));
}

//停止减速
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSInteger page = scrollView.contentOffsetX/scrollView.width;
//    NSLog(@"停止减速 scrollViewDidEndDecelerating %@", @(page));
    self.car.userInteractionEnabled = NO;
    
    switch (page) {
        case 0:
            break;
        case 1:
            [self.page1 easeInAndOutIsIn:YES];
            break;
        case 2:
            [self.page1 reset];
            [self.page2 easeInAndOutIsIn:YES];
            break;
        case 3:
            [self.page2 reset];
            [self.page3 easeInAndOutIsIn:YES];
            self.car.userInteractionEnabled = YES;
            break;
            
        default:
            break;
    }
}

#pragma mark - 交互事件

- (IBAction)buttonDonePressed:(id)sender
{
    [UIView transitionWithView:self.navigationController.view duration:1.0 options:UIViewAnimationCurveEaseInOut|UIViewAnimationOptionTransitionCrossDissolve animations:^{
        [self.navigationController popViewControllerAnimated:NO];
    } completion:NULL];
}

#pragma mark - Getter


#pragma mark - Configure Views and Animations

- (void)configureViews
{
    self.contentView.backgroundColor = [UIColor defaultColor];
    
    self.ground = [[UIView alloc] initWithFrame:CGRectZero];
    [self.contentView addSubview:self.ground];
    
    self.groundLine = [[SRDivideLine alloc] initWithFrame:CGRectZero];
    [self.ground addSubview:self.groundLine];
    
    self.building = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ic_welcome_build"]];
    [self.contentView insertSubview:self.building belowSubview:self.ground];
    
    self.car = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ic_welcome_car"]];
    [self.ground addSubview:self.car];
    self.car.userInteractionEnabled = NO;
    [self.car bk_whenTapped:^{
        self.dismissBlock();
    }];
    
    self.frontTire = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ic_welcome_tire"]];
    [self.ground addSubview:self.frontTire];
    
    self.backTire = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ic_welcome_tire"]];
    [self.ground addSubview:self.backTire];
    
    self.moon = [[UIView alloc] initWithFrame:CGRectZero];
    [self.contentView insertSubview:self.moon belowSubview:self.building];
    
    self.page1 = [SRWelcomePage1 instanceWelcomePage1];
    [self.contentView insertSubview:self.page1 belowSubview:self.ground];
    
    self.page2 = [SRWelcomePage2 instanceWelcomePage2];
    [self.contentView insertSubview:self.page2 belowSubview:self.ground];
    
    self.imTitle0 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"im_welcome_0"]];
    [self.contentView addSubview:self.imTitle0];
    
    self.page3 = [SRWelcomePage3 instanceWelcomePage3];
    [self.contentView insertSubview:self.page3 belowSubview:self.ground];
    @weakify(self)
    self.page3.buttonPressed = ^(){
        @strongify(self)
        self.dismissBlock();
    };
}

- (void)configureAnimations
{
    [self configureBackgroundAnimations];
    [self configureCarAnimations];
    [self configureTireAnimations];
    [self configurePage1Animations];
    [self configurePage2Animations];
    [self configurePage3Animations];
}

- (void)configureBackgroundAnimations
{
    self.ground.layer.masksToBounds = NO;
    self.ground.backgroundColor = [UIColor colorWithRed:244.0f/256.0f green:228.0f/256.0f blue:190.0f/256.0f alpha:244.0f/256.0f];
    [self.ground makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.contentView);
        make.height.equalTo(118.0f);
    }];
    
    self.groundLine.lineColor = [UIColor colorWithRed:130.0f/256.0f green:128.0f/256.0f blue:110.0f/256.0f alpha:244.0f/256.0f];
    self.groundLine.lineWidth = 7.0f;
    self.groundLine.space = 7.0f;
    self.groundLine.lineHeight = 3.0f;
    self.groundLine.isVertical = NO;
    [self.groundLine makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.ground);
        make.right.equalTo(self.ground).with.offset(20.0f);
        make.bottom.equalTo(self.ground).with.offset(-50.0f);
        make.height.equalTo(3.0f);
    }];
    
    [self.building makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.contentView);
        make.bottom.equalTo(self.ground.mas_top);
    }];
    
    self.moon.backgroundColor = [UIColor colorWithRed:255.0f/256.0f green:248.0f/256.0f blue:11.0f/256.0f alpha:244.0f/256.0f];
    self.moon.layer.cornerRadius = 24.0f;
    [self.moon makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.ground.mas_top).with.offset(-90.0f);
        make.size.equalTo(CGSizeMake(48.0f, 48.0f));
        make.centerX.equalTo(self.car).with.offset(-(self.view.width/2 - 24.0f - 30.0f));
    }];
    
    [self keepView:self.imTitle0 onPage:0];
    [self.imTitle0 makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).with.offset(60.0f);
    }];
}

- (void)configureCarAnimations
{
    [self keepView:self.car onPages:@[@(0), @(1), @(2), @(3)]];
    
    [self.car makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.frontTire.mas_centerY);
    }];
    
    __block NSInteger time = 0;
    CGFloat deltaY = 2.0f;
    POPBasicAnimation *positionAnimation = [POPBasicAnimation easeInEaseOutAnimation];
    positionAnimation.duration = 0.1f;
    POPAnimatableProperty *prop = [POPAnimatableProperty propertyWithName:@"CarAnimation" initializer:^(POPMutableAnimatableProperty *prop) {
        prop.writeBlock = ^(UIButton *obj, const CGFloat values[]) {
            
            CGFloat offset;
            if (time%2==0) {
                offset = - values[0];
            } else {
                offset = -(deltaY - values[0]);
            }
            
            [self.car updateConstraints:^(MASConstraintMaker *make) {
                make.bottom.equalTo(self.frontTire.mas_centerY).with.offset(offset);
            }];
        };
    }];
    positionAnimation.property = prop;
    positionAnimation.completionBlock = ^(POPAnimation *anim, BOOL finished){
        ++time;
    };
    positionAnimation.fromValue = @(0);
    positionAnimation.toValue = @(deltaY);
    positionAnimation.repeatForever = YES;
    
    [self.car pop_addAnimation:positionAnimation forKey:@"CarAnimation"];
}

- (void)configureTireAnimations
{
    /* 前轮 */
    [self.frontTire makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.groundLine.mas_top);
        make.centerX.equalTo(self.car.mas_centerX).with.offset(60.0f*iPhoneScale);
    }];
    
    IFTTTRotationAnimation *frontTireRotationAnimation = [IFTTTRotationAnimation animationWithView:self.frontTire];
    [frontTireRotationAnimation addKeyframeForTime:0 rotation:0];
    [frontTireRotationAnimation addKeyframeForTime:3 rotation:-3600];
    [self.animator addAnimation:frontTireRotationAnimation];
    
    /* 后轮 */
    [self.backTire makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.groundLine.mas_top);
        make.centerX.equalTo(self.car.mas_centerX).with.offset(-40.0f*iPhoneScale);
    }];
    
    IFTTTRotationAnimation *backTireRotationAnimation = [IFTTTRotationAnimation animationWithView:self.backTire];
    [backTireRotationAnimation addKeyframeForTime:0 rotation:0];
    [backTireRotationAnimation addKeyframeForTime:3 rotation:-3600];
    [self.animator addAnimation:backTireRotationAnimation];
}

- (void)configurePage1Animations {
    [self.page1 makeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(self.view);
        make.top.equalTo(self.contentView);
    }];
    [self keepView:self.page1 onPage:1];
}

- (void)configurePage2Animations {
    [self.page2 makeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(self.view);
        make.top.equalTo(self.contentView);
    }];
    [self keepView:self.page2 onPage:2];
}

- (void)configurePage3Animations {
    
    [self.page3 makeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(self.view);
        make.top.equalTo(self.contentView);
    }];
    [self keepView:self.page3 onPage:3];
}

@end

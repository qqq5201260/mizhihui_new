//
//  SRBaseViewController.m
//  SiRuiV4.0
//
//  Created by zhangjunbo on 15/6/15.
//  Copyright (c) 2015年 SiRui. All rights reserved.
//

#import "SRBaseViewController.h"
//#import "UINavigationController+FDFullscreenPopGesture.h"
#import "SRUserDefaults.h"
#import "SRUIUtil.h"

@interface SRBaseViewController ()

@end

@implementation SRBaseViewController

#pragma mark - 生命周期

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor defaultBackgroundColor];
    
//    self.navigationController.fd_fullscreenPopGestureRecognizer.enabled = NO;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [TalkingData trackPageBegin:NSStringFromClass(self.class)];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    [TalkingData trackPageEnd:NSStringFromClass(self.class)];
}

#pragma mark - Public

- (void)snapshortNavBar
{
    if (![self.view viewWithTag:1000]) {
        UINavigationBar *navBar = self.navigationController.navigationBar;
        UIEdgeInsets insets = UIEdgeInsetsMake(0, 0, navBar.height-1, 0);
        UIImage *image = [[self.navigationController.navigationBar sr_takeSnapshot] resizableImageWithCapInsets:insets];
        UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
        imageView.tag = 1000;
        imageView.frame = CGRectMake(0, 0, navBar.width, navBar.bottom);
        [self.view addSubview:imageView];
    }
}

- (BOOL)checkLoginStatus
{
    if ([SRUserDefaults loginStatus] != SRLoginStatus_NotLogin) {
        return YES;
    }
    
    [SRUIUtil ModalSRLoginViewController];
    return NO;
}

- (BOOL)checkExperienceUserStatus
{
    if ([SRUserDefaults isExperienceUser]) {
        [SRUIUtil showAutoDisappearHUDWithMessage:@"该功能需要绑定车辆后才能使用" isDetail:YES];
        return YES;
    }
    
    return NO;
}

#pragma mark - 私有方法

- (void)setNavBackButtonTitle:(NSString *)titile {

    CGRect backframe = CGRectMake(0,0,80, 40);
    UIButton *backButton= [[UIButton alloc] initWithFrame:backframe];
    backButton.adjustsImageWhenHighlighted = NO;
    [backButton setImageEdgeInsets:UIEdgeInsetsMake(0, -10,0, 0)];
    [backButton setImage:[UIImage imageNamed:@"bt_back"] forState:UIControlStateNormal];
    [backButton setTitle:titile forState:UIControlStateNormal];
//    backButton.titleLabel.font=[UIFont systemFontOfSize:13];
    [backButton bk_whenTapped:^{
        [self.navigationController popViewControllerAnimated:YES];
    }];
    
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItem = backItem;
}


@end

//
//  SRTabBarController.m
//  SiRuiV4.0
//
//  Created by zhangjunbo on 15/7/14.
//  Copyright (c) 2015年 SiRui. All rights reserved.
//

#import "SRTabBarController.h"
#import "SRUIUtil.h"
#import "SRPortal+Message.h"
#import "SREventCenter.h"
#import "SRCustomer.h"
#import "SRUserDefaults.h"
#import <KVOController/FBKVOController.h>

@interface SRTabBarController ()
{
    FBKVOController *kvoController;
}

@property (nonatomic, weak) UIView *maskView;

@end

@implementation SRTabBarController

#pragma mark - 生命周期

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    kvoController = [[FBKVOController alloc] initWithObserver:self];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[SREventCenter sharedInterface] addObserver:self observerQueue:dispatch_get_main_queue()];
    [self observeForUnreadMessages];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [[SREventCenter sharedInterface] removeObserver:self observerQueue:dispatch_get_main_queue()];
    [kvoController unobserveAll];
}

#pragma mark - SREventCenter

- (void)loginStatusChange:(SRLoginStatus)status
{
    [self observeForUnreadMessages];
}

#pragma mark - Private

- (void)observeForUnreadMessages {
    
    void (^imageRereshBlock)() = ^(){
        BOOL hasUnread = [SRPortal sharedInterface].customer.hasNewMessageInIm
                            || [[SRPortal sharedInterface].customer hasUnreadMessageInMessageCenter];
        UIImage *image = [[UIImage imageNamed:hasUnread?@"ic_tab_3_u":@"ic_tab_3"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        UIImage *selected = [[UIImage imageNamed:hasUnread?@"ic_tab_3_u_highlight":@"ic_tab_3_highlight"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        [self.tabBar.items.lastObject setImage:image];
        [self.tabBar.items.lastObject setSelectedImage:selected];
    };
    
    [kvoController unobserveAll];
    [kvoController observe:[SRPortal sharedInterface].customer keyPaths:@[@"hasNewMessageInIm", @"hasNewMessageInAlert", @"hasNewMessageInRemind", @"hasNewMessageInFunction"] options:NSKeyValueObservingOptionNew block:^(id observer, id object, NSDictionary *change) {
        [self executeOnMain:^{
            imageRereshBlock();
        } afterDelay:0];
    }];
    
    imageRereshBlock();
    
    if ([SRUserDefaults isLogin]) {
        [SRPortal queryMessageUnreadCountWithCompleteBlock:nil];
    }
}

@end

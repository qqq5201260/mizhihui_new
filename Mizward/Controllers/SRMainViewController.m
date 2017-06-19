//
//  SRMainViewController.m
//  SiRuiV4.0
//
//  Created by zhangjunbo on 15/7/3.
//  Copyright (c) 2015年 SiRui. All rights reserved.
//

#import "SRMainViewController.h"
#import "SRPortal.h"
#import "SRCustomer.h"
#import "SRCarStatusViewController.h"
#import "SRUIUtil.h"
#import "SREventCenter.h"
#import "SRVehicleBasicInfo.h"
#import "SRUserDefaults.h"
#import "SRWelcomeViewController.h"
#import "SRBLEManager.h"
#import "SRPeripheral.h"
#import <KVOController/FBKVOController.h>
#import <pop/POP.h>
#import <CoreBluetooth/CoreBluetooth.h>

#import "SRMaterialIndicator.h"

@interface SRMainViewController () <UIPageViewControllerDelegate, UIPageViewControllerDataSource, UIScrollViewDelegate>
{
    FBKVOController *kvoController;
}

@property (weak, nonatomic) IBOutlet UIView *containerView;

@property (weak, nonatomic) UIPageViewController *pageVC;

@property (weak, nonatomic) UIView *v_title;
@property (weak, nonatomic) UILabel *lb_title;
@property (weak, nonatomic) UIPageControl *pageControl;

@property (weak, nonatomic) SRMaterialIndicator *indicator;
@property (weak, nonatomic) UIBarButtonItem *bleItem;

@property (strong, nonatomic) NSMutableArray *statusVCs;

@property (strong, nonatomic) NSArray *vehicles;

@end

@implementation SRMainViewController
{
    BOOL hasVehicle;
}

#pragma mark - 生命周期

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    kvoController = [[FBKVOController alloc] initWithObserver:self];
    
    [[SREventCenter sharedInterface] addObserver:self observerQueue:dispatch_get_main_queue()];
    
//    [self updateStatusVCs];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [SRUIUtil rootViewController].navigationBarHidden = NO;
    
    [[SREventCenter sharedInterface] removeObserver:self observerQueue:dispatch_get_main_queue()];
    
    self.parentVC.navigationItem.titleView = self.v_title;
    
    [self updateStatusVCs];
    
    //防止第一页右滑和最后一页左滑
    for (UIView *sub in self.pageVC.view.subviews) {
        if ([sub isKindOfClass:[UIScrollView class]]) {
            ((UIScrollView *)sub).delegate = self;
        }
    }
    
    [[SREventCenter sharedInterface] addObserver:self observerQueue:dispatch_get_main_queue()];
    
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

- (void)vehicleListChange:(NSArray *)vehicles
{
    [self updateStatusVCs];
}

- (void)centralManagerStateChange:(CBCentralManager *)manager
{
    SRLogDebug(@"蓝牙连接状态 ： %@ %zd", manager, manager.state);
    
    if (manager.state != CBCentralManagerStatePoweredOn) {
        UIButton *bt = (UIButton *)self.bleItem.customView;
        [bt setImage:[UIImage imageNamed:@"ic_ble_unconnect"] forState:UIControlStateNormal];
        [self.indicator stopAnimating];
    }
}

- (void)peripheralStateChange:(CBPeripheral *)peripheral withVehicleID:(NSInteger)vehicleID
{
    if (vehicleID != [SRUserDefaults currentVehicleID]) {
        return;
    }
    
    UIButton *bt = (UIButton *)self.bleItem.customView;
    BOOL canSendData = [[[SRBLEManager sharedInterface] peripheralWithVehicleID:[SRUserDefaults currentVehicleID]] canSendDataToTerminal];
    
    if (peripheral.state == CBPeripheralStateConnected && canSendData) {
        SRLogDebug(@"外设已连接，%zd %@", vehicleID, [SRPortal sharedInterface].currentVehicleBasicInfo.plateNumber);
         if (![bt.currentImage isEqual:[UIImage imageNamed:@"ic_ble_connect"]]) {
        [SRUIUtil showAutoDisappearHUDWithMessage:@"蓝牙连接成功" isDetail:NO];
             [bt setImage:[UIImage imageNamed:@"ic_ble_connect"] forState:UIControlStateNormal];
         }
        [self.indicator stopAnimating];
    } else if (peripheral.state == CBPeripheralStateConnecting) {
        SRLogDebug(@"外设连接中，%zd %@", vehicleID, [SRPortal sharedInterface].currentVehicleBasicInfo.plateNumber);
        [self.indicator startAnimating];
        [bt setImage:[UIImage imageWithColor:[UIColor clearColor] size:bt.imageView.image.size] forState:UIControlStateNormal];
    } else {
        SRLogDebug(@"外设已断开，%zd %@", vehicleID, [SRPortal sharedInterface].currentVehicleBasicInfo.plateNumber);
        
        
        [self.indicator stopAnimating];
        if (![bt.currentImage isEqual:[UIImage imageNamed:@"ic_ble_unconnect"]]) {
            if([SRPortal sharedInterface].currentVehicleBasicInfo.bluetooth &&[[SRBLEManager sharedInterface] bleState])
            [SRUIUtil showAutoDisappearHUDWithMessage:@"连接失败" isDetail:NO];
            [bt setImage:[UIImage imageNamed:@"ic_ble_unconnect"] forState:UIControlStateNormal];
        }
    }
}

#pragma mark - UIPageViewControllerDelegate

- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray *)previousViewControllers transitionCompleted:(BOOL)completed
{
    NSInteger index = [self.statusVCs indexOfObject:self.pageVC.viewControllers.firstObject];
    self.pageControl.currentPage = index;
    
    SRVehicleBasicInfo *current = [SRPortal sharedInterface].currentVehicleBasicInfo;
    
    [UIView animateWithDuration:0.1 animations:^{
        self.lb_title.alpha = 0.0f;
//        self.bleItem.customView.alpha = 0.0f;
    } completion:^(BOOL finished) {
        if (!finished) return ;
        self.lb_title.text = current.plateNumber;
        [UIView animateWithDuration:0.1 animations:^{
            self.lb_title.alpha = 1.0f;
//            self.bleItem.customView.alpha = current.hasBluetooth?1.0f:0.0f;
            self.parentVC.navigationItem.leftBarButtonItem = current.hasBluetooth?self.bleItem:nil;
        }];
        
        [self peripheralStateChange:[[SRBLEManager sharedInterface] peripheralWithVehicleID:current.vehicleID].peripheral
                      withVehicleID:current.vehicleID];
    }];
}

#pragma mark - UIPageViewControllerDataSource

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    NSUInteger index = self.pageControl.currentPage;
    if (index == NSNotFound || index == 0 ) {
        return nil;
    }
    
    --index;
    
    return [self.statusVCs objectAtIndex:index];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    NSUInteger index = self.pageControl.currentPage;
    if (index == NSNotFound || ++index >= self.statusVCs.count) {
        return nil;
    }
    
    return [self.statusVCs objectAtIndex:index];
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (self.pageControl.currentPage == 0
        && scrollView.contentOffset.x < scrollView.bounds.size.width) {
        scrollView.contentOffset = CGPointMake(scrollView.bounds.size.width, 0);
    }
    if (self.pageControl.currentPage == self.statusVCs.count-1
        && scrollView.contentOffset.x > scrollView.bounds.size.width) {
        scrollView.contentOffset = CGPointMake(scrollView.bounds.size.width, 0);
    }
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
{
    if (self.pageControl.currentPage == 0
        && scrollView.contentOffset.x <= scrollView.bounds.size.width) {
        velocity = CGPointZero;
        *targetContentOffset = CGPointMake(scrollView.bounds.size.width, 0);
    }
    if (self.pageControl.currentPage == self.statusVCs.count-1
        && scrollView.contentOffset.x >= scrollView.bounds.size.width) {
        velocity = CGPointZero;
        *targetContentOffset = CGPointMake(scrollView.bounds.size.width, 0);
    }
}

#pragma mark - Getter

- (UIPageViewController *)pageVC
{
    if (_pageVC) {
        return _pageVC;
    }
    
    UIPageViewController *pageVC = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
    pageVC.view.frame = self.containerView.bounds;
    pageVC.delegate = self;
    pageVC.dataSource = self;
    
    [self addChildViewController:pageVC];
    [self.containerView addSubview:pageVC.view];
    
    _pageVC = pageVC;
    return _pageVC;
}

- (UIView *)v_title {
    if (_v_title) {
        return _v_title;
    }
    
    UIView *v_title = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH*2/3, NavigationBar_HEIGHT)];
    v_title.backgroundColor = [UIColor clearColor];
    [v_title bk_whenTapped:^{
        if ([SRPortal sharedInterface].vehicleDic.count>0) {
            [self.navigationController pushViewController:[SRUIUtil SRTerminalInfoViewController] animated:YES];
        }
    }];
    _v_title = v_title;
    
    UILabel *lb_title = [[UILabel alloc] init];
    lb_title.textColor = [UIColor whiteColor];
    lb_title.textAlignment = NSTextAlignmentCenter;
    [_v_title addSubview:lb_title];
    [lb_title makeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(v_title.bounds.size);
        make.centerY.equalTo(v_title).with.offset(-5.0f);
        make.centerX.equalTo(v_title);
    }];
    _lb_title = lb_title;
    
    UIPageControl *pageControl = [[UIPageControl alloc] initWithFrame:CGRectZero];
    pageControl.currentPage = 0;
    pageControl.hidesForSinglePage = YES;
    pageControl.userInteractionEnabled = NO;
    pageControl.pageIndicatorTintColor = [UIColor pageIndicatorTintColor];
    pageControl.currentPageIndicatorTintColor = [UIColor currentPageIndicatorTintColor];
    [_v_title addSubview:pageControl];
    [pageControl makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(v_title);
        make.bottom.equalTo(v_title);
        make.height.equalTo(20.0f);
    }];
    
    _pageControl = pageControl;
    
    return _v_title;
}

- (NSArray *)vehicles {
    
    //如果未登录或没有车辆，默认添加一辆
    if ([SRUserDefaults loginStatus]==SRLoginStatus_NotLogin
        || ![SRPortal sharedInterface].vehicleDic
        || [SRPortal sharedInterface].vehicleDic.count == 0) {
        hasVehicle = NO;
    } else {
        hasVehicle = YES;
        _vehicles = [SRPortal sharedInterface].allVehiclesWithTerminal;
        hasVehicle = _vehicles.count>0;
    }
    
    if (!hasVehicle) {
        SRVehicleBasicInfo *defaultBasic = [[SRVehicleBasicInfo alloc] init];
        _vehicles = @[defaultBasic];
    }
    
    return _vehicles;
}

- (UIBarButtonItem *)bleItem {
    if (_bleItem) {
        return _bleItem;
    }
    
    UIImage *image = [UIImage imageNamed:@"ic_ble_connect"];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.showsTouchWhenHighlighted = YES;
    button.frame = CGRectMake(0, 0, NavigationBar_HEIGHT, NavigationBar_HEIGHT);
    [button setImage:image forState:UIControlStateNormal];
    [button setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, NavigationBar_HEIGHT-image.size.width)];
    [button bk_whenTapped:^{
        [self.indicator startAnimating];
        [button setImage:[UIImage imageWithColor:[UIColor clearColor] size:image.size] forState:UIControlStateNormal];
        [[SRBLEManager sharedInterface] connectPeripheralForVehicle:[SRUserDefaults currentVehicleID] withCompleteBlock:^(NSError *error, id responseObject) {
            [self.indicator stopAnimating];
            if (error) {
                if (![button.currentImage isEqual:[UIImage imageNamed:@"ic_ble_unconnect"]]) {
                    [SRUIUtil showAutoDisappearHUDWithMessage:error.domain isDetail:NO];
                    [button setImage:[UIImage imageNamed:@"ic_ble_unconnect"] forState:UIControlStateNormal];
                }
               
            } else {
                if (![button.currentImage isEqual:[UIImage imageNamed:@"ic_ble_connect"]]) {
                [SRUIUtil showAutoDisappearHUDWithMessage:@"蓝牙连接成功" isDetail:NO];
                    [button setImage:[UIImage imageNamed:@"ic_ble_connect"] forState:UIControlStateNormal];
                }
            }
        }];
    }];
    
    SRMaterialIndicator *indicator = [[SRMaterialIndicator alloc] init];
    [button addSubview:indicator];
    [indicator makeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(CGSizeMake(button.width/2, button.width/2));
        make.left.equalTo(button);
        make.centerY.equalTo(button);
    }];
    [indicator stopAnimating];
    
    self.indicator = indicator;
    
    UIBarButtonItem *bleItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    
    _bleItem = bleItem;
    return _bleItem;
}

#pragma mark - 私有方法

- (void)updateStatusVCs
{
    self.statusVCs = [NSMutableArray array];
    [self.vehicles enumerateObjectsUsingBlock:^(SRVehicleBasicInfo *obj, NSUInteger idx, BOOL *stop) {
        SRCarStatusViewController *vc = (SRCarStatusViewController *)[SRUIUtil SRCarStatusViewController];
        vc.basicInfo = obj;
        [self->_statusVCs insertObject:vc atIndex:idx];
    }];
    
    SRVehicleBasicInfo *current = [[SRPortal sharedInterface].vehicleDic objectForKey:@([SRUserDefaults currentVehicleID])];
    NSUInteger index = 0;
    if (current && [self.vehicles containsObject:current]) {
        index = [self.vehicles indexOfObject:current];
    }
    
    NSInteger direction = index<self.vehicles.count-1?UIPageViewControllerNavigationDirectionForward:UIPageViewControllerNavigationDirectionReverse;
    
    @weakify(self)
    [self.pageVC setViewControllers:@[self.statusVCs[index]] direction:direction animated:NO completion:^(BOOL finished) {
        @strongify(self)
        
        if (finished) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.pageVC setViewControllers:@[self.statusVCs[index]]
                                      direction:direction
                                       animated:NO
                                     completion:nil];
            });
        }
    }];
    
    self.pageControl.numberOfPages = self.statusVCs.count;
    self.pageControl.currentPage = index;
    self.lb_title.text = current.plateNumber;
    
    self.parentVC.navigationItem.leftBarButtonItem = current.hasBluetooth?self.bleItem:nil;
//    self.bleItem.customView.alpha = current.hasBluetooth?1.0f:0.0f;
//    NSLog(@"%f", self.bleItem.customView.alpha);
    [self peripheralStateChange:[[SRBLEManager sharedInterface] peripheralWithVehicleID:current.vehicleID].peripheral
                  withVehicleID:current.vehicleID];
    
    for (UIView *sub in self.pageVC.view.subviews) {
        if ([sub isKindOfClass:[UIScrollView class]]) {
            ((UIScrollView *)sub).scrollEnabled = self.vehicles.count>1;
        }
    }
}

@end

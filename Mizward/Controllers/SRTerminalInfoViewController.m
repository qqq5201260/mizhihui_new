//
//  SRTerminalInfoViewController.m
//  SiRuiV4.0
//
//  Created by zhangjunbo on 15/6/15.
//  Copyright (c) 2015年 SiRui. All rights reserved.
//

#import "SRTerminalInfoViewController.h"
#import "SRSegmentedControl.h"
#import "SRTerminalInfoDetailViewController.h"
#import "SRPortal.h"
#import "SRVehicleBasicInfo.h"
#import "UIView+FDCollapsibleConstraints.h"

@interface SRTerminalInfoViewController () <UIPageViewControllerDelegate, UIPageViewControllerDataSource, UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet SRSegmentedControl *segmentedControl;
@property (weak, nonatomic) IBOutlet UIView *containerView;

@property (weak, nonatomic) UIPageViewController *pageVC;
@property (strong, nonatomic) NSMutableArray *detailVCs;

@property (strong, nonatomic) NSArray *vehicles;

@end

@implementation SRTerminalInfoViewController

#pragma mark - 生命周期

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = SRLocal(@"title_terminal_info");
    
    self.segmentedControl.fd_collapsed = self.vehicles.count<=1;
    
    self.segmentedControl.sectionTitles = self.titles;
    self.segmentedControl.font = [UIFont boldSystemFontOfSize:15.0f];
    self.segmentedControl.selectionIndicatorMode = SRSelectionIndicatorFillsSegment;
    self.segmentedControl.segmentEdgeInset = UIEdgeInsetsMake(0, 15.0, 0, 15.0);
    self.segmentedControl.selectionIndicatorHeight = 2.0f;
    self.segmentedControl.selectedTextColor = [UIColor defaultColor];
    self.segmentedControl.selectionIndicatorColor = [UIColor defaultColor];
    [self.segmentedControl setIndexChangeBlock:^(NSUInteger index) {
        NSInteger preIndex = [self.detailVCs indexOfObject:[self.pageVC.viewControllers firstObject]];
        [self.pageVC setViewControllers:@[self.detailVCs[index]]
                              direction:index>preIndex?UIPageViewControllerNavigationDirectionForward:UIPageViewControllerNavigationDirectionReverse
                               animated:NO completion:NULL];
    }];
    
    @weakify(self)
    [self.pageVC setViewControllers:@[self.detailVCs.firstObject] direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:^(BOOL finished) {
        @strongify(self)
        
        if (finished) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.pageVC setViewControllers:@[self.detailVCs.firstObject]
                                      direction:UIPageViewControllerNavigationDirectionForward
                                       animated:NO
                                     completion:nil];
            });
        }
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    //防止第一页右滑和最后一页左滑
    for (UIView *sub in self.pageVC.view.subviews) {
        if ([sub isKindOfClass:[UIScrollView class]]) {
            ((UIScrollView *)sub).delegate = self;
        }
    }
    
}

#pragma mark - UIPageViewControllerDelegate

- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray *)previousViewControllers transitionCompleted:(BOOL)completed
{
    [self.segmentedControl setSelectedIndex:[self.detailVCs indexOfObject:self.pageVC.viewControllers.firstObject] animated:YES callBack:NO];
}

#pragma mark - UIPageViewControllerDataSource

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    NSUInteger index = [self.detailVCs indexOfObject:viewController];
    if (index == NSNotFound || index == 0 ) {
        return nil;
    }
    
    --index;
    
    return [self.detailVCs objectAtIndex:index];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    NSUInteger index = [self.detailVCs indexOfObject:viewController];
    if (index == NSNotFound || ++index >= self.detailVCs.count) {
        return nil;
    }
    
    return [self.detailVCs objectAtIndex:index];
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (self.segmentedControl.selectedIndex == 0
        && scrollView.contentOffset.x < scrollView.bounds.size.width) {
        scrollView.contentOffset = CGPointMake(scrollView.bounds.size.width, 0);
    }
    if (self.segmentedControl.selectedIndex == self.detailVCs.count-1
        && scrollView.contentOffset.x > scrollView.bounds.size.width) {
        scrollView.contentOffset = CGPointMake(scrollView.bounds.size.width, 0);
    }
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
{
    if (self.segmentedControl.selectedIndex == 0
        && scrollView.contentOffset.x <= scrollView.bounds.size.width) {
        velocity = CGPointZero;
        *targetContentOffset = CGPointMake(scrollView.bounds.size.width, 0);
    }
    if (self.segmentedControl.selectedIndex == self.detailVCs.count-1
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

- (NSMutableArray *)detailVCs
{
    if (_detailVCs) {
        return _detailVCs;
    }
    
    _detailVCs = [NSMutableArray array];
    [self.vehicles enumerateObjectsUsingBlock:^(SRVehicleBasicInfo *obj, NSUInteger idx, BOOL *stop) {
        SRTerminalInfoDetailViewController *vc = [[SRTerminalInfoDetailViewController alloc] initWithVehicleBasicInfo:obj];
        vc.view.frame = self.containerView.bounds;
        [self->_detailVCs insertObject:vc atIndex:idx];
    }];
    
    return _detailVCs;
}

- (NSArray *)vehicles
{
    if (!_vehicles) {
        _vehicles = [SRPortal sharedInterface].allVehicles;
    }
    
    return _vehicles;
}

- (NSArray *)titles
{
    NSArray *temp = @[@"一", @"二", @"三", @"四", @"五", @"六", @"七", @"八", @"九", @"十"];
    NSMutableArray *titles = [NSMutableArray arrayWithCapacity:self.vehicles.count];
    [self.vehicles enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [titles insertObject:[NSString stringWithFormat:@"爱车%@", temp[idx]] atIndex:idx];
    }];
    
    return titles;
}

#pragma mark - 私有方法



@end

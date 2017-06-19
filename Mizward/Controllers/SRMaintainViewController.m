//
//  SRMaintainViewController.m
//  SiRuiV4.0
//
//  Created by zhangjunbo on 15/7/14.
//  Copyright (c) 2015年 SiRui. All rights reserved.
//

#import "SRMaintainViewController.h"
#import "SRUIUtil.h"

@interface SRMaintainViewController () <UIPageViewControllerDataSource>

@property (weak, nonatomic) IBOutlet UIView *containerView;

@property (weak, nonatomic) UIPageViewController *pageVC;
@property (weak, nonatomic) UISegmentedControl *segmentedControl;

@property (strong, nonatomic) NSArray *maintainVCs;

@end

@implementation SRMaintainViewController
{
    NSInteger currentPageIndex;
}

#pragma mark - 生命周期

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    currentPageIndex = 0;

    [self pageViewControllerChangeToIndex:currentPageIndex];
    
    //禁止滑动
    for (UIView *sub in self.pageVC.view.subviews) {
        if ([sub isKindOfClass:[UIScrollView class]]) {
            ((UIScrollView *)sub).scrollEnabled = NO;
        }
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.parentVC.navigationItem.rightBarButtonItem = nil;
    self.parentVC.navigationItem.titleView = self.segmentedControl;
    self.parentVC.navigationItem.leftBarButtonItem = nil;
    
//    [self pageViewControllerChangeToIndex:currentPageIndex];
    self.segmentedControl.selectedSegmentIndex = currentPageIndex;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - UIPageViewControllerDataSource

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    NSUInteger index = [self.maintainVCs indexOfObject:viewController];
    if (index == NSNotFound || index == 0 ) {
        return nil;
    }
    
    --index;
    
    return [self.maintainVCs objectAtIndex:index];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    NSUInteger index = [self.maintainVCs indexOfObject:viewController];
    if (index == NSNotFound || ++index >= self.maintainVCs.count) {
        return nil;
    }
    
    return [self.maintainVCs objectAtIndex:index];
}

#pragma mark - Getter

- (UIPageViewController *)pageVC
{
    if (_pageVC) {
        return _pageVC;
    }
    
    UIPageViewController *pageVC = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
    pageVC.view.frame = self.containerView.bounds;
    pageVC.dataSource = self;
    
    [self addChildViewController:pageVC];
    [self.containerView addSubview:pageVC.view];
    
    _pageVC = pageVC;
    return _pageVC;
}

#pragma mark - 私有方法


#pragma mark - Getter

- (UISegmentedControl *)segmentedControl
{
    if (_segmentedControl) {
        return _segmentedControl;
    }
    
    NSArray *segmentedItems = @[@"预约", @"历史", @"检测"];
    UISegmentedControl *segmentedControl = [[UISegmentedControl alloc] initWithItems:segmentedItems];
    segmentedControl.frame = CGRectMake(0, 0, 288, 28);
    segmentedControl.selectedSegmentIndex = 0;
    segmentedControl.tintColor = [UIColor whiteColor];
    
    [segmentedControl bk_addEventHandler:^(UISegmentedControl *seg) {
        [self pageViewControllerChangeToIndex:seg.selectedSegmentIndex];
    } forControlEvents:UIControlEventValueChanged];

    _segmentedControl = segmentedControl;
    
    return _segmentedControl;
}

- (void)pageViewControllerChangeToIndex:(NSInteger)pageIndex
{
    UIViewController *vc = self.maintainVCs[pageIndex];
    
    currentPageIndex = pageIndex;
    
    @weakify(self)
    [self.pageVC setViewControllers:@[vc] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:^(BOOL finished) {
        @strongify(self)
        
        if (!finished) {
            return ;
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.pageVC setViewControllers:@[vc]
                                  direction:UIPageViewControllerNavigationDirectionForward
                                   animated:NO
                                 completion:nil];
        });
    }];

}

- (NSArray *)maintainVCs
{
    if (_maintainVCs) {
        return _maintainVCs;
    }
    
    UIViewController *orderVC = [[SRUIUtil MaintainStoryBoard] instantiateViewControllerWithIdentifier:@"SRMaintainOrderViewController"];
    UIViewController *historyVC = [[SRUIUtil MaintainStoryBoard] instantiateViewControllerWithIdentifier:@"SRMaintainHistoryViewController"];
    UIViewController *checkVC = [[SRUIUtil MaintainStoryBoard] instantiateViewControllerWithIdentifier:@"SRMaintainCheckViewController"];
    
    NSArray *maintainVCs = @[orderVC, historyVC, checkVC];
    
    _maintainVCs = maintainVCs;
    return _maintainVCs;
}

@end

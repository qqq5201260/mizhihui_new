//
//  SRMessageCenterViewController.m
//  SiRuiV4.0
//
//  Created by zhangjunbo on 15/6/15.
//  Copyright (c) 2015年 SiRui. All rights reserved.
//

#import "SRMessageCenterViewController.h"
#import "SRSegmentedControl.h"
#import "SRMessageViewController.h"

@interface SRMessageCenterViewController () <UIPageViewControllerDelegate, UIPageViewControllerDataSource, UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet SRSegmentedControl *segmentedControl;
@property (weak, nonatomic) IBOutlet UIView *containerView;

@property (weak, nonatomic) UIPageViewController *pageVC;
@property (strong, nonatomic) NSMutableArray *messageVCs;

@end

@implementation SRMessageCenterViewController

#pragma mark - 生命周期

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = SRLocal(@"title_message_center");
    
    self.segmentedControl.sectionTitles = @[@"告警类", @"提醒类", @"推送类"];
    self.segmentedControl.font = [UIFont boldSystemFontOfSize:15.0f];
    self.segmentedControl.selectionIndicatorMode = SRSelectionIndicatorFillsSegment;
    self.segmentedControl.segmentEdgeInset = UIEdgeInsetsMake(0, 15.0, 0, 15.0);
    self.segmentedControl.selectionIndicatorHeight = 2.0f;
    self.segmentedControl.selectedTextColor = [UIColor defaultColor];
    self.segmentedControl.selectionIndicatorColor = [UIColor defaultColor];
    [self.segmentedControl setIndexChangeBlock:^(NSUInteger index) {
        NSInteger preIndex = [self.messageVCs indexOfObject:[self.pageVC.viewControllers firstObject]];
        [self.pageVC setViewControllers:@[self.messageVCs[index]]
                              direction:index>preIndex?UIPageViewControllerNavigationDirectionForward:UIPageViewControllerNavigationDirectionReverse
                               animated:NO completion:NULL];
    }];
    
    @weakify(self)
    [self.pageVC setViewControllers:@[self.messageVCs.firstObject] direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:^(BOOL finished) {
        @strongify(self)
        
        if (finished) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.pageVC setViewControllers:@[self.messageVCs.firstObject]
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
    [self.segmentedControl setSelectedIndex:[self.messageVCs indexOfObject:self.pageVC.viewControllers.firstObject] animated:YES callBack:NO];
}

#pragma mark - UIPageViewControllerDataSource

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    NSUInteger index = [self.messageVCs indexOfObject:viewController];
    if (index == NSNotFound || index == 0 ) {
        return nil;
    }
    
    --index;
    
    return [self.messageVCs objectAtIndex:index];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    NSUInteger index = [self.messageVCs indexOfObject:viewController];
    if (index == NSNotFound || ++index >= self.messageVCs.count) {
        return nil;
    }
    
    return [self.messageVCs objectAtIndex:index];
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (self.segmentedControl.selectedIndex == 0
        && scrollView.contentOffset.x < scrollView.bounds.size.width) {
        scrollView.contentOffset = CGPointMake(scrollView.bounds.size.width, 0);
    }
    if (self.segmentedControl.selectedIndex == self.messageVCs.count-1
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
    if (self.segmentedControl.selectedIndex == self.messageVCs.count-1
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

- (NSMutableArray *)messageVCs
{
    if (_messageVCs) {
        return _messageVCs;
    }
    
    _messageVCs = [NSMutableArray array];
    for (NSInteger index = 0; index < 3; index++) {
        SRMessageViewController *msgVC = [[SRMessageViewController alloc] initWithType:index+1];
        msgVC.view.frame = self.containerView.bounds;
        [_messageVCs addObject:msgVC];
    }
    
    return _messageVCs;
}

#pragma mark - 私有方法



@end

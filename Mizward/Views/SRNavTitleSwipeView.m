//
//  SRNavTitleSwipeView.m
//  SiRuiV4.0
//
//  Created by zhangjunbo on 15/7/3.
//  Copyright (c) 2015年 SiRui. All rights reserved.
//

#import "SRNavTitleSwipeView.h"

@interface SRNavTitleSwipeView () <UIScrollViewDelegate>

@property (weak, nonatomic) UIScrollView *scrollView;
@property (weak, nonatomic) UIPageControl *pageControl;

@end

@implementation SRNavTitleSwipeView

- (instancetype)initWithFrame:(CGRect)frame titles:(NSArray *)titles
{
    if (self = [super initWithFrame:frame]) {
        [self setOpaque:NO];
        
        _currentPage = 0;
        
        UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        scrollView.backgroundColor = [UIColor clearColor];
        scrollView.pagingEnabled = YES;
        scrollView.showsHorizontalScrollIndicator = NO;
        scrollView.bounces = NO;
        scrollView.scrollEnabled = NO;
        [self addSubview:scrollView];
        
        _scrollView = scrollView;
        
        UIPageControl *pageControl = [[UIPageControl alloc] initWithFrame:CGRectZero];
        pageControl.currentPage = 0;
        pageControl.hidesForSinglePage = YES;
        pageControl.userInteractionEnabled = NO;
        pageControl.pageIndicatorTintColor = [UIColor pageIndicatorTintColor];
        pageControl.currentPageIndicatorTintColor = [UIColor currentPageIndicatorTintColor];
        [self addSubview:pageControl];
        [pageControl makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self);
            make.bottom.equalTo(self);
            make.height.equalTo(20.0f);
        }];
        
        _pageControl = pageControl;
        
        self.titles = titles;
    
    }
    
    return self;
}

#pragma mark - Public Method

- (void)updateContentOffset:(CGFloat)offsetX;
{
    static CGFloat lastXOffset = 0;
    CGFloat delta = fabs(lastXOffset - offsetX);
    lastXOffset = offsetX;
    if (delta > 100) {
        return;
    }

    self.scrollView.contentOffsetX = self.currentPage*self.scrollView.width + offsetX;
}

#pragma mark - Setter

- (void)setCurrentPage:(NSInteger)currentPage
{
    _currentPage = currentPage;
    self.scrollView.contentOffset = CGPointMake(self.width*currentPage, 0);
    self.pageControl.currentPage = currentPage;
}

- (void)setTitles:(NSArray *)titles {
    _titles = titles;
    
    self.scrollView.contentSize = CGSizeMake(titles.count*self.width, self.height);
    
    for (UIView *sub in self.scrollView.subviews) {
        [sub removeFromSuperview];
    }
    
    [titles enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL *stop) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
        label.text = obj;
        label.backgroundColor = [UIColor clearColor];
        label.textColor = [UIColor whiteColor];
        label.textAlignment = NSTextAlignmentCenter;
        
        [self.scrollView addSubview:label];
        [label makeConstraints:^(MASConstraintMaker *make) {
            make.size.equalTo(self.scrollView.bounds.size);
            make.centerY.equalTo(self.scrollView).with.offset(-5.0f);
            make.centerX.equalTo(self.scrollView).with.offset(idx*self.scrollView.width);
        }];
        
        UIImageView *test = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ic_ble"]];
        [self.scrollView addSubview:test];
        [test makeConstraints:^(MASConstraintMaker *make) {
            make.size.equalTo(CGSizeMake(self.scrollView.height, self.scrollView.height));
            make.centerY.equalTo(label);
            make.left.equalTo(self.scrollView).with.offset(idx*self.scrollView.width);
        }];
    }];
    
    self.pageControl.numberOfPages = titles.count;
}


@end

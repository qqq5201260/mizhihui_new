//
//  SRNavTitleSwipeView.h
//  SiRuiV4.0
//
//  Created by zhangjunbo on 15/7/3.
//  Copyright (c) 2015年 SiRui. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SRNavTitleSwipeView : UIView

@property (nonatomic, assign) NSInteger currentPage;
@property (nonatomic, strong) NSArray *titles;

- (instancetype)initWithFrame:(CGRect)frame titles:(NSArray *)titles;

- (void)updateContentOffset:(CGFloat)offsetX;

@end

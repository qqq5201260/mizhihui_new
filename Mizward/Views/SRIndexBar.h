//
//  SRIndexBar.h
//  SiRuiV4.0
//
//  Created by zhangjunbo on 15/6/15.
//  Copyright (c) 2015年 SiRui. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SRIndexBarDelegate;

@interface SRIndexBar : UIView

- (id)init;
- (id)initWithFrame:(CGRect)frame;
- (void)reloadTitles;

@property (nonatomic, weak) id<SRIndexBarDelegate> delegate;
@property (nonatomic, strong) UIColor *highlightedBackgroundColor;
@property (nonatomic, strong) UIColor *textColor;
@property (nonatomic, strong) UIFont *textFont;

@end

@protocol SRIndexBarDelegate<NSObject>

- (NSArray *)indexBarTitles:(SRIndexBar *)indexBar;

@optional
- (void)indexSelectionDidChange:(SRIndexBar *)indexBar index:(NSInteger)index title:(NSString*)title;
- (void)indexBarTouchesBegan:(SRIndexBar *)indexBar;
- (void)indexBarTouchesEnd:(SRIndexBar *)indexBar;
@end

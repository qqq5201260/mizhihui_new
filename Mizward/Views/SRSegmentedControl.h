//
//  SRSegmentedControl.h
//  SiRuiV4.0
//
//  Created by zhangjunbo on 15/6/29.
//  Copyright (c) 2015年 SiRui. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, SRSelectionIndicatorMode) {
    SRSelectionIndicatorResizesToStringWidth = 0, // 指示器和字体宽度一致
    SRSelectionIndicatorFillsSegment = 1 // 指示器和segment宽度一致
};

@interface SRSegmentedControl : UIControl

@property (nonatomic, strong) NSArray *sectionTitles;
@property (nonatomic, copy) void (^indexChangeBlock)(NSUInteger index);
@property (nonatomic, strong) UIFont *font; // 默认 [UIFont fontWithName:@"Avenir-Light" size:19.0f]
@property (nonatomic, strong) UIColor *textColor; // 默认 [UIColor blackColor]
@property (nonatomic, strong) UIColor *selectedTextColor; // 默认 52, 181, 229
@property (nonatomic, strong) UIColor *backgroundColor; // 默认 [UIColor whiteColor]
@property (nonatomic, strong) UIColor *selectionIndicatorColor; // 默认 52, 181, 229

@property (nonatomic, assign) SRSelectionIndicatorMode selectionIndicatorMode; //默认 HMSelectionIndicatorResizesToStringWidth

@property (nonatomic, assign) NSInteger selectedIndex;
@property (nonatomic, readwrite) CGFloat height; // 默认 32.0
@property (nonatomic, readwrite) CGFloat selectionIndicatorHeight; // 默认 5.0
@property (nonatomic, readwrite) UIEdgeInsets segmentEdgeInset; // 默认 UIEdgeInsetsMake(0, 5, 0, 5)

- (id)initWithSectionTitles:(NSArray *)sectiontitles;
- (void)setSelectedIndex:(NSUInteger)index animated:(BOOL)animated callBack:(BOOL)callBack;

@end

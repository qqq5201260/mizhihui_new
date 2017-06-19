//
//  SRCalendarPickerView.m
//  SiRuiV4.0
//
//  Created by zhangjunbo on 15/7/10.
//  Copyright (c) 2015年 SiRui. All rights reserved.
//

#import "SRCalendarPickerView.h"
#import "SRUIUtil.h"
#import <DateTools/DateTools.h>
#import <JTCalendar/JTCalendar.h>

const CGFloat   h_titleView = 40.0f;

@interface SRCalendarPickerView () <JTCalendarDataSource>

@property (nonatomic, weak) UIView  *titleView;
@property (nonatomic, weak) UILabel *titleLabel;
@property (nonatomic, weak) JTCalendarContentView *calendarContentView;
@property (nonatomic, weak) JTCalendarMenuView *calendarMenuView;

@property (nonatomic, strong) JTCalendar *calendar;

@property (nonatomic, strong) UIView *maskView;

@property (nonatomic, strong) NSDateFormatter *formatter;

@end

@implementation SRCalendarPickerView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        [self addSubview:self.calendarMenuView];
        [self.calendarMenuView makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.equalTo(self);
            make.height.equalTo(h_titleView);
        }];
        
        [self addSubview:self.titleView];
        [self.titleView makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.equalTo(self);
            make.height.equalTo(h_titleView);
        }];
        
        [self addSubview:self.calendarContentView];
        [self.calendarContentView makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.titleView.mas_bottom);
            make.left.equalTo(self).with.offset(10.0f);
            make.right.bottom.equalTo(self).with.offset(-10.0f);
        }];
        
//        self.maskView.hidden = YES;
        
        self.calendar.dataSource = self;
    }
    
    return self;
}

//- (void)didMoveToSuperview
//{
//    [self.superview insertSubview:self.maskView belowSubview:self];
//    [self.maskView makeConstraints:^(MASConstraintMaker *make) {
//        make.right.bottom.equalTo(self.superview).with.offset(10.0f);
//        make.left.top.equalTo(self.superview).with.offset(-10.0f);
//    }];
//}

- (void)removeFromSuperview
{
    [super removeFromSuperview];
    
    [self.calendarMenuView removeFromSuperview];
    self.calendarMenuView = nil;
    [self.calendarContentView removeFromSuperview];
    self.calendarContentView = nil;
    [self.titleView removeFromSuperview];
    self.titleView = nil;
    [self.titleLabel removeFromSuperview];
    self.titleLabel = nil;
    
    [self.maskView removeFromSuperview];
    self.maskView = nil;
    
    self.calendar = nil;
    self.formatter = nil;
}

#pragma mark - JTCalendarDataSource

- (void)calendarDidDateSelected:(JTCalendar *)calendar date:(NSDate *)date
{
    if ([date isLaterThan:[NSDate date]]) {
        [SRUIUtil showAlertMessage:@"请选择有效时间"];
        return;
    }

    [self dissmissCalendarPickerView];
    
    if (self.delegate) {
        [self.delegate calendarPickerViewDidSelectedDate:date];
    }
    
    self.selectedDate = date;
}

- (BOOL)calendar:(JTCalendar *)calendar canSelectDate:(NSDate *)date
{
    return [date isEarlierThanOrEqualTo:[NSDate date]];
}

- (BOOL)calendarHaveEvent:(JTCalendar *)calendar date:(NSDate *)date
{
    return NO;
}

- (void)calendarDidLoadPreviousPage
{
    NSDate *date = [self.formatter dateFromString:self.titleLabel.text];
    self.titleLabel.text = [self.formatter stringFromDate:[date dateByAddingMonths:-1]];
}

- (void)calendarDidLoadNextPage
{
    NSDate *date = [self.formatter dateFromString:self.titleLabel.text];
    self.titleLabel.text = [self.formatter stringFromDate:[date dateByAddingMonths:1]];
}

#pragma mark - Public

- (void)setSelectedDate:(NSDate *)date
{
    self.calendar.currentDateSelected = date;
    self.calendar.currentDate = date;
}

- (void)showCalendarPickerView
{
    self.isShowing = YES;
//    self.maskView.hidden = NO;
    
    [self.superview insertSubview:self.maskView belowSubview:self];
//    [self.maskView makeConstraints:^(MASConstraintMaker *make) {
//        make.right.bottom.equalTo(self.superview).with.offset(10.0f);
//        make.left.top.equalTo(self.superview).with.offset(-10.0f);
//    }];
    
    self.titleLabel.text = [self.formatter stringFromDate:self.calendarContentView.currentDate];
    
    [self updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.superview.mas_top).with.offset(NavigationBar_HEIGHT + StatusBar_HEIGHT + self.height);
    }];
    
    [self.superview setNeedsUpdateConstraints];
    [self.superview  updateConstraintsIfNeeded];
    [UIView  animateWithDuration:0.35 animations:^{
        [self.superview layoutIfNeeded];
        self.maskView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4f];
    } completion:^(BOOL finished) {
        
    }];
}

- (void)dissmissCalendarPickerView
{
    [self updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.superview.mas_top).with.offset(NavigationBar_HEIGHT + StatusBar_HEIGHT);
    }];
    
    [self.superview setNeedsUpdateConstraints];
    [self.superview  updateConstraintsIfNeeded];
    [UIView  animateWithDuration:0.35 animations:^{
        [self.superview layoutIfNeeded];
        self.maskView.backgroundColor = [UIColor clearColor];
    } completion:^(BOOL finished) {
        self.isShowing = NO;
//        self.maskView.hidden = YES;
        [self.maskView removeFromSuperview];
    }];
}

#pragma mark - 私有方法

#pragma mark - Getter

- (NSDateFormatter *)formatter
{
    if (_formatter) {
        return _formatter;
    }
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy年MM月";
    _formatter = formatter;
    
    return _formatter;
}

- (UIView *)titleView {
    if (_titleView) {
        return _titleView;
    }
    
    UIView *titleView = [[UIView alloc] initWithFrame:CGRectZero];
    titleView.backgroundColor = [UIColor whiteColor];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor defaultColor];
    [titleView addSubview:label];
    [label makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.left.bottom.equalTo(titleView);
    }];
    self.titleLabel = label;
    
    UIButton *bt_pre = [[UIButton alloc] initWithFrame:CGRectZero];
    [bt_pre setImage:[UIImage imageNamed:@"ic_pre"] forState:UIControlStateNormal];
    [titleView addSubview:bt_pre];
    [bt_pre makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.equalTo(titleView);
        make.width.equalTo(h_titleView);
    }];
    [bt_pre bk_whenTapped:^{
        [self.calendar loadPreviousPage];
    }];
    
    UIButton *bt_next = [[UIButton alloc] initWithFrame:CGRectZero];
    [bt_next setImage:[UIImage imageNamed:@"ic_next"] forState:UIControlStateNormal];
    [titleView addSubview:bt_next];
    [bt_next makeConstraints:^(MASConstraintMaker *make) {
        make.right.top.bottom.equalTo(titleView);
        make.width.equalTo(h_titleView);
    }];
    [bt_next bk_whenTapped:^{
        [self.calendar loadNextPage];
    }];
    
    _titleView = titleView;
    
    return _titleView;
}

- (JTCalendarMenuView *)calendarMenuView
{
    if (_calendarMenuView) {
        return _calendarMenuView;
    }

    JTCalendarMenuView *calendarMenuView = [[JTCalendarMenuView alloc] initWithFrame:CGRectZero];
    calendarMenuView.backgroundColor = [UIColor whiteColor];
    _calendarMenuView = calendarMenuView;

    return _calendarMenuView;
}

- (JTCalendarContentView *)calendarContentView
{
    if (_calendarContentView) {
        return _calendarContentView;
    }

    JTCalendarContentView *calendarContentView = [[JTCalendarContentView alloc] initWithFrame:CGRectZero];
    calendarContentView.backgroundColor = [UIColor whiteColor];
    _calendarContentView = calendarContentView;

    return _calendarContentView;
}

- (JTCalendar *)calendar
{
    if (_calendar) {
        return _calendar;
    }
    
    JTCalendar *calendar = [[JTCalendar alloc] init];
    calendar.calendarAppearance.calendar.firstWeekday = 1;
    calendar.calendarAppearance.dayCircleRatio = 9. / 10.;
    calendar.calendarAppearance.ratioContentMenu = 2.;
    calendar.calendarAppearance.focusSelectedDayChangeMode = YES;
    calendar.calendarAppearance.weekDayFormat = JTCalendarWeekDayFormatSingle;
    calendar.currentDate = [NSDate date];
    calendar.currentDateSelected = [NSDate date];
    
    [calendar setMenuMonthsView:self.calendarMenuView];
    [calendar setContentView:self.calendarContentView];
    
    _calendar = calendar;
    
    return _calendar;
}

- (UIView *)maskView
{
    if (_maskView) {
        return _maskView;
    }
    
//    UIView *maskView = [[UIView alloc] initWithFrame:CGRectZero];
    UIView *maskView = [[UIView alloc] initWithFrame:self.superview.bounds];
    maskView.backgroundColor = [UIColor clearColor];
    maskView.layer.shouldRasterize = YES;
    maskView.layer.rasterizationScale = [[UIScreen mainScreen] scale];
    
    [maskView bk_whenTapped:^{
        [self dissmissCalendarPickerView];
    }];
    
    UIInterpolatingMotionEffect *horizontalEffect = [[UIInterpolatingMotionEffect alloc] initWithKeyPath:@"center.x"
                                                                                                    type:UIInterpolatingMotionEffectTypeTiltAlongHorizontalAxis];
    horizontalEffect.minimumRelativeValue = @(-10.0);
    horizontalEffect.maximumRelativeValue = @( 10.0);
    
    UIInterpolatingMotionEffect *verticalEffect = [[UIInterpolatingMotionEffect alloc] initWithKeyPath:@"center.y"
                                                                                                  type:UIInterpolatingMotionEffectTypeTiltAlongVerticalAxis];
    verticalEffect.minimumRelativeValue = @(-10.0);
    verticalEffect.maximumRelativeValue = @( 10.0);
    
    UIMotionEffectGroup *motionEffectGroup = [[UIMotionEffectGroup alloc] init];
    motionEffectGroup.motionEffects = @[horizontalEffect, verticalEffect];
    
    [maskView addMotionEffect:motionEffectGroup];
    
    _maskView = maskView;
    
    return _maskView;
}



@end

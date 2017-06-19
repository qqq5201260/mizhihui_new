//
//  SRCalendarSwipeView.h
//  SiRuiV4.0
//
//  Created by zhangjunbo on 15/7/9.
//  Copyright (c) 2015年 SiRui. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SRCalendarSwipeViewDelegate <NSObject>

@optional
- (void)calendarSwipeViewDidSelectedDate:(NSDate *)date;

@end


@interface SRCalendarSwipeView : UIView

@property (nonatomic, assign) id<SRCalendarSwipeViewDelegate> delegate;

- (void)setDate:(NSDate *)date;

@end



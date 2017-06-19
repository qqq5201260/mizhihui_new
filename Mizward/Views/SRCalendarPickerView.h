//
//  SRCalendarPickerView.h
//  SiRuiV4.0
//
//  Created by zhangjunbo on 15/7/10.
//  Copyright (c) 2015年 SiRui. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SRCalendarPickerViewDelegate <NSObject>

@optional
- (void)calendarPickerViewDidSelectedDate:(NSDate *)date;

@end

@interface SRCalendarPickerView : UIView

@property (nonatomic, assign) id<SRCalendarPickerViewDelegate> delegate;

@property (nonatomic, assign) BOOL isShowing;

- (void)setSelectedDate:(NSDate *)date;

- (void)showCalendarPickerView;
- (void)dissmissCalendarPickerView;

@end

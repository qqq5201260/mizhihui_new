//
//  SRCalendarLabel.m
//  SiRuiV4.0
//
//  Created by zhangjunbo on 15/7/10.
//  Copyright (c) 2015年 SiRui. All rights reserved.
//

#import "SRCalendarLabel.h"
#import <DateTools/DateTools.h>

@implementation SRCalendarLabel

- (void)setDate:(NSDate *)date
{
    if ([date isLaterThan:[NSDate date]]) {
        _date = nil;
    } else {
        _date = date;
        if ([_date isSameDay:[NSDate date]]) {
            self.text = @"今天";
        } else {
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            formatter.dateFormat = @"MM-dd";
            self.text = [formatter stringFromDate:date];
        }
    }
}

@end

//
//  SRRepeatTimePicker.h
//  SiRui
//
//  Created by zhangjunbo on 15/5/18.
//  Copyright (c) 2015年 ChinaPKE. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^SRRepeatTimePickerDoneBlock)(NSArray *obj, NSString *string);
typedef void (^SRRepeatTimePickerCancelBlock)();

@interface SRRepeatTimePicker : UIView

@property (nonatomic, copy) NSString *repeatString;

+ (SRRepeatTimePicker *)instanceRepeatTimePicker;

- (void)setDoneBlock:(SRRepeatTimePickerDoneBlock)doneBlock;
- (void)setCancelBlock:(SRRepeatTimePickerCancelBlock)cancelBlock;

@end

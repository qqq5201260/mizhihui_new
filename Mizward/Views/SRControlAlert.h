//
//  SRControlAlert.h
//  SiRuiV4.0
//
//  Created by zhangjunbo on 15/7/22.
//  Copyright (c) 2015年 SiRui. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SRControlAlert : UIView

@property (nonatomic, assign) BOOL isShowing;

@property (nonatomic, copy) void (^cancelBlock) ();
@property (nonatomic, copy) void (^doneBlock) ();

+ (SRControlAlert *)instanceControlAlert;

- (void)showWithMessage:(NSString *)message andDoneBlock:(void (^)())doneBlock;
- (void)dissmiss;

@end

//
//  SROrderStartView.h
//  SiRuiV4.0
//
//  Created by zhangjunbo on 15/6/24.
//  Copyright (c) 2015年 SiRui. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SRAPNsOrderStartInfo;

@interface SROrderStartView : UIView

@property (nonatomic, assign) BOOL isShowing;

@property (nonatomic, strong) SRAPNsOrderStartInfo *info;

@property (nonatomic, copy) void (^dismissBlock) ();

+ (SROrderStartView *)instanceCustomView;

- (void)show;
- (void)dissmiss;

@end

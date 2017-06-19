//
//  SRControlView.h
//  SiRuiV4.0
//
//  Created by zhangjunbo on 15/7/24.
//  Copyright (c) 2015年 SiRui. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SRVehicleBasicInfo;

@interface SRControlView : UIView

+ (SRControlView *)instanceControlView;

- (void)showOrDismissControlView:(BOOL)isShow animation:(BOOL)animation;

- (void)updateAbilities:(NSArray *)abilities;

- (void)SendCmd:(SRTLVTag_Instruction)cmd withSuccessBlock:(VoidBlock)successBlock;

- (CGFloat)showCenterY;
- (CGFloat)dismissCenterY;

@end

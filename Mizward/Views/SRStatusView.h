//
//  SRStatusView.h
//  SiRuiV4.0
//
//  Created by zhangjunbo on 15/7/24.
//  Copyright (c) 2015年 SiRui. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SRVehicleStatusInfo;

@interface SRStatusView : UIView

+ (SRStatusView *)instanceStatusView;

- (void)updateStatusInfo:(SRVehicleStatusInfo *)info;

- (void)stopAnimations;
- (void)startAnimations;

@end

//
//  SRBluetoothSearchView.h
//  Mizward
//
//  Created by zhangjunbo on 15/9/14.
//  Copyright (c) 2015年 Mizward. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SRVehicleBasicInfo;

@interface SRBluetoothSearchView : UIView

@property (nonatomic, strong) SRVehicleBasicInfo *basicInfo;

+ (SRBluetoothSearchView *)instanceCustomView;

- (void)show;

- (void)dissmiss;

@end

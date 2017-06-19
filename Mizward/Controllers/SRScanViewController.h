//
//  SRScanViewController.h
//  SiRuiV4.0
//
//  Created by zhangjunbo on 15/7/9.
//  Copyright (c) 2015年 SiRui. All rights reserved.
//

#import "SRBaseViewController.h"

typedef NS_ENUM(NSInteger, SRScanViewControllerType) {
    SRScanViewControllerType_Terminal = 0,
    SRScanViewControllerType_Visitor
};

@class SRVehicleInfo;

@protocol SRScanViewControllerDelegate <NSObject>

@optional
- (void)scanResult:(NSString *)result withVehicleInfo:(SRVehicleInfo *)vehicleInfo;

@end

@interface SRScanViewController : SRBaseViewController

@property (nonatomic, assign) id<SRScanViewControllerDelegate> delegate;

@property (nonatomic, assign) NSNumber *type;

@end

//
//  SRBaseViewController.h
//  SiRuiV4.0
//
//  Created by zhangjunbo on 15/6/15.
//  Copyright (c) 2015年 SiRui. All rights reserved.
//

#import "SRBaseViewController.h"

typedef NS_ENUM(NSUInteger, BrandVehicleType) {
    BrandVehicleType_Brand,
    BrandVehicleType_Vehicle,
    BrandVehicleType_Both,
};

@class SRBrandInfo, SRSeriesInfo, SRVehicleInfo;


@protocol SRBrandVehicleViewControllerDelegate <NSObject>

@optional
- (void)selectedBrandInfo:(SRBrandInfo *)brandInfo
               seriesInfo:(SRSeriesInfo *)seriesInfo
           andVehicleInfo:(SRVehicleInfo *)vehicleInfo;

@end

@interface SRBrandVehicleViewController : SRBaseViewController

@property (nonatomic, assign) id<SRBrandVehicleViewControllerDelegate> delegate;

@property (nonatomic, assign) BrandVehicleType tableType;
@property (nonatomic, strong) SRBrandInfo *brandInfo;

@end

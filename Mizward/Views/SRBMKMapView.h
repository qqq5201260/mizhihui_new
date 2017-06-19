//
//  SRBMKMapView.h
//  SiRuiV4.0
//
//  Created by zhangjunbo on 15/7/4.
//  Copyright (c) 2015年 SiRui. All rights reserved.
//

#import <BaiduMapAPI/BMapKit.h>

@class SMCalloutView;

@interface SRBMKMapView : BMKMapView

@property (nonatomic, strong) SMCalloutView *calloutView;

@end

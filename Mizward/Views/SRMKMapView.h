//
//  SRMKMapView.h
//  SiRuiV4.0
//
//  Created by zhangjunbo on 15/7/4.
//  Copyright (c) 2015年 SiRui. All rights reserved.
//

#import <MapKit/MapKit.h>

@class SMCalloutView;

@interface SRMKMapView : MKMapView

@property (nonatomic, strong) SMCalloutView *calloutView;

@end

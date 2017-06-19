//
//  SRMAMapView.h
//  Mizward
//
//  Created by zhangjunbo on 15/10/19.
//  Copyright © 2015年 Mizward. All rights reserved.
//

#import <MAMapKit/MAMapKit.h>

@class SMCalloutView;

@interface SRMAMapView : MAMapView

@property (nonatomic, strong) SMCalloutView *calloutView;

@end

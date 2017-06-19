//
//  BMKMapView+BlocksKit.h
//  SiRuiV4.0
//
//  Created by zhangjunbo on 15/7/4.
//  Copyright (c) 2015年 SiRui. All rights reserved.
//

#import <BaiduMapAPI/BMapKit.h>

@interface BMKMapView (BlocksKit)

@property (nonatomic, copy, setter = bk_viewForAnnotation:) BMKAnnotationView * (^bk_viewForAnnotation)(BMKMapView *mapView , id <BMKAnnotation> annotation);

@property (nonatomic, copy, setter = bk_viewForOverlay:) BMKOverlayView * (^bk_viewForOverlay)(BMKMapView *mapView , id <BMKOverlay> overlay);

@property (nonatomic, copy, setter = bk_didSelectAnnotationView:) void (^bk_didSelectAnnotationView)(BMKMapView *mapView , BMKAnnotationView *view);

@property (nonatomic, copy, setter = bk_didDeselectAnnotationView:) void (^bk_didDeselectAnnotationView)(BMKMapView *mapView , BMKAnnotationView *view);

@property (nonatomic, copy, setter = bk_mapViewDidFinishLoading:) void (^bk_mapViewDidFinishLoading)(BMKMapView *mapView);

@end

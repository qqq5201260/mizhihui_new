//
//  BMKMapView+BlocksKit.m
//  SiRuiV4.0
//
//  Created by zhangjunbo on 15/7/4.
//  Copyright (c) 2015年 SiRui. All rights reserved.
//

#import "BMKMapView+BlocksKit.h"
#import <BlocksKit/A2DynamicDelegate.h>
#import <BlocksKit/NSObject+A2BlockDelegate.h>
#import <BlocksKit/NSObject+A2DynamicDelegate.h>

#pragma mark Delegate

@interface A2DynamicBMKMapViewDelegate : A2DynamicDelegate <BMKMapViewDelegate>

@end

@implementation A2DynamicBMKMapViewDelegate

- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id <BMKAnnotation>)annotation
{
    BMKAnnotationView *view ;
    
    id realDelegate = self.realDelegate;
    if (realDelegate && [realDelegate respondsToSelector:@selector(mapView:viewForAnnotation:)])
        view = [realDelegate mapView:mapView viewForAnnotation:annotation];
    
    BMKAnnotationView* (^block)(BMKMapView *mapView, id <BMKAnnotation> annotation) = [self blockImplementationForMethod:_cmd];
    if (block)
        view = block(mapView, annotation);
    
    return view;
}

- (BMKOverlayView *)mapView:(BMKMapView *)mapView viewForOverlay:(id <BMKOverlay>)overlay
{
    BMKOverlayView *view ;
    
    id realDelegate = self.realDelegate;
    if (realDelegate && [realDelegate respondsToSelector:@selector(mapView:viewForOverlay:)])
        view = [realDelegate mapView:mapView viewForOverlay:overlay];
    
    BMKOverlayView* (^block)(BMKMapView *mapView, id <BMKOverlay> overlay) = [self blockImplementationForMethod:_cmd];
    if (block)
        view = block(mapView, overlay);
    
    return view;
}

-(void)mapView:(BMKMapView *)mapView didSelectAnnotationView:(BMKAnnotationView *)view {
    id realDelegate = self.realDelegate;
    if (realDelegate && [realDelegate respondsToSelector:@selector(mapView:didSelectAnnotationView:)])
        [realDelegate mapView:mapView didSelectAnnotationView:view];
    
    void (^block)(BMKMapView *mapView, BMKAnnotationView *view) = [self blockImplementationForMethod:_cmd];
    if (block)
        block(mapView, view);
    
}

-(void)mapView:(BMKMapView *)mapView didDeselectAnnotationView:(BMKAnnotationView *)view {
    id realDelegate = self.realDelegate;
    if (realDelegate && [realDelegate respondsToSelector:@selector(mapView:didDeselectAnnotationView:)])
        [realDelegate mapView:mapView didDeselectAnnotationView:view];
    
    void (^block)(BMKMapView *mapView, BMKAnnotationView *view) = [self blockImplementationForMethod:_cmd];
    if (block)
        block(mapView, view);
    
}

- (void)mapViewDidFinishLoading:(BMKMapView *)mapView {
    id realDelegate = self.realDelegate;
    if (realDelegate && [realDelegate respondsToSelector:@selector(mapViewDidFinishLoading:)])
        [realDelegate mapViewDidFinishLoading:mapView];
    
    void (^block)(BMKMapView *mapView) = [self blockImplementationForMethod:_cmd];
    if (block)
        block(mapView);
}

@end


@implementation BMKMapView (BlocksKit)

@dynamic bk_viewForAnnotation, bk_viewForOverlay, bk_didSelectAnnotationView, bk_didDeselectAnnotationView, bk_mapViewDidFinishLoading;

+ (void)load
{
    @autoreleasepool {
        [self bk_registerDynamicDelegate];
        [self bk_linkDelegateMethods:@{
                                       @"bk_viewForAnnotation": @"mapView:viewForAnnotation:",
                                       @"bk_viewForOverlay": @"mapView:viewForOverlay:",
                                       @"bk_didSelectAnnotationView": @"mapView:didSelectAnnotationView:",
                                       @"bk_didDeselectAnnotationView": @"mapView:didDeselectAnnotationView:",
                                       @"bk_mapViewDidFinishLoading": @"mapViewDidFinishLoading:"
                                       }];
    }
}

@end

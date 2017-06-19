//
//  BMKMapView+Additions.m
//  SiRuiV4.0
//
//  Created by zhangjunbo on 15/7/4.
//  Copyright (c) 2015年 SiRui. All rights reserved.
//

#import "BMKMapView+Additions.h"

#define MINIMUM_ZOOM_ARC 0.014 //approximately 1 miles (1 degree of arc ~= 69 miles)
#define ANNOTATION_REGION_PAD_FACTOR 1.0
#define MAX_DEGREES_ARC 360

@implementation BMKMapView (Additions)

- (void)zoomMapViewToFitAllAnnotationsWithAnimated:(BOOL)animated
{
    NSArray *annotations = self.annotations;
    NSUInteger count = [self.annotations count];
    if ( count == 0) { return; } //bail if no annotations
    
    BMKMapPoint points[count]; //C array of MKMapPoint struct
    for( NSUInteger i=0; i<annotations.count; i++ ) //load points C array by converting coordinates to points
    {
        CLLocationCoordinate2D coordinate = [(id <BMKAnnotation>)[annotations objectAtIndex:i] coordinate];
        points[i] = BMKMapPointForCoordinate(coordinate);
    }

    //create MKMapRect from array of MKMapPoint
    BMKMapRect mapRect = [[BMKPolygon polygonWithPoints:points count:count] boundingMapRect];
    //convert MKCoordinateRegion from MKMapRect
    BMKCoordinateRegion region = BMKCoordinateRegionForMapRect(mapRect);
    
    //add padding so pins aren't scrunched on the edges
    region.span.latitudeDelta  *= ANNOTATION_REGION_PAD_FACTOR;
    region.span.longitudeDelta *= ANNOTATION_REGION_PAD_FACTOR;
    //but padding can't be bigger than the world
    if( region.span.latitudeDelta > MAX_DEGREES_ARC ) { region.span.latitudeDelta  = MAX_DEGREES_ARC; }
    if( region.span.longitudeDelta > MAX_DEGREES_ARC ){ region.span.longitudeDelta = MAX_DEGREES_ARC; }
    
    //and don't zoom in stupid-close on small samples
    if( region.span.latitudeDelta  < MINIMUM_ZOOM_ARC ) { region.span.latitudeDelta  = MINIMUM_ZOOM_ARC; }
    if( region.span.longitudeDelta < MINIMUM_ZOOM_ARC ) { region.span.longitudeDelta = MINIMUM_ZOOM_ARC; }
    //and if there is a sample of 1 we want the max zoom-in instead of max zoom-out
    if( count == 1 )
    {
        region.span.latitudeDelta = MINIMUM_ZOOM_ARC;
        region.span.longitudeDelta = MINIMUM_ZOOM_ARC;
    }
    [self setRegion:region animated:animated];
}

@end

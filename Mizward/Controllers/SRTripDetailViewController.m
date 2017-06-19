//
//  SRTripDetailViewController.m
//  SiRuiV4.0
//
//  Created by zhangjunbo on 15/6/24.
//  Copyright (c) 2015年 SiRui. All rights reserved.
//

#import "SRTripDetailViewController.h"
#import "SRUserDefaults.h"
#import "BMKMapView+BlocksKit.h"
#import "SRTripPoint.h"
#import "SRUIUtil.h"
#import "CoordinateTransform.h"
#import "SRTripInfo.h"
#import <DateTools/DateTools.h>
#import <MapKit/MapKit.h>
#import <BaiduMapAPI/BMapKit.h>
#import "BMKMapView+Additions.h"
#import <BlocksKit/NSObject+A2DynamicDelegate.h>

@interface SRTripDetailViewController () <MKMapViewDelegate>

@property (weak, nonatomic) IBOutlet UIView *detaiView;
@property (weak, nonatomic) IBOutlet UILabel *lb_time;
@property (weak, nonatomic) IBOutlet UILabel *lb_mileage;

@property (weak, nonatomic) IBOutlet UIView *mapContainerView;

@property (weak, nonatomic) MKMapView *mkMapView;
@property (weak, nonatomic) BMKMapView *bmkMapView;

@end

@implementation SRTripDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = SRLocal(@"title_trip_detail");
    
    [self.detaiView bottomLine];
    
    [self initTimeLabel];
    [self initMileageLabel];
    
    if ([SRUserDefaults isBaiduMap]) {
        [self.mapContainerView addSubview:self.bmkMapView];
        [self.bmkMapView makeConstraints:^(MASConstraintMaker *make) {
            make.top.right.left.bottom.equalTo(self.mapContainerView);
        }];
    } else {
        [self.mapContainerView addSubview:self.mkMapView];
        [self.mkMapView makeConstraints:^(MASConstraintMaker *make) {
            make.top.right.left.bottom.equalTo(self.mapContainerView);
        }];
    }
    
    [self addPathToMap];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    if ([SRUserDefaults isBaiduMap]) {
        [self.bmkMapView viewWillAppear];
        [self.bmkMapView bk_ensuredDynamicDelegate];
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if ([SRUserDefaults isBaiduMap]) {
        NSArray *overlays = self.bmkMapView.overlays;
        [self.bmkMapView setVisibleMapRect:[(id <BMKOverlay>)[overlays firstObject] boundingMapRect] edgePadding:UIEdgeInsetsMake(5, 5, 5, 5) animated:YES];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    if ([SRUserDefaults isBaiduMap]) {
        [self.bmkMapView viewWillDisappear];
        self.bmkMapView.delegate = nil;
        
        NSArray *overlays = [NSArray arrayWithArray:self.bmkMapView.overlays];
        [self.bmkMapView removeOverlays:overlays];
        NSArray *annotations = [NSArray arrayWithArray:self.bmkMapView.annotations];
        [self.bmkMapView removeAnnotations:annotations];
        
        [self.bmkMapView removeFromSuperview];
        self.bmkMapView = nil;
    } else {
        self.mkMapView.delegate = nil;
        
        NSArray *annotations = self.mkMapView.annotations;
        [self.mkMapView removeAnnotations:annotations];
        NSArray *overlays = self.mkMapView.overlays;
        [self.mkMapView removeOverlays:overlays];
        
        [self.mkMapView removeFromSuperview];
        self.mkMapView = nil;
    }
    
    self.tripInfo = nil;
    self.tripPoints = nil;
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - MKMapViewDelegate

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id)annotation{
    if ([annotation isKindOfClass:[MKPointAnnotation class]]) {
        static NSString *identifier = @"Annotation";
        MKAnnotationView *annotationView = (MKAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:identifier];
        if (!annotationView) {
            annotationView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier];
        }
        
        MKPointAnnotation *point = (MKPointAnnotation *)annotation;
        if ([point.title isEqualToString:@"Start"]) {
            annotationView.image = [UIImage imageNamed:@"ic_trip_start"];
        } else {
            annotationView.image = [UIImage imageNamed:@"ic_trip_end"];
        }
        annotationView.centerOffset = CGPointMake(0, -annotationView.image.size.height/2);
        annotationView.canShowCallout = NO;
        
        return annotationView;
    }
    
    return nil;
}

- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id <MKOverlay>)overlay
{
    MKPolylineRenderer *routeLineView = [[MKPolylineRenderer alloc] initWithPolyline:overlay];
    routeLineView.fillColor = [UIColor defaultColor];
    routeLineView.strokeColor = [UIColor defaultColor];
    routeLineView.lineWidth = 5.0f;
    return routeLineView;
}

#pragma mark - 私有方法

- (void)initTimeLabel {
    NSDate *startTime = [NSDate convertDateFromStringWithFormatYYYYMMddHHmmss:self.tripInfo.startTime];
    NSDate *endTime = [NSDate convertDateFromStringWithFormatYYYYMMddHHmmss:self.tripInfo.endTime];
    NSInteger seconds = [endTime secondsLaterThan:startTime];
    NSInteger iHour = seconds/3600;
    NSInteger iMin = (seconds-iHour*3600)/60;
    NSString *firstRow = [NSString stringWithFormat:@"%@小时%@分钟", @(iHour), @(iMin)];
    NSString *secondRow = [NSString stringWithFormat:@"%02zd:%02zd-%02zd:%02zd", startTime.hour, startTime.minute, endTime.hour, endTime.minute];
    NSString *string = [NSString stringWithFormat:@"%@\n%@", firstRow, secondRow];
    NSRange rowFirst = [string rangeOfString:firstRow];
    NSRange rowSecond = [string rangeOfString:secondRow];
    NSMutableAttributedString *attributedstr = [[NSMutableAttributedString alloc] initWithString:string];
    [attributedstr addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:rowFirst];
    [attributedstr addAttribute:NSForegroundColorAttributeName value:[UIColor lightGrayColor] range:rowSecond];
    self.lb_time.attributedText = attributedstr;
}

- (void)initMileageLabel {
    NSString *firstRow = @"行驶距离";
    NSString *secondRow = [NSString stringWithFormat:@"%.1fkm", self.tripInfo.mileage];
    NSString *string = [NSString stringWithFormat:@"%@\n%@", firstRow, secondRow];
    NSRange rowFirst = [string rangeOfString:firstRow];
    NSRange rowSecond = [string rangeOfString:secondRow];
    NSMutableAttributedString *attributedstr = [[NSMutableAttributedString alloc] initWithString:string];
    [attributedstr addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:rowFirst];
    [attributedstr addAttribute:NSForegroundColorAttributeName value:[UIColor lightGrayColor] range:rowSecond];
    self.lb_mileage.attributedText = attributedstr;
}

- (void)addPathToMap
{
    if ([SRUserDefaults isBaiduMap]) {
        NSArray *overlays = [NSArray arrayWithArray:self.bmkMapView.overlays];
        [self.bmkMapView removeOverlays:overlays];
        NSArray *annotations = [NSArray arrayWithArray:self.bmkMapView.annotations];
        [self.bmkMapView removeAnnotations:annotations];
        
        BMKMapPoint *points = malloc(sizeof(BMKMapPoint) * self.tripPoints.count);
        for (int index = 0; index < self.tripPoints.count; index++) {
            SRTripPoint *point = [self.tripPoints objectAtIndex:index];
            points[index] = BMKMapPointForCoordinate(bd_encrypt(point.location));
        }
        
        BMKPolyline *pathLine = [BMKPolyline polylineWithPoints:points count:self.tripPoints.count];
        [self.bmkMapView addOverlay:pathLine];
        free(points);
        
        SRTripPoint *startPoint = [self.tripPoints firstObject];
        BMKPointAnnotation *startAnnotation = [[BMKPointAnnotation alloc] init];
        startAnnotation.coordinate = bd_encrypt(startPoint.location);
        startAnnotation.title = @"Start";
        [self.bmkMapView addAnnotation:startAnnotation];
        
        
        SRTripPoint *lastPoint = [self.tripPoints lastObject];
        BMKPointAnnotation *endAnnotation = [[BMKPointAnnotation alloc] init];
        endAnnotation.coordinate = bd_encrypt(lastPoint.location);
        endAnnotation.title = @"End";
        [self.bmkMapView addAnnotation:endAnnotation];
        
        if (self.tripPoints.count == 1) {
            CLLocationCoordinate2D coords = bd_encrypt(startAnnotation.coordinate);
            BMKCoordinateRegion region = BMKCoordinateRegionMakeWithDistance(coords, 1000, 1000);
            [self.bmkMapView setRegion:[self.bmkMapView regionThatFits:region] animated:YES];
        } else {
            [self.bmkMapView setVisibleMapRect:pathLine.boundingMapRect edgePadding:UIEdgeInsetsMake(5, 5, 5, 5) animated:YES];
        }
    } else {
        [self.mkMapView removeAnnotations:self.mkMapView.annotations];
        [self.mkMapView removeOverlays:self.mkMapView.overlays];
        
        MKMapPoint *points = malloc(sizeof(MKMapPoint) * self.tripPoints.count);
        for (int index = 0; index < self.tripPoints.count; index++) {
            SRTripPoint *point = [self.tripPoints objectAtIndex:index];
            points[index] = MKMapPointForCoordinate(point.location);
        }
        
        MKPolyline *pathLine = [MKPolyline polylineWithPoints:points count:self.tripPoints.count];
        [self.mkMapView addOverlay:pathLine];
        free(points);
        
        SRTripPoint *startPoint = [self.tripPoints firstObject];
        MKPointAnnotation *startAnnotation = [[MKPointAnnotation alloc] init];
        startAnnotation.coordinate = startPoint.location;
        startAnnotation.title = @"Start";
        [self.mkMapView addAnnotation:startAnnotation];
        
        
        SRTripPoint *lastPoint = [self.tripPoints lastObject];
        MKPointAnnotation *endAnnotation = [[MKPointAnnotation alloc] init];
        endAnnotation.coordinate = lastPoint.location;
        endAnnotation.title = @"End";
        [self.mkMapView addAnnotation:endAnnotation];
        
        if (self.tripPoints.count == 1) {
            CLLocationCoordinate2D coords = startAnnotation.coordinate;
            MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(coords, 1000, 1000);
            [self.mkMapView setRegion:[self.mkMapView regionThatFits:region] animated:YES];
        } else {
            [self.mkMapView setVisibleMapRect:pathLine.boundingMapRect edgePadding:UIEdgeInsetsMake(20, 20, 20, 20) animated:YES];
        }
    }

}

#pragma mark - Getter

- (MKMapView *)mkMapView
{
    if (_mkMapView) {
        return _mkMapView;
    }
    
    MKMapView *mkMapView = [[MKMapView alloc] initWithFrame:CGRectZero];
    mkMapView.mapType = MKMapTypeStandard;
    mkMapView.showsUserLocation = NO;
    mkMapView.pitchEnabled = NO;
    mkMapView.rotateEnabled = NO;
    mkMapView.delegate = self;
    [self.mapContainerView addSubview:mkMapView];
    [self.mapContainerView sendSubviewToBack:mkMapView];
    [mkMapView makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.equalTo(self.mapContainerView);
    }];
    
    [mkMapView becomeFirstResponder];
    
    _mkMapView = mkMapView;
    return _mkMapView;
}

- (BMKMapView *)bmkMapView
{
    if (_bmkMapView) {
        return _bmkMapView;
    }
    
    BMKMapView *bmkMapView = [[BMKMapView alloc] initWithFrame:CGRectZero];
    bmkMapView.mapType = BMKMapTypeStandard;
    bmkMapView.showsUserLocation = NO;
    bmkMapView.rotateEnabled = NO;
    bmkMapView.overlookEnabled = NO;
    bmkMapView.userTrackingMode = BMKUserTrackingModeNone;
    [self.mapContainerView addSubview:bmkMapView];
    [self.mapContainerView sendSubviewToBack:bmkMapView];
    [bmkMapView makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.equalTo(self.mapContainerView);
    }];
    
    [bmkMapView becomeFirstResponder];
    
    bmkMapView.bk_viewForAnnotation = ^(BMKMapView *mapView , id <BMKAnnotation> annotation){
        
        if ([annotation isKindOfClass:[BMKPointAnnotation class]]) {
            static NSString *identifier = @"Annotation";
            BMKPinAnnotationView *annotationView = (BMKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:identifier];
            if (!annotationView) {
                annotationView = [[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier];
            }
            
            BMKPointAnnotation *point = (BMKPointAnnotation *)annotation;
            if ([point.title isEqualToString:@"Start"]) {
                annotationView.image = [UIImage imageNamed:@"ic_trip_start"];
            } else {
                annotationView.image = [UIImage imageNamed:@"ic_trip_end"];
            }
            point.title = nil;
            if (!iPhone6Plus) {
                annotationView.centerOffset = CGPointMake(0, -annotationView.image.size.height/2);
            }
            annotationView.canShowCallout = NO;
            
            return (BMKAnnotationView *)annotationView;
        }
        
        return (BMKAnnotationView *)nil;
    };
    
    bmkMapView.bk_viewForOverlay = ^(BMKMapView *mapView , id <BMKOverlay> overlay){
        
        if ([overlay isKindOfClass:[BMKPolyline class]]) {
            BMKPolylineView *routeLineView = [[BMKPolylineView alloc] initWithPolyline:(BMKPolyline*)overlay];
            routeLineView.fillColor = [UIColor defaultColor];
            routeLineView.strokeColor = [UIColor defaultColor];
            routeLineView.lineWidth = 3;
            return (BMKOverlayView *)routeLineView;
        }
        
        return (BMKOverlayView *)nil;
    };
    
    _bmkMapView = bmkMapView;

    return _bmkMapView;

}

@end

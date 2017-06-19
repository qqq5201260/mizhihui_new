//
//  SRLocationViewController.m
//  SiRuiV4.0
//
//  Created by zhangjunbo on 15/6/24.
//  Copyright (c) 2015年 SiRui. All rights reserved.
//

#import "SRLocationViewController.h"
#import "SRUserDefaults.h"
#import "SRPortal.h"
#import "SRVehicleBasicInfo.h"
#import "SRVehicleStatusInfo.h"
#import "SRPhoneApp.h"
#import "SRMKMapView.h"
#import "SRBMKMapView.h"
#import "BMKMapView+BlocksKit.h"
#import "BMKLocationService+BlocksKit.h"
#import "BMKGeoCodeSearch+BlocksKit.h"
#import "SRUIUtil.h"
#import "CoordinateTransform.h"
#import "SRShare.h"
#import "SRShareInfo.h"

#import "SRMAMapView.h"

#import "SREventCenter.h"
#import <SMCalloutView/SMCalloutView.h>
#import <BlocksKit/NSObject+A2DynamicDelegate.h>

const NSInteger  mkRegionDistance = 800;
const NSInteger  bmkRegionDistance = 100;

@interface SRLocationViewController () <MKMapViewDelegate/*MAMapViewDelegate*/>

@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet UIButton *bt_switch;
@property (weak, nonatomic) IBOutlet UIButton *bt_car;
@property (weak, nonatomic) IBOutlet UIButton *bt_user;

@property (copy, nonatomic) NSString *address;

//IOS自带地图
@property (strong, nonatomic) SRMKMapView *mkMapView;
@property (strong, nonatomic) MKPointAnnotation *mkCarAnnotaion;
@property (strong, nonatomic) SMCalloutView *mkCalloutView;
@property (strong, nonatomic) UILabel *mkCalloutLabel;

//高德地图
//@property (strong, nonatomic) SRMAMapView *maMapView;
//@property (strong, nonatomic) MAPointAnnotation *maCarAnnotaion;
//@property (strong, nonatomic) SMCalloutView *maCalloutView;
//@property (strong, nonatomic) UILabel *maCalloutLabel;

//百度地图
@property (strong, nonatomic) BMKGeoCodeSearch *bmkGeoCode;
@property (strong, nonatomic) SRBMKMapView *bmkMapView;
@property (strong, nonatomic) BMKPointAnnotation *bmkCarAnnotaion;
@property (strong, nonatomic) SMCalloutView *bmkCalloutView;
@property (strong, nonatomic) UILabel *bmkCalloutLabel;

@property (strong, nonatomic) BMKLocationService *bLocService;

@end

@implementation SRLocationViewController
{
    BOOL isMKMapInit;
//    BOOL isMAMapInit;
    BOOL isBMKMapInit;
}

#pragma mark - 生命周期

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = SRLocal(@"title_location");
    
    [self addTripButton];
    
    [self.bt_switch setImage:[SRUserDefaults isBaiduMap]?[UIImage imageNamed:@"bt_MKMap"]:[UIImage imageNamed:@"bt_BMKMap"]
                    forState:UIControlStateNormal];
    [self.bt_switch setImage:[SRUserDefaults isBaiduMap]?[UIImage imageNamed:@"bt_BMKMap"]:[UIImage imageNamed:@"bt_MKMap"]
                    forState:UIControlStateSelected];
    
    self.basicInfo = [SRPortal sharedInterface].currentVehicleBasicInfo;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.bmkMapView.hidden = ![SRUserDefaults isBaiduMap];
    self.mkMapView.hidden = [SRUserDefaults isBaiduMap];
//    self.maMapView.hidden = [SRUserDefaults isBaiduMap];
    
    [[SREventCenter sharedInterface] addObserver:self observerQueue:dispatch_get_main_queue()];
    
    [self.bmkMapView viewWillAppear];
    [self.bmkMapView bk_ensuredDynamicDelegate];
    [self.bLocService startUserLocationService];
    
    [self currentVehicleChange:self.basicInfo];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self currentVehicleChange:self.basicInfo];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [[SREventCenter sharedInterface] removeObserver:self observerQueue:dispatch_get_main_queue()];
    
//    NSArray *maAnnotations = [NSArray arrayWithArray:self.maMapView.annotations];
//    [self.maMapView removeAnnotations:maAnnotations];
//    [self.maMapView removeFromSuperview];
//    self.maMapView.delegate = nil;
//    self.maMapView = nil;
//    
//    self.maCarAnnotaion = nil;
//    self.maCalloutView = nil;
    
    NSArray *mkAnnotations = [NSArray arrayWithArray:self.mkMapView.annotations];
    [self.mkMapView removeAnnotations:mkAnnotations];
    [self.mkMapView removeFromSuperview];
    self.mkMapView.delegate = nil;
    self.mkMapView = nil;
    
    self.mkCarAnnotaion = nil;
    self.mkCalloutView = nil;
    
    [self.bmkMapView viewWillDisappear];
    self.bmkMapView.delegate = nil;
    [self.bLocService stopUserLocationService];
    
    NSArray *bmkAnnotations = [NSArray arrayWithArray:self.bmkMapView.annotations];
    [self.bmkMapView removeAnnotations:bmkAnnotations];
    [self.bmkMapView removeFromSuperview];
    self.bmkMapView = nil;
    
    self.bmkCarAnnotaion = nil;
    self.bmkCalloutView = nil;
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
//    [[SREventCenter sharedInterface] removeObserver:self observerQueue:dispatch_get_main_queue()];
//    
//    NSArray *maAnnotations = [NSArray arrayWithArray:self.maMapView.annotations];
//    [self.maMapView removeAnnotations:maAnnotations];
//    [self.maMapView removeFromSuperview];
//    self.maMapView.delegate = nil;
//    self.maMapView = nil;
//    
//    self.maCarAnnotaion = nil;
//    self.maCalloutView = nil;
//    
//    [self.bmkMapView viewWillDisappear];
//    self.bmkMapView.delegate = nil;
//    [self.bLocService stopUserLocationService];
//    
//    NSArray *bmkAnnotations = [NSArray arrayWithArray:self.bmkMapView.annotations];
//    [self.bmkMapView removeAnnotations:bmkAnnotations];
//    [self.bmkMapView removeFromSuperview];
//    self.bmkMapView = nil;
//    
//    self.bmkCarAnnotaion = nil;
//    self.bmkCalloutView = nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
    if (!self.isViewLoaded || self.view.window) return;
}


#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    UIViewController *vc = segue.destinationViewController;
    [vc setValue:self.basicInfo forKey:@"basicInfo"];
}

#pragma mark - SREventCenter

- (void)currentVehicleChange:(SRVehicleBasicInfo *)basicInfo
{
    CLLocationCoordinate2D location = CLLocationCoordinate2DMake(self.basicInfo.status.lat, self.basicInfo.status.lng);
    [self parserAddressWithLocation:location];
    if ([SRUserDefaults isBaiduMap]) {
        self.bmkCarAnnotaion.coordinate = bd_encrypt(location);
    } else {
        self.mkCarAnnotaion.coordinate = location;
//        self.maCarAnnotaion.coordinate = location;
    }
    
    [self buttonCarPressed:nil];
}

#pragma mark - MKMapViewDelegate

- (void)mapViewDidFailLoadingMap:(MKMapView *)mapView withError:(NSError *)error
{
    SRLogError(@"%@", error);
    static NSDate *lastAlertShowTime = nil;
    if (lastAlertShowTime && fabs([lastAlertShowTime timeIntervalSinceDate:[NSDate date]]) <= 1*60) {
        return;
    }
    lastAlertShowTime = [NSDate date];
    [SRUIUtil showAutoDisappearHUDWithMessage:@"地图载入失败，请缩小地图或稍候再试" isDetail:NO];
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id)annotation{
    if ([annotation isEqual:self.mkCarAnnotaion]) {
        static NSString *basicIdentifier = @"Annotation";
        MKAnnotationView *annotationView = (MKAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:basicIdentifier];
        if (!annotationView) {
            annotationView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:basicIdentifier];
            UIImage *image = [UIImage imageNamed:@"ic_carLocation"];
            annotationView.canShowCallout = NO;
            annotationView.centerOffset = CGPointMake(0, -image.size.height/2);
            annotationView.image = image;
        }
        return annotationView;
    }
    
    return nil;
}

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)annotationView
{
    if ([annotationView.annotation isEqual:self.mkCarAnnotaion]) {
        self.mkCalloutView.calloutOffset = annotationView.calloutOffset;
        self.mkCalloutView.constrainedInsets = UIEdgeInsetsMake(self.topLayoutGuide.length, 0, self.bottomLayoutGuide.length, 0);
        [self.mkCalloutView presentCalloutFromRect:annotationView.bounds inView:annotationView constrainedToView:self.mkMapView animated:YES];
    }
}

- (void)mapView:(MKMapView *)mapView didDeselectAnnotationView:(MKAnnotationView *)view
{
    [self.mkCalloutView dismissCalloutAnimated:YES];
}

//#pragma mark - MAMapViewDelegate
//
//- (void)mapViewDidFailLoadingMap:(MAMapView *)mapView withError:(NSError *)error
//{
//    SRLogError(@"%@", error);
//    static NSDate *lastAlertShowTime = nil;
//    if (lastAlertShowTime && fabs([lastAlertShowTime timeIntervalSinceDate:[NSDate date]]) <= 1*60) {
//        return;
//    }
//    lastAlertShowTime = [NSDate date];
//    [SRUIUtil showAutoDisappearHUDWithMessage:@"地图载入失败，请缩小地图或稍候再试" isDetail:NO];
//}
//
//- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id)annotation{
//    if ([annotation isEqual:self.maCarAnnotaion]) {
//        static NSString *basicIdentifier = @"Annotation";
//        MAAnnotationView *annotationView = (MAAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:basicIdentifier];
//        if (!annotationView) {
//            annotationView = [[MAAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:basicIdentifier];
//            UIImage *image = [UIImage imageNamed:@"ic_carLocation"];
//            annotationView.canShowCallout = NO;
//            annotationView.centerOffset = CGPointMake(0, -image.size.height/2);
//            annotationView.image = image;
//        }
//        return annotationView;
//    }
//    
//    return nil;
//}
//
//- (void)mapView:(MAMapView *)mapView didSelectAnnotationView:(MAAnnotationView *)annotationView
//{
//    if ([annotationView.annotation isEqual:self.maCarAnnotaion]) {
//        self.maCalloutView.calloutOffset = annotationView.calloutOffset;
//        self.maCalloutView.constrainedInsets = UIEdgeInsetsMake(self.topLayoutGuide.length, 0, self.bottomLayoutGuide.length, 0);
//        [self.maCalloutView presentCalloutFromRect:annotationView.bounds inView:annotationView constrainedToView:self.maMapView animated:YES];
//    }
//}
//
//- (void)mapView:(MAMapView *)mapView didDeselectAnnotationView:(MAAnnotationView *)view
//{
//    [self.maCalloutView dismissCalloutAnimated:YES];
//}



#pragma mark - 交互操作

- (IBAction)buttonSwitchPressed:(id)sender {
    
    self.bt_switch.selected ^= 1;
    
    BOOL isBaiduMap = [SRUserDefaults isBaiduMap];
    isBaiduMap ^= 1;
    [SRUserDefaults updateBaiduMap:isBaiduMap];
    self.bmkMapView.hidden = ![SRUserDefaults isBaiduMap];
    self.mkMapView.hidden = [SRUserDefaults isBaiduMap];
//    self.maMapView.hidden = [SRUserDefaults isBaiduMap];
    if ([SRUserDefaults isBaiduMap]) {
        CLLocationCoordinate2D location = CLLocationCoordinate2DMake(self.basicInfo.status.lat, self.basicInfo.status.lng);
        self.bmkCarAnnotaion.coordinate = bd_encrypt(location);
    } else {
        self.mkCarAnnotaion.coordinate = CLLocationCoordinate2DMake(self.basicInfo.status.lat, self.basicInfo.status.lng);
//        self.maCarAnnotaion.coordinate = CLLocationCoordinate2DMake(self.basicInfo.status.lat, self.basicInfo.status.lng);
    }
    
    [self buttonCarPressed:nil];
}

- (IBAction)buttonCarPressed:(id)sender {
    
    CLLocationCoordinate2D coords = CLLocationCoordinate2DMake(self.basicInfo.status.lat, self.basicInfo.status.lng);
    
    if ([SRUserDefaults isBaiduMap]) {
        isBMKMapInit = NO;
        [self animationBMKMapToCoordinate:bd_encrypt(coords) animated:YES];
    } else {
        isMKMapInit = NO;
        [self animationMKMapToCoordinate:coords animated:YES];
//        isMAMapInit = NO;
//        [self animationMKMapToCoordinate:coords animated:YES];
    }
    
    if (sender
        && self.basicInfo.status.isOnline == 1
        && self.basicInfo.status.sleepStatus == 2) {
        [SRPhoneApp sendControlCommandWithCmd:TLVTag_Instruction_GPSWeak andCompleteBlock:nil];
    }
}

- (IBAction)buttonUserPressed:(id)sender {
    
//    [[UIApplication sharedApplication] performSelector:@selector(_performMemoryWarning)];
    
    if (![CLLocationManager locationServicesEnabled]) {
        [SRUIUtil showAutoDisappearHUDWithMessage:@"无法获取您的位置信息。请到手机系统的[设置]->[隐私]->[定位服务]中打开定位服务，并允许咪智汇使用定位服务。" isDetail:YES];
            return;
    }
    
    if ([SRUserDefaults isBaiduMap]) {
        CLLocationCoordinate2D coords = self.bLocService.userLocation.location.coordinate;
        isBMKMapInit = NO;
        [self animationBMKMapToCoordinate:coords animated:YES];
    } else {
        CLLocationCoordinate2D coords = self.mkMapView.userLocation.location.coordinate;
        isMKMapInit = NO;
        [self animationMKMapToCoordinate:coords animated:YES];
//        CLLocationCoordinate2D coords = self.maMapView.userLocation.location.coordinate;
//        isMAMapInit = NO;
//        [self animationMKMapToCoordinate:coords animated:YES];
    }
    
}

- (IBAction)buttonSharePressed:(id)sender {
    SRShareInfo *info = [[SRShareInfo alloc] init];
    info.content = [NSString stringWithFormat:@"我的位置：%@", self.address];
    UIImage *image = [SRUserDefaults isBaiduMap]?[self.bmkMapView takeSnapshot]:[self.mkMapView sr_takeSnapshot];
//    UIImage *image = [SRUserDefaults isBaiduMap]?[self.bmkMapView takeSnapshot]:[self.maMapView takeSnapshotInRect:self.maMapView.bounds];
    info.image = [image resizedImage:CGSizeMake(640, 960) interpolationQuality:1.0];
    
    [SRShare share:info];
}

#pragma mark - Getter

#pragma mark IOS自带地图

- (SRMKMapView *)mkMapView
{
    if (_mkMapView) {
        return _mkMapView;
    }
    
    SRMKMapView *mkMapView = [[SRMKMapView alloc] initWithFrame:CGRectZero];
    mkMapView.mapType = MKMapTypeStandard;
    mkMapView.showsUserLocation = YES;
    mkMapView.pitchEnabled = NO;
    mkMapView.rotateEnabled = NO;
    mkMapView.delegate = self;
    mkMapView.calloutView = self.mkCalloutView;
    CLLocationCoordinate2D location = CLLocationCoordinate2DMake(self.basicInfo.status.lat, self.basicInfo.status.lng);
    mkMapView.centerCoordinate = location;
    [self.containerView addSubview:mkMapView];
    [self.containerView sendSubviewToBack:mkMapView];
    [mkMapView makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.equalTo(self.containerView);
    }];
    
    [mkMapView becomeFirstResponder];
    
    _mkMapView = mkMapView;
    _mkMapView.hidden = [SRUserDefaults isBaiduMap];
    return _mkMapView;
}

- (MKPointAnnotation *)mkCarAnnotaion
{
    if (_mkCarAnnotaion) {
        return _mkCarAnnotaion;
    }
    
    MKPointAnnotation *mkCarAnnotaion = [[MKPointAnnotation alloc] init];
    mkCarAnnotaion.coordinate = CLLocationCoordinate2DMake(self.basicInfo.status.lat, self.basicInfo.status.lng);
    [self.mkMapView addAnnotation:mkCarAnnotaion];
    
    _mkCarAnnotaion = mkCarAnnotaion;
    return _mkCarAnnotaion;
}

- (SMCalloutView *)mkCalloutView
{
    if (_mkCalloutView) {
        return _mkCalloutView;
    }
    
    _mkCalloutView = [SMCalloutView platformCalloutView];
    _bmkCalloutView.contentViewInset = UIEdgeInsetsMake(5, 5, 5, 5);
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 170, 55)];
    label.numberOfLines = 0;
    label.attributedText = self.attributtedTitles;
    self.mkCalloutLabel = label;
    
    _mkCalloutView.contentView = label;

    UIImage *img = [UIImage imageNamed:@"bt_share"];
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, img.size.width, img.size.height)];
    [button setImage:img forState:UIControlStateNormal];
    [button bk_whenTapped:^{
        [self buttonSharePressed:nil];
    }];
    _mkCalloutView.rightAccessoryView = button;
 
    return _mkCalloutView;
}

//#pragma mark 高德地图
//
//- (SRMAMapView *)maMapView
//{
//    if (_maMapView) {
//        return _maMapView;
//    }
//    
//    [MAMapServices sharedServices].apiKey = @"197232c52f079d79288687713edbe8e8";
//    
//    SRMAMapView *maMapView = [[SRMAMapView alloc] initWithFrame:CGRectZero];
//    maMapView.mapType = MAMapTypeStandard;
//    maMapView.showsUserLocation = YES;
//    maMapView.delegate = self;
//    maMapView.calloutView = self.maCalloutView;
//    [maMapView addAnnotation:self.maCarAnnotaion];
//    CLLocationCoordinate2D location = CLLocationCoordinate2DMake(self.basicInfo.status.lat, self.basicInfo.status.lng);
//    maMapView.centerCoordinate = location;
//    [self.containerView addSubview:maMapView];
//    [self.containerView sendSubviewToBack:maMapView];
//    @weakify(self)
//    [maMapView makeConstraints:^(MASConstraintMaker *make) {
//        @strongify(self)
//        make.top.left.right.bottom.equalTo(self.containerView);
//    }];
//    
//    [maMapView becomeFirstResponder];
//    
//    _maMapView = maMapView;
//    _maMapView.hidden = [SRUserDefaults isBaiduMap];
//    return maMapView;
//}
//
//- (MAPointAnnotation *)maCarAnnotaion
//{
//    if (_maCarAnnotaion) {
//        return _maCarAnnotaion;
//    }
//    
//    MAPointAnnotation *maCarAnnotaion = [[MAPointAnnotation alloc] init];
//    maCarAnnotaion.coordinate = CLLocationCoordinate2DMake(self.basicInfo.status.lat, self.basicInfo.status.lng);
////    [self.maMapView addAnnotation:maCarAnnotaion];
//    
//    _maCarAnnotaion = maCarAnnotaion;
//    return _maCarAnnotaion;
//}
//
//- (SMCalloutView *)maCalloutView
//{
//    if (_maCalloutView) {
//        return _maCalloutView;
//    }
//    
//    _maCalloutView = [SMCalloutView platformCalloutView];
//    _maCalloutView.contentViewInset = UIEdgeInsetsMake(5, 5, 5, 5);
//    
//    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 170, 55)];
//    label.numberOfLines = 0;
//    label.attributedText = self.attributtedTitles;
//    self.maCalloutLabel = label;
//    
//    _maCalloutView.contentView = label;
//    
//    UIImage *img = [UIImage imageNamed:@"bt_share"];
//    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, img.size.width, img.size.height)];
//    [button setImage:img forState:UIControlStateNormal];
//    @weakify(self)
//    [button bk_whenTapped:^{
//        @strongify(self)
//        [self buttonSharePressed:nil];
//    }];
//    _maCalloutView.rightAccessoryView = button;
//    
//    return _maCalloutView;
//}

#pragma mark 百度地图

- (SRBMKMapView *)bmkMapView
{
    if (_bmkMapView) {
        return _bmkMapView;
    }
    
    SRBMKMapView *bmkMapView = [[SRBMKMapView alloc] initWithFrame:CGRectZero];
    bmkMapView.mapType = BMKMapTypeStandard;
    bmkMapView.showsUserLocation = YES;
    bmkMapView.rotateEnabled = NO;
    bmkMapView.overlookEnabled = NO;
    bmkMapView.userTrackingMode = BMKUserTrackingModeNone;
    bmkMapView.calloutView = self.bmkCalloutView;
    [self.containerView addSubview:bmkMapView];
    [self.containerView sendSubviewToBack:bmkMapView];
    @weakify(self)
    [bmkMapView makeConstraints:^(MASConstraintMaker *make) {
         @strongify(self)
        make.top.left.right.bottom.equalTo(self.containerView);
    }];
    
    [bmkMapView becomeFirstResponder];
    
    bmkMapView.bk_viewForAnnotation = ^(BMKMapView *mapView , id <BMKAnnotation> annotation){
        @strongify(self)
        
        if ([annotation isEqual:self.bmkCarAnnotaion]) {
            static NSString *basicIdentifier = @"Annotation";
            BMKAnnotationView *annotationView = (BMKAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:basicIdentifier];
            if (!annotationView) {
                annotationView = [[BMKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:basicIdentifier];
                UIImage *image = [UIImage imageNamed:@"ic_carLocation"];
                annotationView.canShowCallout = NO;
                annotationView.centerOffset = CGPointMake(0, -image.size.height/2);
                annotationView.image = image;
            }
            return annotationView;
        }
        return (BMKAnnotationView *)nil;
    };
    
    bmkMapView.bk_didSelectAnnotationView = ^(BMKMapView *mapView , BMKAnnotationView *annotationView){
        @strongify(self)
        if ([annotationView.annotation isEqual:self.bmkCarAnnotaion]) {
            self.bmkCalloutView.calloutOffset = annotationView.calloutOffset;
            self.bmkCalloutView.constrainedInsets = UIEdgeInsetsMake(self.topLayoutGuide.length, 0, self.bottomLayoutGuide.length, 0);
            [self.bmkCalloutView presentCalloutFromRect:annotationView.bounds inView:annotationView constrainedToView:self.bmkMapView animated:YES];
            [self.bmkMapView bringSubviewToFront:self.bmkCalloutView];
        }
    };
    
    bmkMapView.bk_didDeselectAnnotationView = ^(BMKMapView *mapView , BMKAnnotationView *view){
        @strongify(self)
        [self.bmkCalloutView dismissCalloutAnimated:YES];
    };
    
    _bmkMapView = bmkMapView;
    _bmkMapView.hidden = ![SRUserDefaults isBaiduMap];
    return _bmkMapView;
}

- (BMKPointAnnotation *)bmkCarAnnotaion
{
    if (_bmkCarAnnotaion) {
        return _bmkCarAnnotaion;
    }
    
    CLLocationCoordinate2D location = CLLocationCoordinate2DMake(self.basicInfo.status.lat, self.basicInfo.status.lng);
    
    BMKPointAnnotation *bmkCarAnnotaion = [[BMKPointAnnotation alloc] init];
    _bmkCarAnnotaion = bmkCarAnnotaion;
    
    bmkCarAnnotaion.coordinate = bd_encrypt(location);
    [self.bmkMapView addAnnotation:bmkCarAnnotaion];

    return _bmkCarAnnotaion;
}

- (SMCalloutView *)bmkCalloutView
{
    if (_bmkCalloutView) {
        return _bmkCalloutView;
    }
    
    _bmkCalloutView = [SMCalloutView platformCalloutView];
    _bmkCalloutView.contentViewInset = UIEdgeInsetsMake(5, 5, 5, 5);
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 170, 55)];
    label.numberOfLines = 0;
    label.attributedText = self.attributtedTitles;
    self.bmkCalloutLabel = label;
    
    _bmkCalloutView.contentView = label;
    
    UIImage *img = [UIImage imageNamed:@"bt_share"];
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, img.size.width, img.size.height)];
    [button setImage:img forState:UIControlStateNormal];
    @weakify(self)
    [button bk_whenTapped:^{
        @strongify(self)
        [self buttonSharePressed:nil];
    }];
    _bmkCalloutView.rightAccessoryView = button;
    
    return _bmkCalloutView;
}

- (BMKLocationService *)bLocService
{
    if (_bLocService) {
        return _bLocService;
    }
    
    [BMKLocationService setLocationDesiredAccuracy:kCLLocationAccuracyNearestTenMeters];
    
    //初始化BMKLocationService
    _bLocService = [[BMKLocationService alloc]init];
    
    @weakify(self)
    _bLocService.bk_didUpdateBMKUserLocation = ^(BMKUserLocation *userLocation){
        @strongify(self)
        [self.bmkMapView updateLocationData:userLocation];
    };
    
    [_bLocService bk_ensuredDynamicDelegate];
    
    return _bLocService;
}

- (BMKGeoCodeSearch *)bmkGeoCode
{
    if (_bmkGeoCode) {
        return _bmkGeoCode;
    }
    
    _bmkGeoCode = [[BMKGeoCodeSearch alloc] init];
    
    @weakify(self)
    _bmkGeoCode.bk_onGetReverseGeoCodeResult = ^(BMKGeoCodeSearch *searcher , BMKReverseGeoCodeResult *result, BMKSearchErrorCode error){
        @strongify(self)
        if (error == BMK_SEARCH_NO_ERROR && result){
            self.address = result.address;
            self.bmkCalloutLabel.attributedText = self.attributtedTitles;
        } else {
            NSLog(@"BMKSearchErrorCode : %zd", error);
        }
    };
    [_bmkGeoCode bk_ensuredDynamicDelegate];
    
    return _bmkGeoCode;
}

#pragma mark - 私有方法

- (void)addTripButton {
    
    if (self.basicInfo.tripHidden != SRTrip_Unhidden) {
        return;
    }
    
    @weakify(self)
    UIBarButtonItem *configItem = [[UIBarButtonItem alloc] bk_initWithTitle:SRLocal(@"title_trip") style:UIBarButtonItemStyleDone handler:^(id sender) {
        @strongify(self)
        [self performSegueWithIdentifier:@"PushSRTripViewController" sender:nil];
    }];
    
    self.navigationItem.rightBarButtonItem = configItem;
}

- (void)parserAddressWithLocation:(CLLocationCoordinate2D)location
{
    self.address = @"正在获取位置信息...";
    
    if ([SRUserDefaults isBaiduMap]) {
        self.bmkCalloutLabel.attributedText = self.attributtedTitles;
        BMKReverseGeoCodeOption *option = [[BMKReverseGeoCodeOption alloc] init];
        option.reverseGeoPoint = bd_encrypt(location);
        [self.bmkGeoCode reverseGeoCode:option];
    } else {
        self.mkCalloutLabel.attributedText = self.attributtedTitles;
        CLGeocoder *geocoder = [[CLGeocoder alloc] init];
        CLLocation *loc = [[CLLocation alloc] initWithLatitude:location.latitude longitude:location.longitude];
        [geocoder reverseGeocodeLocation:loc completionHandler:^(NSArray *placemarks, NSError *error) {
            if (error == nil && [placemarks count] > 0){
                CLPlacemark *placemark = [placemarks objectAtIndex:0];
                self.address = placemark.name;
                self.mkCalloutLabel.attributedText = self.attributtedTitles;
            }
            else if (error == nil && [placemarks count] == 0){
                NSLog(@"No results were returned.");
            }
            else if (error != nil){
                NSLog(@"An error occurred = %@", error);
            }
        }];
        
//        self.maCalloutLabel.attributedText = self.attributtedTitles;
//        CLGeocoder *geocoder = [[CLGeocoder alloc] init];
//        CLLocation *loc = [[CLLocation alloc] initWithLatitude:location.latitude longitude:location.longitude];
//        @weakify(self)
//        [geocoder reverseGeocodeLocation:loc completionHandler:^(NSArray *placemarks, NSError *error) {
//            @strongify(self)
//            if (error == nil && [placemarks count] > 0){
//                CLPlacemark *placemark = [placemarks objectAtIndex:0];
//                self.address = placemark.name;
//                self.maCalloutLabel.attributedText = self.attributtedTitles;
//            }
//            else if (error == nil && [placemarks count] == 0){
//                NSLog(@"No results were returned.");
//            }
//            else if (error != nil){
//                NSLog(@"An error occurred = %@", error);
//            }
//        }];
    }
}

- (NSAttributedString *)attributtedTitles
{
    SRVehicleStatusInfo *status = self.basicInfo.status;
    
    NSString *plateNumber = self.basicInfo.plateNumber;
    NSString *time = [NSString stringWithFormat:@"最后更新时间：%@", status.gpsTime?status.gpsTime:@""];
    NSString *address = self.address?self.address:@"正在获取位置信息...";
    
    NSString *string = [NSString stringWithFormat:@"%@\n%@\n%@", plateNumber, time, address];
    NSRange rowFirst = [string rangeOfString:plateNumber];
    NSRange rowRest = NSMakeRange(rowFirst.location + rowFirst.length, string.length - rowFirst.length);
    
    NSMutableAttributedString *attributedstr = [[NSMutableAttributedString alloc] initWithString:string];
    [attributedstr addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:13.0f] range:rowFirst];
    [attributedstr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:10.0f] range:rowRest];
    
    return attributedstr;
}

- (void)animationMKMapToCoordinate:(CLLocationCoordinate2D)center animated:(BOOL)animated
{
    @try {
        if (isMKMapInit) {
            [self.mkMapView setCenterCoordinate:center animated:animated];
        } else {
            isMKMapInit = YES;
            MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(center, mkRegionDistance, mkRegionDistance);
            [self.mkMapView setRegion:region animated:animated];
        }
//        if (isMAMapInit) {
//            [self.maMapView setCenterCoordinate:center animated:animated];
//        } else {
//            isMAMapInit = YES;
//            MACoordinateRegion region = MACoordinateRegionMakeWithDistance(center, mkRegionDistance, mkRegionDistance);
//            [self.maMapView setRegion:region animated:animated];
//        }
    }
    @catch (NSException *exception) {
        SRLogError(@"%@", [exception callStackSymbols]);
    }
}

- (void)animationBMKMapToCoordinate:(CLLocationCoordinate2D)center animated:(BOOL)animated {
    @try {
        if (isBMKMapInit) {
            [self.bmkMapView setCenterCoordinate:center animated:animated];
        } else {
            isBMKMapInit = YES;
            BMKCoordinateRegion region = BMKCoordinateRegionMakeWithDistance(center, bmkRegionDistance, bmkRegionDistance);
            [self.bmkMapView setRegion:region animated:animated];
        }
    }
    @catch (NSException *exception) {
        SRLogError(@"%@", [exception callStackSymbols]);
    }
}

@end

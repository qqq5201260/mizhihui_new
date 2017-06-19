//
//  SRBluetoothSearchView.m
//  Mizward
//
//  Created by zhangjunbo on 15/9/14.
//  Copyright (c) 2015年 Mizward. All rights reserved.
//

#import "SRBluetoothSearchView.h"
#import "SRUIUtil.h"
#import "SRPortal+Bluetooth.h"
#import "SRVehicleBasicInfo.h"
#import "SRPortalRequest.h"
#import "SRBLEManager.h"
#import "SRNearbyPeripheral.h"
#import <CoreBluetooth/CoreBluetooth.h>
#import <pop/POP.h>

const static CGFloat kCustomIOS7MotionEffectExtent                = 10.0;

@interface SRBluetoothSearchView () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UIButton *bt_close;
@property (weak, nonatomic) IBOutlet UIButton *bt_research;
@property (weak, nonatomic) IBOutlet UILabel *lb_title;
@property (weak, nonatomic) IBOutlet UIView *v_title;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIImageView *ic_search_bg;
@property (weak, nonatomic) IBOutlet UIImageView *ic_search;

@property (strong, nonatomic) UIView *maskView;

@property (strong, nonatomic) NSArray *searchResults;

@end

@implementation SRBluetoothSearchView
{
    CGFloat duration;
    BOOL isShowing;
}

+ (SRBluetoothSearchView *)instanceCustomView
{
    NSArray *nibView = [[NSBundle mainBundle] loadNibNamed:@"SRBluetoothSearchView" owner:nil options:nil];
    return [nibView objectAtIndex:0];
}

- (void)dealloc {
//    [SRNotificationCenter sr_removeObserver:self];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.height *= iPhoneScale;
    self.width *= iPhoneScale;
    
    self.layer.shouldRasterize = YES;
    self.layer.rasterizationScale = [[UIScreen mainScreen] scale];
    self.layer.masksToBounds = YES;
    
    self.v_title.backgroundColor = [UIColor defaultColor];
    
    self.searchResults = [NSArray array];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView = [[UIView alloc] init];
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    [SRUIUtil showLoadingHUDWithTitle:nil];
//    [[SRBLEManager sharedInterface] switchNearbyPeripheral:self.searchResults[indexPath.row] forVehicleID:self.basicInfo.vehicleID  withCompleteBlock:^(NSError *error, id responseObject) {
//        [SRUIUtil dissmissLoadingHUD];
//        if (error) {
//            [SRUIUtil showAlertMessage:error.domain];
//        } else {
//            [SRUIUtil showAutoDisappearHUDWithMessage:@"蓝牙切换成功" isDetail:NO];
//            [self dissmiss];
//        }
//    }];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.searchResults.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CellIdentifier" ;
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:CellIdentifier];
        
        UIImage *ic_signal = [UIImage imageNamed:@"ic_ble_signal_1"];
        UIImageView *im_signal = [[UIImageView alloc] initWithImage:ic_signal];
        im_signal.tag = 100;
        [cell.contentView addSubview:im_signal];
        [im_signal makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(cell.contentView);
            make.right.equalTo(cell.contentView).with.offset(-20.0f);
            make.size.equalTo(ic_signal.size);
        }];
    }
    
    cell.contentView.backgroundColor = indexPath.row%2==0?[UIColor whiteColor]:[UIColor colorWithRed:238.0f/255.0f
                                                                                               green:244.0f/255.0f
                                                                                                blue:242.0f/255.0f
                                                                                               alpha:1.0];
    
    cell.imageView.image = [UIImage imageNamed:@"ic_ble"];
    
    SRNearbyPeripheral *peripheral = self.searchResults[indexPath.row];
    cell.textLabel.text = peripheral.peripheral.name;
    
    UIImageView *im_signal = (UIImageView *)[cell.contentView viewWithTag:100];
    if (peripheral.RSSI.integerValue < -70) {
        im_signal.image = [UIImage imageNamed:@"ic_ble_signal_1"];
    } else if (peripheral.RSSI.integerValue < -40) {
        im_signal.image = [UIImage imageNamed:@"ic_ble_signal_2"];
    } else {
        im_signal.image = [UIImage imageNamed:@"ic_ble_signal_3"];
    }
    
    return cell;
}



#pragma mark - Public

- (void)show
{
    UIView *superView = [SRUIUtil rootViewController].view;
    [superView addSubview:self.maskView];
    [self.maskView makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(superView).with.offset(-5.0f);
        make.right.bottom.equalTo(superView).with.offset(5.0f);
    }];
    
    [self.maskView addSubview:self];
    [self makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.maskView);
        make.size.equalTo(CGSizeMake(self.width, self.height));
    }];
    
    isShowing = YES;
    self.tableView.hidden = YES;
    self.bt_research.hidden = YES;
    
    self.ic_search.hidden = NO;
    self.ic_search_bg.hidden = NO;
    
    self.layer.opacity = 0.5f;
    self.layer.transform = CATransform3DMakeScale(1.3f, 1.3f, 1.0);
    [UIView animateWithDuration:0.2f delay:0.0 options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         self.maskView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4f];
                         self.layer.opacity = 1.0f;
                         self.layer.transform = CATransform3DMakeScale(1, 1, 1);
                     } completion:^(BOOL finished) {
                         [self startSearch];
                     }
     ];
}

- (void)dissmiss
{
    CATransform3D currentTransform = self.layer.transform;
    
    if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_7_1) {
        CGFloat startRotation = [[self valueForKeyPath:@"layer.transform.rotation.z"] floatValue];
        CATransform3D rotation = CATransform3DMakeRotation(-startRotation + M_PI * 270.0 / 180.0, 0.0f, 0.0f, 0.0f);
        
        self.layer.transform = CATransform3DConcat(rotation, CATransform3DMakeScale(1, 1, 1));
    }
    
    self.layer.opacity = 1.0f;
    
    isShowing = NO;
    
    [UIView animateWithDuration:0.2f delay:0.0 options:UIViewAnimationOptionTransitionNone
                     animations:^{
                         self.maskView.backgroundColor = [UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.0f];
                         self.layer.transform = CATransform3DConcat(currentTransform, CATransform3DMakeScale(0.6f, 0.6f, 1.0));
                         self.layer.opacity = 0.0f;
                     }
                     completion:^(BOOL finished) {
                         [self removeFromSuperview];
                         [self.maskView removeFromSuperview];
                         self.maskView = nil;
                     }
     ];
}

#pragma mark - 私有方法

- (void)startSearch {
    self.tableView.hidden = YES;
    self.bt_research.hidden = YES;
    
    self.ic_search.hidden = NO;
    self.ic_search_bg.hidden = NO;
    
    POPBasicAnimation *rotation = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerRotation];
    rotation.toValue = @(degreesToRadian(360));
    rotation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    rotation.duration = 1;
    rotation.repeatForever = YES;
    [self.ic_search.layer pop_addAnimation:rotation forKey:@"rotation"];
    
//    [[SRBLEManager sharedInterface] scanNearbyPeripheralWithCompleteBlock:^(NSError *error, id responseObject) {
//        
//        if (error) {
//            [SRUIUtil showAlertMessage:error.domain];
//        }
//        
//        [self.ic_search.layer pop_removeAllAnimations];
//        self.ic_search.hidden = YES;
//        self.ic_search_bg.hidden = YES;
//        
//        self.bt_research.hidden = NO;
//        self.tableView.hidden = NO;
//        self.searchResults = responseObject;
//        [self.tableView reloadData];
//    }];
}

#pragma mark - 交互事件

- (IBAction)buttonClosePressed:(id)sender {
    [self dissmiss];
}

- (IBAction)buttonResearchPressed:(id)sender {
    [self startSearch];
}

#pragma mark - Getter

- (UIView *)maskView {
    if (_maskView) {
        return _maskView;
    }
    
    UIView *maskView = [[UIView alloc] initWithFrame:CGRectZero];
    maskView.backgroundColor = [UIColor clearColor];
    maskView.layer.shouldRasterize = YES;
    maskView.layer.rasterizationScale = [UIScreen mainScreen].scale;
//    [maskView bk_whenTapped:^{
//
//    }];
    
    UIInterpolatingMotionEffect *horizontalEffect = [[UIInterpolatingMotionEffect alloc] initWithKeyPath:@"center.x"
                                                                                                    type:UIInterpolatingMotionEffectTypeTiltAlongHorizontalAxis];
    horizontalEffect.minimumRelativeValue = @(-kCustomIOS7MotionEffectExtent);
    horizontalEffect.maximumRelativeValue = @( kCustomIOS7MotionEffectExtent);
    
    UIInterpolatingMotionEffect *verticalEffect = [[UIInterpolatingMotionEffect alloc] initWithKeyPath:@"center.y"
                                                                                                  type:UIInterpolatingMotionEffectTypeTiltAlongVerticalAxis];
    verticalEffect.minimumRelativeValue = @(-kCustomIOS7MotionEffectExtent);
    verticalEffect.maximumRelativeValue = @( kCustomIOS7MotionEffectExtent);
    
    UIMotionEffectGroup *motionEffectGroup = [[UIMotionEffectGroup alloc] init];
    motionEffectGroup.motionEffects = @[horizontalEffect, verticalEffect];
    
    [maskView addMotionEffect:motionEffectGroup];
    
    _maskView = maskView;
    return _maskView;
}


@end

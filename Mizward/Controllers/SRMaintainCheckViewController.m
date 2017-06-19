//
//  SRMaintainCheckViewController.m
//  SiRuiV4.0
//
//  Created by zhangjunbo on 15/7/14.
//  Copyright (c) 2015年 SiRui. All rights reserved.
//

#import "SRMaintainCheckViewController.h"
#import "SRMaintainCheckingView.h"
#import "SRPortal+CarInfo.h"
#import "SRPortalRequest.h"
#import "SRUIUtil.h"
#import "SRVehicleBasicInfo.h"
#import "SRUserDefaults.h"
#import <pop/POP.h>

@interface SRMaintainCheckViewController ()
@property (weak, nonatomic) IBOutlet UIView *v_top;
@property (weak, nonatomic) IBOutlet UILabel *label;
@property (weak, nonatomic) IBOutlet UIImageView *im_normal;
@property (weak, nonatomic) IBOutlet UIImageView *im_checking;
@property (weak, nonatomic) IBOutlet SRMaintainCheckingView *engineTransmissionSys;
@property (weak, nonatomic) IBOutlet SRMaintainCheckingView *chassisSys;
@property (weak, nonatomic) IBOutlet SRMaintainCheckingView *bodyworkSys;
@property (weak, nonatomic) IBOutlet SRMaintainCheckingView *networkSys;

@end

@implementation SRMaintainCheckViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor defaultBackgroundColor];
    
    self.v_top.backgroundColor = [UIColor defaultColor];
    
    self.im_checking.layer.opacity = 0.0f;
    [self.im_normal bk_whenTapped:^{
        if (![self checkLoginStatus]) {
            return ;
        }
        
        if (![[SRPortal sharedInterface].currentVehicleBasicInfo hasTerminal]) {
            [SRUIUtil showBindTerminalAlert];
            return;
        }
        
        if ([SRPortal sharedInterface].currentVehicleBasicInfo.onlyPPKE) {
            [SRUIUtil showAlertMessage:SRLocal(@"error_no_ost")];
            return;
        }
        
        [self queryDtcInfos];
    }];
    
    self.engineTransmissionSys.duration = 1.0f;
    self.engineTransmissionSys.type = SRSystemType_Engine_Transmission;
    
    self.chassisSys.duration = 1.0f;
    self.chassisSys.type = SRSystemType_Chassis;
    
    self.bodyworkSys.duration = 1.0f;
    self.bodyworkSys.type = SRSystemType_Bodywork;
    
    self.networkSys.duration = 1.0f;
    self.networkSys.type = SRSystemType_Network;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self resetView];
//    NSLog(@"%@",[SRUIUtil rootViewController]);
//    self.navigationController.navigationBar.hidden = YES;
//    [SRUIUtil rootViewController].navigationBarHidden = YES;
//    self.parentViewController.navigationController.navigationBar.hidden = YES;
        [SRUIUtil rootViewController].navigationBarHidden = YES;
//        self.parentVC.navigationItem.rightBarButtonItem = nil;
//        self.parentVC.navigationItem.titleView = nil;
//        self.parentVC.navigationItem.leftBarButtonItem = nil;
}

- (void)viewDidAppear:(BOOL)animated{

    [super viewDidAppear:animated];
    
//    [SRUIUtil rootViewController].navigationBarHidden = YES;
//    self.parentVC.navigationItem.rightBarButtonItem = nil;
//    self.parentVC.navigationItem.titleView = nil;
//    self.parentVC.navigationItem.leftBarButtonItem = nil;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 私有函数

- (void)resetView {
    
//    [self.im_normal.layer pop_removeAllAnimations];
//    [self.im_checking.layer pop_removeAllAnimations];
//    [self pop_removeAllAnimations];
//    [self.engineTransmissionSys endAnimation];
//    [self.chassisSys endAnimation];
//    [self.bodyworkSys endAnimation];
//    [self.networkSys endAnimation];
//    
//    self.label.text = @"开始检测";
//    self.im_normal.image = [UIImage imageNamed:@"im_check_start"];
//    self.im_normal.viewSize = [UIImage imageNamed:@"im_check_start"].size;
//    self.im_normal.alpha = 1.0f;
//    self.im_checking.alpha = 0.0f;
//    [self.engineTransmissionSys reset];
//    [self.chassisSys reset];
//    [self.bodyworkSys reset];
//    [self.networkSys reset];
}

- (void)queryDtcInfos {
    [SRUIUtil showLoadingHUDWithTitle:nil];
    SRPortalRequestDtcInfo *request = [[SRPortalRequestDtcInfo alloc] init];
    request.vehicleID = [SRUserDefaults currentVehicleID];
    [SRPortal queryDtcInfosWithRequest:request andCompleteBlock:^(NSError *error, NSArray *result) {
        [SRUIUtil dissmissLoadingHUD];
        if (result) {
            self.engineTransmissionSys.isOK = [result[SRSystemType_Engine_Transmission] boolValue];
            self.chassisSys.isOK = [result[SRSystemType_Chassis] boolValue];
            self.bodyworkSys.isOK = [result[SRSystemType_Bodywork] boolValue];
            self.networkSys.isOK = [result[SRSystemType_Network] boolValue];
        } else {
            self.engineTransmissionSys.isOK = YES;
            self.chassisSys.isOK = YES;
            self.bodyworkSys.isOK = YES;
            self.networkSys.isOK = YES;
        }
        
        [self startCheckAnimation];
    }];
}

- (void)updateLabel:(BOOL)status {
    NSString *result = status?@"GOOD":@"WARNING";
    NSString *restart = @"点击重新检测";
    NSString *string = [NSString stringWithFormat:@"%@\n%@", result, restart];
    
    NSMutableAttributedString *attributedstr = [[NSMutableAttributedString alloc] initWithString:string];
    
    NSRange firstRange = [string rangeOfString:result];
    [attributedstr addAttribute:NSFontAttributeName
                          value:[UIFont boldSystemFontOfSize:25.0f]
                          range:firstRange];
    [attributedstr addAttribute:NSForegroundColorAttributeName
                          value:[UIColor whiteColor]
                          range:firstRange];
    
    NSRange secondRange = [string rangeOfString:restart];
    [attributedstr addAttribute:NSFontAttributeName
                          value:[UIFont boldSystemFontOfSize:15.0f]
                          range:secondRange];
    [attributedstr addAttribute:NSForegroundColorAttributeName
                          value:[UIColor colorWithWhite:1.0 alpha:0.5]
                          range:secondRange];
    
    self.label.attributedText = attributedstr;
}

#pragma mark - 动画

- (void)startCheckAnimation
{
    self.im_normal.userInteractionEnabled = NO;
    self.label.hidden = YES;
    
    [self.engineTransmissionSys reset];
    [self.chassisSys reset];
    [self.bodyworkSys reset];
    [self.networkSys reset];
    
    //开始动画
    POPBasicAnimation *normalZoomIn = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerScaleXY];
    normalZoomIn.fromValue = [NSValue valueWithCGSize:CGSizeMake(1.0, 1.0)];
    normalZoomIn.toValue = [NSValue valueWithCGSize:CGSizeMake(1.3, 1.3)];
    normalZoomIn.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    normalZoomIn.duration = 0.4;

    POPBasicAnimation *normalFadeOut = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerOpacity];
    normalFadeOut.fromValue = @(1.0f);
    normalFadeOut.toValue = @(0.0f);
    normalFadeOut.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    normalFadeOut.duration = 0.4;
    normalFadeOut.completionBlock = ^(POPAnimation *anim, BOOL finished){
        if (self.engineTransmissionSys.isOK && self.chassisSys.isOK && self.bodyworkSys.isOK && self.networkSys.isOK) {
            self.im_normal.image = [UIImage imageNamed:@"im_check_good"];
            [self updateLabel:YES];
        } else {
            self.im_normal.image = [UIImage imageNamed:@"im_check_warning"];
            [self updateLabel:NO];
        }
    };
    
    //结束动画
    POPBasicAnimation *normalZoomOut = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerScaleXY];
    normalZoomOut.fromValue = [NSValue valueWithCGSize:CGSizeMake(1.3, 1.3)];
    normalZoomOut.toValue = [NSValue valueWithCGSize:CGSizeMake(1.0, 1.0)];
    normalZoomOut.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    normalZoomOut.duration = 0.4;
    normalZoomOut.beginTime = CACurrentMediaTime() + 4;
    
    POPBasicAnimation *normalFadeIn = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerOpacity];
    normalFadeIn.fromValue = @(0.0f);
    normalFadeIn.toValue = @(1.0f);
    normalFadeIn.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    normalFadeIn.duration = 0.4;
    normalFadeIn.beginTime = CACurrentMediaTime() + 4;
    normalFadeIn.completionBlock = ^(POPAnimation *anim, BOOL finished){
        self.im_normal.userInteractionEnabled = YES;
        self.label.hidden = NO;
    };
    
    [self.im_normal.layer pop_addAnimation:normalZoomIn forKey:@"normalZoomIn"];
    [self.im_normal.layer pop_addAnimation:normalFadeOut forKey:@"normalFadeOut"];
    [self.im_normal.layer pop_addAnimation:normalZoomOut forKey:@"normalZoomOut"];
    [self.im_normal.layer pop_addAnimation:normalFadeIn forKey:@"normalFadeIn"];
    
    //检测动画
    POPBasicAnimation *checkFadeIn = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerOpacity];
    checkFadeIn.fromValue = @(0.0f);
    checkFadeIn.toValue = @(1.0f);
    checkFadeIn.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    checkFadeIn.duration = 0.4;
    
    POPBasicAnimation *checkRotation = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerRotation];
    checkRotation.toValue = @(degreesToRadian(360*3));
    checkRotation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    checkRotation.duration = 5.0;
    checkRotation.repeatForever = YES;
    
    POPBasicAnimation *checkFadeOut = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerOpacity];
    checkFadeOut.fromValue = @(1.0f);
    checkFadeOut.toValue = @(0.0f);
    checkFadeOut.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    checkFadeOut.duration = 0.4;
    checkFadeOut.beginTime = CACurrentMediaTime() + 4.0;
    
    
    [self.im_checking.layer pop_addAnimation:checkFadeIn forKey:@"checkFadeIn"];
    [self.im_checking.layer pop_addAnimation:checkRotation forKey:@"checkRotation"];
    [self.im_checking.layer pop_addAnimation:checkFadeOut forKey:@"checkFadeOut"];
    
    POPBasicAnimation *anim = [POPBasicAnimation linearAnimation];
    anim.duration = 4.0f;
    POPAnimatableProperty *prop = [POPAnimatableProperty propertyWithName:@"time" initializer:^(POPMutableAnimatableProperty *prop) {
        prop.writeBlock = ^(UIButton *obj, const CGFloat values[]) {
            CGFloat progress = values[0];
            if (progress < 1.0) {
                [self.engineTransmissionSys startAnimation];
            } else if (progress < 2.0) {
                [self.chassisSys startAnimation];
            } else if (progress < 3.0) {
                [self.bodyworkSys startAnimation];
            } else if (progress < 4.0) {
                [self.networkSys startAnimation];
            }
        };
    }];

    anim.property = prop;
    anim.fromValue = @(0.0f);
    anim.toValue = @(4.0f);

    [self pop_addAnimation:anim forKey:@"CountDownAnimation"];
}

@end

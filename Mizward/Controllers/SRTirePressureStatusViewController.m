//
//  SRTirePressureStatusViewController.m
//  Mizward
//
//  Created by zhangjunbo on 15/11/23.
//  Copyright © 2015年 Mizward. All rights reserved.
//

#import "SRTirePressureStatusViewController.h"
#import "SREventCenter.h"
#import "SRPortal.h"
#import "SRVehicleBasicInfo.h"
#import "SRVehicleStatusInfo.h"
#import <pop/POP.h>

@interface SRTirePressureStatusViewController ()

//左前轮
@property (weak, nonatomic) IBOutlet UILabel *lb_temp_lf;
@property (weak, nonatomic) IBOutlet UIImageView *im_lb_temp_lf;
@property (weak, nonatomic) IBOutlet UILabel *lb_pressure_lf;
@property (weak, nonatomic) IBOutlet UIImageView *im_pressure_lf;
@property (weak, nonatomic) IBOutlet UILabel *lb_battery_lf;
@property (weak, nonatomic) IBOutlet UIImageView *im_battery_lf;
@property (weak, nonatomic) IBOutlet UIImageView *ic_alert_lf;

//右前轮
@property (weak, nonatomic) IBOutlet UILabel *lb_temp_rf;
@property (weak, nonatomic) IBOutlet UIImageView *im_lb_temp_rf;
@property (weak, nonatomic) IBOutlet UILabel *lb_pressure_rf;
@property (weak, nonatomic) IBOutlet UIImageView *im_pressure_rf;
@property (weak, nonatomic) IBOutlet UILabel *lb_battery_rf;
@property (weak, nonatomic) IBOutlet UIImageView *im_battery_rf;
@property (weak, nonatomic) IBOutlet UIImageView *ic_alert_rf;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constantRFWheel;

//左后轮
@property (weak, nonatomic) IBOutlet UILabel *lb_temp_lb;
@property (weak, nonatomic) IBOutlet UIImageView *im_lb_temp_lb;
@property (weak, nonatomic) IBOutlet UILabel *lb_pressure_lb;
@property (weak, nonatomic) IBOutlet UIImageView *im_pressure_lb;
@property (weak, nonatomic) IBOutlet UILabel *lb_battery_lb;
@property (weak, nonatomic) IBOutlet UIImageView *im_battery_lb;
@property (weak, nonatomic) IBOutlet UIImageView *ic_alert_lb;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constrantLBWheel;

//右后轮
@property (weak, nonatomic) IBOutlet UILabel *lb_temp_rb;
@property (weak, nonatomic) IBOutlet UIImageView *im_lb_temp_rb;
@property (weak, nonatomic) IBOutlet UILabel *lb_pressure_rb;
@property (weak, nonatomic) IBOutlet UIImageView *im_pressure_rb;
@property (weak, nonatomic) IBOutlet UILabel *lb_battery_rb;
@property (weak, nonatomic) IBOutlet UIImageView *im_battery_rb;
@property (weak, nonatomic) IBOutlet UIImageView *ic_alert_rb;

@property (weak, nonatomic) UIBarButtonItem *adjustingItem;


@end

@implementation SRTirePressureStatusViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"胎压";
    self.navigationItem.rightBarButtonItem = self.adjustingItem;
    
    self.constrantLBWheel.constant *= iPhoneScale;
    self.constantRFWheel.constant *= iPhoneScale;
    
    [self.view bk_eachSubview:^(UIView *subview) {
        [subview bk_eachSubview:^(UIView *subview) {
            if ([subview isKindOfClass:[UILabel class]]) {
                [(UILabel *)subview setFont:[UIFont systemFontOfSize:iPhone6Plus?16.0f:14.0f]];
            }
        }];
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [[SREventCenter sharedInterface] addObserver:self observerQueue:dispatch_get_main_queue()];
    
    [self currentVehicleChange:[SRPortal sharedInterface].currentVehicleBasicInfo];
    
    if (!self.ic_alert_lf.hidden) {
        [self startWheelAnimation:self.ic_alert_lf];
    }
    if (!self.ic_alert_rf.hidden) {
        [self startWheelAnimation:self.ic_alert_rf];
    }
    if (!self.ic_alert_lb.hidden) {
        [self startWheelAnimation:self.ic_alert_lb];
    }
    if (!self.ic_alert_rb.hidden) {
        [self startWheelAnimation:self.ic_alert_rb];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    if (!self.ic_alert_lf.hidden) {
        [self.ic_alert_lf pop_removeAllAnimations];
    }
    if (!self.ic_alert_rf.hidden) {
        [self.ic_alert_rf pop_removeAllAnimations];
    }
    if (!self.ic_alert_lb.hidden) {
        [self.ic_alert_lb pop_removeAllAnimations];
    }
    if (!self.ic_alert_rb.hidden) {
        [self.ic_alert_rb pop_removeAllAnimations];
    }
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    [[SREventCenter sharedInterface] removeObserver:self observerQueue:dispatch_get_main_queue()];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - SREventCenter

- (void)currentVehicleChange:(SRVehicleBasicInfo *)basicInfo
{
 
}

#pragma mark -
#pragma mark Private

- (void)startWheelAnimation:(UIImageView *)view {
    
    [view pop_removeAllAnimations];
    
    __block NSInteger time = 0;
    POPBasicAnimation *alphaAnimation = [POPBasicAnimation easeInEaseOutAnimation];
    alphaAnimation.duration = 0.6f;
    POPAnimatableProperty *prop = [POPAnimatableProperty propertyWithName:@"alpha" initializer:^(POPMutableAnimatableProperty *prop) {
        prop.writeBlock = ^(UIButton *obj, const CGFloat values[]) {
            if (time%2==0) {
                view.alpha = values[0];
            } else {
                view.alpha = 1.0 - values[0];
            }
        };
    }];
    alphaAnimation.property = prop;
    alphaAnimation.completionBlock = ^(POPAnimation *anim, BOOL finished){
        ++time;
    };
    alphaAnimation.fromValue = @(0.8f);
    alphaAnimation.toValue = @(0.2f);
    alphaAnimation.repeatForever = YES;
    
    [view pop_addAnimation:alphaAnimation forKey:@"AlphaAnimation"];
}

- (void)stopWheelAnimation:(UIImageView *)view
{
    [view pop_removeAllAnimations];
}

#pragma mark -
#pragma mark Getter

- (UIBarButtonItem *)adjustingItem {
    if (_adjustingItem) {
        return _adjustingItem;
    }
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.showsTouchWhenHighlighted = YES;
    button.frame = CGRectMake(0, 0, NavigationBar_HEIGHT, NavigationBar_HEIGHT);
    [button setTitle:@"校准" forState:UIControlStateNormal];
    [button bk_whenTapped:^{
        [self performSegueWithIdentifier:@"PushSRTirePressureAdjustViewController" sender:nil];
    }];
    
    
    UIBarButtonItem *adjustingItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    
    _adjustingItem = adjustingItem;
    return _adjustingItem;
}

@end

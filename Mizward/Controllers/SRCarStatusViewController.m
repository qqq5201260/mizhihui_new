//
//  SRCarStatusViewController.m
//  SiRuiV4.0
//
//  Created by zhangjunbo on 15/6/15.
//  Copyright (c) 2015年 SiRui. All rights reserved.
//

#import "SRCarStatusViewController.h"
#import "SRUIUtil.h"
#import "SRUserDefaults.h"
#import "SRPortalRequest.h"
#import "SRPortalResponse.h"
#import "SRPortal.h"
#import "SREventCenter.h"
#import "SRKeychain.h"
#import "SROrderStartView.h"
#import "SRPortal+CarInfo.h"
#import "SRVehicleBasicInfo.h"
#import "SRPortal+User.h"
#import "SRPhoneApp.h"
#import "SRVehicleBasicInfo.h"
#import "SRVehicleStatusInfo.h"
#import "SRControlAlert.h"
#import "SRStatusView.h"
#import "SRControlView.h"
#import "SRTLV.h"
#import "SRLocationViewController.h"
#import "SREngineStartImageView.h"
#import "SRBaseImageView.h"
#import "SRArrowImageView.h"

#import "SRWebViewController.h"
#import "SRURLUtil.h"

#import <pop/POP.h>
#import <MJExtension/MJExtension.h>

const NSTimeInterval kStartAnimationDuration = 4; //4S动画
const NSTimeInterval kOtherAnimationDuration = 2; //2S动画

@interface SRCarStatusViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *im_car;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *car_centerX;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *car_centerY;

@property (weak, nonatomic) IBOutlet UIImageView *ic_engine;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *ic_engine_centerX;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *ic_engine_centerY;

@property (weak, nonatomic) IBOutlet UIImageView *ic_left_front_window;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *ic_left_front_window_horizontal;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *ic_left_front_window_vertical;

@property (weak, nonatomic) IBOutlet UIImageView *ic_left_front_door;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *ic_left_front_door_horizontal;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *ic_left_front_door_vertical;

@property (weak, nonatomic) IBOutlet UIImageView *ic_left_back_window;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *ic_left_back_window_horizontal;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *ic_left_back_window_vertical;

@property (weak, nonatomic) IBOutlet UIImageView *ic_left_back_door;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *ic_left_back_door_horizontal;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *ic_left_back_door_vertical;

@property (weak, nonatomic) IBOutlet UIImageView *ic_light_left;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *ic_light_left_horizontal;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *ic_light_left_vertical;

@property (weak, nonatomic) IBOutlet UIImageView *ic_light_right;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *ic_light_right_horizontal;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *ic_light_right_vertical;

//中间View
@property (weak, nonatomic) IBOutlet UIView *v_middle;

//底座
@property (weak, nonatomic) IBOutlet UIImageView *bg_car_base;

//底座动画
@property (weak, nonatomic) IBOutlet SRBaseImageView *im_base_animation;
@property (weak, nonatomic) IBOutlet SRArrowImageView *im_arrow;

//底座状态
@property (weak, nonatomic) IBOutlet UIImageView *ic_lock;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *ic_lock_centerY;
@property (weak, nonatomic) IBOutlet UIImageView *ic_temp;
@property (weak, nonatomic) IBOutlet UILabel *lb_temp;
@property (weak, nonatomic) IBOutlet UIImageView *ic_battery;

//底部控制View
@property (weak, nonatomic) IBOutlet UIView *v_bottom;
//启动按钮
@property (weak, nonatomic) IBOutlet SREngineStartImageView *bt_start;
//定位按钮
@property (weak, nonatomic) IBOutlet UIButton *bt_location;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bt_location_horizontal;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bt_location_vertical;
//寻车按钮
@property (weak, nonatomic) IBOutlet UIButton *bt_call;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bt_call_horizontal;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bt_call_vertical;
//寻车雷达
@property (weak, nonatomic) IBOutlet UIImageView *bt_call_mask;

//状态
@property (weak, nonatomic) SRStatusView *statusView;

//控制
@property (weak, nonatomic) SRControlView *controlView;

@end

@implementation SRCarStatusViewController

#pragma mark - 生命周期

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;

    [self initViews];
    
    @weakify(self)
    [RACObserve(self.ic_left_back_door, hidden) subscribeNext:^(NSNumber *hidden) {
        @strongify(self)
        if (hidden.boolValue) {
            [self.ic_left_back_door pop_removeAllAnimations];
        } else {
            [self startDoorWindowAnimation:self.ic_left_back_door];
        }
    }];
    [RACObserve(self.ic_left_back_window, hidden) subscribeNext:^(NSNumber *hidden) {
        @strongify(self)
        if (hidden.boolValue) {
            [self.ic_left_back_window pop_removeAllAnimations];
        } else {
            [self startDoorWindowAnimation:self.ic_left_back_window];
        }
    }];
    [RACObserve(self.ic_left_front_door, hidden) subscribeNext:^(NSNumber *hidden) {
        @strongify(self)
        if (hidden.boolValue) {
            [self.ic_left_front_door pop_removeAllAnimations];
        } else {
            [self startDoorWindowAnimation:self.ic_left_front_door];
        }
    }];
    [RACObserve(self.ic_left_front_window, hidden) subscribeNext:^(NSNumber *hidden) {
        @strongify(self)
        if (hidden.boolValue) {
            [self.ic_left_front_window pop_removeAllAnimations];
        } else {
            [self startDoorWindowAnimation:self.ic_left_front_window];
        }
    }];
    
    [RACObserve(self.lb_temp, text) subscribeNext:^(NSString *text) {
        @strongify(self)
        if ([text isEqualToString:@"--"]) {
            self.lb_temp.textColor = [UIColor lightGrayColor];
        } else {
            CGFloat temp = [text substringToIndex:text.length-1].floatValue;
            if (temp > 30) {
                self.lb_temp.textColor =  [UIColor colorWithRed:245.0/255.0 green:167.0/255.0 blue:65.0/255.0 alpha:1.0];
            } else if (temp >= 10) {
                self.lb_temp.textColor =  [UIColor colorWithRed:84.0/255.0 green:164.0/255.0 blue:115.0/255.0 alpha:1.0];
            } else {
                self.lb_temp.textColor = [UIColor blackColor];
            }
        }
    }];
    [RACObserve(self.ic_engine, hidden) subscribeNext:^(NSNumber *hidden) {
        @strongify(self)
        if (hidden.boolValue) {
            [self.ic_engine pop_removeAllAnimations];
        } else {
            [self startDoorWindowAnimation:self.ic_engine];
        }
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [SRUserDefaults updateCurrentVehicleID:self.basicInfo.vehicleID];
    
    [[SREventCenter sharedInterface] addObserver:self observerQueue:dispatch_get_main_queue()];
    
    [self currentVehicleChange:self.basicInfo];
    
    [self.im_base_animation startAnimations];
    [self.im_arrow startAnimations];
    [self.bt_start startAnimations];
    [self.statusView startAnimations];

    if (!self.ic_left_back_door.hidden) {
        [self startDoorWindowAnimation:self.ic_left_back_door];
    }
    if (!self.ic_left_back_window.hidden) {
        [self startDoorWindowAnimation:self.ic_left_back_window];
    }
    if (!self.ic_left_front_door.hidden) {
        [self startDoorWindowAnimation:self.ic_left_front_door];
    }
    if (!self.ic_left_front_window.hidden) {
        [self startDoorWindowAnimation:self.ic_left_front_window];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.statusView stopAnimations];
    [self.bt_start stopAnimations];
    [self.im_arrow stopAnimations];
    [self.im_base_animation stopAnimations];
    
    if (!self.ic_left_back_door.hidden) {
        [self.ic_left_back_door pop_removeAllAnimations];
    }
    if (!self.ic_left_back_window.hidden) {
        [self.ic_left_back_window pop_removeAllAnimations];
    }
    if (!self.ic_left_front_door.hidden) {
        [self.ic_left_front_door pop_removeAllAnimations];
    }
    if (!self.ic_left_front_window.hidden) {
        [self.ic_left_front_window pop_removeAllAnimations];
    }
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    [[SREventCenter sharedInterface] removeObserver:self observerQueue:dispatch_get_main_queue()];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
    if (!self.isViewLoaded || self.view.window) return;
    
//    NSLog(@"test");
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    UIViewController *vc = segue.destinationViewController;
    if ([vc isKindOfClass:[SRLocationViewController class]]) {
        [vc setValue:self.basicInfo forKey:@"basicInfo"];
    }
}

#pragma mark - SREventCenter

- (void)currentVehicleChange:(SRVehicleBasicInfo *)basicInfo
{
    SRLogDebug(@"---------------UI------------------");
    SRLogDebug(@"%@", basicInfo.status.keyValues);
    SRLogDebug(@"------------------------------------");
    
    [self.controlView updateAbilities:basicInfo.abilities_v2];
    
    [self.statusView updateStatusInfo:basicInfo.status];
    
    self.im_car.image = [UIImage imageNamed:basicInfo.status.isOnline==1?@"im_car":@"im_car_offline"];
    
    self.ic_engine.hidden = basicInfo.status.engineStatus!=1 || basicInfo.status.isOnline!=1;
//    self.ic_engine.hidden = NO;
    
    self.ic_left_front_window.hidden = basicInfo.status.windowLF!=1 || basicInfo.status.isOnline!=1;
    self.ic_left_front_door.hidden = basicInfo.status.doorLF!=1 || basicInfo.status.isOnline!=1;
    self.ic_left_back_window.hidden = basicInfo.status.windowLB!=1 || basicInfo.status.isOnline!=1;
    self.ic_left_back_door.hidden = basicInfo.status.doorLB!=1 || basicInfo.status.isOnline!=1;
    
    self.ic_light_left.hidden = basicInfo.status.lightBig!=1 || basicInfo.status.isOnline!=1;
    self.ic_light_right.hidden = basicInfo.status.lightBig!=1 || basicInfo.status.isOnline!=1;
    
    if (basicInfo.status.isOnline != 1
        || basicInfo.status.doorLock == 0) {
        self.ic_lock.image = [UIImage imageNamed:@"ic_lock_0"];
    } else {
        self.ic_lock.image = [UIImage imageNamed:basicInfo.status.doorLock==1?@"ic_lock_1":@"ic_lock_2"];
    }
    
    if (basicInfo.status.isOnline == 1
        && basicInfo.status.tempStatus == 1) {
        self.ic_temp.image = [UIImage imageNamed:@"ic_temp_1"];
        self.lb_temp.text = [NSString stringWithFormat:@"%.1lf℃", basicInfo.status.temp];
    } else {
        self.ic_temp.image = [UIImage imageNamed:@"ic_temp_0"];
        self.lb_temp.text = @"--";
    }
    
    if (basicInfo.status.isOnline != 1
        || basicInfo.status.electricityStatus == 0) {
        self.ic_battery.image = [UIImage imageNamed:@"ic_battery_0"];
    } else {
        self.ic_battery.image = [UIImage imageNamed:basicInfo.status.electricityStatus==1?@"ic_battery_1":@"ic_battery_2"];
    }
}

#pragma mark - 交互事件

- (IBAction)buttonLocationPressed:(id)sender {
    
//    [self test:nil];
//    return;
    
//    [self updateAbility:SRControlAbilityType_Support];
//    return;

    if (![self checkLoginStatus]) {
        return;
    }
    
    if (![self.basicInfo hasTerminal]) {
        [SRUIUtil showBindTerminalAlert];
        return;
    }
    
    if (self.basicInfo.onlyPPKE) {
        [SRUIUtil showAlertMessage:@"当前车辆不支持坐标查询"];
        return;
    }
    
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] init];
    backItem.title = @"首页";
    self.navigationItem.backBarButtonItem = backItem;
    [self performSegueWithIdentifier:@"PushSRLocationViewController" sender:nil];
}

- (IBAction)buttonCallPressed:(id)sender {
//    [self updateAbility:SRControlAbilityType_Unsupport];
//    return;
    
    [self.controlView SendCmd:TLVTag_Instruction_Call withSuccessBlock:^{
        //雷达动画
        POPBasicAnimation *rotation = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerRotation];
        rotation.toValue = @(degreesToRadian(360*6));
        rotation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
        rotation.duration = kStartAnimationDuration * 2;
        [self.bt_call_mask.layer pop_addAnimation:rotation forKey:@"rotation"];
    }];
}

- (IBAction)middleSwipeGestureRecognizerHandler:(id)sender {
    [self.controlView showOrDismissControlView:YES animation:YES];
}

#pragma mark - 私有方法

- (void)initViews {
    
    self.ic_engine_centerX.constant *= iPhoneScale;
    self.ic_engine_centerY.constant *= iPhoneScale;
    
    //车辆状态
    self.ic_left_front_window_vertical.constant *= iPhoneScale;
    self.ic_left_front_window_horizontal.constant *= iPhoneScale;
    self.ic_left_front_door_vertical.constant *= iPhoneScale;
    self.ic_left_front_door_horizontal.constant *= iPhoneScale;
    self.ic_left_back_window_vertical.constant *= iPhoneScale;
    self.ic_left_back_window_horizontal.constant *= iPhoneScale;
    self.ic_left_back_door_vertical.constant *= iPhoneScale;
    self.ic_left_back_door_horizontal.constant *= iPhoneScale;
    self.ic_light_left_horizontal.constant *= iPhoneScale;
    self.ic_light_left_vertical.constant *= iPhoneScale;
    self.ic_light_right_vertical.constant *= iPhoneScale;
    self.ic_light_right_horizontal.constant *= iPhoneScale;
    
    [self startDoorWindowAnimation:self.ic_left_back_door];
    
    //背景点击事件
    [self.view bk_whenTapped:^{
        [self.controlView showOrDismissControlView:NO animation:YES];
    }];
    
    //车辆
    self.car_centerX.constant *= iPhoneScale;
    self.car_centerY.constant *= iPhoneScale;

    //中间
    self.v_middle.layer.masksToBounds = NO;
    [self.v_middle bk_whenTapped:^{
        [self.controlView showOrDismissControlView:YES animation:YES];
    }];
    
    //控制遮罩
    self.controlView.hidden = YES;
    
    //底座动画
    self.ic_lock_centerY.constant *= iPhoneScale;
    
    //底部
    self.v_bottom.backgroundColor = [UIColor defaultBackgroundColor];
    
    //启动按钮
    [self.bt_start bk_whenTapped:^{
        [self.controlView SendCmd:TLVTag_Instruction_EngineOn withSuccessBlock:nil];
    }];
    
    //定位按钮
    self.bt_location_horizontal.constant *= iPhoneScale;
    self.bt_location_vertical.constant *= iPhoneScale;
    
    //寻车按钮
    self.bt_call.layer.shadowColor = [UIColor blackColor].CGColor;
    self.bt_call.layer.shadowOffset = CGSizeMake(0.5, 0.5);
    self.bt_call.layer.shadowOpacity = 0.35;//阴影透明度，默认0
    self.bt_call_horizontal.constant *= iPhoneScale;
    self.bt_call_vertical.constant *= iPhoneScale;
    
    self.statusView.hidden = NO;
    
    void (^loadDetail)() = ^() {
        if (![self checkLoginStatus]) {
            return;
        }
        
        if (![self.basicInfo hasTerminal]) {
            [SRUIUtil showBindTerminalAlert];
            return;
        }
        
        SRWebViewController *vc = [[SRWebViewController alloc] init];
        vc.title = @"车辆详情";
        vc.url = [SRURLUtil Portal_StatusDetail];
        [self.navigationController pushViewController:vc animated:YES];
    };
    
    self.ic_lock.userInteractionEnabled = YES;
    self.ic_temp.userInteractionEnabled = YES;
    self.lb_temp.userInteractionEnabled = YES;
    self.ic_battery.userInteractionEnabled = YES;
    self.im_arrow.userInteractionEnabled = YES;
    [self.ic_lock bk_whenTapped:^{
        loadDetail();
    }];
    [self.ic_temp bk_whenTapped:^{
        loadDetail();
    }];
    [self.lb_temp bk_whenTapped:^{
        loadDetail();
    }];
    [self.ic_battery bk_whenTapped:^{
        loadDetail();
    }];
    [self.im_arrow bk_whenTapped:^{
        loadDetail();
    }];
}

- (void)startDoorWindowAnimation:(UIImageView *)view {

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
    alphaAnimation.fromValue = @(1.0f);
    alphaAnimation.toValue = @(0.4f);
    alphaAnimation.repeatForever = YES;
    
    [view pop_addAnimation:alphaAnimation forKey:@"AlphaAnimation"];
}

- (void)stopDoorWindowAnimation:(UIImageView *)view
{
    [view pop_removeAllAnimations];
}

#pragma mark - Getter

- (SRStatusView *)statusView {
    if (_statusView) {
        return _statusView;
    }
    
    SRStatusView *statusView = [SRStatusView instanceStatusView];
    [self.view addSubview:statusView];
    [statusView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).with.offset(20.0f);
        make.bottom.equalTo(self.v_middle.mas_top).with.offset(40.0f);
        make.width.equalTo(statusView.width*iPhoneScale - (iPhone6Plus?2.0f:0.0f));
        make.height.equalTo(statusView.height*iPhoneScale);
    }];
    
    _statusView = statusView;
    
    return _statusView;
}

- (SRControlView *)controlView {
    if (_controlView) {
        return _controlView;
    }
    
    SRControlView *controlView = [SRControlView instanceControlView];
    [self.v_middle insertSubview:controlView belowSubview:self.bg_car_base];
    [controlView makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.v_middle);
        make.centerY.equalTo(self.v_middle).with.offset(controlView.dismissCenterY);
    }];
    
    _controlView = controlView;
    return _controlView;
}

#pragma mark - DEBUG

- (void)updateAbility:(SRControlAbilityType)type {
    NSMutableArray *array = [NSMutableArray array];
    for (NSInteger tag = TLVTag_Ability_Lock; tag<=TLVTag_Ability_SkyOpen; ++tag) {
        SRTLV *tlv = [[SRTLV alloc] init];
        tlv.tag = tag;
        tlv.value = [NSString stringWithFormat:@"%@", @(type)];
        [array addObject:tlv];
    }
    
    [self.controlView updateAbilities:array];
}

@end

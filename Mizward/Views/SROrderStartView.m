//
//  SROrderStartView.m
//  SiRuiV4.0
//
//  Created by zhangjunbo on 15/6/24.
//  Copyright (c) 2015年 SiRui. All rights reserved.
//

#import "SROrderStartView.h"
#import "SRUIUtil.h"
#import "SRAPNsOrderStartInfo.h"
#import "SRPhoneApp.h"
#import "SRUserDefaults.h"
#import "SRNotificationCenter.h"
#import "SRKeychain.h"
#import <IQKeyboardManager/IQKeyboardManager.h>
#import <pop/POP.h>
#import <LocalAuthentication/LocalAuthentication.h>

const static CGFloat kCustomIOS7MotionEffectExtent                = 10.0;

@interface SROrderStartView ()

@property (weak, nonatomic) IBOutlet UILabel *lb_title;
@property (weak, nonatomic) IBOutlet UIButton *bt_close;
@property (weak, nonatomic) IBOutlet UIView *v_separater;

@property (weak, nonatomic) IBOutlet UILabel *lb_message;

@property (weak, nonatomic) IBOutlet UIView *v_dynamic;
@property (weak, nonatomic) IBOutlet UITextField *tx_password;
@property (weak, nonatomic) IBOutlet UIButton *bt_check;

@property (weak, nonatomic) IBOutlet UIButton *bt_engineOn;

@property (strong, nonatomic) UIView *maskView;

@property (nonatomic, copy) NSString *customerName;
@property (nonatomic, copy) NSString *startTime;
@property (nonatomic, copy) NSString *plateNumber;
@property (nonatomic, copy) NSString *startTimeLength;
@property (nonatomic, copy) NSString *temperature;
@property (nonatomic, copy) NSString *vehicleID;
@property (nonatomic, copy) NSString *startClockID;

@end

@implementation SROrderStartView
{
    CGFloat deltaY;
    CGFloat duration;
}

+ (SROrderStartView *)instanceCustomView
{
    NSArray *nibView = [[NSBundle mainBundle] loadNibNamed:@"SROrderStartView" owner:nil options:nil];
    return [nibView objectAtIndex:0];
}

- (void)dealloc {
    [SRNotificationCenter sr_removeObserver:self];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    if (![SRUserDefaults isLogin] || [SRUserDefaults needInputPassword]) {
        [SRNotificationCenter sr_addObserver:self selector:@selector(keyboardWillShowNotification:) name:UIKeyboardWillShowNotification object:nil];
        [SRNotificationCenter sr_addObserver:self selector:@selector(keyboardWillHideNotification:) name:UIKeyboardWillHideNotification object:nil];
    }
    
    self.layer.shouldRasterize = YES;
    self.layer.rasterizationScale = [[UIScreen mainScreen] scale];
    self.layer.cornerRadius = 10.0f;
    self.layer.masksToBounds = YES;
    
    [self bk_whenTapped:^{
        
    }];
    
    self.lb_title.text = @"预约启动";
    
    self.v_separater.backgroundColor = [UIColor defaultColor];
    self.v_dynamic.backgroundColor = [UIColor whiteColor];
    
    [self.bt_check setImage:[UIImage imageNamed:@"bt_alert_check"] forState:UIControlStateSelected];
    [self.bt_check bk_whenTapped:^{
        self.bt_check.selected ^= 1;
        [SRUserDefaults updatePasswrodAvoidStatus:self.bt_check.selected];
    }];
    
    self.tx_password.keyboardType = [[SRKeychain Password] isNumber]?UIKeyboardTypeNumberPad:UIKeyboardTypeDefault;
    UIButton *bt_encrypted = [[UIButton alloc] initWithFrame:CGRectMake(.0f, .0f, self.tx_password.height, self.tx_password.height)];
    [bt_encrypted setImage:[UIImage imageNamed:@"ic_encrypted"] forState:UIControlStateNormal];
    [bt_encrypted setImage:[UIImage imageNamed:@"ic_unencrypted"] forState:UIControlStateSelected];
    [bt_encrypted bk_whenTapped:^{
        bt_encrypted.selected ^= 1;
        self.tx_password.secureTextEntry ^= 1;
    }];
    self.tx_password.rightView = bt_encrypted;
    self.tx_password.rightViewMode = UITextFieldViewModeAlways;
    self.tx_password.layer.borderColor = [UIColor blackColor].CGColor;
    self.tx_password.layer.borderWidth = 1.0f;
    [self.tx_password bk_addEventHandler:^(UITextField *sender) {
        BOOL isCorrect = [sender.text isEqualToString:[SRKeychain Password]];
        sender.layer.borderColor = isCorrect?[UIColor blackColor].CGColor:[UIColor inputErrorColor].CGColor;
    } forControlEvents:UIControlEventEditingChanged];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    if (self.info) {
        self.customerName = self.info.cn;
        self.vehicleID = self.info.vID;
        self.startTime = self.info.st;
        self.startTimeLength = self.info.stl;
        self.temperature = self.info.temp&&self.info.temp.length>0?self.info.temp:@"--";
        self.plateNumber = self.info.pn;
        self.startClockID = self.info.scID;
    }
    
    NSString *startTimeLengthStr = [NSString stringWithFormat:SRLocal(@"%@ minute"), self.startTimeLength];
    NSString *temperatureStr = [NSString stringWithFormat:@"%@℃", self.temperature];
    
    //调整消息框
    NSString *message = [NSString stringWithFormat:SRLocal(@"string_order_start_alert"), self.startTime, self.plateNumber, startTimeLengthStr, temperatureStr];
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:message];
    UIColor *color = [UIColor colorWithRed:72.0/255.0 green:142.0/255.0 blue:168.0/255.0 alpha:1.0];
    NSRange range = [message rangeOfString:self.startTime];
    [string addAttribute:NSForegroundColorAttributeName
                   value:color
                   range:range];
    
    range = [message rangeOfString:self.plateNumber];
    [string addAttribute:NSForegroundColorAttributeName
                   value:color
                   range:range];
    
//    range = [message rangeOfString:self.startTime];
//    [string addAttribute:NSForegroundColorAttributeName
//                   value:color
//                   range:range];
    
    range = [message rangeOfString:startTimeLengthStr];
    [string addAttribute:NSForegroundColorAttributeName
                   value:color
                   range:range];
    
    range = [message rangeOfString:temperatureStr];
    [string addAttribute:NSForegroundColorAttributeName
                   value:color
                   range:range];
    
    self.lb_message.attributedText = string;
    
    CGSize labelSize = [message sizeWithWidth:self.lb_message.width font:self.lb_message.font];
    self.lb_message.height = labelSize.height;
    
    CGFloat newHeight = self.lb_message.top + labelSize.height;

    //调整密码框
    if (![SRUserDefaults isLogin] || [SRUserDefaults needInputPassword]) {
        self.v_dynamic.fd_collapsed = NO;
        self.v_dynamic.hidden = NO;
        newHeight += self.v_dynamic.height;
    } else {
        self.v_dynamic.fd_collapsed = YES;
        self.v_dynamic.hidden = YES;
    }

    newHeight += self.bt_engineOn.height + 10.0;
    
    self.height = newHeight;
}

- (void)removeFromSuperview
{
    [SRNotificationCenter sr_removeObserver:self];
    
    [super removeFromSuperview];
}

#pragma mark - UIKeyboad Notification Handler

- (void)keyboardWillShowNotification: (NSNotification *)notification
{
    if (!self.window) return;
    
    //textField左下角在屏幕中的位置
//    CGPoint  textLeftBottom = [self.tx_password convertPoint:CGPointMake(0, self.tx_password.bottom)
//                                                      toView:self.window];
    
    CGFloat textLeftBottomY = self.top + self.bt_check.top + self.v_dynamic.top;
    
    //键盘左上角在屏幕中的位置
    CGPoint keyboardLeftTop = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].origin;
    
    duration = [[[notification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    
//    deltaY = keyboardLeftTop.y - textLeftBottom.y;
    deltaY = keyboardLeftTop.y - textLeftBottomY - self.bt_check.height - self.bt_engineOn.height;
    
    if (deltaY < 0) {
        [self updateConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.maskView).with.offset(self->deltaY);
        }];
        
        [self.maskView setNeedsUpdateConstraints];
        [self.maskView updateConstraintsIfNeeded];
        [UIView animateWithDuration:duration animations:^{
            [self layoutIfNeeded];
        }];
    }
}

- (void)keyboardWillHideNotification: (NSNotification *)notification
{
    if (!self.window) return;
    
    [self updateConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.maskView);
    }];
    
    [self.maskView setNeedsUpdateConstraints];
    [self.maskView updateConstraintsIfNeeded];
    [UIView animateWithDuration:duration animations:^{
        [self layoutIfNeeded];
    }];
}

#pragma mark - Public

- (void)show
{
    if ([SRUserDefaults isLogin] && [SRUserDefaults needInputPassword] && [SRUserDefaults isTouchIDOpen]) {
        [self showTouchID];
    } else {
        [self showView];
    }
}

- (void)dissmiss
{
    [IQKeyboardManager sharedManager].enableAutoToolbar = YES;
    
    CATransform3D currentTransform = self.layer.transform;
    
    if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_7_1) {
        CGFloat startRotation = [[self valueForKeyPath:@"layer.transform.rotation.z"] floatValue];
        CATransform3D rotation = CATransform3DMakeRotation(-startRotation + M_PI * 270.0 / 180.0, 0.0f, 0.0f, 0.0f);
        
        self.layer.transform = CATransform3DConcat(rotation, CATransform3DMakeScale(1, 1, 1));
    }
    
    self.layer.opacity = 1.0f;
    
    self.isShowing = NO;
    
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
                         
                         if (self.dismissBlock) {
                             self.dismissBlock();
                         }
                     }
     ];
}

#pragma mark - 私有方法

- (void)showView {
    [IQKeyboardManager sharedManager].enableAutoToolbar = NO;
    
    UIView *superView = [SRUIUtil rootViewController].view;
    [superView addSubview:self.maskView];
    [self.maskView makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.equalTo(superView);
    }];
    
    [self.maskView addSubview:self];
    [self makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.maskView);
        make.size.equalTo(CGSizeMake(self.width, self.height));
    }];
    
    self.isShowing = YES;
    
    self.layer.opacity = 0.5f;
    self.layer.transform = CATransform3DMakeScale(1.3f, 1.3f, 1.0);
    [UIView animateWithDuration:0.2f delay:0.0 options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         self.maskView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4f];
                         self.layer.opacity = 1.0f;
                         self.layer.transform = CATransform3DMakeScale(1, 1, 1);
                     } completion:^(BOOL finished) {
                         if (!self.v_dynamic.hidden) {
                             [self.tx_password becomeFirstResponder];
                         }
                     }
     ];
}

- (void)showTouchID {
    LAContext *myContext = [[LAContext alloc] init];
    NSString *myLocalizedReasonString = self.lb_message.attributedText.string;
    
    [myContext evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics
              localizedReason:myLocalizedReasonString
                        reply:^(BOOL success, NSError *error) {
                            [self executeOnMain:^{
                                
                                if (success) {
                                    if (self.dismissBlock) {
                                        self.dismissBlock();
                                    }
                                    return ;
                                }
                                
                                switch (error.code) {
                                    case LAErrorUserCancel:
                                        
                                        break;
                                        
                                    case LAErrorAuthenticationFailed:
                                    {
                                        [SRUIUtil showAlertCancelableWithTitle:@"提示" message:@"指纹验证失败" doneButton:@"输入密码" andDoneBlock:^{
                                            [self showView];
                                        }];
                                    }
                                        break;
                                        
                                    case LAErrorPasscodeNotSet:
                                    {
                                        [SRUIUtil showAlertCancelableWithTitle:@"提示" message:@"请先在系统中设置指纹" doneButton:@"输入密码" andDoneBlock:^{
                                            [self showView];
                                        }];
                                    }
                                        break;
                                        
                                    case LAErrorSystemCancel:
                                        [self showView];
                                        break;
                                        
                                    case LAErrorUserFallback:
                                        [self showView];
                                        break;
                                        
                                    default:
                                        [self showView];
                                        break;
                                }
                                
                            } afterDelay:0];
                        }];

}


#pragma mark - 交互事件

- (IBAction)buttonClosePressed:(id)sender {
    [self dissmiss];
}

- (IBAction)buttonEngineOnPressed:(id)sender {
    
    [SRUIUtil endEditing];
    
    if (!self.v_dynamic.fd_collapsed && ![self.tx_password.text isEqualToString:[SRKeychain Password]]) {
        self.lb_title.text = @"密码错误";
        [self.tx_password shake:6 withDelta:2];
        return;
    }
    
    CompleteBlock block = ^(NSError *error, id responseObject){
        [SRUIUtil dissmissLoadingHUD];
        if (error) {
            [SRUIUtil showAlertMessage:error.domain];
        } else {
            [SRUIUtil showAutoDisappearHUDWithMessage:responseObject isDetail:NO];
            [self dissmiss];
        }
    };
    
    [SRUIUtil showLoadingHUDWithTitle:nil];
    if (![SRUserDefaults isLogin]) {
        [SRPhoneApp sendControlCmdToServer:TLVTag_Instruction_EngineOn
                              withUserName:self.customerName
                                  password:[SRKeychain Password]
                                 vehicleID:self.vehicleID.integerValue
                               andEndBlock:block];
    } else {
        [SRPhoneApp sendControlCommandWithCmd:TLVTag_Instruction_EngineOn
                                    vehicleID:self.vehicleID.integerValue
                             andCompleteBlock:block];
    }
    
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
    [maskView bk_whenTapped:^{
        [SRUIUtil endEditing];
    }];
    
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

#pragma mark - Setter

- (void)setInfo:(SRAPNsOrderStartInfo *)info
{
    _info = info;
    [self layoutSubviews];
}

@end

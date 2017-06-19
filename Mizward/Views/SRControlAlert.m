//
//  SRControlAlert.m
//  SiRuiV4.0
//
//  Created by zhangjunbo on 15/7/22.
//  Copyright (c) 2015年 SiRui. All rights reserved.
//

#import "SRControlAlert.h"
#import "SRUIUtil.h"
#import "SRUserDefaults.h"
#import "SRKeychain.h"
#import "SRNotificationCenter.h"
#import <IQKeyboardManager/IQKeyboardManager.h>
#import <LocalAuthentication/LocalAuthentication.h>

const static CGFloat kCustomIOS7MotionEffectExtent                = 10.0;

@interface SRControlAlert ()

@property (weak, nonatomic) IBOutlet UIButton *bt_close;

@property (weak, nonatomic) IBOutlet UIButton *bt_title;

@property (weak, nonatomic) IBOutlet UIView *v_separater;
@property (weak, nonatomic) IBOutlet UILabel *lb_message;

@property (weak, nonatomic) IBOutlet UITextField *tx_password;
@property (weak, nonatomic) IBOutlet UIButton *bt_check;

@property (strong, nonatomic) UIView *maskView;

@end

@implementation SRControlAlert
{
    CGFloat deltaY;
    CGFloat duration;
    CGPoint keyboardLeftTop;
    
    CGFloat keyboardDistanceFromTextField;
}

+ (SRControlAlert *)instanceControlAlert
{
    NSArray *nibView = [[NSBundle mainBundle] loadNibNamed:@"SRControlAlert" owner:nil options:nil];
    return [nibView objectAtIndex:0];
}

- (void)dealloc {
    [SRNotificationCenter sr_removeObserver:self];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [SRNotificationCenter sr_addObserver:self selector:@selector(keyboardWillShowNotification:) name:UIKeyboardWillShowNotification object:nil];
    [SRNotificationCenter sr_addObserver:self selector:@selector(keyboardWillHideNotification:) name:UIKeyboardWillHideNotification object:nil];
    
    self.layer.shouldRasterize = YES;
    self.layer.rasterizationScale = [[UIScreen mainScreen] scale];
    self.layer.cornerRadius = 10.0f;
    self.layer.masksToBounds = YES;
    
    [self bk_whenTapped:^{
        
    }];
    
    [self.bt_title setTitle:@"输入密码"
                   forState:UIControlStateNormal];
    [self.bt_title setTitleColor:[UIColor defaultColor] forState:UIControlStateNormal];
    
    [self.bt_check setImage:[UIImage imageNamed:@"bt_alert_check"] forState:UIControlStateSelected];
    self.bt_check.selected = [SRUserDefaults passwordAvoidStatus];
    [self.bt_check bk_whenTapped:^{
        self.bt_check.selected ^= 1;
    }];
    
    keyboardDistanceFromTextField = self.bt_check.height*3;
    
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
    self.tx_password.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.tx_password.layer.borderWidth = 1.0f;
    [self.tx_password bk_addEventHandler:^(UITextField *sender) {
        if (![sender.text isEqualToString:[SRKeychain Password]]) {
            sender.layer.borderColor = [UIColor inputErrorColor].CGColor;
            return ;
        }
        
        [SRUserDefaults updatePasswrodAvoidStatus:self.bt_check.selected];
        
        [self dissmiss];
        
        if (self.doneBlock) {
            self.doneBlock();
        }

    } forControlEvents:UIControlEventEditingChanged];
    
    
}

//调整View
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGSize messageSize = [self.lb_message.text sizeWithWidth:self.lb_message.width font:self.lb_message.font];
    CGFloat deltaHeight = messageSize.height - self.lb_message.height;
    self.lb_message.viewSize = messageSize;
    self.height += deltaHeight;
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
//                                                      toView:self.maskView];
    
    CGFloat textLeftBottomY = self.top + self.bt_check.top;
    
    //键盘左上角在屏幕中的位置
    keyboardLeftTop = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].origin;
    
    duration = [[[notification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    
//    deltaY = keyboardLeftTop.y - textLeftBottom.y;
    deltaY = keyboardLeftTop.y - textLeftBottomY - keyboardDistanceFromTextField;
    
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

#pragma mark - 交互事件

- (IBAction)buttonClosePressed:(id)sender {
    [self dissmiss];
}

#pragma mark - Public

- (void)showWithMessage:(NSString *)message andDoneBlock:(void (^)())doneBlock
{
    self.doneBlock = doneBlock;
    self.lb_message.text = message;
    
    [self layoutSubviews];
    
    if ([SRUserDefaults isTouchIDOpen]) {
        [self showTouchID];
    } else {
        [self show];
    }
}

#pragma mark - 私有方法

- (void)show
{
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
                         [self.tx_password becomeFirstResponder];
                     }
     ];
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
    
    self.isShowing = NO;
    
    self.layer.opacity = 1.0f;
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
                         
                         if (self.cancelBlock) {
                             self.cancelBlock();
                         }
                     }
     ];
}

- (void)showTouchID {
    
    LAContext *myContext = [[LAContext alloc] init];
    NSString *myLocalizedReasonString = self.lb_message.text;
    
    [myContext evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics
              localizedReason:myLocalizedReasonString
                        reply:^(BOOL success, NSError *error) {
                            [self executeOnMain:^{
                                
                                if (success) {
                                    if (self.doneBlock) {
                                        self.doneBlock();
                                    }
                                    return ;
                                }
                                
                                switch (error.code) {
                                    case LAErrorUserCancel:

                                        break;
                                        
                                    case LAErrorAuthenticationFailed:
                                    {
                                        [SRUIUtil showAlertCancelableWithTitle:@"提示" message:@"指纹验证失败" doneButton:@"输入密码" andDoneBlock:^{
                                            [self show];
                                        }];
                                    }
                                        break;
                                        
                                    case LAErrorPasscodeNotSet:
                                    {
                                        [SRUIUtil showAlertCancelableWithTitle:@"提示" message:@"请先在系统中设置指纹" doneButton:@"输入密码" andDoneBlock:^{
                                            [self show];
                                        }];
                                    }
                                        break;
                                        
                                    case LAErrorSystemCancel:
                                        [self show];
//                                            alert.message = @"System cancelled authentication";
                                        break;
                                        
                                    case LAErrorUserFallback:
                                        [self show];
//                                            alert.message = @"You chosed to try password";
                                        break;
                                        
                                    default:
                                        [self show];
//                                            alert.message = @"You cannot access to private content!";
                                        break;
                                }
                                
                            } afterDelay:0];
                        }];
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


@end

//
//  SRUIUtil.m
//  SiRuiV4.0
//
//  Created by zhangjunbo on 15/6/15.
//  Copyright (c) 2015年 SiRui. All rights reserved.
//

#import "SRUIUtil.h"
#import "SRNotificationCenter.h"
#import "SRURLUtil.h"
#import "AppDelegate.h"
#import "SRUserDefaults.h"
#import "SRPortal+OrderStart.h"
#import "SRPortal+Login.h"
#import "SROrderStartViewController.h"
#import "SROrderStartView.h"
#import "SRLoginViewController.h"
#import "SRKeychain.h"
#import "SRWelcomeViewController.h"
#import "SRCustomerServiceViewController.h"
#import "SRMessageCenterViewController.h"
#import <MBProgressHUD/MBProgressHUD.h>
#import <BlocksKit/BlocksKit.h>
#import <objc/runtime.h>
#import <AVFoundation/AVFoundation.h>
#import <ObjcAssociatedObjectHelpers/ObjcAssociatedObjectHelpers.h>
#import <LocalAuthentication/LocalAuthentication.h>

static const void *kPhoneCallWebViewKey = &kPhoneCallWebViewKey;
static const void *kLoadingHUDKey       = &kLoadingHUDKey;
static const void *kOrderStartViewKey   = &kOrderStartViewKey;
static const void *kExperienceAlert     = &kExperienceAlert;

@interface SRUIUtil ()

Singleton_Interface(SRUIUtil)

@end

@implementation SRUIUtil

Singleton_Implementation(SRUIUtil)

SYNTHESIZE_ASC_OBJ(orderStartView, setOrderStartView);

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __block id observer = [SRNotificationCenter sr_addObserverForName:UIApplicationDidFinishLaunchingNotification object:nil queue:nil usingBlock:^(NSNotification *note) {
            [SRNotificationCenter sr_removeObserver:observer];
            
            //注册APNS
            [self registerForRemoteNotification];
        }];
    });
}

+ (void)callWithPhoneNumber:(NSString *)phoneNumber
{
    UIWebView *phoneCallWebView = objc_getAssociatedObject(self, kPhoneCallWebViewKey);
    if (!phoneCallWebView) {
        phoneCallWebView = [[UIWebView alloc] initWithFrame:CGRectZero];
        objc_setAssociatedObject(self, kPhoneCallWebViewKey, phoneCallWebView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    
    NSURL *phoneURL = [NSURL URLWithString:[NSString stringWithFormat:@"tel:%@",phoneNumber]];
    [phoneCallWebView loadRequest:[NSURLRequest requestWithURL:phoneURL]];
}

+ (void)jumpToAppStore
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[SRURLUtil appStore]]];
}

+ (void)registerForRemoteNotification
{
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8.0")) {
        [[UIApplication sharedApplication] registerUserNotificationSettings:
         [UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge)
                                           categories:nil]];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
    } else {
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:
         (UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert)];
    }
}

+ (void)showAlertMessage:(NSString *)message
{
    [self showAlertWithTitle:SRLocal(@"title_alert") message:message andCancelButton:SRLocal(@"bt_sure")];
}

+ (void)showAlertWithTitle:(NSString *)title message:(NSString *)message andCancelButton:(NSString *)button
{
    [UIAlertView bk_showAlertViewWithTitle:title message:message cancelButtonTitle:button otherButtonTitles:nil handler:nil];
}

+ (void)showAlertWithTitle:(NSString *)title message:(NSString *)message doneButton:(NSString *)button andDoneBlock:(void(^)())doneBlock
{
    [UIAlertView bk_showAlertViewWithTitle:title message:message cancelButtonTitle:button otherButtonTitles:nil handler:^(UIAlertView *alertView, NSInteger buttonIndex) {
        if (doneBlock) doneBlock();
    }];
}

+ (void)showAlertCancelableWithTitle:(NSString *)title message:(NSString *)message doneButton:(NSString *)button andDoneBlock:(void (^)())doneBlock
{
    [UIAlertView bk_showAlertViewWithTitle:title message:message cancelButtonTitle:@"取消" otherButtonTitles:@[button] handler:^(UIAlertView *alertView, NSInteger buttonIndex) {
        if (buttonIndex != alertView.cancelButtonIndex) {
            doneBlock();
        }
    }];
}

+ (void)showReloginAlertWithMessage:(NSString *)message doneButton:(NSString *)button
{
    [UIAlertView bk_showAlertViewWithTitle:@"提示"
                                   message:message
                         cancelButtonTitle:@"重新登录"
                         otherButtonTitles:nil
                                   handler:^(UIAlertView *alertView, NSInteger buttonIndex) {
                                       [SRPortal logoutWithCompleteBlock:nil];
                                       [self ModalSRLoginViewController];
                                   }];
}

+ (void)showBindTerminalAlert
{
    [UIAlertView bk_showAlertViewWithTitle:@"提示" message:@"请绑定设备" cancelButtonTitle:@"取消" otherButtonTitles:@[@"绑定"] handler:^(UIAlertView *alertView, NSInteger buttonIndex) {
        if (buttonIndex == alertView.cancelButtonIndex) return ;
        
        [[self rootViewController] pushViewController:[self SRTerminalBindViewController] animated:YES];
    }];
}

+ (void)showLoadingHUDWithTitle:(NSString *)title
{
    [self endEditing];
    
    MBProgressHUD *hud = objc_getAssociatedObject(self, kLoadingHUDKey);
    if (!hud) {
        hud = [[MBProgressHUD alloc] initWithWindow:[UIApplication sharedApplication].keyWindow];
        hud.dimBackground = YES;
        objc_setAssociatedObject(self, kLoadingHUDKey, hud, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    
    [[self topViewController].view addSubview:hud];
//    [[UIApplication sharedApplication].keyWindow addSubview:hud];
    [hud show:YES];
}

//+ (void)showLoadingHUDWithTitle:(NSString *)title inView:(UIView *)view
//{
//    [self endEditing];
//    
//    MBProgressHUD *hud = objc_getAssociatedObject(self, kLoadingHUDKey);
//    if (!hud) {
//        hud = [[MBProgressHUD alloc] initWithWindow:[UIApplication sharedApplication].keyWindow];
//        hud.dimBackground = YES;
//        objc_setAssociatedObject(self, kLoadingHUDKey, hud, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
//    }
//    
//    [view addSubview:hud];
//    [hud show:YES];
//}

+ (void)dissmissLoadingHUD
{
    MBProgressHUD *hud = objc_getAssociatedObject(self, kLoadingHUDKey);
    if (!hud) return;
    [hud removeFromSuperview];
}

+ (void)showAutoDisappearHUDWithMessage:(NSString *)message isDetail:(BOOL)isDetail
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow
                                              animated:YES];
    hud.mode = MBProgressHUDModeText;
    if (isDetail) {
        hud.detailsLabelText = message;
    } else {
        hud.labelText = message;
        hud.labelFont = [UIFont boldSystemFontOfSize:13.0f];
    }
    
    hud.margin = 10.f;
    hud.yOffset = SCREEN_HEIGHT/2.3;
    hud.removeFromSuperViewOnHide = YES;
    
    [hud hide:YES afterDelay:1.0];
}

+ (void)showTopAutoDisappearHUDWithMessage:(NSString *)message
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow
                                              animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.detailsLabelText = message;
    
    hud.margin = 10.f;
    hud.yOffset = -SCREEN_HEIGHT/2.3;
    hud.removeFromSuperViewOnHide = YES;
    
    [hud hide:YES afterDelay:3.0];
}


+ (void)showCenterAutoDisappearHUDWithMessage:(NSString *)message{

    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow
                                              animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.detailsLabelText = message;
    
    hud.margin = 10.f;
//    hud.yOffset = -SCREEN_HEIGHT/2.3;
    hud.center = [UIApplication sharedApplication].keyWindow.center;
    hud.removeFromSuperViewOnHide = YES;
    
    [hud hide:YES afterDelay:3.0];

}

+ (void)showOrderStartAlert:(SRAPNsOrderStartInfo *)info
{
    SROrderStartView *view = objc_getAssociatedObject(self, kOrderStartViewKey);
    if (!view) {
        view = [SROrderStartView instanceCustomView];
        view.dismissBlock = ^(){
            objc_setAssociatedObject(self, kOrderStartViewKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        };
        objc_setAssociatedObject(self, kOrderStartViewKey, view, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    
    if (view.isShowing) {
        view.info = info;
    } else {
        view.info = info;
        [view show];
    }
}

+ (void)showOrderRecommendAlert:(NSString *)alert  userName:(NSString *)userName
{
    [UIAlertView bk_showAlertViewWithTitle:SRLocal(@"title_alert")
                                   message:alert
                         cancelButtonTitle:[SRUserDefaults isLogin]?SRLocal(@"bt_not_alert"):SRLocal(@"bt_ignore")
                         otherButtonTitles:[SRUserDefaults isLogin]?@[SRLocal(@"bt_set_order_start")]:@[SRLocal(@"bt_not_alert")]
                                   handler:^(UIAlertView *alertView, NSInteger buttonIndex) {
                                       if (buttonIndex==alertView.cancelButtonIndex) {
                                           if ([SRUserDefaults isLogin]) {
                                               [SRPortal closeOrderStartRemindWithCompleteBlock:nil];
                                           }
                                       } else {
                                           if ([SRUserDefaults isLogin]) {
                                               
                                               UINavigationController *navVC = [self rootViewController];
                                               
                                               if (navVC.presentedViewController) {
                                                   [navVC.presentedViewController dismissViewControllerAnimated:NO completion:NULL];
                                               }
                                               
                                               for (UIViewController *vc in navVC.viewControllers) {
                                                   if ([vc isKindOfClass:[SROrderStartViewController class]]) {
                                                       [navVC popToViewController:vc animated:YES];
                                                       return;
                                                   }
                                               }
                                               
//                                               SROrderStartViewController *vc = [[self SettingsStoryBoard] instantiateViewControllerWithIdentifier:@"SROrderStartViewController"];
                                               SROrderStartViewController *vc = (SROrderStartViewController *)[self SROrderStartViewController];
                                               [navVC pushViewController:vc animated:YES];
                                           } else {
                                               [SRPortal closeOrderStartRemindWithCompleteBlock:nil];
                                           }
                                       }
                                   }];
}

+ (void)showPasswordInputAlertWithTitle:(NSString *)title andConfirmBlock:(void (^)(void))block
{
    [self showPasswordInputAlertWithTitle:title andConfirmBlock:block cancelBlock:nil];
}

+ (void)showPasswordInputAlertWithTitle:(NSString *)title andConfirmBlock:(void (^)(void))confirm cancelBlock:(void (^)(void))cancel
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                    message:nil
                                                   delegate:nil
                                          cancelButtonTitle:@"取消"
                                          otherButtonTitles:@"确定", nil];
    alert.alertViewStyle = UIAlertViewStyleSecureTextInput;
    if ([SRKeychain Password].isNumber) {
        [alert textFieldAtIndex:0].keyboardType = UIKeyboardTypeNumberPad;
    }
    
    [alert bk_setHandler:^{
        
        if ([[SRKeychain Password] isEqualToString:[alert textFieldAtIndex:0].text]) {
            if (confirm)
                confirm();
        } else {
            [self showPasswordInputAlertWithTitle:@"密码错误，请重新输入" andConfirmBlock:confirm cancelBlock:cancel];
        }
    } forButtonAtIndex:alert.firstOtherButtonIndex];
    
    [alert bk_setHandler:^{
        if (cancel)
            cancel();
    } forButtonAtIndex:alert.cancelButtonIndex];
    
    [alert bk_setDidDismissBlock:^(UIAlertView *alert, NSInteger index) {
        [self endEditing];
    }];
    
    [alert show];
}

+ (void)startExperienceAlert
{
    NSTimer *timer = objc_getAssociatedObject(self, kExperienceAlert);
    if (!timer) {
        timer = [NSTimer bk_timerWithTimeInterval:5*60 block:^(NSTimer *timer) {
            [UIAlertView bk_showAlertViewWithTitle:@"提示" message:@"您当前为体验账户，注册绑定车辆升级成为我们的正式客户吧" cancelButtonTitle:@"取消" otherButtonTitles:@[@"注册"] handler:^(UIAlertView *alertView, NSInteger buttonIndex) {
                if (buttonIndex != alertView.cancelButtonIndex) {
                    [self ModalSRLoginViewController];
                }
            }];
        } repeats:YES];
        [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
        objc_setAssociatedObject(self, kExperienceAlert, timer, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        
        [timer fire];
    }
}

+ (void)stopExperienceAlert
{
    NSTimer *timer = objc_getAssociatedObject(self, kExperienceAlert);
    if (timer) {
        [timer invalidate];
        objc_setAssociatedObject(self, kExperienceAlert, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
}

#pragma mark - Authorization

+ (BOOL)cameraAuthorization
{
#if TARGET_IPHONE_SIMULATOR//模拟器
    [SRUIUtil showAlertMessage:@"模拟器不能使用摄像头"];
    return NO;
#endif
    
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if(authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied){
        [self showAlertMessage:@"请在iPhone的“设置-隐私”选项中，允许咪智汇访问你的摄像头。"];
        return NO;
    } else {
        return YES;
    }
}

+ (BOOL)TouchIDAuthorization
{
    LAContext *myContext = [[LAContext alloc] init];
    return [myContext canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:nil];
}

#pragma mark - Controller

+ (UIViewController *)topViewController
{
    if ([self rootViewController].presentedViewController) {
        return [self rootViewController].presentedViewController;
    } else {
        return [self rootViewController];
    }
}

#pragma mark UINavigationController
+ (UINavigationController *)rootViewController
{
    return (UINavigationController *)[(AppDelegate *)[UIApplication sharedApplication].delegate window].rootViewController;
//    return (UINavigationController *)[UIApplication sharedApplication].keyWindow.rootViewController;
}

+ (void)popToRootViewControllerAnimated:(BOOL)animated
{
    UINavigationController *navVC = [self rootViewController];
    if (navVC.presentedViewController) {
        [navVC dismissViewControllerAnimated:NO completion:^{
            [navVC popToRootViewControllerAnimated:animated];
        }];
    } else {
        [navVC popToRootViewControllerAnimated:animated];
    }
}

#pragma mark MainStoryBoard

+ (UIStoryboard *)MainStoryBoard
{
    return [UIStoryboard storyboardWithName:@"Main" bundle:nil];
}

+ (UIViewController *)SRMainViewController
{
    return [[self MainStoryBoard] instantiateViewControllerWithIdentifier:@"SRMainViewController"];
}

+ (UIViewController *)SRCarStatusViewController
{
    return [[self MainStoryBoard] instantiateViewControllerWithIdentifier:@"SRCarStatusViewController"];
}

+ (UIViewController *)SRTirePressureAdjustViewController
{
    return [[self MainStoryBoard] instantiateViewControllerWithIdentifier:@"SRTirePressureAdjustViewController"];
}

#pragma mark MyStoryBoard
+ (UIStoryboard *)MyStoryBoard
{
    return [UIStoryboard storyboardWithName:@"My" bundle:nil];
}

+ (UIViewController *)SRMyViewController
{
    return [[self MyStoryBoard] instantiateViewControllerWithIdentifier:@"SRMyViewController"];
}

+ (UIViewController *)SRTerminalInfoViewController
{
    return [[self MyStoryBoard] instantiateViewControllerWithIdentifier:@"SRTerminalInfoViewController"];
}

+ (UIViewController *)SRTerminalBindViewController
{
    return [[self MyStoryBoard] instantiateViewControllerWithIdentifier:@"SRTerminalBindViewController"];
}

+ (UIViewController *)SRMessageCenterViewController
{
    return [[self MyStoryBoard] instantiateViewControllerWithIdentifier:@"SRMessageCenterViewController"];
}

+ (UIViewController *)SRCustomerServiceViewController
{
    return [[self MyStoryBoard] instantiateViewControllerWithIdentifier:@"SRCustomerServiceViewController"];
}

+ (UIViewController *)SROrderStartViewController
{
    return [[self MyStoryBoard] instantiateViewControllerWithIdentifier:@"SROrderStartViewController"];
}

+ (void)PushSRMessageCenterViewController
{
    UINavigationController *navVC = [self rootViewController];
    
    for (UIViewController *vc in navVC.viewControllers) {
        if ([vc isKindOfClass:[SRMessageCenterViewController class]]) {
            [navVC popToViewController:vc animated:YES];
            return;
        }
    }
    
    UIViewController *vc = [self SRMessageCenterViewController];
    [navVC pushViewController:vc animated:YES];
}

+ (void)PushSRCustomerServiceViewController
{
    UINavigationController *navVC = [self rootViewController];
    
    for (UIViewController *vc in navVC.viewControllers) {
        if ([vc isKindOfClass:[SRCustomerServiceViewController class]]) {
            [navVC popToViewController:vc animated:YES];
            return;
        }
    }
    
    UIViewController *vc = [self SRCustomerServiceViewController];
    [navVC pushViewController:vc animated:YES];
}


//#pragma mark SettingsStoryBoard
//
//+ (UIStoryboard *)SettingsStoryBoard
//{
//    return [UIStoryboard storyboardWithName:@"Settings" bundle:nil];
//}
//
//+ (UIViewController *)SRSettingsViewController
//{
//    return [[self SettingsStoryBoard] instantiateViewControllerWithIdentifier:@"SRSettingsViewController"];
//}
//
//+ (UIViewController *)SRTerminalInfoViewController
//{
//    return [[self SettingsStoryBoard] instantiateViewControllerWithIdentifier:@"SRTerminalInfoViewController"];
//}
//
//+ (UIViewController *)SRTerminalBindViewController
//{
//    return [[self SettingsStoryBoard] instantiateViewControllerWithIdentifier:@"SRTerminalBindViewController"];
//}
//
//+ (UIViewController *)SRMessageCenterViewController
//{
//    return [[self SettingsStoryBoard] instantiateViewControllerWithIdentifier:@"SRMessageCenterViewController"];
//}
//
//+ (UIViewController *)SRCustomerServiceViewController
//{
//    return [[self SettingsStoryBoard] instantiateViewControllerWithIdentifier:@"SRCustomerServiceViewController"];
//}
//
//+ (void)PushSRMessageCenterViewController
//{
//    UINavigationController *navVC = [self rootViewController];
//    
//    for (UIViewController *vc in navVC.viewControllers) {
//        if ([vc isKindOfClass:[SRMessageCenterViewController class]]) {
//            [navVC popToViewController:vc animated:YES];
//            return;
//        }
//    }
//    
//    UIViewController *vc = [self SRMessageCenterViewController];
//    [navVC pushViewController:vc animated:YES];
//}
//
//+ (void)PushSRCustomerServiceViewController
//{
//    UINavigationController *navVC = [self rootViewController];
//    
//    for (UIViewController *vc in navVC.viewControllers) {
//        if ([vc isKindOfClass:[SRCustomerServiceViewController class]]) {
//            [navVC popToViewController:vc animated:YES];
//            return;
//        }
//    }
//    
//    UIViewController *vc = [self SRCustomerServiceViewController];
//    [navVC pushViewController:vc animated:YES];
//}

#pragma mark LoginStoryBoard

+ (UIStoryboard *)LoginStoryBoard
{
    return [UIStoryboard storyboardWithName:@"Login" bundle:nil];
}

+ (UIViewController *)SRScanViewController
{
    return [[self LoginStoryBoard] instantiateViewControllerWithIdentifier:@"SRScanViewController"];
}

+ (void)ModalSRLoginViewController
{
    UIViewController *navVC = [self rootViewController].visibleViewController;
    UIViewController *vc = [[self LoginStoryBoard] instantiateInitialViewController];
//    [navVC presentViewController:vc animated:YES completion:nil];
    [navVC.navigationController pushViewController:vc animated:YES];
}

+ (void)DissmissSRLoginViewController
{
    UIViewController *navVC = [self rootViewController].visibleViewController;
    [navVC.navigationController popViewControllerAnimated:YES];
}

+ (void)DissmissSRLoginViewControllerPopToRoot
{
//    UIViewController *navVC = [self rootViewController].visibleViewController;
    
//    [navVC.navigationController popToRootViewControllerAnimated:YES];
//    [[self rootViewController] dismissViewControllerAnimated:NO completion:^{
        UITabBarController *mainVC = (UITabBarController *)[[self rootViewController].viewControllers firstObject];
        mainVC.selectedIndex = 0;
        [[self rootViewController] popToRootViewControllerAnimated:NO];
//    }];
}
    

#pragma mark SecuritySettingsStoryBoard

+ (UIStoryboard *)SecuritySettingsStoryBoard
{
    return [UIStoryboard storyboardWithName:@"SecuritySettings" bundle:nil];
}

+ (UIViewController *)SRModifyPhoneViewController
{
    return [[self SecuritySettingsStoryBoard] instantiateViewControllerWithIdentifier:@"SRModifyPhoneViewController"];
}

+ (UIViewController *)SRModifyUserNameViewController
{
    return [[self SecuritySettingsStoryBoard] instantiateViewControllerWithIdentifier:@"SRModifyUserNameViewController"];
}

+ (UIViewController *)SRModifyPasswordViewController
{
    return [[self SecuritySettingsStoryBoard] instantiateViewControllerWithIdentifier:@"SRModifyPasswordViewController"];
}

+ (UIViewController *)SRAuthenticateViewController
{
    return [[self SecuritySettingsStoryBoard] instantiateViewControllerWithIdentifier:@"SRAuthenticateViewController"];
}

+ (UIViewController *)SROBDConfigViewController
{
    return [[self SecuritySettingsStoryBoard] instantiateViewControllerWithIdentifier:@"SROBDConfigViewController"];
}

+ (UIViewController *)SRTripHiddenViewController
{
    return [[self SecuritySettingsStoryBoard] instantiateViewControllerWithIdentifier:@"SRTripHiddenViewController"];
}

+ (UIViewController *)SRHarassSettingViewController
{
    return [[self SecuritySettingsStoryBoard] instantiateViewControllerWithIdentifier:@"SRHarassSettingViewController"];
}

#pragma mark MaintainStoryBoard
+ (UIStoryboard *)MaintainStoryBoard
{
    return [UIStoryboard storyboardWithName:@"Maintain" bundle:nil];
}

+ (UIViewController *)SRMaintainViewController
{
    return [[self MaintainStoryBoard] instantiateViewControllerWithIdentifier:@"SRMaintainViewController"];
}

#pragma mark - AppDelegate

+ (void)exitApplication
{
    AppDelegate *app = [UIApplication sharedApplication].delegate;
    UIWindow *window = app.window;
    
    [UIView animateWithDuration:1.0f animations:^{
        window.alpha = 0;
        window.frame = CGRectMake(0, window.bounds.size.width, 0, 0);
    } completion:^(BOOL finished) {
        exit(0);
    }];
}

+ (void)endEditing
{
    [[UIApplication sharedApplication].keyWindow endEditing:YES];
//    [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
}

+ (AppDelegate *)AppDelegate
{
    return (AppDelegate *)[UIApplication sharedApplication].delegate;
}

@end

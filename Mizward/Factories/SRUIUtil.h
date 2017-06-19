//
//  SRUIUtil.h
//  SiRuiV4.0
//
//  Created by zhangjunbo on 15/6/15.
//  Copyright (c) 2015年 SiRui. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SRAPNsOrderStartInfo, AppDelegate;

@interface SRUIUtil : NSObject

+ (void)callWithPhoneNumber:(NSString *)phoneNumber;

+ (void)jumpToAppStore;

+ (void)registerForRemoteNotification;

+ (void)showAlertMessage:(NSString *)message;
+ (void)showAlertWithTitle:(NSString *)title message:(NSString *)message andCancelButton:(NSString *)button;
+ (void)showAlertWithTitle:(NSString *)title message:(NSString *)message doneButton:(NSString *)button andDoneBlock:(void(^)())doneBlock;
+ (void)showAlertCancelableWithTitle:(NSString *)title message:(NSString *)message doneButton:(NSString *)button andDoneBlock:(void (^)())doneBlock;
+ (void)showReloginAlertWithMessage:(NSString *)message doneButton:(NSString *)button;

+ (void)showBindTerminalAlert;

+ (void)showLoadingHUDWithTitle:(NSString *)title;
+ (void)dissmissLoadingHUD;

+ (void)showAutoDisappearHUDWithMessage:(NSString *)message isDetail:(BOOL)isDetail;

+ (void)showTopAutoDisappearHUDWithMessage:(NSString *)message;
+ (void)showCenterAutoDisappearHUDWithMessage:(NSString *)message;

+ (void)showOrderStartAlert:(SRAPNsOrderStartInfo *)info;
+ (void)showOrderRecommendAlert:(NSString *)alert userName:(NSString *)userName;

+ (void)showPasswordInputAlertWithTitle:(NSString *)title andConfirmBlock:(void (^)(void))block;
+ (void)showPasswordInputAlertWithTitle:(NSString *)title andConfirmBlock:(void (^)(void))confirm cancelBlock:(void (^)(void))cancel;

+ (void)startExperienceAlert;
+ (void)stopExperienceAlert;

#pragma mark - Authorization

+ (BOOL)cameraAuthorization;
+ (BOOL)TouchIDAuthorization;

#pragma mark - Controller

+ (UIViewController *)topViewController;

#pragma mark UINavigationController
+ (UINavigationController *)rootViewController;
+ (void)popToRootViewControllerAnimated:(BOOL)animated;

#pragma mark MainStoryBoard
+ (UIStoryboard *)MainStoryBoard;
+ (UIViewController *)SRMainViewController;
+ (UIViewController *)SRCarStatusViewController;
+ (UIViewController *)SRTirePressureAdjustViewController;

#pragma mark MyStoryBoard
+ (UIStoryboard *)MyStoryBoard;
+ (UIViewController *)SRMyViewController;
+ (UIViewController *)SRTerminalInfoViewController;
+ (UIViewController *)SRTerminalBindViewController;
+ (UIViewController *)SRMessageCenterViewController;
+ (UIViewController *)SRCustomerServiceViewController;
+ (void)PushSRMessageCenterViewController;
+ (void)PushSRCustomerServiceViewController;

//#pragma mark SettingsStoryBoard
//+ (UIStoryboard *)SettingsStoryBoard;
//+ (UIViewController *)SRSettingsViewController;
//+ (UIViewController *)SRTerminalInfoViewController;
//+ (UIViewController *)SRTerminalBindViewController;
//+ (UIViewController *)SRMessageCenterViewController;
//+ (UIViewController *)SRCustomerServiceViewController;
//+ (void)PushSRMessageCenterViewController;
//+ (void)PushSRCustomerServiceViewController;

#pragma mark LoginStoryBoard
+ (UIStoryboard *)LoginStoryBoard;
+ (UIViewController *)SRScanViewController;
+ (void)ModalSRLoginViewController;
+ (void)DissmissSRLoginViewController;
+ (void)DissmissSRLoginViewControllerPopToRoot;

#pragma mark SecuritySettingsStoryBoard
+ (UIStoryboard *)SecuritySettingsStoryBoard;
+ (UIViewController *)SRModifyPhoneViewController;
+ (UIViewController *)SRModifyUserNameViewController;
+ (UIViewController *)SRModifyPasswordViewController;
+ (UIViewController *)SRAuthenticateViewController;
+ (UIViewController *)SROBDConfigViewController;
+ (UIViewController *)SRTripHiddenViewController;
+ (UIViewController *)SRHarassSettingViewController;

#pragma mark MaintainStoryBoard
+ (UIStoryboard *)MaintainStoryBoard;
+ (UIViewController *)SRMaintainViewController;


#pragma mark - AppDelegate

+ (AppDelegate *)AppDelegate;
+ (void)exitApplication;
+ (void)endEditing;

@end

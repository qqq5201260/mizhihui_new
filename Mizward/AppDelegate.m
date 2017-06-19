//
//  AppDelegate.m
//  SiRuiV4.0
//
//  Created by zhangjunbo on 15/6/15.
//  Copyright (c) 2015年 SiRui. All rights reserved.
//

#import "AppDelegate.h"

#import "SRUserDefaults.h"
#import "SRKeychain.h"
#import "SRPortal+APNs.h"
#import "SRUIUtil.h"
#import "SRTabBarController.h"
#import <IQKeyboardManager/IQKeyboardManager.h>

#import <Fabric/Fabric.h>
#import <Crashlytics/Crashlytics.h>
#import <BaiduMapAPI/BMapKit.h>
#import "SRUserDefaults.h"
//#import <JSPatchPlatform/JSPatch.h>

//#if DEBUG
    #import "SRLogFormattter.h"
    #import <FLEX/FLEXManager.h>
//#endif

#import <Bugly/Bugly.h>
#import <UIViewController+Swizzled.h>

#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
#endif


#ifdef NSFoundationVersionNumber_iOS_9_x_Max

#define IOS_VERSION_10 (NSFoundationVersionNumber > NSFoundationVersionNumber_iOS_9_x_Max)?(YES):(NO)
@interface AppDelegate () <iConsoleDelegate, BMKGeneralDelegate,UNUserNotificationCenterDelegate>
#else
@interface AppDelegate () <iConsoleDelegate, BMKGeneralDelegate>
#endif

{
    DDFileLogger *fileLogger;
    BMKMapManager *bmkMapManager;
}

@property (nonatomic, unsafe_unretained) UIBackgroundTaskIdentifier backgroundTaskIdentifier;

- (void)startBackgroundTask;
- (void)endBackgroundTask;

@end

@implementation AppDelegate

#pragma mark - 生命周期

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    [self initSDKs];
    
#if DEBUG
    [self debugInit];
#endif
    
    [self initAppearance];
    [self initTabViewController];
    
    SRLogDebug(@"%@", launchOptions);
    if (launchOptions && launchOptions[UIApplicationLaunchOptionsRemoteNotificationKey]) {
        [SRPortal parseAPNsMessage:launchOptions[UIApplicationLaunchOptionsRemoteNotificationKey]];
    }
    
//    [NSThread sleepForTimeInterval:3.0];//设置启动页面时间
    
#if DEBUG
    SWIZZ_IT
#endif
    [self initBugly];
    
    if (IOS_VERSION_10) {
        //iOS 10
    [[UNUserNotificationCenter currentNotificationCenter] requestAuthorizationWithOptions:UNAuthorizationOptionBadge | UNAuthorizationOptionAlert | UNAuthorizationOptionSound completionHandler:^(BOOL granted, NSError * _Nullable error) {
        
        if (granted) {
            NSLog(@"授权成功");
            //设置用户通知中心的代理
            [UNUserNotificationCenter currentNotificationCenter].delegate = self;
            
        }else {
            NSLog(@"授权失败");
        }
        
    }];
    
    //2.获取deviceToken
    [[UIApplication sharedApplication] registerForRemoteNotifications];
    }else{
    
        //iOS 10 before
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert | UIUserNotificationTypeBadge | UIUserNotificationTypeSound categories:nil];
        [application registerUserNotificationSettings:settings];
    
    }

    

    
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    
    //当应用即将后台时调用，停止一切调用opengl相关的操作
    [BMKMapView willBackGround];
    
    //记录进入后台时间
    [SRUserDefaults updateLastResignActiveDate:[NSDate date]];
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    
    [self startBackgroundTask];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    
    [self endBackgroundTask];
}

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application{
    
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    
    //当应用恢复前台状态时调用，回复地图的渲染和opengl相关的操作
    [BMKMapView didForeGround];
    
    //刷新是否后台锁定（是否需要输入密码）
    [SRUserDefaults updateLastActiveDate:[NSDate date]];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    [[SRUserDefaults standardUserDefaults] setObject:@(NO) forKey:@"kLogin5mins"];
    [[SRUserDefaults standardUserDefaults] synchronize];
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark - APNs

//远程通知注册成功委托
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    SRLogDebug(@"deviceToken %@", deviceToken);
    NSString *token = [NSString stringWithFormat:@"%@", deviceToken];
    if (token && token.length>0) {
        [SRUserDefaults updateAPNsPushToken:token];
    }
}

//远程通知注册失败委托
-(void)application:(UIApplication *)application didFailToRegisterForRemoteotificationsWithError:(NSError *)error
{
    SRLogError(@"%@", error);
}

//点击某条远程通知时调用的委托 如果界面处于打开状态,那么此委托会直接响应
-(void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;

    SRLogDebug(@"%@", userInfo);
    [SRPortal parseAPNsMessage:userInfo];
}

#pragma mark - Local

-(void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification {
    //展车用户
    if (notification.userInfo
        && notification.userInfo[SRLocalNotificationExperienceAlert]
        && [SRUserDefaults loginStatus] == SRLoginStatus_Visitor) {
        [SRUIUtil showTopAutoDisappearHUDWithMessage:notification.userInfo[SRLocalNotificationExperienceAlert]];
    } else if (notification.userInfo
               && notification.userInfo[SRLocalNotificationExperienceOverdue]
               && [SRUserDefaults loginStatus] == SRLoginStatus_Visitor) {
        [SRUIUtil showReloginAlertWithMessage:notification.userInfo[SRLocalNotificationExperienceOverdue] doneButton:@"确定"];
    }
}

#pragma mark - URL

//- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
//{
//    return [ShareSDK handleOpenURL:url
//                        wxDelegate:nil];
//}
//- (BOOL)application:(UIApplication *)application
//            openURL:(NSURL *)url
//  sourceApplication:(NSString *)sourceApplication
//         annotation:(id)annotation
//{
//    return [ShareSDK handleOpenURL:url
//                 sourceApplication:sourceApplication
//                        annotation:annotation
//                        wxDelegate:nil];
//}

#pragma mark - 后台任务

- (void)startBackgroundTask
{
    // 标记一个长时间运行的后台任务将开始
    self.backgroundTaskIdentifier =[[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:^(void) {
        // 当应用程序留给后台的时间快要到结束时（应用程序留给后台执行的时间是有限的）， 这个Block块将被执行
        // 我们需要在次Block块中执行一些清理工作。
        // 如果清理工作失败了，那么将导致程序挂掉
        
        // 清理工作需要在主线程中用同步的方式来进行
    }];
}

- (void)endBackgroundTask
{
    [[UIApplication sharedApplication] endBackgroundTask:self.backgroundTaskIdentifier];
    self.backgroundTaskIdentifier = UIBackgroundTaskInvalid;
}

#pragma mark - Application 初始化

- (void)initAppearance {
    [[UINavigationBar appearance] setBarTintColor:[UIColor defaultNavBarTintColor]];
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    [[UINavigationBar appearance] setShadowImage:[[UIImage alloc] init]];
    
//    [[UIBarButtonItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]} forState:UIControlStateNormal];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
}

- (void)initTabViewController {
    
    UITabBarItem *mainItem = [[UITabBarItem alloc] initWithTitle:@"车卫士"
                                                           image:[[UIImage imageNamed:@"ic_tab_1"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]
                                                   selectedImage:[[UIImage imageNamed:@"ic_tab_1_highlight"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    UITabBarItem *maintainItem = [[UITabBarItem alloc] initWithTitle:@"车管家"
                                                               image:[[UIImage imageNamed:@"ic_tab_2"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]
                                                       selectedImage:[[UIImage imageNamed:@"ic_tab_2_highlight"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    UITabBarItem *myItem = [[UITabBarItem alloc] initWithTitle:@"我"
                                                               image:[[UIImage imageNamed:@"ic_tab_3"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]
                                                       selectedImage:[[UIImage imageNamed:@"ic_tab_3_highlight"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    
    UINavigationController *rootVC = (UINavigationController *)self.window.rootViewController;
    
    UIViewController *mainVC = [SRUIUtil SRMainViewController];
    [mainVC setValue:rootVC.topViewController forKey:@"parentVC"];
    mainVC.tabBarItem = mainItem;
    
//    无保养
    UIViewController *checkVC = [[SRUIUtil MaintainStoryBoard] instantiateViewControllerWithIdentifier:@"SRMaintainCheckViewController"];
//    有保养
//    UIViewController *maintainVC = [SRUIUtil SRMaintainViewController];
    [checkVC setValue:rootVC.topViewController forKey:@"parentVC"];
    checkVC.tabBarItem = maintainItem;
    
    UIViewController *myVC = [SRUIUtil SRMyViewController];
    [myVC setValue:rootVC.topViewController forKey:@"parentVC"];
    myVC.tabBarItem = myItem;
    
    [(UITabBarController *)rootVC.topViewController setViewControllers:@[mainVC, checkVC, myVC]];
}

#pragma mark - 第三方SDK初始化

- (void)initTalkingData {
    [TalkingData sessionStarted:@"486DEC5D33F91A041F5A08EFC1547274" withChannelId:@"AppStore"];
    [TalkingData setLogEnabled:NO];
}

- (void)initFabric {
    [Fabric with:@[CrashlyticsKit]]; //ml@mysirui.com/milian2015
    if ([SRKeychain UserName]) {
        [[Crashlytics sharedInstance] setUserName:[SRKeychain UserName]];
    }
}

- (void)initBaiduMap {
    bmkMapManager = [[BMKMapManager alloc] init];
    if (![bmkMapManager start:@"XzO1TIfxSiy1dKS9ptVNo45Y" generalDelegate:nil]) {
        NSLog(@"百度地图 验证失败");
    }
}

- (void)initIQKeyboardManager {
    [IQKeyboardManager sharedManager].enable = YES;
    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = YES;
    [[IQKeyboardManager sharedManager] disableInViewControllerClass:[UINavigationController class]];
}

- (void)initSDKs {
    [self initFabric];
    [self initBaiduMap];
    [self initTalkingData];
    
    [self initIQKeyboardManager];
    
    [self initNotification];
}

- (void)initNotification {
    
   UIApplication *application = [UIApplication sharedApplication];
    CGFloat vision = [[[UIDevice currentDevice] systemVersion] floatValue];
    if (vision >= 10.0 ) {
        
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
        [center requestAuthorizationWithOptions:(UNAuthorizationOptionBadge | UNAuthorizationOptionSound | UNAuthorizationOptionAlert) completionHandler:^(BOOL granted, NSError * _Nullable error) {
            if (!error) {
                NSLog(@"request authorization succeeded!");
            }
        }];
        [UNUserNotificationCenter currentNotificationCenter].delegate = self;
        [application registerForRemoteNotifications];
        
#endif
        
    }
    else if (vision >= 8.0) { //iOS8.0以后注册方法与之前有所不同，需要要分别对待
        if ([UIApplication instancesRespondToSelector:@selector(registerUserNotificationSettings:)]){
            
            [application registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert|UIUserNotificationTypeBadge|UIUserNotificationTypeSound categories:nil]];
            [application registerForRemoteNotifications];
            
        }

    }
}




#pragma mark - Debug Init

- (void)initLog {
#if DEBUG
    SRLogFormattter *formatter = [[SRLogFormattter alloc] init];
    
    [[DDASLLogger sharedInstance] setLogFormatter:formatter];
    [[DDTTYLogger sharedInstance] setLogFormatter:formatter];
    
    [DDLog addLogger:[DDASLLogger sharedInstance]];
    [DDLog addLogger:[DDTTYLogger sharedInstance]];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString *docDir = [paths objectAtIndex:0];
    DDLogFileManagerDefault *logFileManager = [[DDLogFileManagerDefault alloc] initWithLogsDirectory:[docDir stringByAppendingPathComponent:@"Logs"]];
    fileLogger = [[DDFileLogger alloc] initWithLogFileManager:logFileManager];
    fileLogger.maximumFileSize  = 1024 * 1024;        // 1 MB
    fileLogger.rollingFrequency = 60 * 60 * 24;       // 24 Hour
    fileLogger.logFileManager.maximumNumberOfLogFiles = 4;
    [fileLogger setLogFormatter:formatter];
    
    [DDLog addLogger:fileLogger];
#endif
}

- (void)initIConsole {
#if DEBUG
    UIViewController *rootVC = self.window.rootViewController;
    _window = [[iConsoleWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    _window.rootViewController = rootVC;
    
    [iConsole sharedConsole].logSubmissionEmail = @"zhangjunbo@mysirui.com";
    [iConsole sharedConsole].delegate = self;
#endif
}

- (void)initFLEX {
#if DEBUG
    [FLEXManager sharedManager].networkDebuggingEnabled = YES;
#endif
}

- (void)debugInit {
    [self initLog];
    [self initIConsole];
    [self initFLEX];
}

#pragma mark - iConsoleDelegate

- (void)handleConsoleCommand:(NSString *)command {
#if DEBUG
    if ([command isEqualToString:@"flex"]) {
        [[FLEXManager sharedManager] showExplorer];
    }
#endif
}


#pragma mark - Bugly
-(void)initBugly{
    [Bugly startWithAppId:@"13df154246"];

}


#pragma mark UNUserNotificationCenter delegate

/**
 *  App处于前台时收到通知(iOS 10+)
 */
- (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler {
    NSLog(@"Receive a notification in foregound.");
    // 处理iOS 10通知，并上报通知打开回执
    //    [self handleiOS10Notification:notification];
    // 通知不弹出
        completionHandler(UNNotificationPresentationOptionNone);
    
    // 通知弹出，且带有声音、内容和角标
//    completionHandler(UNNotificationPresentationOptionSound | UNNotificationPresentationOptionAlert | UNNotificationPresentationOptionBadge);
}

- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void(^)())completionHandler{
    
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    
    SRLogDebug(@"%@", response);
    if (![response.notification.request.identifier isEqualToString:@"FiveSecond"]) {
       [SRPortal parseAPNsMessage:response.notification.request.content.userInfo];
    }
    
    
    completionHandler();
}



-(void)initPush{




}

@end

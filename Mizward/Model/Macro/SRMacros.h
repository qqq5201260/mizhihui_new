//
//  SRMacros.h
//  SiRuiV4.0
//
//  Created by zhangjunbo on 15/6/15.
//  Copyright (c) 2015年 SiRui. All rights reserved.
//

#ifndef SiRuiV4_0_SRMacros_h
#define SiRuiV4_0_SRMacros_h

#import <UIKit/UIKit.h>

#define APPDELEGATE [(AppDelegate*)[UIApplication sharedApplication]  delegate]

#pragma mark - 设备
//-------------------获取设备大小-------------------------
//NavBar高度
#define NavigationBar_HEIGHT 44
//StatusBar高度
#define StatusBar_HEIGHT ([[UIApplication sharedApplication] statusBarFrame].size.height)
//获取屏幕 宽度、高度
#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)
#define APP_WIDTH [[UIScreen mainScreen]applicationFrame].size.width
#define APP_HEIGHT [[UIScreen mainScreen]applicationFrame].size.height

//-------------------获取设备大小-------------------------

#pragma mark - 系统
//----------------------系统----------------------------

#define AppID   (@"673017008")

//获取系统版本
#define IOS_VERSION [[[UIDevice currentDevice] systemVersion] floatValue]
#define CurrentSystemVersion [[UIDevice currentDevice] systemVersion]
#define CurrentAPPVersion [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]

//检查系统版本
#define SYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)

//判断是否 Retina屏、设备是否iPhone 5、是否是iPad
//#define isRetina ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 960), [[UIScreen mainScreen] currentMode].size) : NO)
//#define iPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)
//#define iPhone6 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(750, 1334), [[UIScreen mainScreen] currentMode].size) : NO)
//#define iPhone6Plus ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242, 2208), [[UIScreen mainScreen] currentMode].size) : NO)

#define SCREEN_MAX_LENGTH (MAX(SCREEN_WIDTH, SCREEN_HEIGHT))
#define SCREEN_MIN_LENGTH (MIN(SCREEN_WIDTH, SCREEN_HEIGHT))

#define iPad (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define iPhone (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define isRetina ([[UIScreen mainScreen] scale] >= 2.0)

#define iPhone4 (iPhone && SCREEN_MAX_LENGTH < 568.0)
#define iPhone5 (iPhone && SCREEN_MAX_LENGTH == 568.0)
#define iPhone6 (iPhone && SCREEN_MAX_LENGTH == 667.0)
#define iPhone6Plus (iPhone && SCREEN_MAX_LENGTH == 736.0)

#define isPad (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)

#define iPhoneScale (iPhone6Plus?1.3:(iPhone6?1.0:1.0))

//判断是真机还是模拟器
#if TARGET_OS_IPHONE
//iPhone Device

#endif //TARGET_OS_IPHONE

#if TARGET_IPHONE_SIMULATOR
//iPhone Simulator
#endif //TARGET_IPHONE_SIMULATOR

//获取当前语言
#define CurrentLanguage ([[NSLocale preferredLanguages] objectAtIndex:0])
#define SRLocal(x) NSLocalizedString(x, nil)

//----------------------系统----------------------------

#pragma mark - 颜色
//----------------------颜色类---------------------------
// rgb颜色转换（16进制->10进制）
#define ColorFromHex(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

// 获取RGB颜色
#define RGBAlpaColor(r,g,b,a) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a]
#define RGBColor(r,g,b) RGBAlpaColor(r,g,b,1.0f)

//----------------------颜色类--------------------------


#pragma mark - 弧度
//由角度获取弧度 有弧度获取角度
#define degreesToRadian(x) (M_PI * (x) / 180.0)
#define radianToDegrees(radian) (radian*180.0)/(M_PI)

#pragma mark - Singleton

//----------------------单例--------------------------
// @interface
#define Singleton_Interface(className) \
+ (className *)sharedInterface;


// @implementation
#define Singleton_Implementation(className) \
+ (className *)sharedInterface \
{ \
static className *_instance;\
static dispatch_once_t onceToken; \
dispatch_once(&onceToken, ^{ \
_instance = [[self alloc] init]; \
}); \
return _instance; \
}
//----------------------单例--------------------------

#pragma mark - 其它

#define dispatch_main_sync_safe(block)\
if ([NSThread isMainThread]) {\
block();\
} else {\
dispatch_sync(dispatch_get_main_queue(), block);\
}

#define dispatch_main_async_safe(block)\
if ([NSThread isMainThread]) {\
block();\
} else {\
dispatch_async(dispatch_get_main_queue(), block);\
}



#endif

//
//  SRNotificationCenter.h
//  SiRuiV4.0
//
//  Created by zhangjunbo on 15/6/16.
//  Copyright (c) 2015年 SiRui. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SRNotificationCenter : NSObject

+ (void)sr_addObserver:(id)observer selector:(SEL)aSelector name:(NSString *)aName object:(id)anObject;

+ (void)sr_postNotification:(NSNotification *)notification;
+ (void)sr_postNotificationName:(NSString *)aName object:(id)anObject;
+ (void)sr_postNotificationName:(NSString *)aName object:(id)anObject userInfo:(NSDictionary *)aUserInfo;

+ (void)sr_removeObserver:(id)observer;
+ (void)sr_removeObserver:(id)observer name:(NSString *)aName object:(id)anObject;

+ (id <NSObject>)sr_addObserverForName:(NSString *)name object:(id)obj queue:(NSOperationQueue *)queue usingBlock:(void (^)(NSNotification *note))block NS_AVAILABLE(10_6, 4_0);

@end

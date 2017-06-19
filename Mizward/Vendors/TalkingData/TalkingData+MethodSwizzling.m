//
//  TalkingData+MethodSwizzling.m
//  SiRuiV4.0
//
//  Created by zhangjunbo on 15/7/10.
//  Copyright (c) 2015年 SiRui. All rights reserved.
//

#import "TalkingData+MethodSwizzling.h"
#import <objc/runtime.h>

@implementation TalkingData (MethodSwizzling)

+ (void)load {
    
    if (!DEBUG) return;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        method_exchangeImplementations(class_getClassMethod(self, @selector(sessionStarted:withChannelId:)),
                                       class_getClassMethod(self, @selector(debug_sessionStarted:withChannelId:)));
        
        method_exchangeImplementations(class_getClassMethod(self, @selector(setLogEnabled:)),
                                       class_getClassMethod(self, @selector(debug_setLogEnabled:)));
        
        method_exchangeImplementations(class_getClassMethod(self, @selector(trackPageBegin:)),
                                       class_getClassMethod(self, @selector(debug_trackPageBegin:)));
        
        method_exchangeImplementations(class_getClassMethod(self, @selector(trackPageEnd:)),
                                       class_getClassMethod(self, @selector(debug_trackPageEnd:)));
        
        method_exchangeImplementations(class_getClassMethod(self, @selector(setLatitude:longitude:)),
                                       class_getClassMethod(self, @selector(debug_setLatitude:longitude:)));
        
        method_exchangeImplementations(class_getClassMethod(self, @selector(trackEvent:)),
                                       class_getClassMethod(self, @selector(debug_trackEvent:)));
        
        method_exchangeImplementations(class_getClassMethod(self, @selector(trackEvent:label:)),
                                       class_getClassMethod(self, @selector(debug_trackEvent:label:)));
        
        method_exchangeImplementations(class_getClassMethod(self, @selector(trackEvent:label:parameters:)),
                                       class_getClassMethod(self, @selector(debug_trackEvent:label:parameters:)));
    });
}


+ (void)debug_trackEvent:(NSString *)eventId
{
    
}

+ (void)debug_trackEvent:(NSString *)eventId label:(NSString *)eventLabel
{
    
}

+ (void)debug_trackEvent:(NSString *)eventId
                   label:(NSString *)eventLabel
              parameters:(NSDictionary *)parameters
{
    
}

+ (void)debug_sessionStarted:(NSString *)appKey withChannelId:(NSString *)channelId {
    
}

+ (void)debug_setLogEnabled:(BOOL)enable {
    
}

+ (void)debug_trackPageBegin:(NSString *)pageName {
    
}

+ (void)debug_trackPageEnd:(NSString *)pageName {
    
}

+ (void)debug_setLatitude:(double)latitude longitude:(double)longitude {
    
}




@end

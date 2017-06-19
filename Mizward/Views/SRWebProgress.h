//
//  SRWebProgress.h
//  Mizward
//
//  Created by zhangjunbo on 15/8/8.
//  Copyright (c) 2015年 SiRui. All rights reserved.
//

#import <Foundation/Foundation.h>

extern const float SRInitialProgressValue;
extern const float SRInteractiveProgressValue;
extern const float SRFinalProgressValue;

typedef void (^SRWebViewProgressBlock)(float progress);

@protocol SRWebViewProgressDelegate;

@interface SRWebProgress : NSObject <UIWebViewDelegate>

@property (nonatomic, unsafe_unretained) id<SRWebViewProgressDelegate>progressDelegate;
@property (nonatomic, unsafe_unretained) id<UIWebViewDelegate>webViewProxyDelegate;
@property (nonatomic, copy) SRWebViewProgressBlock progressBlock;
@property (nonatomic, readonly) float progress; // 0.0..1.0

@end


@protocol SRWebViewProgressDelegate <NSObject>
- (void)webViewProgress:(SRWebProgress *)webViewProgress updateProgress:(float)progress;
@end
//
//  SRAPNsMessageView.h
//  SiRuiV4.0
//
//  Created by zhangjunbo on 15/7/30.
//  Copyright (c) 2015年 SiRui. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SRAPNsMessage;

@interface SRAPNsMessageView : UIView

@property (nonatomic, strong) SRAPNsMessage *apnsMsg;

+ (SRAPNsMessageView *)instanceAPNsMessageView;

@end

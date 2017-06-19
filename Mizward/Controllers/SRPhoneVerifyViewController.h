//
//  SRPhoneVerifyViewController.h
//  SiRuiV4.0
//
//  Created by zhangjunbo on 15/7/16.
//  Copyright (c) 2015年 SiRui. All rights reserved.
//

#import "SRBaseViewController.h"

typedef NS_ENUM(NSInteger, SRPhoneVerifyType) {
    SRPhoneVerifyType_WithoutTernimal = 0,
    SRPhoneVerifyType_WithTernimal
};

@interface SRPhoneVerifyViewController : SRBaseViewController

@property (nonatomic, assign) SRPhoneVerifyType verifyType;

@end

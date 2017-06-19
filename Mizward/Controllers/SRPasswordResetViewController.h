//
//  SRPasswordResetViewController.h
//  SiRuiV4.0
//
//  Created by zhangjunbo on 15/7/9.
//  Copyright (c) 2015年 SiRui. All rights reserved.
//

#import "SRBaseViewController.h"

typedef NS_ENUM(NSInteger, SRPasswordResetViewControllerType) {
    SRPasswordResetViewControllerType_WithoutTernimal = 0,
    SRPasswordResetViewControllerType_WithTernimal
};

@interface SRPasswordResetViewController : SRBaseViewController

@property (nonatomic, copy) NSString *phone;
@property (nonatomic, copy) NSString *authCode;

@end

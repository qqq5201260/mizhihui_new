//
//  SRWelcomeViewController.h
//  SiRuiV4.0
//
//  Created by zhangjunbo on 15/7/13.
//  Copyright (c) 2015年 SiRui. All rights reserved.
//

#import <JazzHands/IFTTTJazzHands.h>

@class SRWelcomeViewController;
@protocol SRWelcomeViewControllerDelegate <NSObject>

-(void)dismissViewController:(SRWelcomeViewController *)vc;

@end

@interface SRWelcomeViewController : IFTTTAnimatedPagingScrollViewController

@property(nonatomic,weak) id<SRWelcomeViewControllerDelegate>delegate;

@end

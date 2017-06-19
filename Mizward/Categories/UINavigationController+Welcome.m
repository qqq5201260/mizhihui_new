//
//  UINavigationController+Welcome.m
//  SiRuiV4.0
//
//  Created by zhangjunbo on 15/8/6.
//  Copyright (c) 2015年 SiRui. All rights reserved.
//

#import "UINavigationController+Welcome.h"
#import "SRUserDefaults.h"
#import "SRWelcomeViewController.h"
#import "SRUIUtil.h"
#import <Aspects/Aspects.h>
#import <MessageUI/MessageUI.h>

@implementation UINavigationController (Welcome)

+ (void)load;
{
    [self aspect_hookSelector:@selector(viewDidLoad) withOptions:AspectPositionAfter usingBlock:^(id<AspectInfo> aspectInfo){
        
        //短信发送页面，title和按钮颜色
        if ([aspectInfo.instance isKindOfClass:[MFMessageComposeViewController class]]) {
            MFMessageComposeViewController *messageVC = aspectInfo.instance;
            [messageVC.navigationBar setTintColor:[UIColor whiteColor]];
            return ;
        }
        
        if ([SRUserDefaults hasShowedWelcome]) return ;
        
        //welcome页面出现会有一定延迟，做一个假的loading页面，使过渡更平滑
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            UINavigationController *navVC = aspectInfo.instance;
            UIView *view = [[[NSBundle mainBundle] loadNibNamed:@"LaunchScreen" owner:nil options:nil] firstObject];
            [navVC.view addSubview:view];
            [view makeConstraints:^(MASConstraintMaker *make) {
                make.top.bottom.left.right.equalTo(navVC.view);
            }];
            [navVC executeOnMain:^{
                [view removeFromSuperview];
            } afterSeconds:1];
        });
       

    } error:nil];

    [self aspect_hookSelector:@selector(viewDidAppear:) withOptions:AspectPositionAfter usingBlock:^(id<AspectInfo> aspectInfo, BOOL animated){
        
        UINavigationController *navVC = aspectInfo.instance;
        if (![SRUserDefaults hasShowedWelcome]) {
            [navVC presentViewController:[[SRWelcomeViewController alloc] init] animated:NO completion:^{
                [SRUserDefaults showedWelcome];
                
                UIImageView *image = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"im_mask_main"]];
                image.userInteractionEnabled = YES;
                [image bk_whenTapped:^{
                    [UIView animateWithDuration:0.35 animations:^{
                        image.alpha = 0.0f;
                    } completion:^(BOOL finished) {
                        if (!finished) return ;
                        [image removeFromSuperview];
                    }];
                }];
                [navVC.view addSubview:image];
                [image makeConstraints:^(MASConstraintMaker *make) {
                    make.top.bottom.left.right.equalTo(navVC.view);
                }];
            }];
        }
    } error:nil];
}

@end

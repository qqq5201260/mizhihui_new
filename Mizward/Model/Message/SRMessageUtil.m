//
//  SRMessageUtil.m
//  SiRuiV4.0
//
//  Created by zhangjunbo on 15/7/22.
//  Copyright (c) 2015年 SiRui. All rights reserved.
//

#import "SRMessageUtil.h"
#import "SRUIUtil.h"
#import "SRAPNsMessageView.h"
#import <TSMessages/TSMessage.h>
#import <TSMessages/TSMessageView.h>

NSString * const kSRAPNsMessage     = @"kSRAPNsMessage";
NSString * const kDoneBlock         = @"kDoneBlock";

@interface SRMessageUtil () <TSMessageViewProtocol>

@end

@implementation SRMessageUtil

Singleton_Implementation(SRMessageUtil)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [TSMessage setDelegate:[self sharedInterface]];
    });
}

+ (void)showAPNsMessage:(SRAPNsMessage *)info withTapBlock:(VoidBlock)doneBlock {
    [[self sharedInterface] _showAPNsMessage:info withTapBlock:doneBlock];
}

#pragma mark - TSMessageViewProtocol

- (void)customizeMessageView:(TSMessageView *)messageView
{
    SRAPNsMessage *apnsMsg = [messageView bk_associatedValueForKey:&kSRAPNsMessage];
    VoidBlock doneBlock = [messageView bk_associatedValueForKey:&kDoneBlock];
    
    messageView.backgroundColor = [UIColor clearColor];
    [messageView.subviews enumerateObjectsUsingBlock:^(UIView *obj, NSUInteger idx, BOOL *stop) {
        [obj removeFromSuperview];
    }];
    
    SRAPNsMessageView *view = [SRAPNsMessageView instanceAPNsMessageView];
    view.apnsMsg = apnsMsg;
    [view bk_whenTapped:^{
        [messageView fadeMeOut];
        if (doneBlock) {
            doneBlock();
        }
    }];
    
    [messageView addSubview:view];
}

- (void)_showAPNsMessage:(SRAPNsMessage *)info withTapBlock:(VoidBlock)doneBlock {

    NSString *lines = @"\n\n";
    TSMessageView *v = [[TSMessageView alloc] initWithTitle:nil
                                                   subtitle:lines
                                                      image:nil
                                                       type:TSMessageNotificationTypeWarning
                                                   duration:10
                                           inViewController:[SRUIUtil rootViewController]
                                                   callback:nil
                                                buttonTitle:nil
                                             buttonCallback:nil
                                                 atPosition:TSMessageNotificationPositionTop
                                       canBeDismissedByUser:NO];
    [v bk_associateValue:info withKey:&kSRAPNsMessage];
    [v bk_associateCopyOfValue:doneBlock withKey:&kDoneBlock];
    [TSMessage prepareNotificationToBeShown:v];
}



@end

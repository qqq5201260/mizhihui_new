//
//  SRMaintainDetailViewController.h
//  SiRuiV4.0
//
//  Created by zhangjunbo on 15/7/14.
//  Copyright (c) 2015年 SiRui. All rights reserved.
//

#import "SRBaseViewController.h"

@class SRMaintainHistory;
@protocol SRMaintainDetailViewControllerDelegate;

@interface SRMaintainDetailViewController : SRBaseViewController

@property (nonatomic, assign) id<SRMaintainDetailViewControllerDelegate> delegate;

@property (nonatomic, strong) NSNumber *isAdd;

@property (nonatomic, strong) SRMaintainHistory *history;

@property (nonatomic, strong) NSNumber *canEdit;

@end

@protocol SRMaintainDetailViewControllerDelegate <NSObject>

- (void)localInfoDidChange;

@end

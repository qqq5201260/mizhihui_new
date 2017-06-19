//
//  UITableView+EmptyView.m
//  SiRuiV4.0
//
//  Created by zhangjunbo on 15/8/5.
//  Copyright (c) 2015年 SiRui. All rights reserved.
//

#import "UITableView+EmptyView.h"
#import <Aspects/Aspects.h>
#import <ObjcAssociatedObjectHelpers/ObjcAssociatedObjectHelpers.h>
#import <MJRefresh/MJRefresh.h>

@implementation UITableView (EmptyView)

SYNTHESIZE_ASC_OBJ(needAddEmptyView, setNeedAddEmptyView);
SYNTHESIZE_ASC_OBJ(emptyView, setEmptyView);
SYNTHESIZE_ASC_OBJ(previousLegendFooter, setPreviousLegendFooter);

+ (void)load;
{
    //raloadData 与UITableView+FDTemplateLayoutCell 冲突 相关代码挪到 UITableView+FDTemplateLayoutCell 里面
//    [self aspect_hookSelector:@selector(reloadData) withOptions:AspectPositionBefore usingBlock:^(id<AspectInfo> aspectInfo){
//        [aspectInfo.instance aspect_reloadData];
//    } error:nil];
    [self aspect_hookSelector:@selector(layoutSubviews) withOptions:AspectPositionBefore usingBlock:^(id<AspectInfo> aspectInfo){
        [aspectInfo.instance aspect_layoutSubviews];
    } error:nil];
    [self aspect_hookSelector:@selector(removeFromSuperview) withOptions:AspectPositionBefore usingBlock:^(id<AspectInfo> aspectInfo){
        [aspectInfo.instance bk_removeObserverForKeyPath:@"header.state" identifier:@"header.state"];
    }  error:nil];
}

#pragma mark aspect methods

- (void)aspect_reloadData;
{
    [self updateEmptyView];
}

- (void)aspect_layoutSubviews;
{
    [self updateEmptyView];
}

#pragma mark Updating

- (void)updateEmptyView;
{
    if (![self.needAddEmptyView boolValue]) return;
    
    if (!self.emptyView) {
        self.emptyView = [[[NSBundle mainBundle] loadNibNamed:@"SRTableEmptyView" owner:nil options:nil] firstObject];
    }
    UIView *emptyView = self.emptyView;
    
    if (emptyView.superview != self) {
        [emptyView removeFromSuperview];
        [self addSubview:emptyView];
        [emptyView makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self);
        }];
    }
    
    [self bk_removeObserverForKeyPath:@"header.state" identifier:@"header.state"];
    if (self.mj_header) {
        [self bk_addObserverForKeyPath:@"header.state" identifier:@"header.state" options:NSKeyValueObservingOptionInitial|NSKeyValueObservingOptionNew task:^(id obj, NSDictionary *change) {
            
            BOOL needHiddenEmptyView = [self hasRowsToDisplay] || self.mj_header.state != MJRefreshStateIdle;
            emptyView.hidden = needHiddenEmptyView;
        }];
    } else {
        BOOL needHiddenEmptyView = [self hasRowsToDisplay];
        emptyView.hidden = needHiddenEmptyView;
    }
}

#pragma mark Properties

- (BOOL)hasRowsToDisplay;
{
    NSUInteger numberOfRows = 0;
    for (NSInteger sectionIndex = 0; sectionIndex < self.numberOfSections; sectionIndex++) {
        numberOfRows += [self numberOfRowsInSection:sectionIndex];
    }
    return (numberOfRows > 0);
}

@end

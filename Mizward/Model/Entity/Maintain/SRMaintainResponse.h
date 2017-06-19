//
//  SRMaintainResponse.h
//  SiRuiV4.0
//
//  Created by zhangjunbo on 15/7/28.
//  Copyright (c) 2015年 SiRui. All rights reserved.
//

#import "SREntity.h"

@class SRMaintainDepInfo;

@interface SRMaintainDepResponse : SREntity

@property (nonatomic, copy) NSString    *cacheTime;
@property (nonatomic, strong) SRMaintainDepInfo *dep;
@property (nonatomic, strong) NSArray *depVOs;

@end

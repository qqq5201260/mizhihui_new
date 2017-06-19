//
//  SRMaintainDepInfo.h
//  SiRuiV4.0
//
//  Created by zhangjunbo on 15/7/27.
//  Copyright (c) 2015年 SiRui. All rights reserved.
//

#import "SREntity.h"

@interface SRMaintainDepInfo : SREntity

@property (nonatomic, assign) NSInteger depID;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, assign) CGFloat lat;
@property (nonatomic, assign) CGFloat lng;
@property (nonatomic, copy) NSString *address;
@property (nonatomic, copy) NSString *phone;

@property (nonatomic, assign) CGFloat distance;

- (CLLocationCoordinate2D)coordinate;

@end

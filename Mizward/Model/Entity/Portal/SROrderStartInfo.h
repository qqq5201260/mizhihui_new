//
//  SROrderStartInfo.h
//  SiRuiV4.0
//
//  Created by zhangjunbo on 15/6/17.
//  Copyright (c) 2015年 SiRui. All rights reserved.
//

#import "SREntity.h"

@class SRPortalRequestAddOrderStart, SRPortalRequestUpdateOrderStart;

extern NSString * const repeateTypeWithNoRepeat;

@interface SROrderStartInfo : SREntity

@property (nonatomic, assign)   NSInteger   startClockID;
@property (nonatomic, assign)   NSInteger   type;
@property (nonatomic, assign)   NSInteger   vehicleID;
@property (nonatomic, copy)     NSString    *startTime;
@property (nonatomic, assign)   BOOL        isRepeat;
@property (nonatomic, assign)   NSInteger   startTimeLength;
@property (nonatomic, copy)     NSString    *repeatType;
@property (nonatomic, assign)   BOOL        isOpen;

- (instancetype)initWithOrderStartInfo:(SROrderStartInfo *)info;
- (instancetype)initWithAddRequest:(SRPortalRequestAddOrderStart *)request;
- (instancetype)initWithUpdateRequest:(SRPortalRequestUpdateOrderStart *)request;

- (NSString *)repeatTypeDetail;
- (NSInteger)customerID;

@end

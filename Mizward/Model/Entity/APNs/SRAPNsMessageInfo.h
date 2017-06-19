//
//  SRAPNsMessageInfo.h
//  SiRuiV4.0
//
//  Created by zhangjunbo on 15/7/15.
//  Copyright (c) 2015年 SiRui. All rights reserved.
//

#import "SREntity.h"

@interface SRAPNsMessageInfo : SREntity

@property (nonatomic, assign) NSInteger cid;//customerID
@property (nonatomic, assign) NSInteger mid;//messageID
@property (nonatomic, assign) SRMessageSubType mt; //二级type
@property (nonatomic, assign) SRMessageType t;//一级type
@property (nonatomic, assign) NSInteger vid;//vehicleID
@property (nonatomic, copy) NSString *o;//object;

@property (nonatomic, strong) NSDictionary *object;

@end

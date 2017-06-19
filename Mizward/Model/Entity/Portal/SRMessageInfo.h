//
//  SRMessageInfo.h
//  SiRuiV4.0
//
//  Created by zhangjunbo on 15/6/27.
//  Copyright (c) 2015年 SiRui. All rights reserved.
//

#import "SREntity.h"

@interface SRMessageInfo : SREntity

@property (nonatomic, assign) SRMessageType type; //一级type
@property (nonatomic, assign) SRMessageSubType msgtype; //二级Type
@property (nonatomic, assign) NSInteger msgid;
@property (nonatomic, assign) NSInteger customerid;
@property (nonatomic, assign) NSInteger vehicleid;
@property (nonatomic, copy)   NSString  *message;
@property (nonatomic, copy)   NSString  *time;

@property (nonatomic, strong) NSDictionary *object;

@end

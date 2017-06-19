//
//  SRAPNsMessage.h
//  SiRuiV4.0
//
//  Created by zhangjunbo on 15/6/30.
//  Copyright (c) 2015年 SiRui. All rights reserved.
//

#import "SREntity.h"

@class SRAPNs, SRAPNsMessageInfo;

@interface SRAPNsMessage : SREntity

@property (nonatomic, strong) SRAPNs *aps;
@property (nonatomic, strong) SRAPNsMessageInfo *MSG;

@end

@interface SRAPNs : SREntity

@property (nonatomic, copy) NSString *alert;
@property (nonatomic, assign) NSInteger badge;
@property (nonatomic, copy) NSString *sound;

@end

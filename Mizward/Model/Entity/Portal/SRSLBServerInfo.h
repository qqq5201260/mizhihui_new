//
//  SRSLBServerInfo.h
//  SiRuiV4.0
//
//  Created by zhangjunbo on 15/6/17.
//  Copyright (c) 2015年 SiRui. All rights reserved.
//

#import "SREntity.h"

@interface SRSLBServerInfo : SREntity

@property (nonatomic, assign) BOOL enabled;
@property (nonatomic, copy) NSString *server;
@property (nonatomic, copy) NSString *ip;
@property (nonatomic, copy) NSString *port;

@end

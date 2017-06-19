//
//  SRPortal+APNs.h
//  SiRuiV4.0
//
//  Created by zhangjunbo on 15/6/23.
//  Copyright (c) 2015年 SiRui. All rights reserved.
//

#import "SRPortal.h"

@interface SRPortal (APNs)

//解析APNs消息
+ (void)parseAPNsMessage:(NSDictionary *)userInfo;

@end

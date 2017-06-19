//
//  BMKLocationService+BlocksKit.h
//  SiRuiV4.0
//
//  Created by zhangjunbo on 15/7/4.
//  Copyright (c) 2015年 SiRui. All rights reserved.
//

#import <BaiduMapAPI/BMapKit.h>

@interface BMKLocationService (BlocksKit)

@property (nonatomic, copy, setter = bk_didUpdateBMKUserLocation:) void (^bk_didUpdateBMKUserLocation)(BMKUserLocation *userLocation);

@end

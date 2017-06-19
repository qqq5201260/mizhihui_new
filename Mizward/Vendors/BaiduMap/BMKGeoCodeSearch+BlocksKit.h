//
//  BMKGeoCodeSearch+BlocksKit.h
//  SiRuiV4.0
//
//  Created by zhangjunbo on 15/7/4.
//  Copyright (c) 2015年 SiRui. All rights reserved.
//

#import <BaiduMapAPI/BMapKit.h>

@interface BMKGeoCodeSearch (BlocksKit)

@property (nonatomic, copy, setter = bk_onGetReverseGeoCodeResult:) void (^bk_onGetReverseGeoCodeResult)(BMKGeoCodeSearch *searcher , BMKReverseGeoCodeResult *result, BMKSearchErrorCode error);

@end

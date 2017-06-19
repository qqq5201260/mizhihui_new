//
//  SRTripPoint.h
//  SiRuiV4.0
//
//  Created by zhangjunbo on 15/6/16.
//  Copyright (c) 2015年 SiRui. All rights reserved.
//

#import "SREntity.h"

@interface SRTripPoint : SREntity

@property (nonatomic, assign) CGFloat lat;
@property (nonatomic, assign) CGFloat lng;
@property (nonatomic, copy) NSString *uTCTime;

//自定义扩展字段
@property (nonatomic, copy) NSString *localTime;
@property (nonatomic, assign) CLLocationCoordinate2D location;

- (NSDictionary *)customerDictionaryValue;

@end

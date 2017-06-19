//
//  SRRealmOrderStart.h
//  Mizward
//
//  Created by zhangjunbo on 15/9/1.
//  Copyright (c) 2015年 Mizward. All rights reserved.
//

#import <Realm/RLMObject.h>

@class SROrderStartInfo;

@interface SRRealmOrderStart : RLMObject

@property   NSInteger   startClockID;
@property   NSInteger   type;
@property   NSInteger   vehicleID;
@property   NSString    *startTime;
@property   BOOL        isRepeat;
@property   NSInteger   startTimeLength;
@property   NSString    *repeatType;
@property   BOOL        isOpen;

//自定义字段
@property   NSInteger   customerID;

- (instancetype)initWithOrderStartInfo:(SROrderStartInfo *)info;
- (SROrderStartInfo *)orderStartInfo;

@end

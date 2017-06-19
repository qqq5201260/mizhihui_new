//
//  SRRealmMessage.h
//  Mizward
//
//  Created by zhangjunbo on 15/9/1.
//  Copyright (c) 2015年 Mizward. All rights reserved.
//

#import <Realm/RLMObject.h>

@class SRMessageInfo;

@interface SRRealmMessage : RLMObject

@property   NSInteger type; //一级type
@property   NSInteger msgtype; //二级Type
@property   NSInteger msgid;
@property   NSInteger customerid;
@property   NSInteger vehicleid;
@property   NSString  *message;
@property   NSString  *time;

- (instancetype)initWithMessageInfo:(SRMessageInfo *)info;
- (SRMessageInfo *)messageInfo;

@end

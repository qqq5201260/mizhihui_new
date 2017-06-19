//
//  SRRealmMaintainDep.h
//  Mizward
//
//  Created by zhangjunbo on 15/9/1.
//  Copyright (c) 2015年 Mizward. All rights reserved.
//

#import <Realm/RLMObject.h>

@class SRMaintainDepInfo;

@interface SRRealmMaintainDep : RLMObject

@property   NSInteger depID;
@property   NSString *name;
@property   CGFloat lat;
@property   CGFloat lng;
@property   NSString *address;
@property   NSString *phone;

- (instancetype)initWithMaintainDepInfo:(SRMaintainDepInfo *)info;

- (SRMaintainDepInfo *)maintainDepInfo;

@end

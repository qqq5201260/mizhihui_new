//
//  SRRealmBrandInfo.h
//  Mizward
//
//  Created by zhangjunbo on 15/9/1.
//  Copyright (c) 2015年 Mizward. All rights reserved.
//

#import <Realm/RLMObject.h>

@class SRBrandInfo;

@interface SRRealmBrandInfo : RLMObject

@property   NSInteger entityID;
@property   NSString *name;

//扩展字段
@property   NSString *seriesList;

- (instancetype)initWithBrandInfo:(SRBrandInfo *)brandInfo;

- (SRBrandInfo *)brandInfo;

@end

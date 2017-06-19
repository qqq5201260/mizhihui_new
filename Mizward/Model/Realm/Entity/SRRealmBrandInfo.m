//
//  SRRealmBrandInfo.m
//  Mizward
//
//  Created by zhangjunbo on 15/9/1.
//  Copyright (c) 2015年 Mizward. All rights reserved.
//

#import "SRRealmBrandInfo.h"
#import "SRBrandInfo.h"

@implementation SRRealmBrandInfo

+ (nullable NSString *)primaryKey
{
    return @"entityID";
}

- (instancetype)initWithBrandInfo:(SRBrandInfo *)brandInfo
{
    if (self = [super init]) {
        _entityID = brandInfo.entityID;
        _name = brandInfo.name?brandInfo.name:@"";
        _seriesList = brandInfo.seriesListString;
    }
    return self;
}

- (SRBrandInfo *)brandInfo
{
    SRBrandInfo *brandInfo = [[SRBrandInfo alloc] init];
    brandInfo.entityID = self.entityID;
    brandInfo.name = self.name;
    [brandInfo setSeriesListWithString:self.seriesList];
    return brandInfo;
}

@end

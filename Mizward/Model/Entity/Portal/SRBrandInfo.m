//
//  SRBrandInfo.m
//  SiRuiV4.0
//
//  Created by zhangjunbo on 15/6/16.
//  Copyright (c) 2015年 SiRui. All rights reserved.
//

#import "SRBrandInfo.h"
#import "SRURLUtil.h"
#import "SRSeriesInfo.h"
#import <MJExtension/MJExtension.h>

@implementation SRBrandInfo

- (instancetype)init {
    if (self = [super init]) {
        _seriesList = [NSArray array];
    }
    
    return self;
}

- (NSString *)logoUrl {
    return [SRURLUtil Portal_BrandImageUrl:self.entityID];
}

- (NSString *)brandFirstLetter {
    return self.name.pinYinFirstLetter;
}


- (NSString *)seriesListString {
    if (!self.seriesList || self.seriesList.count == 0) return nil;
    
    NSMutableArray *array = [NSMutableArray array];
    [self.seriesList enumerateObjectsUsingBlock:^(SRSeriesInfo *obj, NSUInteger idx, BOOL *stop) {
        NSError *error = nil;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:obj.keyValues options:NSJSONWritingPrettyPrinted error:&error];
        if (!error) {
            NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
            [array addObject:jsonString];
        }
    }];
    
    return [array componentsJoinedByString:@"*"];
}

- (void)setSeriesListWithString:(NSString *)string {
    NSArray *jsonArray = [string componentsSeparatedByString:@"*"];
    
    NSMutableArray *list = [NSMutableArray array];
    [jsonArray enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL *stop) {
        NSData *jsonData = [obj dataUsingEncoding:NSUTF8StringEncoding];
        NSError *error = nil;
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableLeaves error:&error];
        if (!error) {
            SRSeriesInfo *info = [SRSeriesInfo objectWithKeyValues:dic];
            [list addObject:info];
        }
    }];
    
    self.seriesList = list;
}

@end

//
//  SRRealmTripPoints.m
//  Mizward
//
//  Created by zhangjunbo on 15/9/1.
//  Copyright (c) 2015年 Mizward. All rights reserved.
//

#import "SRRealmTripPoints.h"
#import "SRTripPoint.h"
#import <MJExtension/MJExtension.h>

@implementation SRRealmTripPoints

+ (nullable NSString *)primaryKey
{
    return @"tripID";
}

- (instancetype)initWithTripID:(NSString *)tripID vehicleID:(NSInteger)vehicleID tripPoints:(NSArray *)tripPoints
{
    if (self = [super init]) {
        _tripID = tripID?tripID:@"";
        _vehicleID = vehicleID;
        _tripPointsStr = [self listToString:tripPoints];
    }
    
    return self;
}

- (NSArray *)tripPoints
{
    return [self stringToList:self.tripPointsStr];
}

- (NSString *)listToString:(NSArray *)list {
    if (!list || list == 0) return @"";
    
    NSMutableArray *array = [NSMutableArray array];
    [list enumerateObjectsUsingBlock:^(SRTripPoint *obj, NSUInteger idx, BOOL *stop) {
        @autoreleasepool {
            NSError *error = nil;
            NSData *jsonData = [NSJSONSerialization dataWithJSONObject:obj.customerDictionaryValue options:NSJSONWritingPrettyPrinted error:&error];
            if (!error) {
                NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
                [array addObject:jsonString];
            }
        }
    }];
    
    return [array componentsJoinedByString:@"*"];
}

- (NSArray *)stringToList:(NSString *)string {
    NSArray *jsonArray = [string componentsSeparatedByString:@"*"];
    
    NSMutableArray *points = [NSMutableArray array];
    [jsonArray enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL *stop) {
        @autoreleasepool {
            NSData *jsonData = [obj dataUsingEncoding:NSUTF8StringEncoding];
            NSError *error = nil;
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableLeaves error:&error];
            if (!error) {
                SRTripPoint *point = [SRTripPoint objectWithKeyValues:dic];
                [points addObject:point];
            }
        }
    }];
    
    return points;
}


@end

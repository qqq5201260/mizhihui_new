//
//  NSDictionary+Additions.m
//  SiRuiV4.0
//
//  Created by zhangjunbo on 15/6/18.
//  Copyright (c) 2015年 SiRui. All rights reserved.
//

#import "NSDictionary+Additions.h"

@implementation NSDictionary (Additions)

- (NSArray *)sortedKeys {
    return [self.allKeys sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        NSComparisonResult result = [obj1 compare:obj2];
        return result == NSOrderedAscending;  // 降序
    }];
}

- (NSArray *)sortedKeysDescending {
    return [self.allKeys sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        NSComparisonResult result = [obj1 compare:obj2];
        return result == NSOrderedDescending; // 升序
    }];
}

@end

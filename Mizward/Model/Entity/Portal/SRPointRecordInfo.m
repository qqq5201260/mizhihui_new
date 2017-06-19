//
//  SRPointRecordInfo.m
//  Mizward
//
//  Created by zhangjunbo on 15/12/11.
//  Copyright © 2015年 Mizward. All rights reserved.
//

#import "SRPointRecordInfo.h"

@implementation SRPointRecordInfo

- (NSDate *)createDate
{
    return [NSDate convertDateFromStringWithFormatYYYYMMddHHmmss:self.createTime];
}

@end

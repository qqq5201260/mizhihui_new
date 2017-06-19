//
//  SROrderStartInfo.m
//  SiRuiV4.0
//
//  Created by zhangjunbo on 15/6/17.
//  Copyright (c) 2015年 SiRui. All rights reserved.
//

#import "SROrderStartInfo.h"
#import "SRUserDefaults.h"
#import "SRPortalRequest.h"

NSString * const repeateTypeWithNoRepeat = @"0000000";

@interface SROrderStartInfo ()

//自定义字段
@property (nonatomic, assign)   NSInteger   customerID;

@end

@implementation SROrderStartInfo

- (instancetype)init {
    if (self = [super init]) {
        _customerID = [SRUserDefaults customerID];
    }
    return self;
}

- (instancetype)initWithOrderStartInfo:(SROrderStartInfo *)info
{
    if (self = [super init]) {
        _startClockID   = info.startClockID;
        _type           = info.type;
        _vehicleID      = info.vehicleID;
        _startTime      = info.startTime;
        _isRepeat       = info.isRepeat;
        _startTimeLength = info.startTimeLength;
        _repeatType     = info.repeatType;
        _isOpen         = info.isOpen;
        _customerID     = info.customerID;
    }
    return self;
}

- (instancetype)initWithAddRequest:(SRPortalRequestAddOrderStart *)request
{
    if (self = [super init]) {
        _type           = request.type;
        _vehicleID      = request.vehicleID;
        _startTime      = request.startTime;
        _isRepeat       = request.isRepeat;
        _startTimeLength = request.startTimeLength;
        _repeatType     = request.repeatType;
        _isOpen         = request.isOpen;
        _customerID     = [SRUserDefaults customerID];
    }
    return self;
}

- (instancetype)initWithUpdateRequest:(SRPortalRequestUpdateOrderStart *)request
{
    if (self = [super init]) {
        _startClockID   = request.startClockID;
        _type           = request.type;
        _vehicleID      = request.vehicleID;
        _startTime      = request.startTime;
        _isRepeat       = request.isRepeat;
        _startTimeLength = request.startTimeLength;
        _repeatType     = request.repeatType;
        _isOpen         = request.isOpen;
        _customerID     = [SRUserDefaults customerID];
    }
    return self;
}

- (NSString *)repeatTypeDetail {
    if ([self.repeatType isEqualToString:repeateTypeWithNoRepeat]) {
        return SRLocal(@"string_order_no_repeat");
    }
    
    NSMutableString *string = [NSMutableString stringWithString:@"周 "];
    for (NSInteger index = 0; index < self.repeatType.length; index++) {
        NSString *sub = [self.repeatType substringWithRange:NSMakeRange(index, 1)];
        if (!sub.boolValue) {
            continue;
        }
        switch (index) {
            case 0:
                [string appendString:@"一 "];
                break;
            case 1:
                [string appendString:@"二 "];
                break;
            case 2:
                [string appendString:@"三 "];
                break;
            case 3:
                [string appendString:@"四 "];
                break;
            case 4:
                [string appendString:@"五 "];
                break;
            case 5:
                [string appendString:@"六 "];
                break;
            case 6:
                [string appendString:@"日 "];
                break;
                
                
            default:
                break;
        }
    }
    
    return string;
}


@end

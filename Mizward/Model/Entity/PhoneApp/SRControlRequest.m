//
//  SRControlRequest.m
//  SiRuiV4.0
//
//  Created by zhangjunbo on 15/6/23.
//  Copyright (c) 2015年 SiRui. All rights reserved.
//

#import "SRControlRequest.h"
#import "SRKeychain.h"

@implementation SRControlRequest

- (instancetype)init {
    if (self = [super init]) {
        _app = @"miz";
    }
    return self;
}

- (NSDictionary *)customerDictionary
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    NSString *input1 = [NSString stringWithFormat:@"%zd_%zd_%@", _vehicleID, _instructionID, _userName].RSAEncode;
    if (input1) {
        [dic setObject:input1 forKey:@"input1"];
    }
    NSString *input2 = _password.RSAEncode;
    if (input2) {
        [dic setObject:input2 forKey:@"input2"];
    }
    
    NSString *input3 = [SRKeychain UUID].RSAEncode;
    if (input3) {
        [dic setObject:input3 forKey:@"input3"];
    }
    
    NSString *input4 = [NSString stringWithFormat:@"%zd", _controlSeries].RSAEncode;
    if (input4) {
        [dic setObject:input4 forKey:@"input4"];
    }
    
    return dic;
    
//    return @{
//             @"input1":[NSString stringWithFormat:@"%zd_%zd_%@", _vehicleID, _instructionID, _userName].RSAEncode,
//             @"input2":_password.RSAEncode,
//             @"input3":[SRKeychain UUID].RSAEncode,
//             @"input4":[NSString stringWithFormat:@"%zd", _controlSeries].RSAEncode,
//             };
}

@end

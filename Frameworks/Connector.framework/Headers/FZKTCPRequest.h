//
//  SRTCPRequest.h
//  SiRuiV4.0
//
//  Created by zhangjunbo on 15/6/16.
//  Copyright (c) 2015年 SiRui. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FZKTCPRequestHead.h"


@interface FZKTCPRequest : NSObject

@property (nonatomic, strong) FZKTCPRequestHead *head;
@property (nonatomic, strong) NSDictionary *body;

+ (FZKTCPRequest *)AddressingRequestWithUserName:(NSString *)userName;

+ (FZKTCPRequest *)LoginRequestWithUserName:(NSString *)userName
                               andPassword:(NSString *)password;

+ (FZKTCPRequest *)InstructionRequestWithCmdID:(NSInteger)instructionID
                                controlSeries:(NSInteger)controlSeries
                                 andVehicleID:(NSInteger)vehicleID;

+ (FZKTCPRequest *)AckWithDirect:(NSInteger)direction
                         funcID:(NSInteger)functionID
                andSerialNumber:(NSInteger)serialNumber;

//蓝牙状态修改
+ (FZKTCPRequest *)bleStatusWithVehicleID:(NSInteger)vehicleID
                             isConnected:(BOOL)isConnected;

+ (FZKTCPRequest *)bleDebuggingWithVehicleID:(NSInteger)vehicleID
                                  logString:(NSString *)logString;

- (NSData *)dataValue;

@end

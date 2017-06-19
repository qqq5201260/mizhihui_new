//
//  SRTCPRequest.h
//  SiRuiV4.0
//
//  Created by zhangjunbo on 15/6/16.
//  Copyright (c) 2015年 SiRui. All rights reserved.
//

#import "SREntity.h"

@class SRTCPRequestHead;

@interface SRTCPRequest : SREntity

@property (nonatomic, strong) SRTCPRequestHead *head;
@property (nonatomic, strong) NSDictionary *body;

+ (SRTCPRequest *)AddressingRequestWithUserName:(NSString *)userName;

+ (SRTCPRequest *)LoginRequestWithUserName:(NSString *)userName
                               andPassword:(NSString *)password;

+ (SRTCPRequest *)InstructionRequestWithCmdID:(NSInteger)instructionID
                                controlSeries:(NSInteger)controlSeries
                                 andVehicleID:(NSInteger)vehicleID;

+ (SRTCPRequest *)AckWithDirect:(NSInteger)direction
                         funcID:(NSInteger)functionID
                andSerialNumber:(NSInteger)serialNumber;

//蓝牙调试
+ (SRTCPRequest *)bleStatusWithVehicleID:(NSInteger)vehicleID
                             isConnected:(BOOL)isConnected;
+ (SRTCPRequest *)bleDebuggingWithVehicleID:(NSInteger)vehicleID
                                  logString:(NSString *)logString;

- (NSData *)dataValue;

@end

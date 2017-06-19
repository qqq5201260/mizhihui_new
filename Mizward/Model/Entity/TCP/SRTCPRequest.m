//
//  SRTCPRequest.m
//  SiRuiV4.0
//
//  Created by zhangjunbo on 15/6/16.
//  Copyright (c) 2015年 SiRui. All rights reserved.
//

#import "SRTCPRequest.h"
#import <MJExtension/MJExtension.h>

#import "SRTCPReqLoginBody.h"
#import "SRTCPReqInstructionBody.h"
#import "SRTCPRequestHead.h"
#import "SRUserDefaults.h"
#import "SRTLV.h"
#import "SRTCPResponseBody.h"

@implementation SRTCPRequest

+ (SRTCPRequest *)AddressingRequestWithUserName:(NSString *)userName {
    
    SRTCPReqLoginBody *loginBody = [[SRTCPReqLoginBody alloc] init];
    loginBody.userName = userName;
    
    SRTCPRequest *request = [[SRTCPRequest alloc] init];
    request.head = [[SRTCPRequestHead alloc] initWithDirect:TCPDirect_Request
                                                     funcID:TCPFuncID_Addressing
                                            andSerialNumber:[SRUserDefaults serialNumber]];
    request.body = loginBody.keyValues;
    
    return request;
}

+ (SRTCPRequest *)LoginRequestWithUserName:(NSString *)userName andPassword:(NSString *)password {
    
    SRTCPReqLoginBody *loginBody = [[SRTCPReqLoginBody alloc] init];
    loginBody.userName = userName.RSAEncode;
    loginBody.password = password.RSAEncode;
    
    SRTCPRequest *request = [[SRTCPRequest alloc] init];
    request.head = [[SRTCPRequestHead alloc] initWithDirect:TCPDirect_Request
                                                     funcID:TCPFuncID_Login
                                            andSerialNumber:[SRUserDefaults serialNumber]];
    request.body = loginBody.keyValues;
    
    return request;
}

+ (SRTCPRequest *)InstructionRequestWithCmdID:(NSInteger)instructionID
                                controlSeries:(NSInteger)controlSeries
                                 andVehicleID:(NSInteger)vehicleID {
    SRTCPReqInstructionBody *instructionBody = [[SRTCPReqInstructionBody alloc] init];
    instructionBody.instructionID = instructionID;
    instructionBody.vehicleID = vehicleID;
    
    SRTCPRequest *request = [[SRTCPRequest alloc] init];
    request.head = [[SRTCPRequestHead alloc] initWithDirect:TCPDirect_Request
                                                     funcID:TCPFuncID_Instruction
                                            andSerialNumber:controlSeries];
    request.body = instructionBody.keyValues;
    
    return request;
}

+ (SRTCPRequest *)AckWithDirect:(NSInteger)direction
                         funcID:(NSInteger)functionID
                andSerialNumber:(NSInteger)serialNumber {
    SRTCPRequest *request = [[SRTCPRequest alloc] init];
    request.head = [[SRTCPRequestHead alloc] initWithDirect:direction funcID:functionID andSerialNumber:serialNumber];
    
    return request;
}

//蓝牙调试
+ (SRTCPRequest *)bleStatusWithVehicleID:(NSInteger)vehicleID
                             isConnected:(BOOL)isConnected
{
    SRTCPRequest *request = [[SRTCPRequest alloc] init];
    request.head = [[SRTCPRequestHead alloc] initWithDirect:TCPDirect_OneWay funcID:TCPFuncID_Synchronous andSerialNumber:[SRUserDefaults serialNumber]];
    
    SRTLV *tlv = [[SRTLV alloc] init];
    tlv.tag = SRTLVTag_Debugging_BleStatus;
    tlv.value = [NSString stringWithFormat:@"%@_%@", @(vehicleID), @(isConnected)];
    
    SRTCPResponseBody *body = [[SRTCPResponseBody alloc] init];
    body.clientType = 4;
    body.entityID = [SRUserDefaults customerID];
    body.parameters = @[tlv];

    request.body = body.keyValues;
    
    return request;
}

+ (SRTCPRequest *)bleDebuggingWithVehicleID:(NSInteger)vehicleID
                                  logString:(NSString *)logString
{
    SRTCPRequest *request = [[SRTCPRequest alloc] init];
    request.head = [[SRTCPRequestHead alloc] initWithDirect:TCPDirect_OneWay funcID:TCPFuncID_BleDebugging andSerialNumber:[SRUserDefaults serialNumber]];
    
    SRTLV *tlv = [[SRTLV alloc] init];
    tlv.tag = SRTLVTag_Debugging_TerminalToServer;
    tlv.value = [NSString stringWithFormat:@"%@", logString];
    
    SRTCPResponseBody *body = [[SRTCPResponseBody alloc] init];
    body.clientType = 4;
    body.entityID = [SRUserDefaults customerID];
    body.parameters = @[tlv];
    
    request.body = body.keyValues;
    
    return request;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _head = [[SRTCPRequestHead alloc] init];
    }
    
    return self;
}

- (NSData *)dataValue {
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self.keyValues options:kNilOptions error:nil];
    NSString *preString = [NSString stringWithFormat:@"%04zd%02zd%02zd", jsonData.length, self.head.direction, self.head.functionID];
    NSMutableData *reusltData = [NSMutableData data];
    [reusltData appendData:[preString dataUsingEncoding:NSUTF8StringEncoding]];
    [reusltData appendData:jsonData];
    
    SRLogDebug(@"TCP Request: %@", [[NSString alloc] initWithData:reusltData encoding:NSUTF8StringEncoding]);
    
    return reusltData;
}


@end

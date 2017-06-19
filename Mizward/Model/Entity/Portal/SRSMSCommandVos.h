//
//  SRSMSCommandVos.h
//  SiRuiV4.0
//
//  Created by zhangjunbo on 15/6/16.
//  Copyright (c) 2015年 SiRui. All rights reserved.
//

#import "SREntity.h"

@interface SRSMSCommandVos : SREntity

@property (nonatomic, assign) NSInteger vehicleID;
@property (nonatomic, strong) NSArray   *smsCommandVos; //obj:SRTLV

- (NSString *)stringValue;
- (instancetype)initWithString:(NSString *)aString;

- (NSString *)getSMSCommandStringWithTag:(SRTLVTag_Instruction)tag;

@end

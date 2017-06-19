//
//  SRTCPRequestHead.h
//  SiRuiV4.0
//
//  Created by zhangjunbo on 15/6/16.
//  Copyright (c) 2015年 SiRui. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FZKTCPRequestHead : NSObject

@property (nonatomic, assign) NSInteger direction;
@property (nonatomic, assign) NSInteger functionID;
@property (nonatomic, assign) NSInteger serialNumber;

- (instancetype)initWithDirect:(NSInteger)direction
                        funcID:(NSInteger)functionID
               andSerialNumber:(NSInteger)serialNumber;

@end

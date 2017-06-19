//
//  SRNearbyPeripheral.h
//  Mizward
//
//  Created by zhangjunbo on 15/9/16.
//  Copyright (c) 2015年 Mizward. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CBPeripheral;

@interface SRNearbyPeripheral : NSObject

@property (nonatomic,strong) CBPeripheral *peripheral;
@property (nonatomic,strong) NSDictionary *advertisementData;
@property (nonatomic,strong) NSNumber *RSSI;

- (NSString *)mac;

@end

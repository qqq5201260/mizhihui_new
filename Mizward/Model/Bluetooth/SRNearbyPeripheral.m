//
//  SRNearbyPeripheral.m
//  Mizward
//
//  Created by zhangjunbo on 15/9/16.
//  Copyright (c) 2015年 Mizward. All rights reserved.
//

#import "SRNearbyPeripheral.h"
#import <CoreBluetooth/CoreBluetooth.h>

@implementation SRNearbyPeripheral

- (NSString *)mac
{
    return self.advertisementData[CBAdvertisementDataLocalNameKey];
}

@end

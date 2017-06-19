//
//  SRDtcInfo.m
//  SiRuiV4.0
//
//  Created by zhangjunbo on 15/7/30.
//  Copyright (c) 2015年 SiRui. All rights reserved.
//

#import "SRDtcInfo.h"

@implementation SRDtcInfo

- (SRSystemType)systemType
{
    if ([self.errorSystem isEqualToString:@"变速箱控制系统故障"]
        ||[self.errorSystem isEqualToString:@"点火系统故障"]
        ||[self.errorSystem isEqualToString:@"废气控制系统故障"]
        ||[self.errorSystem isEqualToString:@"燃油和空气侦测系统故障"]) {
        return SRSystemType_Engine_Transmission;
    } else if ([self.errorSystem isEqualToString:@"车速怠速控制系统故障"]) {
        return SRSystemType_Chassis;
    } else if ([self.errorSystem isEqualToString:@"电脑控制系统故障"]) {
        return SRSystemType_Bodywork;
    } else {
        return SRSystemType_Network;
    }
}

@end

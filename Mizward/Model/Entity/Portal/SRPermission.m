//
//  SRPermission.m
//  SiRuiV4.0
//
//  Created by zhangjunbo on 15/6/16.
//  Copyright (c) 2015年 SiRui. All rights reserved.
//

#import "SRPermission.h"

NSString * const SRPermissionTypeString_NamePassword = @"u_NamePassword";
NSString * const SRPermissionTypeString_Phone = @"u_Phone";

@implementation SRPermission

- (SRPermissionType)permissionType {
    if ([self.name isEqualToString:SRPermissionTypeString_NamePassword]) {
        return SRPermissionType_NamePassword;
    } else if ([self.name isEqualToString:SRPermissionTypeString_Phone]) {
        return SRPermissionType_Phone;
    } else {
        return SRPermissionType_Unknown;
    }
}

@end

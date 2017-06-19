//
//  SRPermission.h
//  SiRuiV4.0
//
//  Created by zhangjunbo on 15/6/16.
//  Copyright (c) 2015年 SiRui. All rights reserved.
//

#import "SREntity.h"

@interface SRPermission : SREntity

@property (nonatomic, copy)     NSString    *name;
@property (nonatomic, assign)   BOOL        value;

- (SRPermissionType)permissionType;

@end

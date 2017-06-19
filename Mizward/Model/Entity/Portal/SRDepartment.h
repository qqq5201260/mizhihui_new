//
//  SRDepartment.h
//  SiRuiV4.0
//
//  Created by zhangjunbo on 15/6/16.
//  Copyright (c) 2015年 SiRui. All rights reserved.
//

#import "SREntity.h"

@interface SRDepartment : SREntity

@property (nonatomic, copy) NSString *phone;
@property (nonatomic, copy) NSString *assistPhone;
@property (nonatomic, copy) NSString *notifyDangerPhone;
@property (nonatomic, copy) NSString *serverPhone;
@property (nonatomic, copy) NSString *address;
@property (nonatomic, assign) CGFloat lat;
@property (nonatomic, assign) CGFloat lng;
@property (nonatomic, copy) NSString *name;

@end

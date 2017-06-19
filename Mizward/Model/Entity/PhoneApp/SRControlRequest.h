//
//  SRControlRequest.h
//  SiRuiV4.0
//
//  Created by zhangjunbo on 15/6/23.
//  Copyright (c) 2015年 SiRui. All rights reserved.
//

#import "SREntity.h"

@interface SRControlRequest : SREntity

@property (nonatomic, copy) NSString *userName;
@property (nonatomic, copy) NSString *password;
@property (nonatomic, assign) NSInteger vehicleID;
@property (nonatomic, assign) NSInteger instructionID;
@property (nonatomic, copy) NSString *app;
@property (nonatomic, assign) NSInteger controlSeries;

- (NSDictionary *)customerDictionary;

@end

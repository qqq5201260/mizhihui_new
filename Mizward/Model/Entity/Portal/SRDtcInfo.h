//
//  SRDtcInfo.h
//  SiRuiV4.0
//
//  Created by zhangjunbo on 15/7/30.
//  Copyright (c) 2015年 SiRui. All rights reserved.
//

#import "SREntity.h"

@interface SRDtcInfo : SREntity

@property (nonatomic, copy) NSString *dtcCode;
@property (nonatomic, copy) NSString *errorSystem;
@property (nonatomic, copy) NSString *errorMessage;

- (SRSystemType)systemType;

@end

//
//  SRTLV.h
//  SiRuiV4.0
//
//  Created by zhangjunbo on 15/6/16.
//  Copyright (c) 2015年 SiRui. All rights reserved.
//

#import "SREntity.h"

@interface SRTLV : SREntity

@property (nonatomic, assign) NSInteger tag;
@property (nonatomic, copy)   NSString  *value;

@end

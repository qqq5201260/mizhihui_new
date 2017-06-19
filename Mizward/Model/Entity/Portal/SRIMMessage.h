//
//  SRIMMessage.h
//  SiRuiV4.0
//
//  Created by zhangjunbo on 15/6/25.
//  Copyright (c) 2015年 SiRui. All rights reserved.
//

#import "SREntity.h"

@interface SRIMMessage : SREntity

@property (nonatomic, copy) NSString *adddate;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, assign) NSInteger customerID;
@property (nonatomic, assign) NSInteger ID;
@property (nonatomic, assign) BOOL   isImg;
@property (nonatomic, assign) BOOL   isRead;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, assign) NSInteger type;

//自定义字段
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, strong) NSDate *date;

@end

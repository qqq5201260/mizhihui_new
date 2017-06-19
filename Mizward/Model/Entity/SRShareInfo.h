//
//  SRShareInfo.h
//  SiRuiV4.0
//
//  Created by zhangjunbo on 15/7/10.
//  Copyright (c) 2015年 SiRui. All rights reserved.
//

#import "SREntity.h"

@interface SRShareInfo : SREntity

@property (nonatomic, copy) NSString *defaultContent;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *url;
@property (nonatomic, copy) NSString *_description;

@property (nonatomic, strong) UIImage *image;

@end

//
//  SRShareInfo.m
//  SiRuiV4.0
//
//  Created by zhangjunbo on 15/7/10.
//  Copyright (c) 2015年 SiRui. All rights reserved.
//

#import "SRShareInfo.h"

@implementation SRShareInfo

- (instancetype)init {
    if (self = [super init]) {
        _defaultContent = @"咪智汇";
        _title   = @"咪智汇，升级聪明爱车，体验更加安全、便捷的车生活";
        _url     = @"http://www.mizway.com/app.html";
        __description   = @"咪智汇";
    }
    
    return self;
}

- (void)setContent:(NSString *)content {
    _content = content;
    _defaultContent = content;
    __description = content;
}

@end

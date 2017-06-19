//
//  SRBrandInfo.h
//  SiRuiV4.0
//
//  Created by zhangjunbo on 15/6/16.
//  Copyright (c) 2015年 SiRui. All rights reserved.
//

#import "SREntity.h"

@interface SRBrandInfo : SREntity

@property (nonatomic, assign)   NSInteger entityID;
@property (nonatomic, copy)     NSString *name;
@property (nonatomic, copy)     NSString *logoUrl;

//扩展字段
@property (nonatomic, copy)     NSString *brandFirstLetter;
@property (nonatomic, strong)   NSArray *seriesList; //obj:JBSeriesInfo

- (NSString *)seriesListString;
- (void)setSeriesListWithString:(NSString *)string;

@end

//
//  SRSeriesInfo.h
//  SiRuiV4.0
//
//  Created by zhangjunbo on 15/6/16.
//  Copyright (c) 2015年 SiRui. All rights reserved.
//

#import "SREntity.h"

@interface SRSeriesInfo : SREntity

@property (nonatomic, assign)   NSInteger   seriesID;
@property (nonatomic, copy)     NSString    *seriesName;
@property (nonatomic, copy)     NSString    *seriesFirstLetter;
@property (nonatomic, strong)   NSArray     *vehicleModelVOs; //obj:SRVehicleInfo

@end

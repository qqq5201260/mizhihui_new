//
//  SRSeriesInfo.h
//  SiRui
//
//  Created by 宋搏 on 2017/4/19.
//  Copyright © 2017年 chinapke. All rights reserved.
//

#import <Foundation/Foundation.h>

//车系信息
@interface FZKBSeriesInfo : NSObject

@property (nonatomic, assign) NSInteger seriesID;
@property (nonatomic, copy) NSString *seriesName;
@property (nonatomic, copy) NSString *enName;
@property (nonatomic, copy) NSString *seriesFirstLetter;
@property (nonatomic, strong) NSMutableArray *vehicleModelVOs; 


@end


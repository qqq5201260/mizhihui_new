
//
//  FZKBQueryCarInfoModel.h
//  Connector
//
//  Created by czl on date
//  Copyright © 2017年 chinapke. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FZKBOptionModel.h"

@interface FZKBQueryCarInfoModel : NSObject

@property (nonatomic,copy) NSArray *entity;

@property (nonatomic,strong) FZKBOptionModel *option;


@end
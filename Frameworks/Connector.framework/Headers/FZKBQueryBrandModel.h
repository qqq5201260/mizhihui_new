
//
//  FZKBQueryBrandModel.h
//  Connector
//
//  Created by czl on date
//  Copyright © 2017年 chinapke. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FZKBPageResultModel.h"
#import "FZKBOptionModel.h"

@interface FZKBQueryBrandModel : NSObject

@property (nonatomic,strong) FZKBPageResultModel *pageResult;

@property (nonatomic,strong) FZKBOptionModel *option;


@end
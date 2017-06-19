
//
//  FZKBAddBookingStartModel.h
//  Connector
//
//  Created by czl on date
//  Copyright © 2017年 chinapke. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FZKBOptionModel.h"

@interface FZKBAddBookingStartModel : NSObject

@property (nonatomic,assign) NSInteger entity;

@property (nonatomic,strong) FZKBOptionModel *option;


@end
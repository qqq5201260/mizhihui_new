//
//  FZKVehicleSynchronousResponse.h
//  Connector
//
//  Created by 宋搏 on 2017/5/3.
//  Copyright © 2017年 chinapke. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FZKTCPResponse.h"

@interface FZKVehicleDataProcess : NSObject

+(void)synchronous:(FZKTCPResponse *)response;

@end

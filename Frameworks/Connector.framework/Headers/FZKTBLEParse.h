//
//  FZKTBLEParse.h
//  Connector
//
//  Created by czl on 2017/5/15.
//  Copyright © 2017年 chinapke. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SRBLEReceivedData.h"

@interface FZKTBLEParse : NSObject
//设备返回的状态信息解析，并通过代理更新界面
+(void)BLEReceivedData:(SRBLEReceivedData *)response;
@end

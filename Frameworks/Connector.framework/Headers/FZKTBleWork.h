//
//  FZKTBleWork.h
//  Connector
//
//  Created by czl on 2017/5/17.
//  Copyright © 2017年 chinapke. All rights reserved.
//

#import <Connector/Connector.h>

#import "SRBLESendData.h"

@interface FZKTBleWork : FZKLongWork


/**
 请求命令
 */
@property (nonatomic,assign) SRBLEInstruction command;

@end

//
//  FZKBTCPWork.h
//  Connector
//
//  Created by czl on 2017/5/11.
//  Copyright © 2017年 chinapke. All rights reserved.
//

#import "FZKLongWork.h"
#import <Foundation/Foundation.h>
#import "FZKTCPClient.h"

@interface FZKBTCPWork : FZKLongWork


/**
 请求
 */
@property (nonatomic,strong) FZKTCPRequest *request;

@end

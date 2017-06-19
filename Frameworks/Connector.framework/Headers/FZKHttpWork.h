//
//  HttpWork.h
//  SRN
//
//  Created by 马宁 on 2017/3/1.
//  Copyright © 2017年 Fuizk. All rights reserved.
//

#import "FZKLongWork.h"
#import <SUIMVVMKit/SUIMVVMKit.h>


@interface FZKHttpWork : FZKLongWork<SMKRequestProtocol>


@property NSString* urlPath;


/**
 业务逻辑处理 override

 @param result
 */
- (void)progress:(FZKActionResult *)result;

@end

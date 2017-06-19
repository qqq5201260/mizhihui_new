//
//  SRTCPParseResponse.h
//  TCP
//
//  Created by 宋搏 on 2017/5/2.
//  Copyright © 2017年 Fuizk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FZKTCPResponse.h"

@interface FZKTCPParseResponse : NSObject


+ (void)parseResponseWithResponse:(FZKTCPResponse *)respon;

@end

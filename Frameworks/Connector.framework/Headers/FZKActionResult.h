//
//  ActionResult.h
//  SRN
//
//  Created by 马宁 on 2017/3/1.
//  Copyright © 2017年 Fuizk. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FZKActionResult : NSObject

@property  NSInteger resultCode;
@property  NSString* resultMessage;
@property  id paramters;


@end

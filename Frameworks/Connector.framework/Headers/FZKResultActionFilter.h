//
//  ResultActionFilter.h
//  SRN
//
//  Created by 马宁 on 2017/3/1.
//  Copyright © 2017年 Fuizk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FZKBlockDefine.h"

@interface FZKResultActionFilter : NSObject

@property ResultAction action;
@property ResultFilter filter;

-(void) doActionWith:(FZKActionResult*) result;

+(FZKResultActionFilter*) build:(ResultAction) action withFilter:(ResultFilter)filter;


@end

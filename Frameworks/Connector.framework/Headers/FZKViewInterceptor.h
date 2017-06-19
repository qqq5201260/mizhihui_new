//
//  ResultActionFilter.h
//  SRN
//
//  Created by 马宁 on 2017/3/1.
//  Copyright © 2017年 Fuizk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FZKBlockDefine.h"

@interface FZKViewInterceptor: NSObject
//长时间任务开始执行前执行方法
-(void) runOnStart;

//长时间任务方法执行后执行方法
-(void) runOnComplet;

@property NSString* key ;

@end


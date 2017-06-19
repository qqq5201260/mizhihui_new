//
//  FZKViewActionProcessor.h
//  SRN
//
//  Created by 马宁 on 2017/3/1.
//  Copyright © 2017年 Fuizk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FZKLongWork.h"
#import "FZKViewInterceptor.h"
#import "FZKBlockDefine.h"
#import "FZKViewInterceptorCollection.h"
#import "FZKResultActionFilter.h"

@interface FZKViewActionProcessor : NSObject

//长时间业务
@property FZKLongWork * longWork;
@property FZKViewInterceptorCollection * interceptorCollection;
@property NSMutableArray<FZKResultActionFilter*>* actionList;

//设置业务执行逻辑
-(FZKViewActionProcessor*) setWork:(FZKLongWork*) work;

/*
 业务执行
 */
-(void) run;

//添加拦截器
-(FZKViewActionProcessor*) addInterceptor:(FZKViewInterceptor*) interceptor;

//添加结果处理Block
-(FZKViewActionProcessor*) onResult:(ResultAction) handler;

//业务成功处理函数 resultCode = 0
-(FZKViewActionProcessor*) onSuncc:(ResultAction) handler;

//业务失败处理函数 resultCode != 0
-(FZKViewActionProcessor*) onError:(ResultAction) handler;

//特定resultCode返回结果处理函数
-(FZKViewActionProcessor*) onError:(ResultAction) handler WithCode:(NSInteger) resultCode;


@end

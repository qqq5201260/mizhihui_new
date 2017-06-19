//
//  LongWork.h
//  SRN
//
//  Created by 马宁 on 2017/3/1.
//  Copyright © 2017年 Fuizk. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FZKBlockDefine.h"
#import "FZKViewInterceptor.h"
#import "FZKBlockDefine.h"
#import "FZKViewInterceptorCollection.h"
#import "FZKResultActionFilter.h"

@interface FZKLongWork : NSObject

@property NSMutableDictionary * parameters;
@property FZKViewInterceptorCollection * interceptorCollection;
@property NSMutableArray<FZKResultActionFilter*>* actionList;


/*
 添加请求参数
 */
-(void) addPara:(NSString*) key withValue:(NSString*)value;

/*
 执行并且回调
 */
-(void) runThenCallback:(ResultAction) callback;

/*
 业务执行
 */
-(void) run;

//添加拦截器
-(FZKLongWork*) addInterceptor:(FZKViewInterceptor*) interceptor;

//添加结果处理Block
-(FZKLongWork*) onResult:(ResultAction) handler;

//业务成功处理函数 resultCode = 0
-(FZKLongWork*) onSuncc:(ResultAction) handler;

//业务失败处理函数 resultCode != 0
-(FZKLongWork*) onError:(ResultAction) handler;

//特定resultCode返回结果处理函数
-(FZKLongWork*) onError:(ResultAction) handler WithCode:(NSInteger) resultCode;

@end

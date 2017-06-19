//
//  FZKViewInterceptorCollection.h
//  SRN
//
//  Created by 马宁 on 2017/3/1.
//  Copyright © 2017年 Fuizk. All rights reserved.
//

#import "FZKViewInterceptor.h"

@interface FZKViewInterceptorCollection : FZKViewInterceptor

@property NSMutableArray<FZKViewInterceptor *>* list;

-(void) addInterceptor:(FZKViewInterceptor*) interceptor;

@end

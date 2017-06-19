//
//  InterceptorUtil.h
//  SRN
//
//  Created by 马宁 on 2017/3/2.
//  Copyright © 2017年 Fuizk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FZKViewInterceptor.h"
#import <UIKit/UIKit.h>
@interface FZKInterceptorUtil : NSObject

+(FZKViewInterceptor*) buildLoading:(NSString*)msg With:(UIView*)view;
+(FZKViewInterceptor*) buildDisable:(UIView*) view;
@end

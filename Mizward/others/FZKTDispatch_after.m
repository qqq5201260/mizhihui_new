//
//  FZKTDispatch_after.m
//  Connector
//
//  Created by czl on 2017/5/20.
//  Copyright © 2017年 chinapke. All rights reserved.
//

#import "FZKTDispatch_after.h"
#import "SRUserDefaults.h"

@interface FZKTDispatch_after ()

@property (nonatomic,assign) CFTimeInterval time;

@end

@implementation FZKTDispatch_after

Singleton_Implementation(FZKTDispatch_after);

//+ (instancetype)share{
//    
//    static FZKTDispatch_after *_instance;
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        _instance = [[self alloc] init];
//    });
//    return _instance;
//}

- (void)runDispatch_after:(NSTimeInterval)timer block:(dispatch_block_t)block{
    

    self.time = CFAbsoluteTimeGetCurrent();
    NSLog(@"对象：%@，time：%f,time:%f",self,self.time,timer);
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(timer * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        NSLog(@"对象：%@，time：%f,time:%f,两次时间差：%f",self,self.time,timer,(CFAbsoluteTimeGetCurrent()-self.time));
        if ((CFAbsoluteTimeGetCurrent()-self.time)<timer) {
            return;
        }
        block();
    });
}


@end

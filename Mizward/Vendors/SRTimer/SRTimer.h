//
//  SRTimer.h
//  Mizward
//
//  Created by zhangjunbo on 15/8/27.
//  Copyright (c) 2015年 Mizward. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SRTimer : NSObject

@property (nonatomic, assign) NSInteger tag;

+ (SRTimer *)scheduledTimerWithTimeInterval:(NSTimeInterval)seconds
                                      block:(dispatch_block_t)block
                                    repeats:(BOOL)repeats
                                      delay:(NSTimeInterval)delay;

- (void)invalidate;

@end

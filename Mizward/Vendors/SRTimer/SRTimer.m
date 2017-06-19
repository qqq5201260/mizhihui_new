//
//  SRTimer.m
//  Mizward
//
//  Created by zhangjunbo on 15/8/27.
//  Copyright (c) 2015年 Mizward. All rights reserved.
//

#import "SRTimer.h"
#import <libkern/OSAtomic.h>

@interface SRTimer ()
{
    struct
    {
        uint32_t timerIsInvalidated;
    } _timerFlags;
}

@property (nonatomic, copy) dispatch_block_t block;
@property (nonatomic, strong) dispatch_source_t source;

@property (nonatomic, assign) BOOL repeats;

@end

@implementation SRTimer

+ (SRTimer*)scheduledTimerWithTimeInterval:(NSTimeInterval)seconds
                                     block:(dispatch_block_t)block
                                   repeats:(BOOL)repeats
                                     delay:(NSTimeInterval)delaySeconds
{
    NSParameterAssert(seconds);
    NSParameterAssert(block);
    
    return [[SRTimer alloc] initWithTimeInterval:seconds * NSEC_PER_SEC
                                           block:block
                                         repeats:repeats
                                           delay:delaySeconds * NSEC_PER_SEC];
}

- (instancetype)initWithTimeInterval:(NSTimeInterval)interval
                               block:(dispatch_block_t)block
                             repeats:(BOOL)repeats
                               delay:(NSTimeInterval)delay
{
    if (self = [super init]) {
        _block = block;
        _repeats = repeats;
        _source = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER,
                                         0, 0,
                                         dispatch_get_main_queue());
        dispatch_source_set_timer(_source,
                                  dispatch_time(DISPATCH_TIME_NOW, interval+delay),
                                  interval, 0);
        
        __weak __typeof(self) weakSelf = self;
        dispatch_source_set_event_handler(_source, ^(){
            __strong __typeof(weakSelf) self = weakSelf;
            [self timerFired];
        });
        
        dispatch_resume(_source);
    }
    
    return self;
}

- (void)invalidate {
    if (!OSAtomicTestAndSetBarrier(7, &_timerFlags.timerIsInvalidated) && self.source) {
        dispatch_source_cancel(self.source);
        self.source = nil;
        self.block = nil;
    }
}

- (void)timerFired {
    if (OSAtomicAnd32OrigBarrier(1, &_timerFlags.timerIsInvalidated)) {
        return;
    }
    
    if (self.block) {
        self.block();
    }
    
    if (!self.repeats) {
        [self invalidate];
    }
}

- (void)dealloc {
    [self invalidate];
}

@end

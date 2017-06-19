//
//  NSObject+Additions.m
//  SiRuiV4.0
//
//  Created by zhangjunbo on 15/6/15.
//  Copyright (c) 2015年 SiRui. All rights reserved.
//

#import "NSObject+Additions.h"

@implementation NSObject (Additions)

- (void)executeOnMain:(dispatch_block_t)block afterDelay:(int64_t)delta {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, delta),
                   dispatch_get_main_queue(),
                   block);
}

- (void)executeOnMain:(dispatch_block_t)block afterSeconds:(NSInteger)seconds
{
    [self executeOnMain:block afterDelay:NSEC_PER_SEC * seconds];
}

- (void)executeOnMain:(dispatch_block_t)block afterMilliseconds:(NSInteger)milliseconds
{
    [self executeOnMain:block afterDelay:NSEC_PER_MSEC * milliseconds];
}

@end

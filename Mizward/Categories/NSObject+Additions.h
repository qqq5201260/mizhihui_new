//
//  NSObject+Additions.h
//  SiRuiV4.0
//
//  Created by zhangjunbo on 15/6/15.
//  Copyright (c) 2015年 SiRui. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (Additions)

- (void)executeOnMain:(dispatch_block_t)block afterDelay:(int64_t)delta;

- (void)executeOnMain:(dispatch_block_t)block afterSeconds:(NSInteger)seconds;

- (void)executeOnMain:(dispatch_block_t)block afterMilliseconds:(NSInteger)milliseconds;

@end

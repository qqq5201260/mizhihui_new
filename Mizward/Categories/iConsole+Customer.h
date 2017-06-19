//
//  iConsole+Customer.h
//  SiRuiV4.0
//
//  Created by zhangjunbo on 15/6/15.
//  Copyright (c) 2015年 SiRui. All rights reserved.
//

#import <iConsole/iConsole.h>

@interface iConsole (Customer)

+ (void)log_file:(const char *)file
        function:(const char *)function
            line:(NSUInteger)line
          format:(NSString *)format, ...;

+ (void)info_file:(const char *)file
         function:(const char *)function
             line:(NSUInteger)line
           format:(NSString *)format, ...;

+ (void)warn_file:(const char *)file
         function:(const char *)function
             line:(NSUInteger)line
           format:(NSString *)format, ...;

+ (void)error_file:(const char *)file
          function:(const char *)function
              line:(NSUInteger)line
            format:(NSString *)format, ...;

+ (void)crash_file:(const char *)file
          function:(const char *)function
              line:(NSUInteger)line
            format:(NSString *)format, ...;

+ (void)debug_file:(const char *)file
          function:(const char *)function
              line:(NSUInteger)line
            format:(NSString *)format, ...;

+ (void)verbose_file:(const char *)file
            function:(const char *)function
                line:(NSUInteger)line
              format:(NSString *)format, ...;


@end

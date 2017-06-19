//
//  iConsole+Customer.m
//  SiRuiV4.0
//
//  Created by zhangjunbo on 15/6/15.
//  Copyright (c) 2015年 SiRui. All rights reserved.
//

#import "iConsole+Customer.h"
#import "SRNotificationCenter.h"

static NSDateFormatter *formatter;

static BOOL isApplicationDidFinishLaunching;

@implementation iConsole (Customer)

+ (void)load
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __block id observer = [SRNotificationCenter sr_addObserverForName:UIApplicationDidFinishLaunchingNotification object:nil queue:nil usingBlock:^(NSNotification *note) {
            [SRNotificationCenter sr_removeObserver:observer];
            
            isApplicationDidFinishLaunching = YES;
        }];
    });
}

+ (NSString *)Time
{
    if (!formatter) {
        formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss.SSS"];
    }
    
    return [formatter stringFromDate:[NSDate date]];
}


+ (void)log_file:(const char *)file
        function:(const char *)function
            line:(NSUInteger)line
          format:(NSString *)format, ...
{
    if (isApplicationDidFinishLaunching && [self sharedConsole].logLevel >= iConsoleLogLevelNone)
    {
        NSString *fileName = [[NSString stringWithUTF8String:file] lastPathComponent];
        NSString *pre = [NSString stringWithFormat:@"%@[%@|%s|%zd]", [self Time], fileName, function, line];
        NSString *_format = [NSMutableString stringWithFormat:@"%@%@", pre, format];
        
        va_list argList;
        va_start(argList,format);
        [self log:_format args:argList];
        va_end(argList);
    }
}

+ (void)info_file:(const char *)file
         function:(const char *)function
             line:(NSUInteger)line
           format:(NSString *)format, ...
{
    if (isApplicationDidFinishLaunching && [self sharedConsole].logLevel >= iConsoleLogLevelInfo)
    {
        NSString *fileName = [[NSString stringWithUTF8String:file] lastPathComponent];
        NSString *pre = [NSString stringWithFormat:@"%@:[Info][%@|%s|%zd]", [self Time], fileName, function, line];
        NSString *_format = [NSMutableString stringWithFormat:@"%@%@", pre, format];
        
        va_list argList;
        va_start(argList,format);
        [self log:_format args:argList];
        va_end(argList);
    }
}

+ (void)warn_file:(const char *)file
         function:(const char *)function
             line:(NSUInteger)line
           format:(NSString *)format, ...
{
    if (isApplicationDidFinishLaunching && [self sharedConsole].logLevel >= iConsoleLogLevelWarning)
    {
        NSString *fileName = [[NSString stringWithUTF8String:file] lastPathComponent];
        NSString *pre = [NSString stringWithFormat:@"%@:[WARNING][%@|%s|%zd]", [self Time], fileName, function, line];
        NSString *_format = [NSMutableString stringWithFormat:@"%@%@", pre, format];
        
        va_list argList;
        va_start(argList,format);
        [self log:_format args:argList];
        va_end(argList);
    }
}

+ (void)error_file:(const char *)file
          function:(const char *)function
              line:(NSUInteger)line
            format:(NSString *)format, ...
{
    if (isApplicationDidFinishLaunching && [self sharedConsole].logLevel >= iConsoleLogLevelError)
    {
        NSString *fileName = [[NSString stringWithUTF8String:file] lastPathComponent];
        NSString *pre = [NSString stringWithFormat:@"%@:[ERROR][%@|%s|%zd]", [self Time], fileName, function, line];
        NSString *_format = [NSMutableString stringWithFormat:@"%@%@", pre, format];
        
        va_list argList;
        va_start(argList,format);
        [self log:_format args:argList];
        va_end(argList);
    }
}

+ (void)crash_file:(const char *)file
          function:(const char *)function
              line:(NSUInteger)line
            format:(NSString *)format, ...
{
    if (isApplicationDidFinishLaunching && [self sharedConsole].logLevel >= iConsoleLogLevelCrash)
    {
        NSString *fileName = [[NSString stringWithUTF8String:file] lastPathComponent];
        NSString *pre = [NSString stringWithFormat:@"%@:[CRASH][%@|%s|%zd]", [self Time], fileName, function, line];
        NSString *_format = [NSMutableString stringWithFormat:@"%@%@", pre, format];
        
        va_list argList;
        va_start(argList,format);
        [self log:_format args:argList];
        va_end(argList);
    }
}

+ (void)debug_file:(const char *)file
          function:(const char *)function
              line:(NSUInteger)line
            format:(NSString *)format, ...
{
    if (isApplicationDidFinishLaunching && [self sharedConsole].logLevel >= iConsoleLogLevelInfo)
    {
        NSString *fileName = [[NSString stringWithUTF8String:file] lastPathComponent];
        NSString *pre = [NSString stringWithFormat:@"%@:[DEBUG][%@|%s|%zd]", [self Time], fileName, function, line];
        NSString *_format = [NSMutableString stringWithFormat:@"%@%@", pre, format];
        
        va_list argList;
        va_start(argList,format);
        [self log:_format args:argList];
        va_end(argList);
    }
}

+ (void)verbose_file:(const char *)file
            function:(const char *)function
                line:(NSUInteger)line
              format:(NSString *)format, ...
{
    if (isApplicationDidFinishLaunching && [self sharedConsole].logLevel >= iConsoleLogLevelNone)
    {
        NSString *fileName = [[NSString stringWithUTF8String:file] lastPathComponent];
        NSString *pre = [NSString stringWithFormat:@"%@:[Verbos][%@|%s|%zd]", [self Time], fileName, function, line];
        NSString *_format = [NSMutableString stringWithFormat:@"%@%@", pre, format];
        
        va_list argList;
        va_start(argList,format);
        [self log:_format args:argList];
        va_end(argList);
    }
}

@end

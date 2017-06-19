//
//  SRLogFormattter.m
//  SiRuiV4.0
//
//  Created by zhangjunbo on 15/6/15.
//  Copyright (c) 2015年 SiRui. All rights reserved.
//

#import "SRLogFormattter.h"

@interface SRLogFormattter ()

@property (nonatomic, strong) NSDateFormatter *dateFormatter;

@end

@implementation SRLogFormattter

- (NSString *)formatLogMessage:(DDLogMessage *)logMessage
{
    return [NSString stringWithFormat:@"%@ [%@][%@|%@|%@][%@|%@|%@]:%@",
            [self getTime:logMessage->_timestamp],
            [self getLevelString:logMessage->_flag],
            logMessage->_threadName,
            logMessage->_threadID,
            logMessage->_queueLabel,
            [logMessage fileName],
            logMessage->_function,
            @(logMessage->_line),
            logMessage->_message];
}

- (NSString *)getTime:(NSDate *)date {
    if (!_dateFormatter) {
        self.dateFormatter = [[NSDateFormatter alloc] init];
        [self.dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss.SSS"];
    }
    
    return [self.dateFormatter stringFromDate:date];
}

- (NSString *)getLevelString:(DDLogFlag)flag {
    NSString *levelString;
    switch (flag) {
        case DDLogFlagError:
            levelString = @"Error";
            break;
        case DDLogFlagWarning:
            levelString = @"Warning";
            break;
        case DDLogFlagInfo:
            levelString = @"Info";
            break;
        case DDLogFlagDebug:
            levelString = @"Debug";
            break;
        case DDLogFlagVerbose:
            levelString = @"Verbose";
            break;
            
        default:
            break;
    }
    
    return levelString;
}


@end

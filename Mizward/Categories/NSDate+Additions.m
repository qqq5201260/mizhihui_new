//
//  NSDate+Additions.m
//  SiRuiV4.0
//
//  Created by zhangjunbo on 15/6/17.
//  Copyright (c) 2015年 SiRui. All rights reserved.
//

#import "NSDate+Additions.h"
#import <DateTools/DateTools.h>

@implementation NSDate (Additions)

+ (NSDateFormatter *)defaultDateFormatterWithFormatYYYY
{
    static NSDateFormatter *staticDateFormatterWithFormatYYYY;
    if (!staticDateFormatterWithFormatYYYY) {
        staticDateFormatterWithFormatYYYY = [[NSDateFormatter alloc] init];
        [staticDateFormatterWithFormatYYYY setDateFormat:@"yyyy"];
    }
    
    return staticDateFormatterWithFormatYYYY;
}

+ (NSDateFormatter *)defaultDateFormatterWithFormatYYYYMM
{
    static NSDateFormatter *staticDateFormatterWithFormatYYYYMM;
    if (!staticDateFormatterWithFormatYYYYMM) {
        staticDateFormatterWithFormatYYYYMM = [[NSDateFormatter alloc] init];
        [staticDateFormatterWithFormatYYYYMM setDateFormat:@"yyyy-MM"];
    }
    
    return staticDateFormatterWithFormatYYYYMM;
}

+ (NSDateFormatter *)defaultDateFormatterWithFormatYYYYMMdd
{
    static NSDateFormatter *staticDateFormatterWithFormatYYYYMMdd;
    if (!staticDateFormatterWithFormatYYYYMMdd) {
        staticDateFormatterWithFormatYYYYMMdd = [[NSDateFormatter alloc] init];
        [staticDateFormatterWithFormatYYYYMMdd setDateFormat:@"yyyy-MM-dd"];
    }
    
    return staticDateFormatterWithFormatYYYYMMdd;
}

+ (NSDateFormatter *)defaultDateFormatterWithFormatYYYYMMddHHmmss
{
    static NSDateFormatter *staticDateFormatterWithFormatYYYYMMddHHmmss;
    if (!staticDateFormatterWithFormatYYYYMMddHHmmss) {
        staticDateFormatterWithFormatYYYYMMddHHmmss = [[NSDateFormatter alloc] init];
        [staticDateFormatterWithFormatYYYYMMddHHmmss setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    }
    
    return staticDateFormatterWithFormatYYYYMMddHHmmss;
}

+ (NSDateFormatter *)defaultDateFormatterWithFormatYYYYMMddHHmm
{
    static NSDateFormatter *staticDateFormatterWithFormatYYYYMMddHHmmss;
    if (!staticDateFormatterWithFormatYYYYMMddHHmmss) {
        staticDateFormatterWithFormatYYYYMMddHHmmss = [[NSDateFormatter alloc] init];
        [staticDateFormatterWithFormatYYYYMMddHHmmss setDateFormat:@"yyyy-MM-dd HH:mm"];
    }
    
    return staticDateFormatterWithFormatYYYYMMddHHmmss;
}


+ (NSDateFormatter *)defaultDateFormatterWithFormatYYYYMMddHHmmssSSS
{
    static NSDateFormatter *staticDateFormatterWithFormatYYYYMMddHHmmss;
    if (!staticDateFormatterWithFormatYYYYMMddHHmmss) {
        staticDateFormatterWithFormatYYYYMMddHHmmss = [[NSDateFormatter alloc] init];
        [staticDateFormatterWithFormatYYYYMMddHHmmss setDateFormat:@"yyyy-MM-dd HH:mm:ss.SSS"];
    }
    
    return staticDateFormatterWithFormatYYYYMMddHHmmss;
}

+ (NSDateFormatter *)defaultDateFormatterWithFormatYYYYMMChinese
{
    static NSDateFormatter *staticDateFormatterWithFormatYYYYMMddChinese;
    if (!staticDateFormatterWithFormatYYYYMMddChinese) {
        staticDateFormatterWithFormatYYYYMMddChinese = [[NSDateFormatter alloc] init];
        [staticDateFormatterWithFormatYYYYMMddChinese setDateFormat:@"yyyy年MM月"];
    }
    
    return staticDateFormatterWithFormatYYYYMMddChinese;
}

+ (NSDateFormatter *)defaultDateFormatterWithFormatYYYYMMddChinese
{
    static NSDateFormatter *staticDateFormatterWithFormatYYYYMMddChinese;
    if (!staticDateFormatterWithFormatYYYYMMddChinese) {
        staticDateFormatterWithFormatYYYYMMddChinese = [[NSDateFormatter alloc] init];
        [staticDateFormatterWithFormatYYYYMMddChinese setDateFormat:@"yyyy年MM月dd日"];
    }
    
    return staticDateFormatterWithFormatYYYYMMddChinese;
}

+ (NSDateFormatter *)defaultDateFormatterWithFormatMMddChinese
{
    static NSDateFormatter *staticDateFormatterWithFormatMMddChinese;
    if (!staticDateFormatterWithFormatMMddChinese) {
        staticDateFormatterWithFormatMMddChinese = [[NSDateFormatter alloc] init];
        [staticDateFormatterWithFormatMMddChinese setDateFormat:@"MM月dd日"];
    }
    
    return staticDateFormatterWithFormatMMddChinese;
}

+(NSDate*)convertDateFromStringWithFormatYYYYMMddHHmmss:(NSString*)strDate
{
    NSDate *date=[[self defaultDateFormatterWithFormatYYYYMMddHHmmss] dateFromString:strDate];
    return date;
}

+ (NSDate *)convertDateFromStringWithFormatYYYYMMddHHmm:(NSString*)strDate
{
    NSDate *date=[[self defaultDateFormatterWithFormatYYYYMMddHHmm] dateFromString:strDate];
    return date;
}

+ (NSDate *)convertDateFromStringWithFormatYYYYMMChinese:(NSString*)strDate
{
    NSDate *date=[[self defaultDateFormatterWithFormatYYYYMMChinese] dateFromString:strDate];
    return date;
}

+ (NSDate *)convertDateFromStringWithFormatYYYYMMddChinese:(NSString*)strDate
{
    NSDate *date=[[self defaultDateFormatterWithFormatYYYYMMddChinese] dateFromString:strDate];
    return date;
}

+(NSDate*)convertDateFromStringWithFormatYYYYMMdd:(NSString*)strDate
{
    NSDate *date=[[self defaultDateFormatterWithFormatYYYYMMdd] dateFromString:strDate];
    return date;
}

- (NSDate *)Local_YYYYMMddHHmmss
{
    //设置源日期时区
    NSTimeZone* sourceTimeZone = [NSTimeZone timeZoneWithAbbreviation:@"UTC"];//或GMT
    //设置转换后的目标日期时区
    NSTimeZone* destinationTimeZone = [NSTimeZone localTimeZone];
    //得到源日期与世界标准时间的偏移量
    NSInteger sourceGMTOffset = [sourceTimeZone secondsFromGMTForDate:self];
    //目标日期与本地时区的偏移量
    NSInteger destinationGMTOffset = [destinationTimeZone secondsFromGMTForDate:self];
    //得到时间偏移量的差值
    NSTimeInterval interval = destinationGMTOffset - sourceGMTOffset;
    //转为本地时间
    return [[NSDate alloc] initWithTimeInterval:interval sinceDate:self];
}

- (NSDate *)Utc_YYYYYMMddHHmmss
{
    //设置源日期时区
    NSTimeZone* sourceTimeZone = [NSTimeZone localTimeZone];
    //设置转换后的目标日期时区
    NSTimeZone* destinationTimeZone = [NSTimeZone timeZoneWithAbbreviation:@"UTC"];//或GMT
    //得到源日期与本地时区的偏移量
    NSInteger sourceGMTOffset = [sourceTimeZone secondsFromGMTForDate:self];
    //目标日期与世界标准时间的偏移量
    NSInteger destinationGMTOffset = [destinationTimeZone secondsFromGMTForDate:self];
    //得到时间偏移量的差值
    NSTimeInterval interval = destinationGMTOffset - sourceGMTOffset;
    //转为UTC时间
    return [[NSDate alloc] initWithTimeInterval:interval sinceDate:self];
}

- (NSString *)stringOfDateWithFormatYYYY
{
    return [[NSDate defaultDateFormatterWithFormatYYYY] stringFromDate:self];
}

- (NSString *)stringOfDateWithFormatYYYYMM
{
    return [[NSDate defaultDateFormatterWithFormatYYYYMM] stringFromDate:self];
}

- (NSString *)stringOfDateWithFormatYYYYMMdd
{
    return [[NSDate defaultDateFormatterWithFormatYYYYMMdd] stringFromDate:self];
}

- (NSString *)stringOfDateWithFormatYYYYMMddChinese
{
    return [[NSDate defaultDateFormatterWithFormatYYYYMMddChinese] stringFromDate:self];
}

- (NSString *)stringOfDateWithFormatMMddChinese
{
    return [[NSDate defaultDateFormatterWithFormatMMddChinese] stringFromDate:self];
}

- (NSString *)stringOfDateWithFormatYYYYMMddHHmmss
{
    return [[NSDate defaultDateFormatterWithFormatYYYYMMddHHmmss] stringFromDate:self];
}

- (NSString *)stringOfDateWithFormatYYYYMMddHHmmssSSS
{
    return [[NSDate defaultDateFormatterWithFormatYYYYMMddHHmmssSSS] stringFromDate:self];
}

- (BOOL)isSameDay:(NSDate *)date
{
    return self.year==date.year&&self.month==date.month&&self.day==date.day;
}


@end

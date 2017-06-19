//
//  NSDate+Additions.h
//  SiRuiV4.0
//
//  Created by zhangjunbo on 15/6/17.
//  Copyright (c) 2015年 SiRui. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (Additions)

+ (NSDate *)convertDateFromStringWithFormatYYYYMMddHHmmss:(NSString*)strDate;
+ (NSDate *)convertDateFromStringWithFormatYYYYMMddHHmm:(NSString*)strDate;
+ (NSDate *)convertDateFromStringWithFormatYYYYMMChinese:(NSString*)strDate;
+ (NSDate *)convertDateFromStringWithFormatYYYYMMddChinese:(NSString*)strDate;
+ (NSDate*)convertDateFromStringWithFormatYYYYMMdd:(NSString*)strDate;

- (NSDate *)Local_YYYYMMddHHmmss;
- (NSDate *)Utc_YYYYYMMddHHmmss;

- (NSString *)stringOfDateWithFormatYYYY;
- (NSString *)stringOfDateWithFormatYYYYMM;
- (NSString *)stringOfDateWithFormatYYYYMMdd;
- (NSString *)stringOfDateWithFormatYYYYMMddHHmmss;
- (NSString *)stringOfDateWithFormatYYYYMMddHHmmssSSS;
- (NSString *)stringOfDateWithFormatYYYYMMddChinese;
- (NSString *)stringOfDateWithFormatMMddChinese;

- (BOOL)isSameDay:(NSDate *)date;

@end

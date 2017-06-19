//
//  NSString+Additions.h
//  SiRuiV4.0
//
//  Created by zhangjunbo on 15/6/15.
//  Copyright (c) 2015年 SiRui. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Additions)

+ (NSString *)LocalTimeString_YYYYMMddHHmmss:(NSString *)utc;
+ (NSString *)UTCTimeString_YYYYYMMddHHmmss:(NSString *)local;

//计算String所占大小
- (CGSize)sizeWithWidth:(CGFloat)width font:(UIFont *)font;

- (BOOL)isEmpty;

- (NSString *)pinYinFirstLetter;

- (BOOL)isPhoneNumber;
- (BOOL)isNumber;
- (BOOL)isIDNumber;

- (NSString *)encodePhoneNumber;
- (NSString *)encodeIDNumber;

- (NSString *)urlEncode;

- (NSData*)hexToBytes;

@end

#pragma mark - RSA

@interface NSString (RSA)

- (NSString *)RSAEncode;

@end

#pragma mark - BASE64

@interface NSString (BASE64)

+ (NSString *)stringWithBase64EncodedString:(NSString *)base64EncodedString;
- (NSString *)base64EncodedString;

@end

#pragma mark - AES256

@interface NSString(AES256)

-(NSString *) aes256_encrypt:(NSString *)key;
-(NSString *) aes256_decrypt:(NSString *)key;

@end

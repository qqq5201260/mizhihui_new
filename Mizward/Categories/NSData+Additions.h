//
//  NSData+Additions.h
//  Mizward
//
//  Created by zhangjunbo on 15/12/11.
//  Copyright © 2015年 Mizward. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSData (Additions)

@end


#pragma - AES256

@interface NSData (AES256)

-(NSData *) aes256_encrypt:(NSString *)key;
-(NSData *) aes256_decrypt:(NSString *)key;

@end
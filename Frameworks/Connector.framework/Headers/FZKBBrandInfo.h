//
//  SRBrandInfo.h
//  SiRui
//
//  Created by 宋搏 on 2017/4/19.
//  Copyright © 2017年 chinapke. All rights reserved.
//

#import <Foundation/Foundation.h>

//品牌信息
@interface FZKBBrandInfo : NSObject

@property (strong, nonatomic) NSDecimalNumber *alterImageCount;
@property (strong, nonatomic) NSString *brandid;
@property (strong, nonatomic) NSString *createTime;
@property (strong, nonatomic) NSDecimalNumber *createUserID;
@property (strong, nonatomic) NSDecimalNumber *depID;
@property (strong, nonatomic) NSString *enName;
@property (strong, nonatomic) NSString * entityID;
@property (strong, nonatomic) NSString *firstLetter;
@property (strong, nonatomic) NSString *firstSpellByName;
@property (strong, nonatomic) NSDecimalNumber *imgMathParam;
@property (assign, nonatomic) BOOL isOpen4I18N;
@property (strong, nonatomic) NSString *logoUrl;
@property (strong, nonatomic) NSString *memo;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *updateTime;
@property (strong, nonatomic) NSDecimalNumber *updateUserID;
@end



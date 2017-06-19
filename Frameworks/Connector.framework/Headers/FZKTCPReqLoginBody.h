//
//  SRTCPLoginBody.h
//  SiRuiV4.0
//
//  Created by zhangjunbo on 15/6/16.
//  Copyright (c) 2015年 SiRui. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FZKTCPReqLoginBody : NSObject

@property (nonatomic, assign) NSInteger clientType;
@property (nonatomic, copy) NSString *protocolVersion;
@property (nonatomic, copy) NSString *hardWareversion;
@property (nonatomic, copy) NSString *softwareVersion;
@property (nonatomic, copy) NSString *userName;
@property (nonatomic, copy) NSString *password;
@property (nonatomic, copy) NSString *token;

@end

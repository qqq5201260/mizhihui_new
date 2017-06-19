//
//  SRRealmCustomer.h
//  Mizward
//
//  Created by zhangjunbo on 15/9/1.
//  Copyright (c) 2015年 Mizward. All rights reserved.
//

#import <Realm/RLMObject.h>

@class SRCustomer;

@interface SRRealmCustomer : RLMObject

@property   NSInteger   customerID;
@property   NSString    *hashCode;
@property   NSString    *customerIDNumber;
@property   NSString    *customerUserName;
@property   NSString    *name;
@property   NSInteger   customerSex;
@property   NSString    *customerBirthday;
@property   NSString    *customerPhone;
@property   NSString    *customerEmail;
@property   NSString    *customerAddress;
@property   NSInteger   depID;
@property   NSString    *depName;
@property   NSString    *levelCode;
@property   NSInteger  bindingStatus;
@property   BOOL        openHiddenTrip;
@property   NSInteger realNameAuthentication;
@property   NSInteger  customerType;
@property   NSInteger   exhibitionExperienceTime;

//自定义扩展字段
@property NSString     *permissions;
@property NSString     *messageSwitchs;
@property NSString     *messageUnread;

- (instancetype)initWithCustomer:(SRCustomer *)customer;

- (SRCustomer *)customer;

@end

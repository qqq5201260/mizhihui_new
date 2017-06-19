//
//  SRRealmCustomer.m
//  Mizward
//
//  Created by zhangjunbo on 15/9/1.
//  Copyright (c) 2015年 Mizward. All rights reserved.
//

#import "SRRealmCustomer.h"
#import "SRCustomer.h"

@implementation SRRealmCustomer

+ (nullable NSString *)primaryKey
{
    return @"customerID";
}

- (instancetype)initWithCustomer:(SRCustomer *)customer {
    if (self = [super init]) {
        _customerID = customer.customerID;
        _hashCode = customer.hashCode?customer.hashCode:@"";
        _customerIDNumber = customer.customerIDNumber?customer.customerIDNumber:@"";
        _customerUserName = customer.customerUserName?customer.customerUserName:@"";
        _name = customer.name?customer.name:@"";
        _customerSex = customer.customerSex;
        _customerBirthday = customer.customerBirthday?customer.customerBirthday:@"";
        _customerPhone = customer.customerPhone?customer.customerPhone:@"";
        _customerEmail = customer.customerEmail?customer.customerEmail:@"";
        _customerAddress = customer.customerAddress?customer.customerAddress:@"";
        _depID = customer.depID;
        _depName = customer.depName?customer.depName:@"";
        _levelCode = customer.levelCode?customer.levelCode:@"";
        _bindingStatus = customer.bindingStatus;
        _openHiddenTrip = customer.openHiddenTrip;
        _realNameAuthentication = customer.realNameAuthentication;
        _customerType = customer.customerType;
        _exhibitionExperienceTime = customer.exhibitionExperienceTime;
        _permissions = customer.permissionsString?customer.permissionsString:@"";
        _messageSwitchs = customer.messageSwitchString?customer.messageSwitchString:@"";
        _messageUnread = customer.messageUnreadString?customer.messageUnreadString:@"";
    }
    
    return self;
}

- (SRCustomer *)customer
{
    SRCustomer *customer = [[SRCustomer alloc] init];
    customer.customerID = self.customerID;
    customer.hashCode = self.hashCode;
    customer.customerIDNumber = self.customerIDNumber;
    customer.customerUserName = self.customerUserName;
    customer.name = self.name;
    customer.customerSex = self.customerSex;
    customer.customerBirthday = self.customerBirthday;
    customer.customerPhone = self.customerPhone;
    customer.customerEmail = self.customerEmail;
    customer.customerAddress = self.customerAddress;
    customer.depID = self.depID;
    customer.depName = self.depName;
    customer.levelCode = self.levelCode;
    customer.bindingStatus = self.bindingStatus;
    customer.openHiddenTrip = self.openHiddenTrip;
    customer.realNameAuthentication = self.realNameAuthentication;
    customer.customerType = self.customerType;
    customer.exhibitionExperienceTime = self.exhibitionExperienceTime;
    [customer setPermissionsWithString:self.permissions];
    [customer setMessageSwitchsWithString:self.messageSwitchs];
    [customer setMessageUnreadWithString:self.messageUnread];
    return customer;
}

@end

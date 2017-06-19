//
//  SRCustomer.h
//  SiRuiV4.0
//
//  Created by zhangjunbo on 15/6/16.
//  Copyright (c) 2015年 SiRui. All rights reserved.
//

#import "SREntity.h"

@class SRMessageSwitchInfo;

@interface SRCustomer : SREntity

@property (nonatomic, assign)   NSInteger   customerID;
@property (nonatomic, copy)     NSString    *hashCode;
@property (nonatomic, copy)     NSString    *customerIDNumber;
@property (nonatomic, copy)     NSString    *customerUserName;
@property (nonatomic, copy)     NSString    *name;
@property (nonatomic, assign)   SRSexType   customerSex;
@property (nonatomic, copy)     NSString    *customerBirthday;
@property (nonatomic, copy)     NSString    *customerPhone;
@property (nonatomic, copy)     NSString    *customerEmail;
@property (nonatomic, copy)     NSString    *customerAddress;
@property (nonatomic, assign)   NSInteger   depID;
@property (nonatomic, copy)     NSString    *depName;
@property (nonatomic, copy)     NSString    *levelCode;
@property (nonatomic, assign)   SRBindingStatus  bindingStatus;
@property (nonatomic, assign)   BOOL        openHiddenTrip;
@property (nonatomic, assign)   AuthenticationStatus realNameAuthentication;
@property (nonatomic, assign)   SRCustomerType  customerType;
@property (nonatomic, assign)   NSInteger   exhibitionExperienceTime;

//2015-12-11 新增
@property (nonatomic, assign)   CGFloat     accountCash;//账户可利用金额
@property (nonatomic, assign)   BOOL        hasCarNeedRenew;//有车辆需要续费
@property (nonatomic, assign)   BOOL        hasTodaySign;//今天是否签到了
@property (nonatomic, assign)   NSInteger   continuousSignDay;//连续签到天数
@property (nonatomic, assign)   NSInteger   point;//积分
@property (nonatomic, copy)     NSString    *headImg;

//自定义扩展字段
@property (nonatomic, strong)   NSArray     *permissions; //obj:SRPermission
@property (nonatomic, strong)   NSArray     *messageSwitchs;//obj:SRMessageSwitchInfo
@property (nonatomic, strong)   NSArray     *messageUnread; //obj:SRMessageUnreadInfo

@property (nonatomic, strong)   NSMutableArray  *pointRecords;

@property (nonatomic, assign)   BOOL        hasNewMessageInIm;
@property (nonatomic, assign)   BOOL        hasNewMessageInAlert;
@property (nonatomic, assign)   BOOL        hasNewMessageInRemind;
@property (nonatomic, assign)   BOOL        hasNewMessageInFunction;

@property (nonatomic, strong)   NSDate      *signedDate;

- (BOOL)isSigned;

- (SRMessageSwitchInfo *)messageSwitchWithMessageType:(SRMessageType)messageType;

- (NSInteger)unreadMessageCountWithMessageType:(SRMessageType)messageType;
- (BOOL)hasUnreadMessageInMessageCenter;

- (BOOL)hasPermissionWithType:(SRPermissionType)type;

- (NSString *)permissionsString;
- (void)setPermissionsWithString:(NSString *)string;

- (NSString *)messageSwitchString;
- (void)setMessageSwitchsWithString:(NSString *)string;

- (NSString *)messageUnreadString;
- (void)setMessageUnreadWithString:(NSString *)string;

@end

//
//  SRPortal+User.m
//  SiRuiV4.0
//
//  Created by zhangjunbo on 15/6/25.
//  Copyright (c) 2015年 SiRui. All rights reserved.
//

#import "SRPortal+User.h"
#import "SRPortalRequest.h"
#import "SRPortalResponse.h"
#import "SRUserDefaults.h"
#import "SRHttpUtil.h"
#import "SRURLUtil.h"
#import "SRCustomer.h"
#import "SRDataBase+Customer.h"
#import "SRKeychain.h"
#import "SRPermission.h"
#import "SRUIUtil.h"
#import "SRPointRecordInfo.h"
#import "SREventCenter.h"
#import <MJExtension/MJExtension.h>

@implementation SRPortal (User)

//查询用户信息
+ (void)queryCustomerWithCompleteBlock:(CompleteBlock)completeBlock
{
    SRPortalRequestQueryCustomer *request = [[SRPortalRequestQueryCustomer alloc] init];
    [SRHttpUtil POST:[SRURLUtil Portal_QueryCustomerUrl] WithParameter:request.keyValues completeBlock:^(NSError *error, id responseObject) {
        if (error) {
            if (completeBlock) completeBlock(error, responseObject);
            return ;
        }
        
        SRPortalResponse *response = [SRPortalResponse objectWithKeyValues:responseObject];
        if (response.result.resultCode != SRHTTP_Success) {
            error = [NSError errorWithDomain:response.result.resultMessage
                                        code:response.result.resultCode
                                    userInfo:response.result.fieldErrors];
            if (completeBlock) completeBlock(error, nil);
            return;
        }
        
        SRCustomer *customer = [SRCustomer objectWithKeyValues:response.entity];
        SRCustomer *local = [self sharedInterface].customer;
        if (local) {
            customer.permissions = local.permissions;
            customer.messageSwitchs = local.messageSwitchs;
            customer.messageUnread = local.messageUnread;
        }
        
        [[SREventCenter sharedInterface] loginStatusChange:customer.customerType==SRCustomer_Normal?SRLoginStatus_DidLogin:SRLoginStatus_Visitor];
        
        [[SREventCenter sharedInterface] customerChange:customer];
        
        [self sharedInterface].customer = customer;
        
        [[SRDataBase sharedInterface] deleteAllCustomerWithCompleteBlock:^(NSError *error, id responseObject) {
            [[SRDataBase sharedInterface] updateCustomer:customer withCompleteBlock:nil];
        }];
        
        [SRUserDefaults updateCustomerID:customer.customerID];
        [SRUserDefaults updateHashCode:customer.hashCode];
        
        if (customer.customerType == SRCustomer_Visitor && [SRUserDefaults isVisitorOverTime:[NSDate date] experienceMinutes:customer.exhibitionExperienceTime]) {
            [SRUIUtil showReloginAlertWithMessage:@"您的体验时间已结束，如需继续体验请返回登录页面重新扫描体验" doneButton:@"确定"];
        }
        
        if (completeBlock) completeBlock(nil, customer);
    }];
}

//查询修改权限
+ (void)queryPermissionWithCompleteBlock:(CompleteBlock)completeBlock
{
    SRPortalRequestQueryPermission *request = [[SRPortalRequestQueryPermission alloc] init];
    [SRHttpUtil POST:[SRURLUtil Portal_QueryModifyPermissionUrl] WithParameter:request.keyValues completeBlock:^(NSError *error, id responseObject) {
        if (error) {
            if (completeBlock) completeBlock(error, responseObject);
            return ;
        }
        
        SRPortalResponse *response = [SRPortalResponse objectWithKeyValues:responseObject];
        if (response.result.resultCode != SRHTTP_Success) {
            error = [NSError errorWithDomain:response.result.resultMessage
                                        code:response.result.resultCode
                                    userInfo:response.result.fieldErrors];
            if (completeBlock) completeBlock(error, nil);
            return;
        }
        
        NSArray *list = [SRPermission objectArrayWithKeyValuesArray:response.entity];
        [self sharedInterface].customer.permissions = list;
        
        [[SRDataBase sharedInterface] updateCustomer:[self sharedInterface].customer withCompleteBlock:nil];
        
        if (completeBlock) completeBlock(nil, list);
    }];
}

//修改用户信息
+ (void)modifyUserRecordWithRequest:(SRPortalRequestModifyUserRecord *)request andCompleteBlock:(CompleteBlock)completeBlock
{
    [SRHttpUtil POST :[SRURLUtil Portal_ModifyUserRecordUrl] WithParameter:request.customerDictionaryValue completeBlock:^(NSError *error, id responseObject) {
        
        if (error) {
            if (completeBlock) completeBlock(error, responseObject);
            return ;
        }
        
        SRPortalResponse *response = [SRPortalResponse objectWithKeyValues:responseObject];
        if (response.result.resultCode != SRHTTP_Success) {
            error = [NSError errorWithDomain:response.result.resultMessage
                                        code:response.result.resultCode
                                    userInfo:response.result.fieldErrors];
            if (completeBlock) completeBlock(error, nil);
            return;
        }
        
        [self sharedInterface].customer.name = request.name;
        [self sharedInterface].customer.customerSex = request.customerSex;
        [self sharedInterface].customer.customerUserName = request.customerUserName;
        [self sharedInterface].customer.customerPhone = request.customerPhone;
        [self sharedInterface].customer.customerEmail = request.customerEmail;
        [self sharedInterface].customer.customerAddress = request.customerAddress;
        [self sharedInterface].customer.customerIDNumber = request.customerIDNumber;
        
        [[SRDataBase sharedInterface] updateCustomer:[self sharedInterface].customer withCompleteBlock:nil];
        [SRKeychain updateUserName:request.customerUserName];
        [SRKeychain updatePassword:request.customerPassword];
        
        if (completeBlock) completeBlock(nil, @(YES));
    }];

}

//绑定手机
+ (void)updateBindStatus:(BOOL)isBind withCompleteBlock:(CompleteBlock)completeBlock;
{
    SRPortalRequestBindPhone *request = [[SRPortalRequestBindPhone alloc] init];
    
    [SRHttpUtil POST :isBind?[SRURLUtil Portal_BindUrl]:[SRURLUtil Portal_UnbindUrl] WithParameter:request.keyValues completeBlock:^(NSError *error, id responseObject) {
        
        if (error) {
            if (completeBlock) completeBlock(error, responseObject);
            return ;
        }
        
        SRPortalResponse *response = [SRPortalResponse objectWithKeyValues:responseObject];
        if (response.result.resultCode != SRHTTP_Success) {
            error = [NSError errorWithDomain:response.result.resultMessage
                                        code:response.result.resultCode
                                    userInfo:response.result.fieldErrors];
            if (completeBlock) completeBlock(error, nil);
            return;
        }
        
        [self sharedInterface].customer.bindingStatus = isBind?SRBindingStatus_Bind_Self:SRBindingStatus_Unbind;
        
        [[SRDataBase sharedInterface] updateCustomer:[self sharedInterface].customer withCompleteBlock:nil];
        
        if (completeBlock) completeBlock(nil, @(YES));
    }];
}

//轨迹开关设置
+ (void)updateTripSwitch:(BOOL)isOpen withCompleteBlock:(CompleteBlock)completeBlock
{
    SRPortalRequestTripSwitch *request = [[SRPortalRequestTripSwitch alloc] init];
    request.isOpen = isOpen;
    
    [SRHttpUtil POST :[SRURLUtil Portal_OpenHiddenTrip] WithParameter:request.keyValues completeBlock:^(NSError *error, id responseObject) {
        
        if (error) {
            if (completeBlock) completeBlock(error, responseObject);
            return ;
        }
        
        SRPortalResponse *response = [SRPortalResponse objectWithKeyValues:responseObject];
        if (response.result.resultCode != SRHTTP_Success) {
            error = [NSError errorWithDomain:response.result.resultMessage
                                        code:response.result.resultCode
                                    userInfo:response.result.fieldErrors];
            if (completeBlock) completeBlock(error, nil);
            return;
        }
        
        [self sharedInterface].customer.openHiddenTrip = isOpen;
        
        [[SRDataBase sharedInterface] updateCustomer:[self sharedInterface].customer withCompleteBlock:nil];
        
        if (completeBlock) completeBlock(nil, @(YES));
    }];

}

//实名认证
+ (void)realNameAuthenticationWithRequest:(SRPortalRequestAuthentication *)request andCompleteBlock:(CompleteBlock)completeBlock
{
    [SRHttpUtil POST :[SRURLUtil Portal_RealNameAuthentication] WithParameter:request.keyValues completeBlock:^(NSError *error, id responseObject) {
        
        if (error) {
            if (completeBlock) completeBlock(error, responseObject);
            return ;
        }
        
        SRPortalResponse *response = [SRPortalResponse objectWithKeyValues:responseObject];
        if (response.result.resultCode != SRHTTP_Success) {
            error = [NSError errorWithDomain:response.result.resultMessage
                                        code:response.result.resultCode
                                    userInfo:response.result.fieldErrors];
            if (completeBlock) completeBlock(error, nil);
            return;
        }
        
        [self sharedInterface].customer.realNameAuthentication = AuthenticationStatus_InReview;
        [self sharedInterface].customer.name = request.name;
        [self sharedInterface].customer.customerIDNumber = request.customerIDNumber;
        [[SRDataBase sharedInterface] updateCustomer:[self sharedInterface].customer withCompleteBlock:nil];
        
        if (completeBlock) completeBlock(nil, @(YES));
    }];
}

//签到
+ (void)signDailyWithCompleteBlock:(CompleteBlock)completeBlock
{
    SRPortalRequestRSAApend *request = [[SRPortalRequestRSAApend alloc] init];
    [SRHttpUtil POST:[SRURLUtil Portal_SiginDaily] WithParameter:request.keyValues completeBlock:^(NSError *error, id responseObject) {
        if (error) {
            if (completeBlock) completeBlock(error, responseObject);
            return ;
        }
        
        SRPortalResponse *response = [SRPortalResponse objectWithKeyValues:responseObject];
        if (response.result.resultCode != SRHTTP_Success) {
            error = [NSError errorWithDomain:response.result.resultMessage
                                        code:response.result.resultCode
                                    userInfo:response.result.fieldErrors];
            if (completeBlock) completeBlock(error, nil);
            return;
        }
        
        SRPortalResponseSign *sigin = [SRPortalResponseSign objectWithKeyValues:response.entity];
        
        [self sharedInterface].customer.hasTodaySign = YES;
        [self sharedInterface].customer.continuousSignDay = sigin.continuouslySignDay;
        [self sharedInterface].customer.point = sigin.point;
        [[SRDataBase sharedInterface] updateCustomer:[self sharedInterface].customer withCompleteBlock:nil];
        
        if (completeBlock) completeBlock(nil, @(YES));
    }];
}

static NSInteger currentPage = 1;

+ (void)queryPointRecordIsRefresh:(BOOL)isRefresh andCompleteBlock:(CompleteBlock)completeBlock
{
    SRPortalRequestPage *request = [[SRPortalRequestPage alloc] init];
    if (isRefresh) {
        currentPage = 1;
    } else {
        ++currentPage;
    }
    request.pageIndex = currentPage;
    [SRHttpUtil POST:[SRURLUtil Portal_PointQuery] WithParameter:request.keyValues completeBlock:^(NSError *error, id responseObject) {
        if (error) {
            if (completeBlock) completeBlock(error, responseObject);
            return ;
        }
        
        SRPortalResponse *response = [SRPortalResponse objectWithKeyValues:responseObject];
        if (response.result.resultCode != SRHTTP_Success) {
            error = [NSError errorWithDomain:response.result.resultMessage
                                        code:response.result.resultCode
                                    userInfo:response.result.fieldErrors];
            if (completeBlock) completeBlock(error, nil);
            return;
        }
        
        NSArray *records = [SRPointRecordInfo objectArrayWithKeyValuesArray:response.pageResult.entityList];
        if (isRefresh) {
            [self sharedInterface].customer.pointRecords = [NSMutableArray arrayWithArray:records];
        } else {
            [[self sharedInterface].customer.pointRecords addObjectsFromArray:records];
        }
        
        [[SRDataBase sharedInterface] updateCustomer:[self sharedInterface].customer withCompleteBlock:nil];
        
        if (completeBlock) completeBlock(nil, [self sharedInterface].customer.pointRecords);
    }];
}

@end

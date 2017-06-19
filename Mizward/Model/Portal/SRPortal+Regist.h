//
//  SRPortal+Regist.h
//  SiRuiV4.0
//
//  Created by zhangjunbo on 15/6/23.
//  Copyright (c) 2015年 SiRui. All rights reserved.
//

#import "SRPortal.h"

@class SRPortalRequestSendAuthCodeToPhone, SRPortalRequestRegist, SRBrandInfo, SRPortalRequestBindTerminal, SRPortalRequestValidateIMEI, SRPortalRequestPhoneVerifyWithTernimal, SRPortalRequestPhoneVerifyWithoutTernimal, SRPortalRequestResetPassword, SRPortalRequestAccountAppeal, SRPortalRequestPhoneVerifyWithAuthcode;

@interface SRPortal (Regist)

#pragma mark - 注册

//发送验证码
+ (void)sendAuthCodeToPhoneWithRequest:(SRPortalRequestSendAuthCodeToPhone *)request andCompleteBlock:(CompleteBlock)completeBlock;

//注册新用户
+ (void)registeWithRequest:(SRPortalRequestRegist *)request andCompleteBlock:(CompleteBlock)completeBlock;

//获取品牌列表
+ (void)getBrandListWithCompleteBlock:(CompleteBlock)completeBlock;
//获取车型车系列表
+ (void)getSeriesAndVehiclesWithBrandInfo:(SRBrandInfo *)brandInfo andCompleteBlock:(CompleteBlock)completeBlock;

//绑定终端
+ (void)bindTerminalWithRequest:(SRPortalRequestBindTerminal *)request andCompleteBlock:(CompleteBlock)completeBlock;

//验证IMEI
+ (void)validateIMEIWithRequest:(SRPortalRequestValidateIMEI *)request andCompleteBlock:(CompleteBlock)completeBlock;

//手机号验证，无终端
+ (void)phoneVerifyWithoutTernimalWithRequest:(SRPortalRequestPhoneVerifyWithoutTernimal *)request andCompleteBlock:(CompleteBlock)completeBlock;
//手机号验证，无终端，不需要本地验证
+ (void)phoneVerifyWithoutTernimalNoAuthcodeWithRequest:(SRPortalRequestPhoneVerifyWithoutTernimal *)request andCompleteBlock:(CompleteBlock)completeBlock;

//手机号验证，有终端
+ (void)phoneVerifyWithTernimalWithRequest:(SRPortalRequestPhoneVerifyWithTernimal *)request andCompleteBlock:(CompleteBlock)completeBlock;
//手机号验证，有终端，不需要本地验证
+ (void)phoneVerifyWithTernimalNoAuthCodeWithRequest:(SRPortalRequestPhoneVerifyWithTernimal *)request andCompleteBlock:(CompleteBlock)completeBlock;

//密码找回，验证短信验证码
+ (void)phoneVerifyWithAuthcodeWithRequest:(SRPortalRequestPhoneVerifyWithAuthcode *)request andCompleteBlock:(CompleteBlock)completeBlock;

//密码重置
+ (void)resetPasswordWithRequest:(SRPortalRequestResetPassword *)request andCompleteBlock:(CompleteBlock)completeBlock;

//账户申诉
+ (void)accountAppealWithRequest:(SRPortalRequestAccountAppeal *)request andCompleteBlock:(CompleteBlock)completeBlock;

@end

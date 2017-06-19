//
//  SRPortal+Regist.m
//  SiRuiV4.0
//
//  Created by zhangjunbo on 15/6/23.
//  Copyright (c) 2015年 SiRui. All rights reserved.
//

#import "SRPortal+Regist.h"
#import "SRPortalRequest.h"
#import "SRPortalResponse.h"
#import "SRHttpUtil.h"
#import "SRURLUtil.h"
#import "SRBrandInfo.h"
#import "SRSeriesInfo.h"
#import "SRDataBase+BrandInfo.h"
#import <MJExtension/MJExtension.h>
#import <AFNetworking/AFNetworking.h>

@implementation SRPortal (Regist)

#pragma mark - 注册

//发送验证码
+ (void)sendAuthCodeToPhoneWithRequest:(SRPortalRequestSendAuthCodeToPhone *)request andCompleteBlock:(CompleteBlock)completeBlock
{
    [SRHttpUtil POST:[SRURLUtil Portal_SendAuthCodeToPhoneUrl] WithParameter:request.keyValues completeBlock:^(NSError *error, id responseObject) {
        if (error) {
            if (completeBlock) completeBlock(error, responseObject);
            return ;
        }
        
        SRPortalResponse *response = [SRPortalResponse objectWithKeyValues:responseObject];
        if (response.result.resultCode != SRHTTP_Success) {
            error = [NSError errorWithDomain:response.result.resultMessage
                                        code:response.result.resultCode
                                    userInfo:response.result.fieldErrors];
            if (completeBlock) completeBlock(error, response.option[@"authCode"]);
        } else {
            if (completeBlock) completeBlock(nil, response.option[@"authCode"]);
        }
    } autoRetry:0 retryInterval:0];
}

//注册新用户
+ (void)registeWithRequest:(SRPortalRequestRegist *)request andCompleteBlock:(CompleteBlock)completeBlock
{
    [SRHttpUtil POST :[SRURLUtil Portal_RegistUrl] WithParameter:request.keyValues completeBlock:^(NSError *error, id responseObject) {
        
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
        } else {
            if (completeBlock) completeBlock(nil, response);
        }
    }];
}

//获取品牌列表
+ (void)getBrandListWithCompleteBlock:(CompleteBlock)completeBlock
{
    SRPortalRequestQueryBrandList *request = [[SRPortalRequestQueryBrandList alloc] init];
    [SRHttpUtil POST :[SRURLUtil Portal_QueryBrandListUrl] WithParameter:request.keyValues completeBlock:^(NSError *error, id responseObject) {
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
        } else {
            NSArray *brands = [[SRBrandInfo objectArrayWithKeyValuesArray:response.entity[@"brands"]]
                               sortedArrayUsingComparator:^NSComparisonResult(SRBrandInfo *obj1, SRBrandInfo *obj2) {
                                   return obj1.entityID>obj2.entityID;
                               }];
            NSMutableDictionary *brandDic = [NSMutableDictionary dictionary];
            [brands enumerateObjectsUsingBlock:^(SRBrandInfo *obj, NSUInteger idx, BOOL *stop) {
                if (obj.entityID < 0) return ;
                
                NSMutableArray *array = [brandDic objectForKey:obj.brandFirstLetter];
                if (!array) {
                    array = [NSMutableArray arrayWithObject:obj];
                    [brandDic setObject:array forKey:obj.brandFirstLetter];
                } else {
                    [array addObject:obj];
                }
            }];
            
            [[SRDataBase sharedInterface] updateBrandInfos:brands withCompleteBlock:nil];
            
            if (completeBlock) completeBlock(nil, brandDic);
        }
    }];
}

//获取车型车系列表
+ (void)getSeriesAndVehiclesWithBrandInfo:(SRBrandInfo *)brandInfo andCompleteBlock:(CompleteBlock)completeBlock
{
    SRPortalRequestQuerySeriesModelTreeList *request = [[SRPortalRequestQuerySeriesModelTreeList alloc] init];
    request.brandID = brandInfo.entityID;
    
    [SRHttpUtil POST :[SRURLUtil Portal_QuerySeriesModelTreeListUrl] WithParameter:request.keyValues completeBlock:^(NSError *error, id responseObject) {
        
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
        } else {
            NSArray *seriesList = [SRSeriesInfo objectArrayWithKeyValuesArray:response.entity];
            brandInfo.seriesList = seriesList;
            
            [[SRDataBase sharedInterface] updateBrandInfos:@[brandInfo] withCompleteBlock:nil];
            
            if (completeBlock) completeBlock(nil, brandInfo);
        }
        
    }];
}

//绑定终端
+ (void)bindTerminalWithRequest:(SRPortalRequestBindTerminal *)request andCompleteBlock:(CompleteBlock)completeBlock
{
    [SRHttpUtil POST :[SRURLUtil Portal_BindTerminal] WithParameter:request.keyValues completeBlock:^(NSError *error, id responseObject) {
        
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
        } else {
            if (completeBlock) completeBlock(nil, @(YES));
        }
    }];
}

//验证IMEI
+ (void)validateIMEIWithRequest:(SRPortalRequestValidateIMEI *)request andCompleteBlock:(CompleteBlock)completeBlock
{
    [SRHttpUtil POST :[SRURLUtil Portal_ValidateIMEI] WithParameter:request.keyValues completeBlock:^(NSError *error, id responseObject) {
        
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
        } else {
            SRPortalResponseValideIMEI *info = [SRPortalResponseValideIMEI objectWithKeyValues:response.entity];
            if (completeBlock) completeBlock(nil, info);
        }
    }];
}

//手机号验证，无终端
+ (void)phoneVerifyWithoutTernimalWithRequest:(SRPortalRequestPhoneVerifyWithoutTernimal *)request andCompleteBlock:(CompleteBlock)completeBlock
{
    [SRHttpUtil POST :[SRURLUtil Portal_PhoneVerifyWithoutTernimal] WithParameter:request.keyValues completeBlock:^(NSError *error, id responseObject) {
        
        if (error) {
            if (completeBlock) completeBlock(error, responseObject);
            return ;
        }
        
        SRPortalResponse *response = [SRPortalResponse objectWithKeyValues:responseObject];
//        if (response.result.resultCode != SRHTTP_Success) {
//            error = [NSError errorWithDomain:response.result.resultMessage
//                                        code:response.result.resultCode
//                                    userInfo:response.result.fieldErrors];
//            if (completeBlock) completeBlock(error, nil);
//            return;
//        }
        if (response.result.resultCode != SRHTTP_Success) {
            error = [NSError errorWithDomain:response.result.resultMessage
                                        code:response.result.resultCode
                                    userInfo:response.result.fieldErrors];
            if (completeBlock) completeBlock(error, response.option[@"authCode"]);
        } else {
            if (completeBlock) completeBlock(nil, response.option[@"authCode"]);
        }
        
//        if (completeBlock) completeBlock(nil, response.result.resultMessage);
    }];
}

//手机号验证，无终端，不需要本地验证
+ (void)phoneVerifyWithoutTernimalNoAuthcodeWithRequest:(SRPortalRequestPhoneVerifyWithoutTernimal *)request andCompleteBlock:(CompleteBlock)completeBlock
{
    [SRHttpUtil POST :[SRURLUtil Portal_PhoneVerifyWithoutTernimalNoAuthcode] WithParameter:request.keyValues completeBlock:^(NSError *error, id responseObject) {
        
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

        
        if (completeBlock) completeBlock(nil, response.result.resultMessage);
    }];
}

//手机号验证，有终端
+ (void)phoneVerifyWithTernimalWithRequest:(SRPortalRequestPhoneVerifyWithTernimal *)request andCompleteBlock:(CompleteBlock)completeBlock
{
    [SRHttpUtil POST :[SRURLUtil Portal_PhoneVerifyWithTernimal] WithParameter:request.keyValues completeBlock:^(NSError *error, id responseObject) {
        
        if (error) {
            if (completeBlock) completeBlock(error, responseObject);
            return ;
        }
        
        SRPortalResponse *response = [SRPortalResponse objectWithKeyValues:responseObject];
        if (response.result.resultCode != SRHTTP_Success) {
            error = [NSError errorWithDomain:response.result.resultMessage
                                        code:response.result.resultCode
                                    userInfo:response.result.fieldErrors];
            if (completeBlock) completeBlock(error, response.option[@"authCode"]);
        } else {
            if (completeBlock) completeBlock(nil, response.option[@"authCode"]);
        }
//        if (response.result.resultCode != SRHTTP_Success) {
//            error = [NSError errorWithDomain:response.result.resultMessage
//                                        code:response.result.resultCode
//                                    userInfo:response.result.fieldErrors];
//            if (completeBlock) completeBlock(error, nil);
//            return;
//        }
//        
//        if (completeBlock) completeBlock(nil, response.result.resultMessage);
    }];
}

//手机号验证，有终端，不需要本地验证
+ (void)phoneVerifyWithTernimalNoAuthCodeWithRequest:(SRPortalRequestPhoneVerifyWithTernimal *)request andCompleteBlock:(CompleteBlock)completeBlock
{
    [SRHttpUtil POST :[SRURLUtil Portal_PhoneVerifyWithTernimalNoAuthcode] WithParameter:request.keyValues completeBlock:^(NSError *error, id responseObject) {
        
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
        
        if (completeBlock) completeBlock(nil, response.result.resultMessage);
    }];
}

//密码找回，验证短信验证码
+ (void)phoneVerifyWithAuthcodeWithRequest:(SRPortalRequestPhoneVerifyWithAuthcode *)request andCompleteBlock:(CompleteBlock)completeBlock
{
    [SRHttpUtil POST :[SRURLUtil Portal_PhoneVerifyWithAuthcode] WithParameter:request.keyValues completeBlock:^(NSError *error, id responseObject) {
        
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
        
        if (completeBlock) completeBlock(nil, response.result.resultMessage);
    }];
}

//密码重置
+ (void)resetPasswordWithRequest:(SRPortalRequestResetPassword *)request andCompleteBlock:(CompleteBlock)completeBlock
{
    [SRHttpUtil POST :[SRURLUtil Portal_ResetPasswordUrl] WithParameter:request.keyValues completeBlock:^(NSError *error, id responseObject) {
        
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
        
        if (completeBlock) completeBlock(nil, response.result.resultMessage);
    }];
}

//账户申诉
+ (void)accountAppealWithRequest:(SRPortalRequestAccountAppeal *)request andCompleteBlock:(CompleteBlock)completeBlock
{
    [SRHttpUtil POST:[SRURLUtil Portal_AccountAppealSubmitUrl] WithParameter:request.keyValues constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        UIImage *resizedImage = [request.photoContent resizedImageWithContentMode:UIViewContentModeScaleAspectFit
                                                                           bounds:CGSizeMake(720 , 720)
                                                             interpolationQuality:kCGInterpolationMedium];
        
        [formData appendPartWithFileData:UIImageJPEGRepresentation(resizedImage, 0.5)
                                    name:@"photoContent"
                                fileName:[NSString stringWithFormat:@"%@.jpg", request.idNumber]
                                mimeType:@"image/jpeg"];
    } completeBlock:^(NSError *error, id responseObject) {
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
        
        if (completeBlock) completeBlock(nil, response.result.resultMessage);
    }];
}

@end

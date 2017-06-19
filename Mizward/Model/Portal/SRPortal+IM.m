//
//  SRPortal+IM.m
//  SiRuiV4.0
//
//  Created by zhangjunbo on 15/6/25.
//  Copyright (c) 2015年 SiRui. All rights reserved.
//

#import "SRPortal+IM.h"
#import "SRPortalRequest.h"
#import "SRPortalResponse.h"
#import "SRIMMessage.h"
#import "SRHttpUtil.h"
#import "SRURLUtil.h"
#import "SRKeychain.h"
#import "SRCustomer.h"
#import <MJExtension/MJExtension.h>
#import <AFURLRequestSerialization.h>

@implementation SRPortal (IM)

//查询消息列表
+ (void)queryIMWithRequest:(SRPortalRequestQueryIM *)request andCompleteBlock:(CompleteBlock)completeBlock
{
    if (request.direction == SRIMDirection_New) {
        [self sharedInterface].customer.hasNewMessageInIm = NO;
    }
    
    [SRHttpUtil POST :[SRURLUtil Portal_QueryIMUrl] WithParameter:request.keyValues completeBlock:^(NSError *error, id responseObject) {
        
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
        
        NSArray *list = [SRIMMessage objectArrayWithKeyValuesArray:response.entity];
        
        if (completeBlock) completeBlock(nil, list);
    }];
}

//发送消息
+ (void)sendIMWithRequest:(SRPortalRequestSendIM *)request andCompleteBlock:(CompleteBlock)completeBlock
{

    NSString *url = [NSString stringWithFormat:@"%@?", [SRURLUtil Portal_SendIMUrl]];
    if ([SRKeychain UserName] && [SRKeychain Password]) {
        url = [NSString stringWithFormat:@"%@input1=%@&input2=%@", url, [[SRKeychain UserName].RSAEncode urlEncode], [[SRKeychain Password].RSAEncode urlEncode]];
    }
    
    if (request.content && request.content.length>0) {
        url = [NSString stringWithFormat:@"%@&content=%@", url, [request.content stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    }
    
    [SRHttpUtil POST:url/*[SRURLUtil Portal_SendIMUrl]*/ WithParameter:request.parameter constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
        if (!request.image) return ;
        
        UIImage *resizedImage = [request.image resizedImageWithContentMode:UIViewContentModeScaleAspectFit
                                                                    bounds:CGSizeMake(720 , 720)
                                                      interpolationQuality:kCGInterpolationMedium];
        
//        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
//        NSString *filePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"test.jpeg"]];   // 保存文件的名称
//        [UIImageJPEGRepresentation(resizedImage, 0.5) writeToFile: filePath    atomically:YES]; // 保存成功会返回YES
        
        [formData appendPartWithFileData:UIImageJPEGRepresentation(resizedImage, 0.5)
                                    name:@"content"
                                fileName:[NSString stringWithFormat:@"%zd.jpg", (NSInteger)[[NSDate date] timeIntervalSince1970]]
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
        } else {
            SRIMMessage *message = [SRIMMessage objectWithKeyValues:response.entity];
            message.type = SRIMType_Customer;
            if (request.image) {
                message.isImg = YES;
                message.image = request.image;
            } else {
                message.content = request.content;
            }
            if (completeBlock) completeBlock(nil, message);
        }
    }];

}

@end

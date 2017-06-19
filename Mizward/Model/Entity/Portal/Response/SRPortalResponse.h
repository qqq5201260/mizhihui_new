//
//  SRPortalResponse.h
//  SiRuiV4.0
//
//  Created by zhangjunbo on 15/6/18.
//  Copyright (c) 2015年 SiRui. All rights reserved.
//

#import "SREntity.h"

@class SRPortalResult, SRPageResult;

#pragma mark - Base

@interface SRPortalResponse : SREntity

@property (nonatomic, strong) id entity;
@property (nonatomic, strong) id option;
@property (nonatomic, strong) SRPageResult   *pageResult;
@property (nonatomic, strong) SRPortalResult *result;

@end

@interface SRPortalResult : SREntity

@property (nonatomic, copy) NSString *errFieldMessage;
@property (nonatomic, strong) NSDictionary *fieldErrors;
@property (nonatomic, assign) NSInteger resultCode;
@property (nonatomic, copy) NSString *resultMessage;

@end

@interface SRPageResult : SREntity

@property (nonatomic, strong) id        entityList;
@property (nonatomic, assign) NSInteger pageIndex;
@property (nonatomic, assign) NSInteger pageSize;
@property (nonatomic, assign) NSInteger totalCount;
@property (nonatomic, assign) NSInteger totalPage;

@end


#pragma mark - 登陆

@interface SRPortalResponseLogin : SREntity

@property (nonatomic, assign) BOOL needUpdate;
@property (nonatomic, copy) NSString *updateURL;
@property (nonatomic, copy) NSString *updateVersion;
@property (nonatomic, assign) NSInteger controlSeries;

@end

#pragma mark - IMEI验证

@interface SRPortalResponseValideIMEI : SREntity

@property (nonatomic, copy) NSString *bname;
@property (nonatomic, assign) NSInteger bid;
@property (nonatomic, copy) NSString *sname;
@property (nonatomic, assign) NSInteger sid;
@property (nonatomic, copy) NSString *vmname;
@property (nonatomic, assign) NSInteger vmid;

@end

#pragma mark - 签到

@interface SRPortalResponseSign : SREntity

@property (nonatomic, assign) NSInteger point;
@property (nonatomic, assign) NSInteger continuouslySignDay;

@end
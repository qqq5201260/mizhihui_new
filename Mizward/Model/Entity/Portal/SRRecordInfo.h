//
//  SRRecordInfo.h
//  SiRuiV4.0
//
//  Created by zhangjunbo on 15/6/16.
//  Copyright (c) 2015年 SiRui. All rights reserved.
//

#import "SREntity.h"

@interface SRRecordInfo : SREntity

//Customer
@property (nonatomic, copy) NSString    *customerName;
@property (nonatomic, copy) NSString    *customerIDNumber;
@property (nonatomic, assign) NSInteger customerSex;
@property (nonatomic, copy) NSString    *customerBirthdayStr;
@property (nonatomic, copy) NSString    *customerUserName;
@property (nonatomic, copy) NSString    *customerPhone;
@property (nonatomic, copy) NSString    *customerEmail;
@property (nonatomic, copy) NSString    *customerAddress;

//Department
@property (nonatomic, copy) NSString    *depName;
@property (nonatomic, copy) NSString    *depAddress;

//VehicleBasic
@property (nonatomic, assign) NSInteger brandID;
@property (nonatomic, copy) NSString    *brandName;
@property (nonatomic, assign) NSInteger entityID;
@property (nonatomic, assign) NSInteger vehicleModelID;
@property (nonatomic, copy) NSString    *vehicleModelName;
@property (nonatomic, copy) NSString    *color;
@property (nonatomic, copy) NSString    *vin;
@property (nonatomic, copy) NSString    *saleDateStr;
@property (nonatomic, copy) NSString    *serialNumber;
@property (nonatomic, copy) NSString    *msisdn;
@property (nonatomic, copy) NSString    *installDateStr;
@property (nonatomic, copy) NSString    *barcode;
@property (nonatomic, assign) CGFloat   balance;

@end

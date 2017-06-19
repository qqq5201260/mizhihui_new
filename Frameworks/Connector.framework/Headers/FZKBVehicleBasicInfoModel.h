//
//  FZKBVehicleBasicInfoModel.h
//  Connector
//
//  Created by czl on 2017/4/19.
//  Copyright © 2017年 chinapke. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "FZKBAbilitiesModel.h"
#import "FZKTBluetoothInfoModel.h"

@interface FZKBVehicleBasicInfoModel : NSObject<NSCoding>

/**
 单利
 
 @return
 */
+ (instancetype)shareVehicleBasicInfoModel;

/**
 归档
 */
- (void)archive;

@property (nonatomic , copy) NSString              * plateNumber;
@property (nonatomic , copy) NSString              * msisdn;
@property (nonatomic , assign) NSInteger              nextMaintenMileage;
@property (nonatomic , assign) NSInteger              vehicleID;
@property (nonatomic , copy) NSString              * balanceDate;
@property (nonatomic , copy) NSString              * goHomeTime;
@property (nonatomic , assign) NSInteger              vehicleModelID;
@property (nonatomic , assign) NSInteger              customerID;
@property (nonatomic , assign) BOOL              gotoV3;
@property (nonatomic , copy) NSString              * renewServiceStartTime;
@property (nonatomic , assign) NSInteger              preMaintenMileage;
@property (nonatomic , copy) NSString              * product;
@property (nonatomic , assign) NSInteger              openObd;
@property (nonatomic , assign) CGFloat              fenceCentralLat;
@property (nonatomic , assign) NSInteger               serialNumber;
@property (nonatomic , assign) NSInteger              tripHidden;
@property (nonatomic , assign) BOOL              gotBalance;
@property (nonatomic , assign) NSInteger              isInFence;
@property (nonatomic , assign) BOOL              hasOBDModule;
@property (nonatomic , assign) BOOL              whetherExpire;
@property (nonatomic , assign) NSInteger              controlSms;
@property (nonatomic , assign) NSInteger              fenceRadius;
@property (nonatomic , copy) NSString              * customerName;
@property (nonatomic , copy) NSString              * customerPhone;
@property (nonatomic , strong) NSArray              * abilities;
@property (nonatomic , assign) CGFloat              fenceCentralLng;
@property (nonatomic , assign) BOOL              has4SModule;
@property (nonatomic , assign) BOOL              hasControlModule;
@property (nonatomic , assign) NSInteger              brandID;
@property (nonatomic , copy) NSString              * barcode;
@property (nonatomic , assign) NSInteger              terminalID;
@property (nonatomic , assign) BOOL              isPreciseFuelCons;
@property (nonatomic , copy) NSString              * serviceCode;
@property (nonatomic , assign) NSInteger              controlBt;
@property (nonatomic , copy) NSString              * renewServiceEndTime;
@property (nonatomic , copy) NSString              * vehicleModelName;
@property (nonatomic , copy) NSString              * brandName;
@property (nonatomic , strong) NSArray              * abilities_v2;
@property (nonatomic , assign) CGFloat              balance;
@property (nonatomic , assign) NSInteger              maxStartTimeLength;
@property (nonatomic , copy) NSString              * workTime;
@property (nonatomic , strong)FZKTBluetoothInfoModel *bluetooth;



@end

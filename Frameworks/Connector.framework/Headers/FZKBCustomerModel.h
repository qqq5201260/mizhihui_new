
//
//  FZKBCustomerModel.h
//  Connector
//
//  Created by czl on date
//  Copyright © 2017年 chinapke. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FZKBCarModel.h"

@interface FZKBCustomerModel : NSObject<NSCoding>


/**
 单利

 @return
 */
+ (instancetype)shareCustomer;


/**
 归档
 */
- (void)archive;

@property (nonatomic , assign) NSInteger              customerType;
@property (nonatomic , assign) BOOL              ageFlag;
@property (nonatomic , assign) NSInteger              phoneType;
@property (nonatomic , copy) NSString              * secondLevelCode;
@property (nonatomic , assign) BOOL              isTopSystem;
@property (nonatomic , assign) NSInteger              vehicleModelID;
@property (nonatomic , assign) NSInteger              updateUserID;
@property (nonatomic , assign) NSInteger              customerID;
@property (nonatomic , assign) NSInteger              realNameAuthentication;
@property (nonatomic , copy) NSString              * levelCode;
@property (nonatomic , assign) BOOL              isChild;
@property (nonatomic , assign) BOOL              querySub;
@property (nonatomic , assign) NSInteger              customerSex;
@property (nonatomic , copy) NSString              * depName;
@property (nonatomic , copy) NSString              * app;
@property (nonatomic , assign) BOOL              isFrozen;
@property (nonatomic , assign) NSInteger              exhibtionID;
@property (nonatomic , copy) NSString              * updateTime;
@property (nonatomic , assign) NSInteger              customerManagerID;
@property (nonatomic , copy) NSString              * name;
@property (nonatomic , copy) NSString              * customerPhone;
@property (nonatomic , assign) NSInteger              customerIDNumberType;
@property (nonatomic , assign) NSInteger              brandID;
@property (nonatomic , copy) NSString              * customerUserName;
@property (nonatomic , assign) NSInteger              depID;
@property (nonatomic , strong) NSArray              * cars;
@property (nonatomic , assign) NSInteger              createUserID;
@property (nonatomic , assign) BOOL              customerBinded;
@property (nonatomic , copy) NSString              * customerSexStr;
@property (nonatomic , assign) NSInteger              isContainsChild;
@property (nonatomic , assign) BOOL              isTop;
@property (nonatomic , copy) NSString              * createTime;
@property (nonatomic , assign) BOOL              openHiddenTrip;
@property (nonatomic , assign) BOOL              isSecond;
@property (nonatomic , assign) BOOL              topOrParentLevel;
@property (nonatomic , copy) NSString              * topLevelCode;
@property (nonatomic , copy) NSString              * phoneID;
@property (nonatomic , assign) BOOL              isSelf;
@property (nonatomic , assign) BOOL              temporary;
@property (nonatomic , copy) NSString              * customerPassword;
@property (nonatomic , assign) NSInteger              entityID;

@end

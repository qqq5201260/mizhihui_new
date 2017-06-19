
//
//  FZKBLoginModel.h
//  Connector
//
//  Created by czl on date
//  Copyright © 2017年 chinapke. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "FZKBDepartmentModel.h"
#import "FZKBCustomerModel.h"
#import "FZKBEndPointsModel.h"
#import "FZKBTotalInfosModel.h"

@interface FZKBLoginModel : NSObject<NSCoding>

/**
 单利
 
 @return
 */
+ (instancetype)share;


/**
 归档
 */
- (void)archive;

@property (nonatomic , assign) NSInteger              bindingStatus;
@property (nonatomic , assign) BOOL              needChangeUserName;
@property (nonatomic , strong) FZKBCustomerModel              * customer;
@property (nonatomic , assign) NSInteger              exhibitionExperienceTime;
@property (nonatomic , strong) NSArray              * totalInfos;
@property (nonatomic , assign) NSInteger              customerID;
@property (nonatomic , strong) NSArray              * endPoints;
@property (nonatomic , assign) BOOL              needUpdate;
@property (nonatomic , copy) NSString              * updateURL;
@property (nonatomic , copy) NSString              * token;
@property (nonatomic , copy) NSString              * updateVersion;
@property (nonatomic , assign) NSInteger              customerType;
@property (nonatomic , strong) FZKBDepartmentModel              * department;
@property (nonatomic , assign) NSInteger              controlSeries;

@end

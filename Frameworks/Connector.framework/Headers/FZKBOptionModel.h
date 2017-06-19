
//
//  FZKBOptionModel.h
//  Connector
//
//  Created by czl on date
//  Copyright © 2017年 chinapke. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FZKBDepartmentModel.h"
#import "FZKBCustomerModel.h"

@interface FZKBOptionModel : NSObject

@property (nonatomic,assign) NSInteger exhibitionExperienceTime;

@property (nonatomic,copy) NSString *updateVersion;

@property (nonatomic,assign) NSInteger needUpdate;

@property (nonatomic,assign) NSInteger needChangeUserName;

@property (nonatomic,copy) NSString *token;

@property (nonatomic,assign) NSInteger customerType;

@property (nonatomic,assign) NSInteger bindingStatus;

@property (nonatomic,assign) NSInteger controlSeries;

@property (nonatomic,copy) NSString *updateURL;

@property (nonatomic,assign) NSInteger customerID;

@property (nonatomic,strong) FZKBDepartmentModel *department;

@property (nonatomic,copy) NSArray *endPoints;

@property (nonatomic,strong) FZKBCustomerModel *customer;




@end

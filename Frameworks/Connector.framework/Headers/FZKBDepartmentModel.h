
//
//  FZKBDepartmentModel.h
//  Connector
//
//  Created by czl on date
//  Copyright © 2017年 chinapke. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FZKBDepPartAttrModel.h"
#import "FZKBFDepPartAttrModel.h"

@interface FZKBDepartmentModel : NSObject<NSCoding>

@property (nonatomic , copy) NSString              * memo;
@property (nonatomic , assign) BOOL              isSelf;
@property (nonatomic , assign) NSInteger              createUserID;
@property (nonatomic , assign) BOOL              has4sOnline;
@property (nonatomic , assign) NSInteger              depID;
@property (nonatomic , assign) BOOL              isTop;
@property (nonatomic , copy) NSString              * extendOrderRule;
@property (nonatomic , copy) NSString              * extendLevelCode;
@property (nonatomic , assign) BOOL              isChild;
@property (nonatomic , assign) NSInteger              updateUserID;
@property (nonatomic , copy) NSString              * fExtendOrderRule;
@property (nonatomic , assign) BOOL              fHas4sOnline;
@property (nonatomic , copy) NSString              * address;
@property (nonatomic , assign) CGFloat              imgMathParam;
@property (nonatomic , strong) FZKBFDepPartAttrModel              * fDepPartAttr;
@property (nonatomic , assign) CGFloat              lng;
@property (nonatomic , assign) BOOL              hasOrderOpen;
@property (nonatomic , assign) NSInteger              viewOrder;
@property (nonatomic , assign) NSInteger              view4SOnline;
@property (nonatomic , assign) NSInteger              gwstock;
@property (nonatomic , copy) NSString              * topLevelCode;
@property (nonatomic , copy) NSString              * contractPerson;
@property (nonatomic , assign) CGFloat              lat;
@property (nonatomic , assign) BOOL              fHasOrderOpen;
@property (nonatomic , copy) NSString              * name;
@property (nonatomic , assign) BOOL              querySub;
@property (nonatomic , copy) NSString              * levelCode;
@property (nonatomic , copy) NSString              * memoStr;
@property (nonatomic , assign) BOOL              isTopSystem;
@property (nonatomic , assign) NSInteger              depType;
@property (nonatomic , assign) NSInteger              entityID;
@property (nonatomic , assign) NSInteger              otustock;
@property (nonatomic , assign) BOOL              topOrParentLevel;
@property (nonatomic , copy) NSString              * updateTime;
@property (nonatomic , assign) NSInteger              storeWgStock;
@property (nonatomic , strong) FZKBDepPartAttrModel              * depPartAttr;
@property (nonatomic , copy) NSString              * siruiOnlineName;
@property (nonatomic , assign) BOOL              isSecond;
@property (nonatomic , copy) NSString              * secondLevelCode;
@property (nonatomic , assign) NSInteger              isContainsChild;
@property (nonatomic , copy) NSString              * fExtendLevelCode;
@property (nonatomic , copy) NSString              * fExtendOrderOpen;
@property (nonatomic , assign) NSInteger              audiInterfaceSwitch;

@property (nonatomic , copy) NSString              * regionalismCode;
@property (nonatomic , copy) NSString              * createTime;
@property (nonatomic , assign) NSInteger              extendOrderFlag;
@property (nonatomic , copy) NSString              * fLevelcode;
@property (nonatomic , assign) NSInteger              storeOtuStock;
@property (nonatomic , assign) BOOL              isCooperateMainten;
@property (nonatomic , copy) NSString              * extendOrderOpen;
@property (nonatomic , assign) NSInteger              brandID;
@property (nonatomic , assign) NSInteger              userID;


@end

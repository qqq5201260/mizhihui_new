//
//  FZKBCarModel.h
//  Connector
//
//  Created by czl on 2017/4/19.
//  Copyright © 2017年 chinapke. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <UIKit/UIKit.h>

@interface FZKBCarModel : NSObject<NSCoding>

@property (nonatomic , assign) CGFloat              mileAge;
@property (nonatomic , assign) NSInteger              maintenCount;
//@property (nonatomic , strong) NSArray<FZKBBtsModel *>              * bts;
@property (nonatomic , assign) BOOL              isSelf;
@property (nonatomic , assign) NSInteger              createUserID;
@property (nonatomic , assign) NSInteger              customerSex;
@property (nonatomic , copy) NSString              * vehicleModelName;
@property (nonatomic , assign) NSInteger              depID;
@property (nonatomic , assign) BOOL              isTop;
@property (nonatomic , assign) BOOL              isChild;
@property (nonatomic , assign) CGFloat              nextMaintenMileage;
@property (nonatomic , copy) NSString              * customerName;
@property (nonatomic , strong) NSString              * serialNumber;
@property (nonatomic , assign) NSInteger              importExcelFlag;
@property (nonatomic , assign) NSInteger              vehicleID;
@property (nonatomic , assign) NSInteger              updateUserID;
@property (nonatomic , copy) NSString              * barcode;
@property (nonatomic , assign) NSInteger              lastMessageTime;
@property (nonatomic , assign) NSInteger              star;
@property (nonatomic , assign) NSInteger              customerID;
@property (nonatomic , assign) NSInteger              maintenOrderCount;
@property (nonatomic , assign) NSInteger              giftMaintenanceTimes;
@property (nonatomic , copy) NSString              * topLevelCode;
@property (nonatomic , assign) NSInteger              customerBindedByInt;
@property (nonatomic , assign) BOOL              querySub;
@property (nonatomic , copy) NSString              * serviceEndTime;
@property (nonatomic , copy) NSString              * levelCode;
@property (nonatomic , assign) NSInteger              search_star;
@property (nonatomic , assign) NSInteger              toCustomerFenceRedius;
@property (nonatomic , assign) CGFloat              balance;
@property (nonatomic , assign) BOOL              customerBinded;
@property (nonatomic , assign) BOOL              isTopSystem;
@property (nonatomic , assign) BOOL              needMainten;
@property (nonatomic , assign) NSInteger              seriesID;
@property (nonatomic , assign) NSInteger              entityID;
@property (nonatomic , assign) NSInteger              vehicleModelID;
@property (nonatomic , copy) NSString              * renewServiceEndTime;
//@property (nonatomic , strong) NSArray<FZKBWgsModel *>              * wgs;
@property (nonatomic , assign) NSInteger              isOnline;
@property (nonatomic , assign) BOOL              topOrParentLevel;
@property (nonatomic , copy) NSString              * updateTime;
@property (nonatomic , copy) NSString              * customerSexString;
@property (nonatomic , assign) BOOL              isSecond;
@property (nonatomic , assign) NSInteger              nextBigMaintenMileage;
@property (nonatomic , copy) NSString              * secondLevelCode;
@property (nonatomic , copy) NSString              * renewServiceStartTime;
@property (nonatomic , copy) NSString              * customerUserName;
@property (nonatomic , assign) NSInteger              isContainsChild;
@property (nonatomic , copy) NSString              * msisdn;
@property (nonatomic , assign) CGFloat              oilSize;
@property (nonatomic , assign) NSInteger              terminal_status;
@property (nonatomic , assign) NSInteger              preMaintenMileage;
@property (nonatomic , copy) NSString              * createTime;
@property (nonatomic , assign) NSInteger              groupID;
@property (nonatomic , assign) NSInteger              terminalID;
@property (nonatomic , assign) NSInteger              from;
@property (nonatomic , copy) NSString              * brandName;
@property (nonatomic , copy) NSString              * customerPhone;
@property (nonatomic , copy) NSString              * plateNumber;
@property (nonatomic , assign) NSInteger              brandID;



@end

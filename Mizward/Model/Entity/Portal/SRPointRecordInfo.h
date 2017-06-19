//
//  SRPointRecordInfo.h
//  Mizward
//
//  Created by zhangjunbo on 15/12/11.
//  Copyright © 2015年 Mizward. All rights reserved.
//

#import "SREntity.h"

typedef NS_ENUM(NSInteger, SRPointRecordType){
    SRPointRecordType_Add = 1,
    SRPointRecordType_Reduce = 2,
};

@interface SRPointRecordInfo : SREntity

@property (nonatomic, copy)     NSString    *createTime;//yyyy-MM-dd hh:mm:ss
@property (nonatomic, assign)   SRPointRecordType   updateType;
@property (nonatomic, assign)   NSInteger   pointUpdate;
@property (nonatomic, copy)     NSString    *typeStr;
@property (nonatomic, copy)     NSString    *remark;

- (NSDate *)createDate;

@end

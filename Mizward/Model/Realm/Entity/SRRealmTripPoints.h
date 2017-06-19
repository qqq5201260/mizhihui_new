//
//  SRRealmTripPoints.h
//  Mizward
//
//  Created by zhangjunbo on 15/9/1.
//  Copyright (c) 2015年 Mizward. All rights reserved.
//

#import <Realm/RLMObject.h>

@interface SRRealmTripPoints : RLMObject

@property   NSString *tripID;
@property   NSInteger vehicleID;
@property   NSString  *tripPointsStr;

- (instancetype)initWithTripID:(NSString *)tripID vehicleID:(NSInteger)vehicleID tripPoints:(NSArray *)tripPoints;
- (NSArray *)tripPoints;

@end

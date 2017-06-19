//
//  FZKBGetCarInfoHttpAction.h
//  Connector
//
//  Created by czl on 2017/4/18.
//  Copyright © 2017年 chinapke. All rights reserved.
//

#import <Connector/Connector.h>

@interface FZKBQueryTripListHttpAction : FZKHttpWork

- (void)queryTripListActionWithVehicleID:(NSString *)vehicleID input1:(NSString *)input1 input2:(NSString *)input2 pageIndex:(NSString *)pageIndex pageSize:(NSString *)pageSize startTime:(NSString *)startTime endTime:(NSString *)endTime;

@end

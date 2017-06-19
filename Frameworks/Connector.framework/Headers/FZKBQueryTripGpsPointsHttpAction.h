//
//  FZKBQueryTripGpsPointsHttpAction.h
//  Connector
//
//  Created by 宋搏 on 2017/5/4.
//  Copyright © 2017年 chinapke. All rights reserved.
//

#import <Connector/Connector.h>

@interface FZKBQueryTripGpsPointsHttpAction : FZKHttpWork

- (void)queryTripListActionWithTripID:(NSString *)tripID input1:(NSString *)input1 input2:(NSString *)input2 pageIndex:(NSString *)pageIndex pageSize:(NSString *)pageSize;



@end

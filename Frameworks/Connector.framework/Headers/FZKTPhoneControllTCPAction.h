//
//  FZKTPhoneControllTCPAction.h
//  Connector
//
//  Created by czl on 2017/5/11.
//  Copyright © 2017年 chinapke. All rights reserved.
//

#import "FZKBTCPWork.h"
#import "FZKEnum.h"


@interface FZKTPhoneControllTCPAction : FZKBTCPWork

/**
 汽车操作代码
 
 @param cmdID 操作码
 @param series 流水号
 @param vehicleID 汽车编号
 */
- (void)phoneControllActionWithCarId:(NSInteger)carId tag:(NSInteger)tag controlSeries:(NSInteger)controlSeries;

@end

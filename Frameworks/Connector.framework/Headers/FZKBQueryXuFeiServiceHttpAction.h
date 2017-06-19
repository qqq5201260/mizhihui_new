
//
//  FZKBQueryXuFeiServiceHttpAction.h
//
//
//  Created by mac on date.
//  Copyright © 2017年 chinapke. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FZKHttpWork.h"

@interface FZKBQueryXuFeiServiceHttpAction : FZKHttpWork
    
/**
 方法描述：
 续费查询（查询用户车辆是否欠费等）
 
 传入参数：

返回参数：
annualFee：一年需要费用
endDays：到期日期
endYearMon：到期年月（显示用的）
isWulianCard：1表示是物联卡，0表示不是物联卡
plateNumber：车牌号
surplusMonth：剩余月数（用来判断是否需要续费的标准）
vehicleID：车辆ID
resultCode：0表示成功

 */
- (void)queryXuFeiServiceAction;

@end
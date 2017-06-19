
//
//  FZKBQueryCarSeriesHttpAction.h
//
//
//  Created by mac on date.
//  Copyright © 2017年 chinapke. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FZKHttpWork.h"

@interface FZKBQueryCarSeriesHttpAction : FZKHttpWork
    
/**
 方法描述：
 查询车辆系列集合（比如奥迪车集合）
 
 传入参数：
brandID：车辆品牌ID（相当于查询品牌接口中的 entityID）

返回参数：
seriesFirstLetter：首字符（排序用的）
seriesID：系列ID（如奥迪是一个系列）
seriesName：系列名字
vehicleModelVOs：车辆实例
vehicleModelID：车辆实例ID
vehicleName：车辆名字
resultCode：0表示成功

 */
- (void)queryCarSeriesActionWithBrandID:(NSString *)brandID;

@end

//
//  FZKCUserDefaults.h
//  Connector
//
//  Created by 宋搏 on 2017/5/2.
//  Copyright © 2017年 chinapke. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FZKCUserDefaults : NSUserDefaults

//流水号
+ (NSInteger)serialNumber;




+(BOOL)isLogin;
+(void)updateLoginStatus:(BOOL)isLogin;

//当前车辆ID
+ (NSInteger)currentVehicleID;
+ (void)updateCurrentVehicleID:(NSInteger)vehicleID;

@end



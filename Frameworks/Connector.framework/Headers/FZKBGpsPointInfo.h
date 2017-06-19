//
//  FZKBGpsPointInfo.h
//  Connector
//
//  Created by 宋搏 on 2017/5/5.
//  Copyright © 2017年 chinapke. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface FZKBGpsPointInfo : NSObject

@property (nonatomic, assign) CGFloat direction;
@property (nonatomic, assign) CGFloat gpsspeed;
@property (nonatomic, assign) CGFloat lat;
@property (nonatomic, assign) CGFloat lng;
@property (nonatomic, assign) CGFloat obdspeed;
@property (nonatomic, strong) NSString * uTCTime;

@end

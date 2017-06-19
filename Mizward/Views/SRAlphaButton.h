//
//  SRAlphaButton.h
//  SiRuiV4.0
//
//  Created by zhangjunbo on 15/7/24.
//  Copyright (c) 2015年 SiRui. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SRAlphaButton : UIButton

/**
 *  忽略点击到了透明区域
 */
@property (nonatomic, assign) BOOL isIgnoreTouchInTransparentPoint;

@end

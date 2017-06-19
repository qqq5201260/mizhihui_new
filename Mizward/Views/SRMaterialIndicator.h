//
//  SRMaterialIndicator.h
//  Mizward
//
//  Created by zhangjunbo on 15/9/17.
//  Copyright © 2015年 Mizward. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SRMaterialIndicator : UIView

@property (nonatomic) CGFloat lineWidth;

@property (nonatomic) BOOL hidesWhenStopped;

/** Defaults to kCAMediaTimingFunctionEaseInEaseOut */
@property (nonatomic, strong) CAMediaTimingFunction *timingFunction;

@property (nonatomic, readonly) BOOL isAnimating;

- (void)setAnimating:(BOOL)animate;

- (void)startAnimating;

- (void)stopAnimating;


@end

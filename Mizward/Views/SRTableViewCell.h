//
//  SRTableViewCell.h
//  SiRuiV4.0
//
//  Created by zhangjunbo on 15/6/15.
//  Copyright (c) 2015年 SiRui. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SRTableViewCell : UITableViewCell

- (void)setNormalColor:(UIColor *)normalColor
      highlightedColor:(UIColor *)highlightedColor
      andSelectedColor:(UIColor *)selectedColor;

- (void)setFisrtCell:(BOOL)isFirstCell lastCell:(BOOL)isLastCell;

@end

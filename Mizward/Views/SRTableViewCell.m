//
//  SRTableViewCell.m
//  SiRuiV4.0
//
//  Created by zhangjunbo on 15/6/15.
//  Copyright (c) 2015年 SiRui. All rights reserved.
//

#import "SRTableViewCell.h"

@interface SRTableViewCell ()
{
    UIColor *_normalColor;
    UIColor *_selectedColor;
    UIColor *_highlightedColor;
    
    BOOL _isFirstCell;
    BOOL _isLastCell;
}

@end

@implementation SRTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [UIColor clearColor].CGColor);
    CGContextFillRect(context, rect);
    
    if (_isFirstCell) {
        //上分割线
        CGContextSetStrokeColorWithColor(context, [UIColor separatorColor].CGColor);
        CGContextStrokeRect(context, CGRectMake(0, -1, rect.size.width, 1));
    }
    
    if (_isLastCell) {
        //下分割线
        CGContextSetStrokeColorWithColor(context, [UIColor separatorColor].CGColor);
        CGContextStrokeRect(context, CGRectMake(0, rect.size.height, rect.size.width, 1));
    }
}

#pragma mark - Setter

- (void)setNormalColor:(UIColor *)normalColor
      highlightedColor:(UIColor *)highlightedColor
      andSelectedColor:(UIColor *)selectedColor
{
    
    _normalColor = normalColor;
    _selectedColor = selectedColor;
    _highlightedColor = highlightedColor;
}

- (void)setFisrtCell:(BOOL)isFirstCell lastCell:(BOOL)isLastCell
{
    _isFirstCell = isFirstCell;
    _isLastCell = isLastCell;
    
    [self setNeedsDisplay];
}

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wobjc-protocol-method-implementation"

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    if (selected && _selectedColor) {
        [self.contentView setBackgroundColor:_selectedColor];
    }else if (_normalColor){
        [self.contentView setBackgroundColor:_normalColor];
    }
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated
{
    [super setHighlighted:highlighted animated:animated];
    
    if (highlighted && _highlightedColor) {
        [self.contentView setBackgroundColor:_highlightedColor];
    }else if (_normalColor){
        [self.contentView setBackgroundColor:_normalColor];
    }
}


@end

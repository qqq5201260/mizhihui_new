//
//  SRIndexBar.h
//  SiRuiV4.0
//
//  Created by zhangjunbo on 15/6/15.
//  Copyright (c) 2015年 SiRui. All rights reserved.
//

#import "SRIndexBar.h"
#import <QuartzCore/QuartzCore.h>

@interface SRIndexBar ()

- (void)initializeDefaults;

@end

@implementation SRIndexBar

@synthesize delegate;
@synthesize highlightedBackgroundColor;
@synthesize textColor;

- (id)init {
    if ((self = [super init])) {
        [self initializeDefaults];
    }
    
    return self;
}

- (id)initWithFrame:(CGRect)frame  {
    if ((self = [super initWithFrame:frame]))  {
        [self initializeDefaults];
    }
    
    return self;
}

- (void)initializeDefaults {
    self.backgroundColor = [UIColor clearColor];
    self.textColor = [UIColor blackColor];
    self.highlightedBackgroundColor = [UIColor lightGrayColor];
    self.textFont = [UIFont fontWithName: @"HelveticaNeue-Bold" size: 11];
}

- (void)reloadTitles {
    [self setNeedsLayout];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    for (UIView *subview in self.subviews) {
        [subview removeFromSuperview];
    }
    
    if (!self.delegate || ![self.delegate respondsToSelector:@selector(indexBarTitles:)]) {
        return;
    }
    
    NSArray *titles = [self.delegate indexBarTitles:self];
    
    for (NSInteger i=0; i<[titles count]; i++) {
        float ypos;
        
        if(i == 0) {
            ypos = 0;
        } else if(i == [titles count]-1) {
            ypos = self.frame.size.height-24.0;
        } else {
            float sectionheight = ((self.frame.size.height-24.0)/[titles count]);
            sectionheight = sectionheight+(sectionheight/[titles count]);
            
            ypos = (sectionheight*i);
        }
        
        UILabel *alphaLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, ypos, self.frame.size.width, 24.0)];
        alphaLabel.textAlignment = NSTextAlignmentCenter;
        alphaLabel.text = [titles objectAtIndex:i];
        alphaLabel.font = self.textFont;
        alphaLabel.backgroundColor = [UIColor clearColor];
        alphaLabel.textColor = textColor;
        [self addSubview:alphaLabel];
    }
    
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesEnded:touches withEvent:event];
    [self touchesEndedOrCancelled:touches withEvent:event];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesCancelled:touches withEvent:event];
    [self touchesEndedOrCancelled:touches withEvent:event];
}

- (void) touchesEndedOrCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    UIView *backgroundView = (UIView*)[self viewWithTag:767];
    [backgroundView removeFromSuperview];
    
    if (self.delegate&&[self.delegate respondsToSelector:@selector(indexBarTouchesEnd:)]) {
        [self.delegate indexBarTouchesEnd:self];
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    
    if (self.delegate&&[self.delegate respondsToSelector:@selector(indexBarTouchesBegan:)]) {
        [self.delegate indexBarTouchesBegan:self];
    }
    
    UIView *backgroundview = [[UIView alloc] initWithFrame:CGRectMake(0,0, self.bounds.size.width, self.bounds.size.height)];
    [backgroundview setBackgroundColor:highlightedBackgroundColor];
    backgroundview.layer.cornerRadius = self.bounds.size.width/2;
    backgroundview.layer.masksToBounds = YES;
    backgroundview.tag = 767;
    [self addSubview:backgroundview];
    [self sendSubviewToBack:backgroundview];
    
    if (!self.delegate) return;
    
    CGPoint touchPoint = [[[event touchesForView:self] anyObject] locationInView:self];
    
    if(touchPoint.x < 0) {
        return;
    }
    
    NSString *title = nil;
    int count=0;
    
    for (UILabel *subview in self.subviews) {
        if ([subview isKindOfClass:[UILabel class]]) {
            if(touchPoint.y < subview.frame.origin.y+subview.frame.size.height) {
                count++;
                title = subview.text;
                break;
            }
            
            count++;
            title = subview.text;
        }
    }
    
    if ([delegate respondsToSelector: @selector(indexSelectionDidChange:index:title:)])
        [delegate indexSelectionDidChange: self index: count - 1 title: title];
}


- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesMoved:touches withEvent:event];
    
    if (!self.delegate) return;
    
    CGPoint touchPoint = [[[event touchesForView:self] anyObject] locationInView:self];
    
    if(touchPoint.x < 0) {
        return;
    }
    
    NSString *title = nil;
    int count=0;
    
    for (UILabel *subview in self.subviews) {
        if ([subview isKindOfClass:[UILabel class]]) {
            if(touchPoint.y < subview.frame.origin.y+subview.frame.size.height) {
                count++;
                title = subview.text;
                break;
            }
            
            count++;
            title = subview.text;
        }
    }
    
    if ([delegate respondsToSelector: @selector(indexSelectionDidChange:index:title:)])
        [delegate indexSelectionDidChange: self index: count - 1 title: title];
}


@end

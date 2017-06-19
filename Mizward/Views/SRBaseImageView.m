//
//  SRBaseImageView.m
//  Mizward
//
//  Created by zhangjunbo on 15/8/11.
//  Copyright (c) 2015年 Mizward. All rights reserved.
//

#import "SRBaseImageView.h"
#import <pop/POP.h>

@implementation SRBaseImageView
{
    NSInteger index;
}

- (void)startAnimations {
    [self pop_removeAllAnimations];
    POPBasicAnimation *anim = [POPBasicAnimation linearAnimation];
    anim.duration = 2.0f;
    POPAnimatableProperty *prop = [POPAnimatableProperty propertyWithName:@"index" initializer:^(POPMutableAnimatableProperty *prop) {
        prop.writeBlock = ^(UIImageView *obj, const CGFloat values[]) {
            NSInteger pre = self->index;
            self->index = values[0];
            if (pre == self->index || self->index > 47) {
                return ;
            }
            @autoreleasepool {
                NSString *path = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"quan_%05zd", self->index] ofType:@"png"];
                UIImage *image = [UIImage imageWithContentsOfFile:path];
                obj.image = image;
                
            }
        };
    }];
    anim.property = prop;
    anim.completionBlock = ^(POPAnimation *anim, BOOL finished){
        
    };
    anim.fromValue = @(0.0f);
    anim.toValue = @(48.0f);
    anim.repeatForever = YES;
    
    [self pop_addAnimation:anim forKey:@"BaseAnimation"];
}

- (void)stopAnimations {
    [self pop_removeAllAnimations];
}

@end

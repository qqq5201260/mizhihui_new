//
//  SREngineStartImageView.m
//  Mizward
//
//  Created by zhangjunbo on 15/8/11.
//  Copyright (c) 2015年 Mizward. All rights reserved.
//

#import "SREngineStartImageView.h"
#import <pop/POP.h>

const NSInteger maxLength = 10;
const NSInteger maxPics = 72;

@interface SREngineStartImageView ()

@property (nonatomic, strong) NSMutableArray *imagesList1; //10张
@property (nonatomic, strong) NSMutableArray *imagesList2; //10张

@end

@implementation SREngineStartImageView
{
    NSInteger index;
}

- (void)startAnimations {
    [self pop_removeAllAnimations];
    POPBasicAnimation *anim = [POPBasicAnimation linearAnimation];
    anim.duration = 4.0f;
    POPAnimatableProperty *prop = [POPAnimatableProperty propertyWithName:@"index" initializer:^(POPMutableAnimatableProperty *prop) {
        prop.writeBlock = ^(UIImageView *obj, const CGFloat values[]) {
            
            NSInteger pre = self->index;
            self->index = values[0];
//            NSLog(@"%f, %zd", values[0], self->index);
            if (pre == self->index || self->index >= maxPics) {
                return ;
            }
            
//            NSLog(@"read -------------------------- %zd", self->index);
            
            @autoreleasepool {
//                NSString *path = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"st%02zd", self->index] ofType:@"png"];
                NSString *path = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"st ani_%05zd", self->index] ofType:@"png"];
                UIImage *image = [UIImage imageWithContentsOfFile:path];
                obj.image = image;
                
            }
        };
    }];
    anim.property = prop;
    anim.completionBlock = ^(POPAnimation *anim, BOOL finished){
        
    };
    anim.fromValue = @(0.0f);
    anim.toValue = @(72.0f);
    anim.repeatForever = YES;
    
    [self pop_addAnimation:anim forKey:@"EngineStartAnimation"];
}

- (void)stopAnimations {
    [self pop_removeAllAnimations];
}

#pragma mark - Preload

//- (void)preloadImages {
//    
//    if (index%maxLength != 0) return;
//    
//    @autoreleasepool {
//        NSMutableArray *array = [NSMutableArray array];
//        for (NSInteger temp = index; temp<MIN(index+maxLength, maxPics); ++temp) {
//            [array addObject:[self imageFromFileWithIndex:temp]];
//        }
//        if (!isInited) {
//            isInited = YES;
//            self.imagesList1 = array;
//            NSLog(@"1----->preloadImages %zd - %zd", index, MIN(index+maxLength, maxPics));
//        } else if ((index/maxLength)%2 == 0) {
//            self.imagesList2 = array;
//            NSLog(@"2----->preloadImages %zd - %zd", index, MIN(index+maxLength, maxPics));
//        } else {
//            self.imagesList1 = array;
//            NSLog(@"1----->preloadImages %zd - %zd", index, MIN(index+maxLength, maxPics));
//        }
//    }
//}
//
//- (UIImage *)imageFromFileWithIndex:(NSInteger)idx {
//    NSString *path = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"st%02zd", idx] ofType:@"png"];
//    return [UIImage imageWithContentsOfFile:path];
//}
//
//- (UIImage *)imageWithIndex:(NSInteger)idx {
//    if ((idx/maxLength)%2 == 0 && idx%maxLength<self.imagesList1.count) {
//        //list1
//        NSLog(@"1<-------read %zd ", index);
//        return self.imagesList1[idx%maxLength];
//    } else if (idx%maxLength<self.imagesList2.count) {
//        //list2
//        NSLog(@"2<-------read %zd ", index);
//        return self.imagesList2[idx%maxLength];
//    } else {
//        return nil;
//    }
//}

@end

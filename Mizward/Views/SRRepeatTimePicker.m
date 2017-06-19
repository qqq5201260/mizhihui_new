//
//  SRRepeatTimePicker.m
//  SiRui
//
//  Created by zhangjunbo on 15/5/18.
//  Copyright (c) 2015年 ChinaPKE. All rights reserved.
//

#import "SRRepeatTimePicker.h"

@interface SRRepeatTimePicker ()

@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *buttons;

@property (nonatomic, copy) SRRepeatTimePickerDoneBlock doneBlock;
@property (nonatomic, copy) SRRepeatTimePickerCancelBlock cancelBlock;

@property (nonatomic, strong) NSMutableArray *selectedTag;
@property (nonatomic, copy) NSString *selectedString;

@end

@implementation SRRepeatTimePicker

+ (SRRepeatTimePicker *)instanceRepeatTimePicker {
    return [[[NSBundle mainBundle] loadNibNamed:@"SRRepeatTimePicker" owner:self options:nil] objectAtIndex:0];
}

- (void)dealloc {
    self.selectedTag = nil;
}

- (void)awakeFromNib {
    for (UIButton *button in self.buttons) {
        button.layer.borderColor = [UIColor lightGrayColor].CGColor;
        button.layer.borderWidth = 1.0f;
        button.layer.cornerRadius = 5.0f;
        
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        [button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        button.backgroundColor = [UIColor whiteColor];
    }
}

- (void)setRepeatString:(NSString *)repeatString {
    _repeatString = repeatString;
    if (_repeatString && _repeatString.length == 7) {
        for (NSInteger index = 0; index < _repeatString.length; index++) {
            NSString *sub = [_repeatString substringWithRange:NSMakeRange(index, 1)];
            
            if (!sub.boolValue) continue;
            
            NSInteger tag = 100 + index;
            UIButton *button = (UIButton *)[self viewWithTag:tag];
            [self buttonPressed:button];
        }
    }
}

- (IBAction)buttonPressed:(UIButton *)sender {
    sender.selected ^= 1;
    sender.backgroundColor = sender.selected?[UIColor colorWithRed:42.0/255.0 green:95.0/255.0 blue:130.0/255.0 alpha:1.0]:[UIColor whiteColor];
    sender.layer.borderColor = sender.selected?[UIColor colorWithRed:21.0/255.0 green:79.0/255.0 blue:120.0/255.0 alpha:1.0].CGColor:[UIColor lightGrayColor].CGColor;
    
    if (!self.selectedTag) {
        self.selectedTag = [NSMutableArray array];
    }
    
    if (!self.selectedString) {
        self.selectedString = @"0000000";
    }
    
    if (sender.selected) {
        [self.selectedTag addObject:@(sender.tag)];
        self.selectedString = [self.selectedString stringByReplacingCharactersInRange:NSMakeRange(sender.tag-100, 1) withString:@"1"];
    } else {
        [self.selectedTag removeObject:@(sender.tag)];
        self.selectedString = [self.selectedString stringByReplacingCharactersInRange:NSMakeRange(sender.tag-100, 1) withString:@"0"];
    }
}

- (IBAction)cancelButtonPressed:(id)sender {
    if (self.cancelBlock) {
        self.cancelBlock();
    }
}

- (IBAction)doneButtonPressed:(id)sender {
    
    if (!self.selectedString) {
        self.selectedString = @"0000000";
    }
    
    NSMutableArray *array;
    if (self.selectedTag) {
        [self.selectedTag sortUsingComparator:^NSComparisonResult(NSNumber *obj1, NSNumber *obj2) {
            return [obj1 compare:obj2] == NSOrderedDescending;
        }];
        
        array = [NSMutableArray arrayWithCapacity:self.selectedTag.count];
        [self.selectedTag enumerateObjectsUsingBlock:^(NSNumber *obj, NSUInteger idx, BOOL *stop) {
            UIButton *button = (UIButton *)[self viewWithTag:obj.integerValue];
            [array insertObject:[[button titleForState:UIControlStateNormal] stringByReplacingOccurrencesOfString:@"星期" withString:@"周"] atIndex:idx];
        }];
    }

    if (self.doneBlock) {
        self.doneBlock(array, self.selectedString);
    }
}

@end

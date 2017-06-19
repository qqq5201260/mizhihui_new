//
//  SRMaintainHistoryCell.m
//  SiRuiV4.0
//
//  Created by zhangjunbo on 15/7/20.
//  Copyright (c) 2015年 SiRui. All rights reserved.
//

#import "SRMaintainHistoryCell.h"
#import "SRMaintainHistory.h"

@interface SRMaintainHistoryCell ()
@property (weak, nonatomic) IBOutlet UILabel *lb_title;
@property (weak, nonatomic) IBOutlet UITextField *lb_time;
@property (weak, nonatomic) IBOutlet UITextField *lb_store;

@end

@implementation SRMaintainHistoryCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    UIImageView *padding1 = [[UIImageView  alloc] initWithImage:[UIImage imageNamed:@"ic_maintain_history_time"]];
    padding1.contentMode = UIViewContentModeCenter;
    padding1.frame = CGRectMake(0, 0, self.lb_time.height, self.lb_time.height);
    self.lb_time.leftView = padding1;
    self.lb_time.leftViewMode = UITextFieldViewModeAlways;
    
    UIImageView *padding2 = [[UIImageView  alloc] initWithImage:[UIImage imageNamed:@"ic_maintain_history_location"]];
    padding2.contentMode = UIViewContentModeCenter;
    padding2.frame = CGRectMake(0, 0, self.lb_store.height, self.lb_store.height);
    self.lb_store.leftView = padding2;
    self.lb_store.leftViewMode = UITextFieldViewModeAlways;
    
    self.imageView.image = [UIImage imageNamed:@"ic_maintain_history"];
}

#pragma mark - Setter

- (void)setHistory:(SRMaintainHistory *)history {
    _history = history;
    
    self.lb_title.text = [NSString stringWithFormat:@"保养里程    %.1fkm", history.currentMileage];
    self.lb_time.text = [[NSDate convertDateFromStringWithFormatYYYYMMddHHmm:history.startTimeStr] stringOfDateWithFormatMMddChinese];
    self.lb_store.text = history.depName;
}

@end

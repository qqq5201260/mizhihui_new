//
//  SRMaintainStoreCell.m
//  SiRuiV4.0
//
//  Created by zhangjunbo on 15/7/20.
//  Copyright (c) 2015年 SiRui. All rights reserved.
//

#import "SRMaintainStoreCell.h"
#import "SRMaintainDepInfo.h"
#import "SRPortal.h"
#import "SRCustomer.h"

@interface SRMaintainStoreCell ()
@property (weak, nonatomic) IBOutlet UILabel *lb_store;
@property (weak, nonatomic) IBOutlet UILabel *lb_address;
@property (weak, nonatomic) IBOutlet UILabel *lb_phone;
@property (weak, nonatomic) IBOutlet UILabel *lb_mileage;

@end

@implementation SRMaintainStoreCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    NSString *icName = [NSString stringWithFormat:@"ic_maintain_stroe_%zd", arc4random()%5];
    self.imageView.image = [UIImage imageNamed:icName];
}

#pragma mark - Public 

- (void)setDefault
{
    UIView *top = [[UIView alloc] initWithFrame:CGRectZero];
    top.backgroundColor = [UIColor defaultColor];
    top.alpha = 0.35f;
    top.tag = 1000;
    [self.contentView addSubview:top];
    [top makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self);
        make.height.equalTo(1.0f);
    }];
    UIView *bottom = [[UIView alloc] initWithFrame:CGRectZero];
    bottom.backgroundColor = [UIColor defaultColor];
    bottom.alpha = 0.35f;
    bottom.tag = 1001;
    [self.contentView addSubview:bottom];
    [bottom makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self);
        make.height.equalTo(1.0f);
    }];
    self.imageView.image = [UIImage imageNamed:@"ic_maintain_stroe_0"];
}

#pragma mark - Setter

- (void)setDepInfo:(SRMaintainDepInfo *)depInfo {
    _depInfo = depInfo;
    self.lb_store.text = depInfo.name;
    self.lb_address.text = depInfo.address;
    self.lb_phone.text = depInfo.phone;
    
    if (depInfo.distance < 10000) {
        self.lb_mileage.text = [NSString stringWithFormat:@"%.1fm", depInfo.distance];
    } else if (depInfo.distance/1000 < 10000) {
        self.lb_mileage.text = [NSString stringWithFormat:@"%.1fkm", depInfo.distance/1000];
    } else {
        self.lb_mileage.text = [NSString stringWithFormat:@"%.1f万km", depInfo.distance/(1000*10000)];
    }
    
    if (depInfo.depID == [SRPortal sharedInterface].customer.depID) {
        [self setDefault];
    } else {
        [[self.contentView viewWithTag:1000] removeFromSuperview];
        [[self.contentView viewWithTag:1001] removeFromSuperview];
    }
}

@end

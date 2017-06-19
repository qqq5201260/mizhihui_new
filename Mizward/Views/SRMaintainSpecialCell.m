//
//  SRMaintainSpecialCell.m
//  SiRuiV4.0
//
//  Created by zhangjunbo on 15/7/18.
//  Copyright (c) 2015年 SiRui. All rights reserved.
//

#import "SRMaintainSpecialCell.h"
#import "SRMaintainSpecialProgress.h"
#import "SRMaintainUncommonItem.h"
#import "SRPortal.h"
#import "SRVehicleBasicInfo.h"
#import "SRVehicleStatusInfo.h"

@interface SRMaintainSpecialCell ()

@property (weak, nonatomic) IBOutlet SRMaintainSpecialProgress *progressView;
@property (weak, nonatomic) IBOutlet UILabel *lb_mileage;

@property (strong, nonatomic) NSDictionary *specialMaintainIconDic;
@property (strong, nonatomic) NSDictionary *specialMaintainTitleDic;

@end

@implementation SRMaintainSpecialCell

- (void)awakeFromNib {
    // Initialization code
    
    self.textLabel.font = [UIFont systemFontOfSize:13.0f];
    self.textLabel.textColor = [UIColor lightGrayColor];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - Setter

- (void)setUncommonItem:(SRMaintainUncommonItem *)uncommonItem
{
    _uncommonItem = uncommonItem;
    self.imageView.image = [UIImage imageNamed:self.specialMaintainIconDic[@(uncommonItem.specialType)]];
    self.textLabel.text = uncommonItem.name;
    self.textLabel.backgroundColor = [UIColor clearColor];
    
    SRVehicleStatusInfo *status = [SRPortal sharedInterface].currentVehicleBasicInfo.status;
    CGFloat restMileage = (uncommonItem.nextMileage - status.mileAge);
    CGFloat progress = (status.mileAge - uncommonItem.lastMileage)/uncommonItem.intervalMile;
    self.lb_mileage.text = [NSString stringWithFormat:@"剩%zdkm", restMileage>0?(NSInteger)restMileage:0];
    self.progressView.progress = progress;
}

#pragma mark - Getter

- (NSDictionary *)specialMaintainIconDic {
    if (_specialMaintainIconDic) {
        return _specialMaintainIconDic;
    }
    
    _specialMaintainIconDic = @{@(SRMaintainSpecialType_Tire)   :   @"ic_maintain_tire",
                                @(SRMaintainSpecialType_Brake)  :   @"ic_maintain_brake",
                                @(SRMaintainSpecialType_Battery):   @"ic_maintain_battery",
                                @(SRMaintainSpecialType_Wiper)  :   @"ic_maintain_wiper"};
    return _specialMaintainIconDic;
}

@end

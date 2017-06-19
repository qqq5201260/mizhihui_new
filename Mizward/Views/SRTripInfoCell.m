//
//  SRTripInfoCell.m
//  SiRuiV4.0
//
//  Created by zhangjunbo on 15/7/10.
//  Copyright (c) 2015年 SiRui. All rights reserved.
//

#import "SRTripInfoCell.h"
#import "SRDivideLine.h"
#import "SRTripInfo.h"
#import "SRPortal.h"
#import "SRVehicleBasicInfo.h"
#import <DateTools/DateTools.h>

@interface SRTripInfoCell ()
@property (weak, nonatomic) IBOutlet UILabel *lb_time;
@property (weak, nonatomic) IBOutlet UILabel *lb_timeLengh;
@property (weak, nonatomic) IBOutlet UILabel *lb_mileage;

@end

@implementation SRTripInfoCell

- (void)setTripInfo:(SRTripInfo *)tripInfo
{
    _tripInfo = tripInfo;
    
    NSString *time = [NSString stringWithFormat:@"%@\n%@", [tripInfo.startTime substringWithRange:NSMakeRange(11, 5)], [tripInfo.endTime substringWithRange:NSMakeRange(11, 5)]];
    self.lb_time.text = time;
    
    NSDate *startTime = [NSDate convertDateFromStringWithFormatYYYYMMddHHmmss:tripInfo.startTime];
    NSDate *endTime = [NSDate convertDateFromStringWithFormatYYYYMMddHHmmss:tripInfo.endTime];
    NSInteger seconds = [endTime secondsLaterThan:startTime];
    NSInteger iHour = seconds/3600;
    NSInteger iMin = (seconds-iHour*3600)/60;
    NSInteger iSen = seconds-iHour*3600-iMin*60;
    NSString *timeLengh = [NSString stringWithFormat:@"行驶时间\n%@:%@:%@", @(iHour), @(iMin), @(iSen)];
    self.lb_timeLengh.text = timeLengh;
    
    BOOL hasOBDModule = [SRPortal sharedInterface].currentVehicleBasicInfo.hasOBDModule;
    
    NSString *mileage = tripInfo.mileage>1?[NSString stringWithFormat:@"行驶距离\n%.1fkm", tripInfo.mileage]:[NSString stringWithFormat:@"行驶距离\n%zdm", (NSInteger)(tripInfo.mileage*1000)];
    self.lb_mileage.text = hasOBDModule?mileage:@"--";
}

- (void)setFisrtCell:(BOOL)isFirstCell lastCell:(BOOL)isLastCell
{
    [super setFisrtCell:isFirstCell lastCell:isLastCell];

    self.imageView.image = [UIImage imageNamed:@"ic_trip_car"];
    
    SRDivideLine *line = (SRDivideLine *)[self.contentView viewWithTag:100];
    if (!line) {
        line = [[SRDivideLine alloc] initWithFrame:CGRectZero];
        line.tag = 100;
        [self.contentView insertSubview:line belowSubview:self.imageView];
        [line makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.equalTo(self.contentView);
            make.centerX.equalTo(self.imageView);
            make.width.equalTo(2.0f);
        }];
    }
    
    if (isFirstCell && isLastCell) {
        line.hidden = YES;
    } else {
        line.hidden = NO;
        
        CGFloat topOffset = isFirstCell?self.height/2:0.0f;
        CGFloat bottomOffset = isLastCell?-self.height/2:0.0f;
        
        [line remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView).with.offset(topOffset);
            make.bottom.equalTo(self.contentView).with.offset(bottomOffset);
            make.centerX.equalTo(self.imageView);
            make.width.equalTo(2.0f);
        }];
        [line setNeedsDisplay];
    }
}

@end

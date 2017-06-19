//
//  SRMessageCell.m
//  SiRuiV4.0
//
//  Created by zhangjunbo on 15/7/13.
//  Copyright (c) 2015年 SiRui. All rights reserved.
//

#import "SRMessageCell.h"
#import "SRMessageInfo.h"

UIImage * imageForMessageSubType(SRMessageSubType subType) {
    static NSDictionary *dic;
    if (!dic) {
        dic = @{@(SRMessageSubType_Alert_Alert):@"ic_message_Alert",
                @(SRMessageSubType_Alert_CarTrouble):@"ic_message_CarTrouble",
                @(SRMessageSubType_Alert_OverSpeed):@"ic_message_OverSpeed",
                @(SRMessageSubType_Alert_LowElectric):@"ic_message_LowElectric",
                @(SRMessageSubType_Alert_PowerOff):@"ic_message_PowerOff",
                @(SRMessageSubType_Alert_CarCrash):@"ic_message_CarCrash",
                @(SRMessageSubType_Alert_TerminalToken):@"ic_message_TerminalToken",
                @(SRMessageSubType_Alert_DoorWindowNotClose):@"ic_message_DoorWindowNotClose",
                @(SRMessageSubType_Alert_BigLightNotClose):@"ic_message_BigLightNotClose",
                
                @(SRMessageSubType_Remind_EngineOn):@"ic_message_EngineOn",
                @(SRMessageSubType_Remind_ServiceExpire):@"ic_message_ServiceExpire",
                @(SRMessageSubType_Remind_PasswordChange):@"ic_message_PasswordChange",
                @(SRMessageSubType_Remind_OrderStart):@"ic_message_OrderStart",
                @(SRMessageSubType_Remind_CustomerDelete):@"ic_message_CustomerDelete",
                @(SRMessageSubType_Remind_MaintainSuccess):@"ic_message_Unknown",
                @(SRMessageSubType_Remind_MaintainRemind):@"ic_message_Unknown",
                
                @(SRMessageSubType_Function_OrderStartRecommend):@"ic_message_OrderStartRecommend",
                @(SRMessageSubType_Unknown):@"ic_message_Unknown"};
    }
    
    if (dic[@(subType)]) {
        return [UIImage imageNamed:dic[@(subType)]];
    } else {
        return [UIImage imageNamed:@"ic_message_Unknown"];
    }
}

static inline NSString * titleForMessageSubType(SRMessageSubType subType) {
    static NSDictionary *dic;
    if (!dic) {
        dic = @{@(SRMessageSubType_Alert_Alert):@"告警",
                @(SRMessageSubType_Alert_CarTrouble):@"车辆故障",
                @(SRMessageSubType_Alert_OverSpeed):@"车辆超速",
                @(SRMessageSubType_Alert_LowElectric):@"低电压",
                @(SRMessageSubType_Alert_PowerOff):@"断电",
                @(SRMessageSubType_Alert_CarCrash):@"碰撞告警",
                @(SRMessageSubType_Alert_TerminalToken):@"设备被拆",
                @(SRMessageSubType_Alert_DoorWindowNotClose):@"未关门窗",
                @(SRMessageSubType_Alert_BigLightNotClose):@"大灯未关",
                
                @(SRMessageSubType_Remind_EngineOn):@"点火启动",
                @(SRMessageSubType_Remind_ServiceExpire):@"服务费到期",
                @(SRMessageSubType_Remind_PasswordChange):@"修改密码",
                @(SRMessageSubType_Remind_OrderStart):@"预约启动",
                @(SRMessageSubType_Remind_CustomerDelete):@"客户被删",
                @(SRMessageSubType_Remind_MaintainSuccess):@"预约保养",
                @(SRMessageSubType_Remind_MaintainRemind):@"预约保养",
                
                @(SRMessageSubType_Function_OrderStartRecommend):@"预约启动功能推荐",
                @(SRMessageSubType_Unknown):@"其他"};
    }
    
    if (dic[@(subType)]) {
        return dic[@(subType)];
    } else {
        return @"其它";
    }
}


@interface SRMessageCell ()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lb_title_leading;
@property (weak, nonatomic) IBOutlet UILabel *lb_title;
@property (weak, nonatomic) IBOutlet UILabel *lb_time;
@property (weak, nonatomic) IBOutlet UILabel *lb_message;

@end

@implementation SRMessageCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    // Fix the bug in iOS7 - initial constraints warning
//    self.contentView.bounds = [UIScreen mainScreen].bounds;
    self.lb_title_leading.constant *= iPhoneScale;
}

- (void)setInfo:(SRMessageInfo *)info
{
    _info = info;
    
    self.imageView.image = imageForMessageSubType(info.msgtype);
    
    self.lb_title.text = titleForMessageSubType(info.msgtype);
    self.lb_time.text = [info.time substringToIndex:16];
//    self.lb_message.text = [NSString stringWithFormat:@"%@   ", info.message];
    self.lb_message.text = [info.message stringByAppendingString:@"  "];
//    self.lb_message.text = @"fdasfdsafdsafdsafdsafdsafdsafdsafdsafdsafdsafdsafadsfdsafdsaffafdasfadsfasdfadsfasfads";
}

@end

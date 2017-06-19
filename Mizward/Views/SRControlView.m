//
//  SRControlView.m
//  SiRuiV4.0
//
//  Created by zhangjunbo on 15/7/24.
//  Copyright (c) 2015年 SiRui. All rights reserved.
//

#import "SRControlView.h"
#import "SRAlphaButton.h"
#import "SRTLV.h"
#import "SRUserDefaults.h"
#import "SRUIUtil.h"
#import "SRPortal.h"
#import "SRPhoneApp.h"
#import "SRVehicleBasicInfo.h"
#import "SRCustomer.h"
#import "SRControlAlert.h"
#import "SREventCenter.h"
#import "SRVehicleStatusInfo.h"
#import "SRSoundPlayer.h"
#import <pop/POP.h>

const CGFloat defaultShowCenterY = -34.0f;
const CGFloat defaultDismissCenterY = 100.0f;
const CGFloat defaultWithoutWindowTopPadding = 30.0f;

static CFTimeInterval notNeedPwdTime;//免密控制操作时间

@interface SRControlView ()
@property (weak, nonatomic) IBOutlet UIImageView *bg_control_mask;

@property (weak, nonatomic) IBOutlet SRAlphaButton *bt_window_open;
@property (weak, nonatomic) IBOutlet SRAlphaButton *bt_window_close;
@property (weak, nonatomic) IBOutlet SRAlphaButton *bt_skylight_open;
@property (weak, nonatomic) IBOutlet SRAlphaButton *bt_skylight_close;
@property (weak, nonatomic) IBOutlet SRAlphaButton *bt_lock;
@property (weak, nonatomic) IBOutlet SRAlphaButton *bt_unlock;
@property (weak, nonatomic) IBOutlet SRAlphaButton *bt_engine_off;

@property (weak, nonatomic) IBOutlet SRAlphaButton *bt_lock_1;
@property (weak, nonatomic) IBOutlet SRAlphaButton *bt_unlock_1;
@property (weak, nonatomic) IBOutlet SRAlphaButton *bt_engine_off_1;

//降窗top缩放
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bt_window_open_top;

@property (assign, nonatomic) BOOL hasWindow;

@end

@implementation SRControlView
{
    BOOL isControlMaskAnimating;
    BOOL isControlMaskShowing;
    
    CGFloat showCenterY;
    CGFloat dismissCenterY;
    CGFloat withoutWindowTopPadding;
    
    CGFloat newWidth;
    CGFloat newHeight;
}

+ (SRControlView *)instanceControlView
{
    NSArray *nibView = [[NSBundle mainBundle] loadNibNamed:@"SRControlView" owner:nil options:nil];
    return [nibView objectAtIndex:0];
}

- (void)dealloc {
    [self bk_removeAllBlockObservers];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.backgroundColor = [UIColor clearColor];
    
    showCenterY = defaultShowCenterY * iPhoneScale;
    dismissCenterY = defaultDismissCenterY * iPhoneScale;
    withoutWindowTopPadding = defaultWithoutWindowTopPadding * iPhoneScale;
    
    self.bt_window_open_top.constant *= iPhoneScale;

    newWidth = SCREEN_WIDTH;
    newHeight = self.height*newWidth/self.width;
    self.width = newWidth;
    self.height = newHeight;
    
    [self.bt_window_open setImage:[UIImage imageNamed:@"bt_window_open_disable"]
                         forState:UIControlStateDisabled];
    
    [self.bt_window_close setImage:[UIImage imageNamed:@"bt_window_close_disable"]
                          forState:UIControlStateDisabled];
    
    [self.bt_skylight_open setImage:[UIImage imageNamed:@"bt_skylight_open_disable"]
                           forState:UIControlStateDisabled];
    
    [self.bt_skylight_close setImage:[UIImage imageNamed:@"bt_skylight_close_disable"]
                            forState:UIControlStateDisabled];
    
    [self.bt_lock setImage:[UIImage imageNamed:@"bt_lock_disable"]
                            forState:UIControlStateDisabled];
    
    [self.bt_unlock setImage:[UIImage imageNamed:@"bt_unlock_disable"]
                    forState:UIControlStateDisabled];
    
    [self.bt_engine_off setImage:[UIImage imageNamed:@"bt_engine_off_disable"]
                        forState:UIControlStateDisabled];
    
    [self.bt_lock_1 setImage:[UIImage imageNamed:@"bt_lock_disable_1"] forState:UIControlStateDisabled];
    [self.bt_unlock_1 setImage:[UIImage imageNamed:@"bt_unlock_disable_1"] forState:UIControlStateDisabled];
    [self.bt_engine_off_1 setImage:[UIImage imageNamed:@"bt_engine_off_disable_1"] forState:UIControlStateDisabled];
    
    [self bk_addObserverForKeyPath:@"hasWindow" options:NSKeyValueObservingOptionNew task:^(id obj, NSDictionary *change) {
        [self updateControlBackground];
    }];
    
    self.hasWindow = YES;
}

#pragma mark - 交互操作

- (IBAction)swipGestureRecognizerHandler:(id)sender {
    [self showOrDismissControlView:NO animation:YES];
}

- (IBAction)buttonLockPressed:(id)sender {
    [self SendCmd:TLVTag_Instruction_Lock withSuccessBlock:nil];
}

- (IBAction)buttonUnlockPressed:(id)sender {
    [self SendCmd:TLVTag_Instruction_Unlock withSuccessBlock:nil];
}

- (IBAction)buttonEngineOffPressed:(id)sender {
    [self SendCmd:TLVTag_Instruction_EngineOff withSuccessBlock:nil];
}

- (IBAction)buttonWIndowOpenPressed:(id)sender {
    [self SendCmd:TLVTag_Instruction_WindowOpen withSuccessBlock:nil];
}

- (IBAction)buttonWindowClosePressed:(id)sender {
    [self SendCmd:TLVTag_Instruction_WindowClose withSuccessBlock:nil];
}

- (IBAction)buttonSkylightOpenPressed:(id)sender {
    [self SendCmd:TLVTag_Instruction_SkyOpen withSuccessBlock:nil];
}

- (IBAction)buttonSkylightClosePressed:(id)sender {
    [self SendCmd:TLVTag_Instruction_SkyClose withSuccessBlock:nil];
}

#pragma mark - Public

- (void)showOrDismissControlView:(BOOL)isShow animation:(BOOL)animation {
    
    if (isControlMaskAnimating
        || (isShow && isControlMaskShowing)
        || (!isShow && !isControlMaskShowing)) {
        return;
    }

    CGFloat startPosition = isShow?dismissCenterY:showCenterY;
    CGFloat endPosition = isShow?showCenterY:dismissCenterY;
    
    isControlMaskAnimating = YES;
    POPBasicAnimation *anim = [POPBasicAnimation easeInEaseOutAnimation];
    anim.duration = animation?0.35f:0.0f;
    POPAnimatableProperty *prop = [POPAnimatableProperty propertyWithName:@"CenterY" initializer:^(POPMutableAnimatableProperty *prop) {
        prop.writeBlock = ^(id obj, const CGFloat values[]) {
            self.hidden = NO;
            [self updateControlViewYPosition:values[0]];
        };
    }];
    anim.property = prop;
    anim.completionBlock = ^(POPAnimation *anim, BOOL finished){
        self->isControlMaskAnimating = NO;
        self->isControlMaskShowing = isShow;
        self.hidden = !isShow;
        [self updateControlViewYPosition:endPosition];
    };
    anim.fromValue = @(startPosition);
    anim.toValue = @(endPosition);
    
    [self pop_addAnimation:anim forKey:@"ControlAnimation"];
}

- (void)updateAbilities:(NSArray *)abilities
{
    __block BOOL hasWindow = NO;
    [abilities enumerateObjectsUsingBlock:^(SRTLV *obj, NSUInteger idx, BOOL *stop) {
        SRControlAbilityType ability = obj.value.integerValue;
        switch (obj.tag) {
            case TLVTag_Ability_Lock:
                self.bt_lock.hidden = ability == SRControlAbilityType_Unsupport;
                self.bt_lock.enabled = ability == SRControlAbilityType_Support;
                self.bt_lock_1.hidden = ability == SRControlAbilityType_Unsupport;
                self.bt_lock_1.enabled = ability == SRControlAbilityType_Support;
                break;
            case TLVTag_Ability_Unlock:
                self.bt_unlock.hidden = ability == SRControlAbilityType_Unsupport;
                self.bt_unlock.enabled = ability == SRControlAbilityType_Support;
                self.bt_unlock_1.hidden = ability == SRControlAbilityType_Unsupport;
                self.bt_unlock_1.enabled = ability == SRControlAbilityType_Support;
                break;
            case TLVTag_Ability_EngineOff:
                self.bt_engine_off.hidden = ability == SRControlAbilityType_Unsupport;
                self.bt_engine_off.enabled = ability == SRControlAbilityType_Support;
                self.bt_engine_off_1.hidden = ability == SRControlAbilityType_Unsupport;
                self.bt_engine_off_1.enabled = ability == SRControlAbilityType_Support;
                break;
            case TLVTag_Ability_WindowClose:
                self.bt_window_close.hidden = ability == SRControlAbilityType_Unsupport;
                self.bt_window_close.enabled = ability == SRControlAbilityType_Support;
                hasWindow = !self.bt_window_close.hidden;
                break;
            case TLVTag_Ability_WindowOpen:
                self.bt_window_open.hidden = ability == SRControlAbilityType_Unsupport;
                self.bt_window_open.enabled = ability == SRControlAbilityType_Support;
                hasWindow = !self.bt_window_open.hidden;
                break;
            case TLVTag_Ability_SkyClose:
                self.bt_skylight_close.hidden = ability == SRControlAbilityType_Unsupport;
                self.bt_skylight_close.enabled = ability == SRControlAbilityType_Support;
                hasWindow = !self.bt_skylight_close.hidden;
                break;
            case TLVTag_Ability_SkyOpen:
                self.bt_skylight_open.hidden = ability == SRControlAbilityType_Unsupport;
                self.bt_skylight_open.enabled = ability == SRControlAbilityType_Support;
                hasWindow = !self.bt_skylight_open.hidden;
                break;
                
            default:
                break;
        }
    }];
    
    self.hasWindow = hasWindow;
}

- (void)SendCmd:(SRTLVTag_Instruction)cmd withSuccessBlock:(VoidBlock)successBlock
{
    if ([SRUserDefaults loginStatus] == SRLoginStatus_NotLogin) {
        [SRUIUtil ModalSRLoginViewController];
        return;
    }
    
    if ([SRUserDefaults isExperienceUser]) {
        [self simulateSendCmd:cmd withSuccessBlock:successBlock];
        return;
    }
    
    if (![[SRPortal sharedInterface].currentVehicleBasicInfo hasTerminal]) {
        [SRUIUtil showBindTerminalAlert];
        return;
    }
    
    if ([SRPortal sharedInterface].customer.bindingStatus == SRBindingStatus_Bind_Others) {
        [SRUIUtil showAlertMessage:@"账号已被其他手机绑定"];
        return;
    }
    
    SRControlType type = [SRPhoneApp chooseControlModeWithCmd:cmd andVehicleId:[SRUserDefaults currentVehicleID]];
    if (type == SRControlType_Unsupport) {
        [SRUIUtil showAlertMessage:@"当前车辆不支持该操作"];
        return;
    }

    
    NSString *message;
    if (cmd == TLVTag_Instruction_EngineOff) {
        message = @"请确认车辆在静止状态下进行熄火操作，否则有可能造成行驶过程中熄火，造成交通事故";
    } else if (cmd == TLVTag_Instruction_OilBreak) {
        message = @"请确认车辆在静止状态下进行断油操作，否则有可能造成行驶过程中断油，造成交通事故";
    } else {
        message = [NSString stringWithFormat:@"是否发送%@指令？", [SRPhoneApp getStringWithInstructionID:cmd]];
    }
    
    if (type == SRControlType_SMS) {
        message = [message stringByAppendingFormat:@"\n注意:当手机无网络或车辆离线的情况下，将通过短信下发控制指令，短信控制只支持车主手机%@",
                   [[SRPortal sharedInterface].customer.customerPhone encodePhoneNumber]];
    }
    
    void (^sendBlock)(SRTLVTag_Instruction) = ^(SRTLVTag_Instruction cmd){
        //清空控制锁定状态
        [SRUserDefaults updateBackgroundLockStatus:NO];
        [SRUIUtil showLoadingHUDWithTitle:nil];
        [SRPhoneApp sendControlCommandWithCmd:cmd andCompleteBlock:^(NSError *error, id responseObject) {
            [SRUIUtil dissmissLoadingHUD];
            if (error) {
                [SRUIUtil showAlertMessage:error.domain];
            } else {
                [SRUIUtil showAutoDisappearHUDWithMessage:[NSString stringWithFormat:@"指令%@发送成功", [SRPhoneApp getStringWithInstructionID:cmd]]
                                                 isDetail:NO];
                
                if (successBlock) {
                    successBlock();
                }
            }
        }];
    };
    
    if ([SRUserDefaults needInputPassword]||(CFAbsoluteTimeGetCurrent()-notNeedPwdTime)>=300) {
        notNeedPwdTime = CFAbsoluteTimeGetCurrent();
        [[SRControlAlert instanceControlAlert] showWithMessage:message andDoneBlock:^{
            sendBlock(cmd);
        }];
        
    } else {
        UIActionSheet *actionSheet = [UIActionSheet bk_actionSheetWithTitle:message];
        [actionSheet bk_addButtonWithTitle:[NSString stringWithFormat:@"确定%@", [SRPhoneApp getStringWithInstructionID:cmd]] handler:^{
            sendBlock(cmd);
        }];
        [actionSheet bk_setCancelButtonWithTitle:@"取消" handler:^{
            
        }];
        [actionSheet bk_setDidDismissBlock:^(UIActionSheet *actionSheet, NSInteger buttonIndex) {
            if (buttonIndex == actionSheet.cancelButtonIndex) return ;
        }];
        [actionSheet showInView:[SRUIUtil rootViewController].view];
      
    }
}

#pragma mark - Private

- (void)updateControlViewYPosition:(CGFloat)position
{
    [self updateConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.superview).with.offset(position);
    }];
    [self.superview setNeedsUpdateConstraints];
    [self.superview  updateConstraintsIfNeeded];
}

- (void)updateControlBackground
{
    self.bt_window_open.hidden = !self.hasWindow;
    self.bt_window_close.hidden = !self.hasWindow;
    self.bt_skylight_open.hidden = !self.hasWindow;
    self.bt_skylight_close.hidden = !self.hasWindow;
    self.bt_lock.hidden = !self.hasWindow;
    self.bt_unlock.hidden = !self.hasWindow;
    self.bt_engine_off.hidden = !self.hasWindow;
    self.bt_lock_1.hidden = self.hasWindow;
    self.bt_unlock_1.hidden = self.hasWindow;
    self.bt_engine_off_1.hidden = self.hasWindow;
    
    [self setNeedsUpdateConstraints];
    [self updateConstraintsIfNeeded];
    [UIView  animateWithDuration:isControlMaskShowing?0.35:0 animations:^(){
    } completion:^(BOOL finished) {
    }];
}

- (void)simulateSendCmd:(SRTLVTag_Instruction)cmd withSuccessBlock:(VoidBlock)successBlock
{
    SRVehicleBasicInfo *basic = [SRPortal sharedInterface].currentVehicleBasicInfo;
    NSString *message;
    switch (cmd) {
        case TLVTag_Instruction_Lock:
            basic.status.doorLock = 2;
            message = @[@"爱车已经上锁", @"放心去吧，我就在这等着，哪儿也不去"][arc4random()%2];
            break;
        case TLVTag_Instruction_Unlock:
            basic.status.doorLock = 1;
            message = @[@"爱车已经解锁", @"锁了这么久，也该我大显身手了吧"][arc4random()%2];
            break;
        case TLVTag_Instruction_EngineOn:
            [SRSoundPlayer playEngineOnSondWithShake:YES];
            basic.status.engineStatus = 1;
            message = @[@"爱车引擎已启动，您可以随时开始驾驶", @"主公，座驾已经备好，开启征程吧"][arc4random()%2];
            break;
        case TLVTag_Instruction_EngineOff:
            basic.status.engineStatus = 2;
            message = @[@"你的爱车已经熄火", @"终于可以休息一会了"][arc4random()%2];
            break;
        case TLVTag_Instruction_Call:
            message = @[@"爱车开始鸣笛并闪光", @"您的爱车正在用鸣笛和闪灯呼唤主人~"][arc4random()%2];
            break;
        case TLVTag_Instruction_WindowClose:
            basic.status.windowLB = 2;
            basic.status.windowLF = 2;
            basic.status.windowRB = 2;
            basic.status.windowRF = 2;
            message = @"爱车车窗已经关闭";
            break;
        case TLVTag_Instruction_WindowOpen:
            basic.status.windowLB = 1;
            basic.status.windowLF = 1;
            basic.status.windowRB = 1;
            basic.status.windowRF = 1;
            message = @"爱车车窗已经开启";
            break;
        case TLVTag_Instruction_SkyClose:
            basic.status.windowSky = 2;
            message = @"爱车天窗已经关闭";
            break;
        case TLVTag_Instruction_SkyOpen:
            basic.status.windowSky = 1;
            message = @"爱车天窗已经开启";
            break;
            
        default:
            break;
    }
    [SRUIUtil showAutoDisappearHUDWithMessage:message
                                     isDetail:NO];
    if (successBlock) {
        successBlock();
    }
    
    [[SREventCenter sharedInterface] currentVehicleChange:basic];
}

#pragma mark - Getter

- (CGFloat)showCenterY {
    return showCenterY;
}

- (CGFloat)dismissCenterY {
    return dismissCenterY;
}

@end

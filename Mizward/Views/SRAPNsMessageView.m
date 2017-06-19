//
//  SRAPNsMessageView.m
//  SiRuiV4.0
//
//  Created by zhangjunbo on 15/7/30.
//  Copyright (c) 2015年 SiRui. All rights reserved.
//

#import "SRAPNsMessageView.h"
#import "SRMessageCell.h"
#import "SRAPNsMessage.h"
#import "SRAPNsMessageInfo.h"
#import <TSMessages/TSMessage.h>

@interface SRAPNsMessageView ()
@property (weak, nonatomic) IBOutlet UIImageView *image;
@property (weak, nonatomic) IBOutlet UILabel *label;
@property (weak, nonatomic) IBOutlet UIButton *button;

@end

@implementation SRAPNsMessageView

+ (SRAPNsMessageView *)instanceAPNsMessageView
{
    NSArray *nibView = [[NSBundle mainBundle] loadNibNamed:@"SRAPNsMessageView" owner:nil options:nil];
    return [nibView objectAtIndex:0];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.width = SCREEN_WIDTH;
    self.backgroundColor = [UIColor colorWithRed:.0f green:.0f blue:.0f alpha:.9f];
    
    [self.button bk_whenTapped:^{
        [TSMessage dismissActiveNotification];
    }];
}


#pragma mark - Setter

- (void)setApnsMsg:(SRAPNsMessage *)apnsMsg {
    _apnsMsg = apnsMsg;
    
    if (apnsMsg.MSG.t == SRMessageType_IM) {
        self.image.image = [UIImage imageNamed:@"ic_message_IM"];
    } else {
        self.image.image = imageForMessageSubType(apnsMsg.MSG.mt);
    }
    self.label.text = apnsMsg.aps.alert;
}

@end

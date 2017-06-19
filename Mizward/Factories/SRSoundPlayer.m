//
//  SRSoundPlayer.m
//  SiRuiV4.0
//
//  Created by zhangjunbo on 15/6/17.
//  Copyright (c) 2015年 SiRui. All rights reserved.
//

#import "SRSoundPlayer.h"
#import <AudioToolbox/AudioToolbox.h>

@implementation SRSoundPlayer

+ (void)playEngineOnSondWithShake:(BOOL)needShake
{
    static SystemSoundID soundID = 0;
    
    
    CFURLRef soundFileURLRef  = CFBundleCopyResourceURL(CFBundleGetMainBundle(),
                                                        CFSTR ("enginestart"),
                                                        CFSTR ("wav"),
                                                        NULL);
    AudioServicesCreateSystemSoundID(soundFileURLRef, &soundID);
    
    AudioServicesPlaySystemSound(soundID);
    
    if (needShake) {
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    }
}

@end

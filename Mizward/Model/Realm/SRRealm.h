//
//  SRRealm.h
//  Mizward
//
//  Created by zhangjunbo on 15/9/1.
//  Copyright (c) 2015年 Mizward. All rights reserved.
//

#import <Foundation/Foundation.h>

#if DEBUG
#define RealmEnable     (0)
#else
#define RealmEnable     (0)
#endif

@class RLMRealm;

@interface SRRealm : NSObject

@property (nonatomic, strong) RLMRealm *realm;

Singleton_Interface(SRRealm)

@end

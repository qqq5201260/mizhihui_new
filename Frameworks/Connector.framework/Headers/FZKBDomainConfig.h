
//
//  FZKBDomainConfig.h
//  bussiceTest
//
//  Created by czl on date.
//  Copyright © 2017年 chinapke. All rights reserved.
//

#ifndef FZKBDomainConfig_h
#define FZKBDomainConfig_h


#define GATE_RELEASE @"4s.mysirui.com"

#define PHONE_CONTROL_RELEASE @"42.120.61.246:2302"

#define GATE_TEST @"192.168.6.148:8080"




/**
 预解析数组

 @return 
 */
#define PreresolveHosts @[GATE_RELEASE,PHONE_CONTROL_RELEASE,GATE_TEST]

#endif /* FZKBDomainConfig_h */
//
//  FZKTPhoneControllBleAction.h
//  Connector
//
//  Created by czl on 2017/5/17.
//  Copyright © 2017年 chinapke. All rights reserved.
//

#import "FZKTBleWork.h"

@interface FZKTPhoneControllBleAction : FZKTBleWork


/**
 发送控制指令

 @param tag 指令编号
 */
- (void)phoneControllActionWithtag:(NSInteger)tag;

@end

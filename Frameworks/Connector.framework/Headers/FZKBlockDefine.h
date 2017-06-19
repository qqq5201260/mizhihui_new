//
//  FZKBlockDefine.h
//  SRN
//
//  Created by 宋搏 on 2017/3/27.
//  Copyright © 2017年 Fuizk. All rights reserved.
//

#ifndef FZKBlockDefine_h
#define FZKBlockDefine_h

#import "FZKActionResult.h"

#endif /* BlockDefine_h */

typedef void(^Action)();
typedef void(^Action1)(id parameter);

typedef void(^ResultAction)(FZKActionResult* result);
typedef BOOL(^ResultFilter)(NSInteger resultCode);

//
//  FZKBEndPointsModel.h
//  Connector
//
//  Created by czl on 2017/4/19.
//  Copyright © 2017年 chinapke. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FZKBEndPointsModel : NSObject<NSCoding>


@property (nonatomic , assign) NSInteger              port;
@property (nonatomic , assign) NSInteger              id;
@property (nonatomic , copy) NSString              * endtype;
@property (nonatomic , copy) NSString              * context;
@property (nonatomic , copy) NSString              * ip;


@end

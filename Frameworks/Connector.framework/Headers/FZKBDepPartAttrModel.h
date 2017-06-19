
//
//  FZKBDepPartAttrModel.h
//  Connector
//
//  Created by czl on date
//  Copyright © 2017年 chinapke. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface FZKBDepPartAttrModel : NSObject<NSCoding>

@property (nonatomic , assign) CGFloat              annualFee;
@property (nonatomic , assign) NSInteger              parentDirectSaleDepID;
@property (nonatomic , assign) NSInteger              depID;
@property (nonatomic , assign) BOOL              isDirectSale;
@property (nonatomic , assign) BOOL              isInstallationShop;
@property (nonatomic , copy) NSString              * levelCode;


@end

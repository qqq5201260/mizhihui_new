
//
//  FZKBPageResultModel.h
//  Connector
//
//  Created by czl on date
//  Copyright © 2017年 chinapke. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FZKBBrandPageResultModel : NSObject

@property (nonatomic,assign) NSInteger pageIndex;

@property (nonatomic,copy) NSArray *entityList;

@property (nonatomic,assign) NSInteger totalPage;

@property (nonatomic,assign) NSInteger pageSize;

@property (nonatomic,assign) NSInteger totalCount;


@end

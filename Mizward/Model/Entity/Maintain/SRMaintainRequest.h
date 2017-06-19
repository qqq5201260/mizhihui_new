//
//  SRMaintainRequest.h
//  SiRuiV4.0
//
//  Created by zhangjunbo on 15/7/28.
//  Copyright (c) 2015年 SiRui. All rights reserved.
//

#import "SRPortalRequest.h"

#pragma mark - 查询下次预约项目

@interface SRMaintainRequestQueryReserve : SRPortalRequestRSAApend

@property (nonatomic, assign) NSInteger vehicleID;

@end

#pragma mark - 查询4S店
@interface SRMaintainRequestQueryDepPage : SRPortalRequestRSAApend

@property (nonatomic, assign) NSInteger pageIndex;
@property (nonatomic, assign) NSInteger pageSize;

@end

#pragma mark - 添加预约记录

@interface SRMaintainRequestAddReserve : SRPortalRequestRSAApend

@property (nonatomic, assign) NSInteger vehicleID;
@property (nonatomic, assign) NSInteger depID;
@property (nonatomic, copy) NSString *depName;
@property (nonatomic, copy) NSString *startTime;
@property (nonatomic, copy) NSString *endTime;

@end

#pragma mark - 添加历史记录

@interface SRMaintainRequestAddHistory : SRPortalRequestRSAApend

@property (nonatomic, assign) NSInteger vehicleID;
@property (nonatomic, assign) NSInteger depID;
@property (nonatomic, copy) NSString *depName;
@property (nonatomic, copy) NSString *startTime;
@property (nonatomic, assign) CGFloat currentMileage;
@property (nonatomic, assign) CGFloat fee;
@property (nonatomic, assign) BOOL isIgnore;
@property (nonatomic, assign) NSInteger type;
@property (nonatomic, copy) NSString *uncommonMaintenItems;
@property (nonatomic, copy) NSString *defineMaintenItems;

- (BOOL)isCloseWithItemName:(NSString *)name;
- (CGFloat)remainMileageWithItemName:(NSString *)name;
- (void)updateUncommonMaintainItemsWithItemName:(NSString *)name
                                  remainMileage:(NSNumber *)mileage
                                        isClose:(NSNumber *)isClose;
- (void)updateUncommonMaintainItemsWithItemName:(NSString *)name
                                        isClose:(NSNumber *)isClose;
- (void)updateUncommonMaintainItemsWithItemName:(NSString *)name
                                  remainMileage:(NSNumber *)mileage;

@end

#pragma mark - 修改历史记录

@class SRMaintainHistory;
@interface SRMaintainRequestUpdateHistory : SRMaintainRequestAddHistory

//@property (nonatomic, assign) NSInteger vehicleID;
//@property (nonatomic, assign) NSInteger depID;
//@property (nonatomic, copy) NSString *depName;
//@property (nonatomic, copy) NSString *startTime;
//@property (nonatomic, assign) BOOL isIgnore;
//@property (nonatomic, assign) CGFloat currentMileage;
//@property (nonatomic, assign) CGFloat fee;
//@property (nonatomic, assign) NSInteger type;
//@property (nonatomic, copy) NSString *uncommonMaintenItems;
//@property (nonatomic, copy) NSString *defineMaintenItems;
@property (nonatomic, assign) NSInteger maintenReservationID;

- (instancetype)initWithMaintainHistory:(SRMaintainHistory *)history;

@end

#pragma mark - 查询历史记录

@interface SRMaintainRequestQueryHistoryPage : SRPortalRequestRSAApend

@property (nonatomic, assign) NSInteger vehicleID;

@property (nonatomic, assign) NSInteger pageIndex;
@property (nonatomic, assign) NSInteger pageSize;

@end

#pragma mark - 删除历史记录

@interface  SRMaintainRequestDeleteHistory : SRPortalRequestRSAApend

@property (nonatomic, assign) NSInteger maintenReservationID;

@end

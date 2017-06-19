//
//  SRMaintainOrderCell.m
//  SiRuiV4.0
//
//  Created by zhangjunbo on 15/7/18.
//  Copyright (c) 2015年 SiRui. All rights reserved.
//

#import "SRMaintainOrderCell.h"
#import "SRMaintainReserveInfo.h"

@interface SRMaintainOrderCell () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *collectionHeight;

@property (weak, nonatomic) IBOutlet UILabel *lb_none_description;

@property (weak, nonatomic) IBOutlet UILabel *lb_title;
@property (weak, nonatomic) IBOutlet UILabel *lb_description;
@property (weak, nonatomic) IBOutlet UIButton *bt_newOrder;
@property (weak, nonatomic) IBOutlet UIButton *bt_newRecord;

@property (strong, nonatomic) NSArray *bigMaintainIcons;
@property (strong, nonatomic) NSArray *bigMaintainTitles;

@property (strong, nonatomic) NSArray *littleMaintainIcons;
@property (strong, nonatomic) NSArray *littleMaintainTitles;

@property (strong, nonatomic) NSDictionary *specialMaintainIconDic;
@property (strong, nonatomic) NSDictionary *specialMaintainTitleDic;

@end

@implementation SRMaintainOrderCell

+ (CGFloat)heightWithSpecialTypes:(BOOL)withSpecialTypes
{
    if (withSpecialTypes) {
        return 150.0f;
    } else {
        return 113.5f;
    }
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.lb_none_description.text = @"暂无保养项目";
    
    self.lb_title.text = @"保养";
    self.lb_description.text = @"更加及时、安全的全方位保养";
    
    self.bt_newOrder.layer.cornerRadius = 5.0f;
    [self.bt_newOrder setTitle:@"立即预约" forState:UIControlStateNormal];
    [self.bt_newOrder setTitle:@"已预约" forState:UIControlStateDisabled];
    [RACObserve(self.bt_newOrder, enabled) subscribeNext:^(NSNumber *enabled) {
        if (enabled.boolValue) {
            self.bt_newOrder.backgroundColor = [UIColor defaultColor];
        } else {
            self.bt_newOrder.backgroundColor = [UIColor disableColor];
        }
    }];
    self.bt_newOrder.enabled = YES;
    
    self.bt_newRecord.layer.cornerRadius = 5.0f;
    self.bt_newRecord.layer.borderWidth = 1.0;
    self.bt_newRecord.layer.borderColor = [UIColor lightGrayColor].CGColor;
    [self.bt_newRecord setTitle:@"已保养" forState:UIControlStateNormal];
    
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.backgroundColor = [UIColor clearColor];
    self.collectionView.backgroundView.backgroundColor = [UIColor clearColor];
    UINib *nib = [UINib nibWithNibName:@"SRMaintainOrderCollectionCell" bundle:nil];
    [self.collectionView registerNib:nib forCellWithReuseIdentifier:reuseIdentifier];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return self.hasSpecialMaintain?2:1;
//    return 2;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (section == 0) {
        return self.reserveInfo.commonMaintenItemsTop.count;
//        return 4;
    } else {
        return self.reserveInfo.commonMaintenItemsBottom.count;
//        return 4;
    }
}

static NSString * const reuseIdentifier = @"Cell";
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    UIButton *bt = (UIButton *)[cell.contentView viewWithTag:100];
//    [bt setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter];
    
    NSString *ic;
    NSString *title;
    if (indexPath.section == 0) {
        ic = self.reserveInfo.maintainGeneralType==SRMaintainGeneralType_Big?self.bigMaintainIcons[indexPath.row]:self.littleMaintainIcons[indexPath.row];
        title = self.reserveInfo.maintainGeneralType==SRMaintainGeneralType_Big?self.bigMaintainTitles[indexPath.row]:self.littleMaintainTitles[indexPath.row];
//        ic = self.bigMaintainIcons[indexPath.row];
//        title = self.bigMaintainTitles[indexPath.row];
    } else {
        ic = self.specialMaintainIconDic[self.reserveInfo.specialTypes[indexPath.row]];
        title = self.specialMaintainTitleDic[self.reserveInfo.specialTypes[indexPath.row]];
    }
    [bt setImage:[UIImage imageNamed:ic] forState:UIControlStateNormal];
    [bt setTitle:title forState:UIControlStateNormal];
    
    return cell;
}

#pragma mark - UICollectionViewDelegate

- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}

#pragma mark - UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat heigth = self.hasSpecialMaintain?collectionView.height/2:collectionView.height;
    CGFloat width = (SCREEN_WIDTH-25)/4;
    return CGSizeMake(width , heigth);
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 0.0f;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0.0f;
}

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsZero;
}

#pragma mark - Getter

- (BOOL)hasSpecialMaintain
{
    return self.reserveInfo.commonMaintenItemsBottom && self.reserveInfo.commonMaintenItemsBottom.count>0;
}

- (NSArray *)bigMaintainIcons {
    if (_bigMaintainIcons) {
        return _bigMaintainIcons;
    }
    
    _bigMaintainIcons = @[@"ic_maintain_oil", @"ic_maintain_oil_filter", @"ic_maintain_air_filter", @"ic_maintain_air_confition"];
    return _bigMaintainIcons;
}

- (NSArray *)bigMaintainTitles {
    if (_bigMaintainTitles) {
        return _bigMaintainTitles;
    }
    
    _bigMaintainTitles = [SRMaintainReserveInfo commonBigMaintainTitles];
    return _bigMaintainTitles;
}

- (NSArray *)littleMaintainIcons {
    if (_littleMaintainIcons) {
        return _littleMaintainIcons;
    }
    
    _littleMaintainIcons = @[@"ic_maintain_oil", @"ic_maintain_oil_filter"];
    return _littleMaintainIcons;
}

- (NSArray *)littleMaintainTitles {
    if (_littleMaintainTitles) {
        return _littleMaintainTitles;
    }
    
    _littleMaintainTitles = [SRMaintainReserveInfo commonLittleMaintainTitles];
    return _littleMaintainTitles;
}

- (NSDictionary *)specialMaintainIconDic {
    if (_specialMaintainIconDic) {
        return _specialMaintainIconDic;
    }
    
    _specialMaintainIconDic = @{@(SRMaintainSpecialType_Tire)   :   @"ic_maintain_tire",
                                @(SRMaintainSpecialType_Brake)  :   @"ic_maintain_brake",
                                @(SRMaintainSpecialType_Battery):   @"ic_maintain_battery",
                                @(SRMaintainSpecialType_Wiper)  :   @"ic_maintain_wiper"};
    return _specialMaintainIconDic;
}

- (NSDictionary *)specialMaintainTitleDic {
    if (_specialMaintainTitleDic) {
        return _specialMaintainTitleDic;
    }
    
    _specialMaintainTitleDic = [SRMaintainReserveInfo uncommonMaintainItemsDic];
    return _specialMaintainTitleDic;
}

#pragma mark - Setter

- (void)setReserveInfo:(SRMaintainReserveInfo *)reserveInfo {
    
//    reserveInfo.commonMaintenItemsTop = [SRMaintainReserveInfo commonBigMaintainTitles];
//    reserveInfo.commonMaintenItemsBottom = [SRMaintainReserveInfo uncommonMaintainItems];
    
    _reserveInfo = reserveInfo;
    if (reserveInfo.commonMaintenItemsBottom && reserveInfo.commonMaintenItemsBottom.count > 0) {
        self.collectionHeight.constant = 73.0f;
    } else {
        self.collectionHeight.constant = 36.5f;
    }
    
    if (reserveInfo.status == SRMaintainStatus_None) {
        self.bt_newOrder.enabled = YES;
    } else {
        self.bt_newOrder.enabled = NO;
    }
    
    self.lb_none_description.hidden = reserveInfo.commonMaintenItemsTop.count>0 || reserveInfo.commonMaintenItemsBottom.count>0;
    
    [self.collectionView reloadData];
}

- (void)setOrderPressedBlock:(void (^)())orderPressedBlock
{
    _orderPressedBlock = orderPressedBlock;
    
    [self.bt_newOrder bk_whenTapped:^{
        self->_orderPressedBlock();
    }];
}

- (void)setRecordPressedBlock:(void (^)())recordPressedBlock
{
    _recordPressedBlock = recordPressedBlock;
    [self.bt_newRecord bk_whenTapped:^{
        self->_recordPressedBlock();
    }];
}

@end

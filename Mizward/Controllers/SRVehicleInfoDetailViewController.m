//
//  SRVehicleInfoDetailViewController.m
//  Mizward
//
//  Created by zhangjunbo on 15/11/4.
//  Copyright © 2015年 Mizward. All rights reserved.
//

#import "SRVehicleInfoDetailViewController.h"
#import "SRVehicleBasicInfo.h"
#import "SRPortal+CarInfo.h"
#import "SRPortalRequest.h"
#import "SRUIUtil.h"
#import "SRTableViewCell.h"
#import "SRBrandInfo.h"
#import "SRVehicleInfo.h"
#import "SRSeriesInfo.h"
#import "SRDataBase+Vehicle.h"

@interface SRVehicleInfoDetailViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) UITableView *tableView;

@property (weak, nonatomic) UITextField *tx_brand;
@property (weak, nonatomic) UITextField *tx_plateNumber;
@property (weak, nonatomic) UITextField *tx_vin;

@property (weak, nonatomic) UIButton *bt_done;

@property (strong, nonatomic) SRVehicleBasicInfo *baiscInfo;

@property (strong, nonatomic) NSArray *titles;

@end

@implementation SRVehicleInfoDetailViewController

- (instancetype)initWithVehicleBasicInfo:(SRVehicleBasicInfo *)info {
    if (self = [super init]) {
        _baiscInfo = info;
    }
    
    return self;
}

#pragma mark - 生命周期

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    
    [self initViews];
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 20.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44.0f;
}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section
{
    view.tintColor = [UIColor defaultBackgroundColor];
}

- (void)tableView:(UITableView *)tableView willDisplayFooterView:(UIView *)view forSection:(NSInteger)section {
    view.tintColor = [UIColor defaultBackgroundColor];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(SRTableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [cell setFisrtCell:indexPath.row==0
              lastCell:indexPath.row == [self tableView:tableView numberOfRowsInSection:indexPath.section]-1];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.titles.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CellIdentifier" ;
    SRTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[SRTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:CellIdentifier];
        UITextField *tx = [[UITextField alloc] initWithFrame:CGRectZero];
        tx.tag = 100;
        tx.font = [UIFont systemFontOfSize:15.0f];
        [cell.contentView addSubview:tx];
        [tx makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(cell.contentView).with.offset(100.0f);
            make.right.equalTo(cell.contentView).with.offset(-10.0f);
            make.top.bottom.equalTo(cell.contentView);
        }];
        
        UILabel *lb = [[UILabel alloc] initWithFrame:CGRectZero];
        lb.tag = 101;
        lb.font = [UIFont systemFontOfSize:12.0f];
        lb.numberOfLines = 0;
        lb.textColor = [UIColor lightGrayColor];
        [cell.contentView addSubview:lb];
        [lb makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(cell.contentView).with.offset(100.0f);
            make.right.equalTo(cell.contentView).with.offset(-10.0f);
            make.top.bottom.equalTo(cell.contentView);
        }];
    }
    
    cell.textLabel.text = self.titles[indexPath.row];
    cell.textLabel.font = [UIFont systemFontOfSize:15.0f];
    UITextField *tx = (UITextField *)[cell.contentView viewWithTag:100];
    UILabel *lb = (UILabel *)[cell.contentView viewWithTag:101];
    lb.hidden = YES;
    
    if (indexPath.row!=1) {
        cell.textLabel.textColor = [UIColor lightGrayColor];
        tx.userInteractionEnabled = NO;
        tx.textColor = [UIColor lightGrayColor];
    }
    
    switch (indexPath.row) {
        case 0:
        {
            tx.font = [UIFont systemFontOfSize:12.0f];
            lb.hidden = NO;
            lb.font = tx.font;
            lb.text = [NSString stringWithFormat:@"%@ %@", self.baiscInfo.brandName, self.baiscInfo.vehicleModelName];
            self.tx_brand = tx;
        }
            break;
        case 1:
            tx.text = self.baiscInfo.plateNumber;
            self.tx_plateNumber = tx;
            break;
        case 2:
            tx.text = self.baiscInfo.vin;
            self.tx_vin = tx;
            break;
            
        default:
            break;
    }
    
    return cell;
}


#pragma mark - 交互操作


#pragma mark - Getter

- (NSArray *)titles
{
    if (!_titles) {
        _titles = @[@"品牌车型", @"车牌号", @"车架号"];
    }
    
    return _titles;
}

#pragma mark - 私有方法

- (void)initViews
{
    UIButton *bt_done = [UIButton buttonWithType:UIButtonTypeCustom];
    bt_done.layer.cornerRadius = 5.0f;
    bt_done.titleLabel.font = [UIFont systemFontOfSize:17.0f];
    [bt_done setTitle:SRLocal(@"bt_done") forState:UIControlStateNormal];
    [bt_done setBackgroundColor:[UIColor defaultColor]];
    [bt_done bk_whenTapped:^{
        
        if ([self checkExperienceUserStatus]) {
            return;
        }
        
        [SRUIUtil showLoadingHUDWithTitle:nil];
        SRPortalRequestModifyCarRecord *request = [[SRPortalRequestModifyCarRecord alloc] initWithBasic:self.baiscInfo];
        request.plateNumber = self.tx_plateNumber.text;
        [SRPortal modifyCarRecordWthRequest:request andCompleteBlock:^(NSError *error, id responseObject) {
            [SRUIUtil dissmissLoadingHUD];
            if (error) {
                [SRUIUtil showAlertMessage:error.domain];
            } else {
                [SRUIUtil showAutoDisappearHUDWithMessage:@"修改成功" isDetail:NO];
            }
        }];
    }];
    [self.view addSubview:bt_done];
    [bt_done makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).with.offset(16.0f);
        make.right.equalTo(self.view).with.offset(-16.0f);
        make.bottom.equalTo(self.view).with.offset(-15.0f);
        make.height.equalTo(35.0f*iPhoneScale);
    }];
    
    self.bt_done = bt_done;
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero];
    tableView.backgroundColor = [UIColor clearColor];
    tableView.backgroundView.backgroundColor = [UIColor clearColor];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.allowsSelection = NO;
    tableView.tableFooterView = [[UIView alloc] init];
    [self.view addSubview:tableView];
    [tableView makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view);
        make.bottom.equalTo(self.bt_done.mas_top);
    }];
    
    self.tableView = tableView;
}
@end

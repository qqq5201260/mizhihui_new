//
//  SRTerminalInfoDetailViewController.m
//  Mizward
//
//  Created by zhangjunbo on 15/11/4.
//  Copyright © 2015年 Mizward. All rights reserved.
//

#import "SRTerminalInfoDetailViewController.h"
#import "SRVehicleBasicInfo.h"
#import "SRPortal+CarInfo.h"
#import "SRPortalRequest.h"
#import "SRUIUtil.h"
#import "SRTableViewCell.h"
#import "SRVehicleBluetoothInfo.h"
#import "SRBrandInfo.h"
#import "SRVehicleInfo.h"
#import "SRSeriesInfo.h"
#import "SRDataBase+Vehicle.h"

@interface SRTerminalInfoDetailViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) UITableView *tableView;

@property (weak, nonatomic) UITextField *tx_serialNumber;
@property (weak, nonatomic) UITextField *tx_barcode;
@property (weak, nonatomic) UITextField *tx_bluetooth;
@property (weak, nonatomic) UITextField *tx_msisdn;
@property (weak, nonatomic) UITextField *tx_balance;

@property (strong, nonatomic) SRVehicleBasicInfo *baiscInfo;

@property (strong, nonatomic) NSArray *titles;

@end

@implementation SRTerminalInfoDetailViewController

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
    
    cell.textLabel.textColor = [UIColor lightGrayColor];
    tx.userInteractionEnabled = NO;
    tx.textColor = [UIColor lightGrayColor];
    
    switch (indexPath.row) {
        case 0:
            tx.text = self.baiscInfo.barcode;
            self.tx_barcode = tx;
            break;
        case 1:
            tx.text = self.baiscInfo.serialNumber;
            self.tx_serialNumber = tx;
            break;
        case 2:
            tx.text = self.baiscInfo.bluetooth?self.baiscInfo.bluetooth.mac:@"--";
            self.tx_bluetooth = tx;
            break;
        case 3:
            tx.text = self.baiscInfo.msisdn;
            self.tx_msisdn = tx;
            cell.accessoryView = [self bt_phone];
            break;
        case 4:
        {
            tx.text = self.baiscInfo.gotBalance?[NSString stringWithFormat:@"%.2f元", self.baiscInfo.balance]:@"--";
            cell.accessoryView = [self bt_balance];
        }
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
        _titles = @[@"主机编码", @"终端序列号", @"蓝牙"
//                    , @"SIM卡号", @"余额"
                    ];
    }
    
    return _titles;
}

- (UIButton *)bt_phone
{
    UIButton *bt_phone = [UIButton buttonWithType:UIButtonTypeCustom];
    [bt_phone setImage:[UIImage imageNamed:@"ic_balance"] forState:UIControlStateNormal];
    bt_phone.frame = CGRectMake(0, 0, 30, 30);
    [bt_phone bk_whenTapped:^{
        [SRUIUtil showAlertMessage:@"车载终端上的手机号码\n车机号码信息仅供您参考，具体请参照产品盒子里手机卡上的电话号码"];
    }];
    
    return bt_phone;
}

- (UIButton *)bt_balance
{
    UIButton *bt_balance = [UIButton buttonWithType:UIButtonTypeCustom];
    [bt_balance setImage:[UIImage imageNamed:@"ic_balance"] forState:UIControlStateNormal];
    bt_balance.frame = CGRectMake(0, 0, 30, 30);
    [bt_balance bk_whenTapped:^{
        [SRUIUtil showAlertMessage:@"车机号码话费余额信息\n咪智汇系统会在每月初更新数据，余额不足会影响到您正常使用咪智汇功能，请您及时为车机号码充值。\n--表示未查询到相关话费信息，请您到营业厅进行查询。\n以上信息仅供您参考，具体请参照营业厅查询为准"];
    }];
    
    return bt_balance;
}

#pragma mark - 私有方法

- (void)initViews
{
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero];
    tableView.backgroundColor = [UIColor clearColor];
    tableView.backgroundView.backgroundColor = [UIColor clearColor];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.allowsSelection = NO;
    tableView.tableFooterView = [[UIView alloc] init];
    [self.view addSubview:tableView];
    [tableView makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.equalTo(self.view);
    }];
    
    self.tableView = tableView;
}

@end

//
//  SRTerminalDetailViewController.m
//  SiRuiV4.0
//
//  Created by zhangjunbo on 15/7/2.
//  Copyright (c) 2015年 SiRui. All rights reserved.
//

#import "SRTerminalDetailViewController.h"
#import "SRVehicleBasicInfo.h"
#import "SRPortal+CarInfo.h"
#import "SRPortalRequest.h"
#import "SRUIUtil.h"
#import "SRTableViewCell.h"
#import "SRBrandVehicleViewController.h"
#import "SRBrandInfo.h"
#import "SRVehicleInfo.h"
#import "SRSeriesInfo.h"
#import "SRDataBase+Vehicle.h"

@interface SRTerminalDetailViewController () <UITableViewDataSource, UITableViewDelegate, SRBrandVehicleViewControllerDelegate>

@property (weak, nonatomic) UITableView *tableView;

@property (weak, nonatomic) UIButton *bt_brandVehicle;

@property (weak, nonatomic) UITextField *tx_brand;
@property (weak, nonatomic) UITextField *tx_plateNumber;
@property (weak, nonatomic) UITextField *tx_vin;

@property (weak, nonatomic) UITextField *tx_serialNumber;
@property (weak, nonatomic) UITextField *tx_barcode;
@property (weak, nonatomic) UITextField *tx_msisdn;
@property (weak, nonatomic) UITextField *tx_balance;

@property (weak, nonatomic) UIButton *bt_done;

@property (strong, nonatomic) SRBrandInfo *selectedBrandInfo;
@property (strong, nonatomic) SRVehicleInfo *selectedVehicleInfo;
@property (strong, nonatomic) SRSeriesInfo *selectedSeriesInfo;

@property (strong, nonatomic) SRVehicleBasicInfo *baiscInfo;

@property (strong, nonatomic) NSArray *titles;
@property (strong, nonatomic) NSArray *headers;

@end

@implementation SRTerminalDetailViewController

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
    return 40.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44.0f;
}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section
{
    view.tintColor = [UIColor defaultBackgroundColor];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
    label.font = [UIFont systemFontOfSize:15.0f];
    label.text = self.headers[section];
    label.textAlignment = NSTextAlignmentCenter;
    [view addSubview:label];
    [label makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(view).with.offset(10.0f);
        make.bottom.equalTo(view).with.offset(-10.0f);
        make.left.equalTo(view).with.offset(20.0f);
        make.right.equalTo(view).with.offset(-20.0f);
    }];
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
    return self.headers.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.titles[section] count];
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
//        lb.textAlignment = NSTextAlignmentCenter;
        lb.textColor = [UIColor lightGrayColor];
        [cell.contentView addSubview:lb];
        [lb makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(cell.contentView).with.offset(100.0f);
            make.right.equalTo(cell.contentView).with.offset(-10.0f);
            make.top.bottom.equalTo(cell.contentView);
        }];
    }
    
    cell.textLabel.text = self.titles[indexPath.section][indexPath.row];
    cell.textLabel.font = [UIFont systemFontOfSize:15.0f];
    UITextField *tx = (UITextField *)[cell.contentView viewWithTag:100];
    UILabel *lb = (UILabel *)[cell.contentView viewWithTag:101];
    lb.hidden = YES;
    
    if ((indexPath.section == 0 &&(indexPath.row!=1))
        || indexPath.section > 0) {
        cell.textLabel.textColor = [UIColor lightGrayColor];
        tx.userInteractionEnabled = NO;
        tx.textColor = [UIColor lightGrayColor];
    }
    
    if (indexPath.section == 0) {
        switch (indexPath.row) {
            case 0:
            {
                tx.font = [UIFont systemFontOfSize:12.0f];
                lb.hidden = NO;
                lb.font = tx.font;
                if (self.selectedBrandInfo) {
                    lb.text = [NSString stringWithFormat:@"%@ %@", self.selectedBrandInfo.name, self.selectedVehicleInfo.vehicleName];
                } else {
                    lb.text = [NSString stringWithFormat:@"%@ %@", self.baiscInfo.brandName, self.baiscInfo.vehicleModelName];
                }
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
    } else {
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
                tx.text = self.baiscInfo.msisdn;
                self.tx_msisdn = tx;
                cell.accessoryView = [self bt_phone];
                break;
            case 3:
            {
                tx.text = self.baiscInfo.gotBalance?[NSString stringWithFormat:@"%.2f元", self.baiscInfo.balance]:@"--";
                cell.accessoryView = [self bt_balance];
            }
                break;
                
            default:
                break;
        }
    }
    
    
    return cell;
}

#pragma mark - SRBrandVehicleViewControllerDelegate

- (void)selectedBrandInfo:(SRBrandInfo *)brandInfo seriesInfo:(SRSeriesInfo *)seriesInfo andVehicleInfo:(SRVehicleInfo *)vehicleInfo
{
    if (brandInfo) {
        self.selectedBrandInfo = brandInfo;
    }
    
    if (seriesInfo) {
        self.selectedSeriesInfo = seriesInfo;
    }
    
    if (vehicleInfo) {
        self.selectedVehicleInfo = vehicleInfo;
    }
    
    [self.tableView reloadData];
}


#pragma mark - 交互操作


#pragma mark - Getter

- (NSArray *)titles
{
    if (!_titles) {
        _titles = @[@[@"品牌车型", @"车牌号", @"车架号"],
                    @[@"主机编码", @"终端序列号", @"SIM卡号", @"余额"]];
    }
    
    return _titles;
}

- (NSArray *)headers
{
    if (!_headers) {
        _headers = @[@"车辆资料", @"终端资料"];
    }
    
    return _headers;
}

- (UIButton *)bt_brandVehicle
{
    if (_bt_brandVehicle) {
        return _bt_brandVehicle;
    }
    
    UIButton *bt_brandVehicle = [[UIButton alloc] initWithFrame:CGRectMake(.0f, .0f, 30.0f, 30.0f)];
    bt_brandVehicle.backgroundColor = [UIColor defaultColor];
    bt_brandVehicle.layer.cornerRadius = 10.0f;
    [bt_brandVehicle bk_whenTapped:^{
        SRBrandVehicleViewController *vc = [[SRBrandVehicleViewController alloc] init];
        vc.tableType = BrandVehicleType_Both;
        vc.delegate = self;
        [self.navigationController presentViewController:vc animated:YES completion:NULL];
    }];
    
    _bt_brandVehicle = bt_brandVehicle;
    return _bt_brandVehicle;
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
    UIButton *bt_done = [UIButton buttonWithType:UIButtonTypeCustom];
    bt_done.layer.cornerRadius = 5.0f;
    bt_done.titleLabel.font = [UIFont systemFontOfSize:17.0f];
    [bt_done setTitle:SRLocal(@"bt_done") forState:UIControlStateNormal];
    [bt_done setBackgroundColor:[UIColor defaultColor]];
    [bt_done bk_whenTapped:^{
        
        [SRUIUtil showLoadingHUDWithTitle:nil];
        SRPortalRequestModifyCarRecord *request = [[SRPortalRequestModifyCarRecord alloc] initWithBasic:self.baiscInfo];
        request.plateNumber = self.tx_plateNumber.text;
        if (self.selectedVehicleInfo) {
            request.vehicleModelID = self.selectedVehicleInfo.vehicleModelID;
        }
        [SRPortal modifyCarRecordWthRequest:request andCompleteBlock:^(NSError *error, id responseObject) {
            [SRUIUtil dissmissLoadingHUD];
            if (error) {
                [SRUIUtil showAlertMessage:error.domain];
            } else {
                [SRUIUtil showAutoDisappearHUDWithMessage:@"修改成功" isDetail:NO];
                if (self.selectedVehicleInfo) {
                    SRVehicleBasicInfo *localInfo = [[SRPortal sharedInterface] vehicleBasicInfoWithVehicleID:request.entityID];
                    if (self.selectedVehicleInfo) {
                        localInfo.vehicleModelName = self.selectedVehicleInfo.vehicleName;
                        [[SRDataBase sharedInterface] updateVehicleList:@[localInfo] withCompleteBlock:nil];
                    }
                }
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

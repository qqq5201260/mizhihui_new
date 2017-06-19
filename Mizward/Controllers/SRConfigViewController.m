//
//  SRConfigViewController.m
//  SiRuiV4.0
//
//  Created by zhangjunbo on 15/6/19.
//  Copyright (c) 2015年 SiRui. All rights reserved.
//

#import "SRConfigViewController.h"
#import "SRURLUtil.h"
#import "SRUIUtil.h"
#import "SRSLBMod.h"
#import "SRUserDefaults.h"

@interface SRConfigViewController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) UINavigationBar *navBar;
@property (weak, nonatomic) UITableView *tableView;
@property (weak, nonatomic) UIButton *bt_done;

@property (weak, nonatomic) UITextField *tx_slb_ip;
@property (weak, nonatomic) UITextField *tx_slb_dns;
@property (weak, nonatomic) UITextField *tx_portal;
@property (weak, nonatomic) UITextField *tx_phoneapp;
@property (weak, nonatomic) UITextField *tx_online;
@property (weak, nonatomic) UITextField *tx_tcp;

@property (weak, nonatomic) UITextField *tx_mac;
@property (weak, nonatomic) UITextField *tx_id;
@property (weak, nonatomic) UITextField *tx_key;

@property (nonatomic, strong) NSArray *titles;

@end

@implementation SRConfigViewController

#pragma mark - 生命周期

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"配置";
    
    [self initView];
    
    [self addConfigButton];
    
    self.titles = @[@"SLB_IP", @"SLB_DNS", @"Portal", @"PhoneApp", @"Online", @"TCP", @"蓝牙MAC", @"加密ID", @"加密KEY"];
//    self.titles = @[@"SLB_IP", @"SLB_DNS", @"Portal", @"PhoneApp", @"Online", @"TCP"];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44.0f;
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.titles.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CellIdentifier" ;
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:CellIdentifier];
    }
    
    cell.textLabel.text = self.titles[indexPath.row];
    cell.textLabel.font = [UIFont systemFontOfSize:10.0f];
    
    UITextField *text = (UITextField *)[cell.contentView viewWithTag:100];
    if (!text) {
        text = [[UITextField alloc] initWithFrame:CGRectZero];
        text.font = [UIFont systemFontOfSize:10.0f];
        text.tag = 100;
        [cell.contentView addSubview:text];
        [text makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.trailing.equalTo(cell.contentView);
            make.leading.equalTo(cell.contentView).with.offset(90.0f);
        }];
    }
    
    switch (indexPath.row) {
        case 0:
            self.tx_slb_ip = text;
            text.text = [SRURLUtil BaseURL_Slb_IP];
            break;
        case 1:
            self.tx_slb_dns = text;
            text.text = [SRURLUtil BaseURL_Slb_DNS];
            break;
        case 2:
            self.tx_portal = text;
            text.text = [SRURLUtil BaseURL_Portal];
            break;
        case 3:
            self.tx_phoneapp = text;
            text.text = [SRURLUtil BaseURL_PhoneApp];
            break;
        case 4:
            self.tx_online = text;
            text.text = [SRURLUtil BaseURL_Online];
            break;
        case 5:
            self.tx_tcp = text;
            text.text = [NSString stringWithFormat:@"%@:%zd", [SRURLUtil TcpHost], [SRURLUtil TcpPort]];
            break;
        case 6:
            self.tx_mac = text;
            text.text = [SRUserDefaults macAddress];
            break;
        case 7:
            self.tx_id = text;
            text.text = [SRUserDefaults idString];
            break;
        case 8:
            self.tx_key = text;
            text.text = [SRUserDefaults keyString];
            break;
            
        default:
            break;
    }
    
    
    return cell;
}

#pragma mark - Getter

- (UITableView *)tableView {
    if (!_tableView) {
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero];
        tableView.delegate = self;
        tableView.dataSource = self;
        [tableView setTableFooterView:[[UIView alloc] init]];
        [self.view addSubview:tableView];
        [tableView makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view).with.offset(StatusBar_HEIGHT+NavigationBar_HEIGHT);
            make.leading.trailing.equalTo(self.view);
            make.height.equalTo(200.0f);
        }];
       _tableView = tableView;
    }
    
    return _tableView;
}

//- (UIButton *)bt_done {
//    if (!_bt_done) {
//        UIButton *bt_done = [[UIButton alloc] initWithFrame:CGRectZero];
//        bt_done.backgroundColor = [UIColor defaultColor];
//        [bt_done setTitle:@"确定" forState:UIControlStateNormal];
//        [self.view addSubview:bt_done];
//        [bt_done makeConstraints:^(MASConstraintMaker *make) {
//            make.top.equalTo(self.tableView.bottom);
//            make.leading.equalTo(self.view).with.offset(20.0f);
//            make.trailing.equalTo(self.view).with.offset(-20.0f);
//            make.height.equalTo(40.0f);
//        }];
//        
//        [bt_done bk_whenTapped:^{
//            [SRURLUtil setBaseURL_Slb_IP:self.tx_slb_ip.text];
//            [SRURLUtil setBaseURL_Slb_DNS:self.tx_slb_dns.text];
//            [SRURLUtil setBaseURL_Portal:self.tx_portal.text];
//            [SRURLUtil setBaseURL_PhoneApp:self.tx_phoneapp.text];
//            [SRURLUtil setBaseURL_Online:self.tx_online.text];
//            
//            NSArray *array = [self.tx_tcp.text componentsSeparatedByString:@":"];
//            if (array.count == 2) {
//                [SRURLUtil setTcpHost:array[0]];
//                [SRURLUtil setTcpPort:[array[1] integerValue]];
//            }
//            
//            [SRUIUtil showLoadingHUDWithTitle:nil];
//            [[SRSLBMod sharedInterface] getSLBFromServerWithCompleteBlock:^(NSError *error, id responseObject) {
//                [SRUIUtil dissmissLoadingHUD];
//                [self.tableView reloadData];
//            }];
//            
//            [SRUserDefaults setMacAddress:self.tx_mac.text];
//            [SRUserDefaults setIdString:self.tx_id.text];
//            [SRUserDefaults setKeyString:self.tx_key.text];
//        }];
//        
//        _bt_done = bt_done;
//    }
//    
//    return _bt_done;
//}



#pragma mark - 私有方法

- (void)addConfigButton {
    UIBarButtonItem *online = [[UIBarButtonItem alloc] bk_initWithTitle:@"商用" style:UIBarButtonItemStyleDone handler:^(id sender) {
        [SRURLUtil resetURLs];
        [self.tableView reloadData];
    }];
    UIBarButtonItem *test = [[UIBarButtonItem alloc] bk_initWithTitle:@"测试" style:UIBarButtonItemStyleDone handler:^(id sender) {
        [SRURLUtil restTestURLs];
        [self.tableView reloadData];
    }];
    self.navigationItem.rightBarButtonItems = @[online,test];
}

- (void)initView {
    if (!_tableView) {
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero];
        tableView.delegate = self;
        tableView.dataSource = self;
        [tableView setTableFooterView:[[UIView alloc] init]];
        [self.view addSubview:tableView];
        [tableView makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view).with.offset(StatusBar_HEIGHT+NavigationBar_HEIGHT);
            make.leading.trailing.equalTo(self.view);
            make.bottom.equalTo(self.view).with.offset(-100.0f);
        }];
        _tableView = tableView;
    }
    
    if (!_bt_done) {
        UIButton *bt_done = [[UIButton alloc] initWithFrame:CGRectZero];
        bt_done.backgroundColor = [UIColor defaultColor];
        [bt_done setTitle:@"确定" forState:UIControlStateNormal];
        [self.view addSubview:bt_done];
        [bt_done makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.view).with.offset(-50.0f);
            make.leading.equalTo(self.view).with.offset(20.0f);
            make.trailing.equalTo(self.view).with.offset(-20.0f);
            make.height.equalTo(40.0f);
        }];
        
        [bt_done bk_whenTapped:^{
            [SRURLUtil setBaseURL_Slb_IP:self.tx_slb_ip.text];
            [SRURLUtil setBaseURL_Slb_DNS:self.tx_slb_dns.text];
            [SRURLUtil setBaseURL_Portal:self.tx_portal.text];
            [SRURLUtil setBaseURL_PhoneApp:self.tx_phoneapp.text];
            [SRURLUtil setBaseURL_Online:self.tx_online.text];
            
            NSArray *array = [self.tx_tcp.text componentsSeparatedByString:@":"];
            if (array.count == 2) {
                [SRURLUtil setTcpHost:array[0]];
                [SRURLUtil setTcpPort:[array[1] integerValue]];
            }
            
            [SRUIUtil showLoadingHUDWithTitle:nil];
            [[SRSLBMod sharedInterface] getSLBFromServerWithCompleteBlock:^(NSError *error, NSNumber *responseObject) {
                [SRUIUtil dissmissLoadingHUD];
                [self.tableView reloadData];
            }];
            
            [SRUserDefaults setMacAddress:self.tx_mac.text];
            [SRUserDefaults setIdString:self.tx_id.text];
            [SRUserDefaults setKeyString:self.tx_key.text];
        }];
        
        _bt_done = bt_done;
    }
}

@end

//
//  SROBDConfigViewController.m
//  SiRuiV4.0
//
//  Created by zhangjunbo on 15/7/2.
//  Copyright (c) 2015年 SiRui. All rights reserved.
//

#import "SROBDConfigViewController.h"
#import "SRTableViewCell.h"
#import "SRPortal+CarInfo.h"
#import "SRPortalRequest.h"
#import "SRVehicleBasicInfo.h"
#import "SRUIUtil.h"
#import <KVOController/FBKVOController.h>

@interface SROBDConfigViewController ()
{
    FBKVOController *kvoController;
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) NSArray *vehicles;


@end

@implementation SROBDConfigViewController

#pragma mark - 生命周期

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = SRLocal(@"title_obd");
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.backgroundView.backgroundColor = [UIColor clearColor];
    
    kvoController = [[FBKVOController alloc] initWithObserver:self];
    
    self.vehicles = [SRPortal sharedInterface].allVehicles;
    
    
    [self.tableView reloadData];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.vehicles  enumerateObjectsUsingBlock:^(SRVehicleBasicInfo *obj, NSUInteger idx, BOOL *stop) {
        [self->kvoController observe:obj keyPath:@"openObd" options:NSKeyValueObservingOptionNew block:^(id observer, id object, NSDictionary *change) {
            [self executeOnMain:^{
                [self.tableView reloadData];
            } afterDelay:0];
        }];
    }];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [kvoController unobserveAll];
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 20.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 70.0f;
}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section
{
    view.tintColor = [UIColor defaultBackgroundColor];
}

- (void)tableView:(UITableView *)tableView willDisplayFooterView:(UIView *)view forSection:(NSInteger)section {
    view.tintColor = [UIColor defaultBackgroundColor];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
    label.text = SRLocal(@"description_obd");
    label.numberOfLines = 0;
    label.font = [UIFont systemFontOfSize:13.0f];
    label.textColor = [UIColor lightGrayColor];
    [view addSubview:label];
    [label makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(view).with.offset(10.0f);
        make.left.equalTo(view).with.offset(20.0f);
        make.right.equalTo(view).with.offset(-20.0f);
    }];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(SRTableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [cell setFisrtCell:indexPath.row==0
              lastCell:indexPath.row == [self tableView:tableView numberOfRowsInSection:indexPath.section]-1];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [SRPortal sharedInterface].vehicleDic.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CellIdentifier" ;
    SRTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[SRTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:CellIdentifier];
        UISwitch *sw = [[UISwitch alloc] initWithFrame:CGRectMake(0, 0, 50, 30)];
        sw.onTintColor = [UIColor defaultColor];
        cell.accessoryView = sw;
    }
    
    UISwitch *sw = (UISwitch *)cell.accessoryView;
    
    SRVehicleBasicInfo *basic = self.vehicles[indexPath.row];
    cell.imageView.image = [UIImage imageNamed:@"ic_car"];
//    if (indexPath.row < 3) {
//        cell.imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"ic_car_%zd", indexPath.row]];
//    } else {
//        cell.imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"ic_car_%zd", arc4random()%3]];
//    }
    
    cell.textLabel.text = basic.plateNumber;
    sw.on = [basic isObdOpen];
    [sw bk_associateValue:@(basic.vehicleID) withKey:@"vehicleID"];
    [sw addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
    
    return cell;
}

#pragma mark - 交互操作

- (IBAction)switchAction:(UISwitch *)sender
{
    if ([self checkExperienceUserStatus]) {
        sender.on ^= 1;
        return ;
    }
    
    [SRUIUtil showLoadingHUDWithTitle:nil];
    SRPortalRequestUpdateObdStatus *request = [[SRPortalRequestUpdateObdStatus alloc] init];
    request.vehicleID = [[sender bk_associatedValueForKey:@"vehicleID"] integerValue];
    request.openObd = sender.on;
    [SRPortal updateOBDStatusWithRequest:request andCompleteBlock:^(NSError *error, id responseObject) {
        [SRUIUtil dissmissLoadingHUD];
        if (error) {
            [SRUIUtil showAlertMessage:error.domain];
            sender.on ^= 1;
        } else {
            [SRUIUtil showAutoDisappearHUDWithMessage:[NSString stringWithFormat:@"诊断设置已%@", sender.on?@"开启":@"关闭"]
                                             isDetail:NO];
        }
    }];
}

@end

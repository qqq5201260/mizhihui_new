//
//  SRTripHiddenViewController.m
//  SiRuiV4.0
//
//  Created by zhangjunbo on 15/6/24.
//  Copyright (c) 2015年 SiRui. All rights reserved.
//

#import "SRTripHiddenViewController.h"
#import "SRTableViewCell.h"
#import "SRPortal+CarInfo.h"
#import "SRPortal+User.h"
#import "SRPortalRequest.h"
#import "SRVehicleBasicInfo.h"
#import "SRCustomer.h"
#import "SRUIUtil.h"
#import <KVOController/FBKVOController.h>

@interface SRTripHiddenViewController ()
{
    FBKVOController *kvoController;
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) NSMutableArray *carsCanConfig;

@end

@implementation SRTripHiddenViewController

#pragma mark - 生命周期

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = SRLocal(@"title_trip_hidden");
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.backgroundView.backgroundColor = [UIColor clearColor];
    
    kvoController = [[FBKVOController alloc] initWithObserver:self];
    
    self.carsCanConfig = [NSMutableArray array];
    [[SRPortal sharedInterface].vehicleDic.allValues enumerateObjectsUsingBlock:^(SRVehicleBasicInfo *obj, NSUInteger idx, BOOL *stop) {
        if (obj.tripHidden != SRTrip_Hidden_Others) {
            [self.carsCanConfig addObject:obj];
        }
    }];
    
    [self.tableView reloadData];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [[SRPortal sharedInterface].vehicleDic.allValues  enumerateObjectsUsingBlock:^(SRVehicleBasicInfo *obj, NSUInteger idx, BOOL *stop) {
        [self->kvoController observe:obj keyPath:@"tripHidden" options:NSKeyValueObservingOptionNew block:^(id observer, id object, NSDictionary *change) {
            if (obj.tripHidden == SRTrip_Hidden_Others) {
                [self.carsCanConfig removeObject:obj];
            } else if (![self.carsCanConfig containsObject:obj]) {
                [self.carsCanConfig addObject:obj];
            }
            
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
//    return section==0?30.0f:70.0f;
    return 100.0f;
}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section
{
    view.tintColor = [UIColor defaultBackgroundColor];
}

- (void)tableView:(UITableView *)tableView willDisplayFooterView:(UIView *)view forSection:(NSInteger)section {
    view.tintColor = [UIColor defaultBackgroundColor];
    

    UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
    label.text = [NSString stringWithFormat:@"%@", SRLocal(@"desctription_trip_hidden")];
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
    return self.carsCanConfig.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [SRPortal sharedInterface].customer.openHiddenTrip?2:1;
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
    
    SRVehicleBasicInfo *basic = self.carsCanConfig[indexPath.row];
    
    cell.imageView.image = [UIImage imageNamed:@"ic_car"];
//    if (indexPath.row < 3) {
//        cell.imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"ic_car_%zd", indexPath.row]];
//    } else {
//        cell.imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"ic_car_%zd", arc4random()%3]];
//    }
    
    cell.textLabel.text = basic.plateNumber;
    sw.on = basic.tripHidden == SRTrip_Hidden_Self;
    [sw bk_addEventHandler:^(id sender) {
        
        if ([self checkExperienceUserStatus]) {
            sw.on ^= 1;
            return ;
        }
        
        [SRUIUtil showLoadingHUDWithTitle:nil];
        SRPortalRequestTripHidden *request = [[SRPortalRequestTripHidden alloc] init];
        request.vehicleID = basic.vehicleID;
        request.isHidden = sw.on;
        [SRPortal hiddenTripWithRequest:request andCompleteBlock:^(NSError *error, id responseObject) {
            [SRUIUtil dissmissLoadingHUD];
            if (error) {
                [SRUIUtil showAlertMessage:error.domain];
                sw.on ^= 1;
            } else {
                [SRUIUtil showAutoDisappearHUDWithMessage:[NSString stringWithFormat:@"隐藏行踪已%@", sw.on?@"开启":@"关闭"]
                                                     isDetail:NO];
            }
        }];
    } forControlEvents:UIControlEventValueChanged];
    
    return cell;
}

@end

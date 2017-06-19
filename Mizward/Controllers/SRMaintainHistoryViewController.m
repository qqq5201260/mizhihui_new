//
//  SRMaintainHistoryViewController.m
//  SiRuiV4.0
//
//  Created by zhangjunbo on 15/7/14.
//  Copyright (c) 2015年 SiRui. All rights reserved.
//

#import "SRMaintainHistoryViewController.h"
#import "SRTableViewCell.h"
#import "SRMaintainHistory.h"
#import "SRDataBase+MaintainHistory.h"
#import "SRMaintainRequest.h"
#import "SRUserDefaults.h"
#import "SRMaintain.h"
#import "SRMaintainHistoryCell.h"
#import "SRMaintainDetailViewController.h"
#import "SRUIUtil.h"
#import <MJRefresh/MJRefresh.h>

@interface SRMaintainHistoryViewController () <SRMaintainDetailViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *historyList;

@end

@implementation SRMaintainHistoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.historyList = [NSMutableArray array];
    
    UINib *nib = [UINib nibWithNibName:@"SRMaintainHistoryCell" bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:CellIdentifier];
    self.tableView.backgroundView.backgroundColor = [UIColor clearColor];
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.needAddEmptyView = @(YES);
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        if (![self checkLoginStatus]) {
            [self.tableView.mj_header endRefreshing];
            return ;
        }
        
        SRMaintainRequestQueryHistoryPage *request = [[SRMaintainRequestQueryHistoryPage alloc] init];
        request.vehicleID = [SRUserDefaults currentVehicleID];
        [SRMaintain queryMaintainHistoryWithRequest:request isRefresh:YES andCompleteBlock:^(NSError *error, id responseObject) {
            [self.tableView.mj_header endRefreshing];
            if (!error) {
                self.historyList = responseObject;
            }
        }];
    }];
    
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        if (![self checkLoginStatus]) {
            [self.tableView.mj_footer endRefreshing];
            return ;
        }
        
        SRMaintainRequestQueryHistoryPage *request = [[SRMaintainRequestQueryHistoryPage alloc] init];
        request.vehicleID = [SRUserDefaults currentVehicleID];
        [SRMaintain queryMaintainHistoryWithRequest:request isRefresh:NO andCompleteBlock:^(NSError *error, id responseObject) {
            [self.tableView.mj_footer endRefreshing];
            if (!error) {
                self.historyList = responseObject;
            }
        }];
    }];
    
    if ([SRUserDefaults isLogin]) {
        self.tableView.mj_header.state = MJRefreshStateRefreshing;
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if ([SRUserDefaults isLogin]) {
        SRMaintainRequestQueryHistoryPage *request = [[SRMaintainRequestQueryHistoryPage alloc] init];
        request.vehicleID = [SRUserDefaults currentVehicleID];
        [SRMaintain queryMaintainHistoryWithRequest:request isRefresh:YES andCompleteBlock:^(NSError *error, id responseObject) {
            [self.tableView.mj_header endRefreshing];
            if (!error) {
                self.historyList = responseObject;
            }
        }];
    } else {
        self.historyList = nil;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    UIViewController *vc = segue.destinationViewController;
    
    if (sender && [sender isKindOfClass:[UIButton class]]) {
        [vc setValue:@(YES) forKey:@"isAdd"];
    } else {
        NSIndexPath *selectedIndexPath = [self.tableView indexPathForSelectedRow];
        [vc setValue:self.historyList[selectedIndexPath.row] forKey:@"history"];
        [vc setValue:@(selectedIndexPath.row==0) forKey:@"canEdit"];
        [vc setValue:self forKey:@"delegate"];
    }
}

#pragma mark - SRMaintainDetailViewControllerDelegate

- (void)localInfoDidChange {
    [[SRDataBase sharedInterface] queryAllMaintainHistoryByVehicleID:[SRUserDefaults currentVehicleID] withCompleteBlock:^(NSError *error, id responseObject) {
        if (responseObject) {
            self.historyList = responseObject;
        }
    }];
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 20.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70.0f;
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
    [cell setFisrtCell:indexPath.row == 0
              lastCell:indexPath.row == [self tableView:tableView numberOfRowsInSection:indexPath.section]-1];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self performSegueWithIdentifier:@"PushSRMaintainDetailViewController" sender:nil];
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.historyList.count;
}

static NSString *CellIdentifier = @"CellIdentifier" ;
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SRMaintainHistoryCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    cell.history = self.historyList[indexPath.row];
    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self checkExperienceUserStatus]) {
        return;
    }
    
    if (editingStyle != UITableViewCellEditingStyleDelete) {
        return;
    }
    
    [UIAlertView bk_showAlertViewWithTitle:@"提示"
                                   message:@"是否删除该条保养记录？"
                         cancelButtonTitle:@"取消"
                         otherButtonTitles:@[@"确定"]
                                   handler:^(UIAlertView *alertView, NSInteger buttonIndex) {
                                       if (buttonIndex == alertView.cancelButtonIndex) {
                                           return ;
                                       }
                                       [self deleteHistory:self.historyList[indexPath.row]];
                                   }];
}

#pragma mark - 交互操作

- (IBAction)buttonAddPressed:(id)sender {
    if (![self checkLoginStatus]) {
        return ;
    }
    
    [self performSegueWithIdentifier:@"PushSRMaintainDetailViewController" sender:sender];
}

#pragma mark - Private

- (void)deleteHistory:(SRMaintainHistory *)history {
    [SRUIUtil showLoadingHUDWithTitle:nil];
    SRMaintainRequestDeleteHistory *request = [[SRMaintainRequestDeleteHistory alloc] init];
    request.maintenReservationID = history.maintenReservationID;
    [SRMaintain deleteMaintainHistoryWithRequest:request andCompleteBlock:^(NSError *error, id responseObject) {
        [SRUIUtil dissmissLoadingHUD];
        if (error) {
            [SRUIUtil showAlertMessage:error.domain];
        } else {
            [self.historyList removeObject:history];
            [self.tableView reloadData];
        }
    }];
}

#pragma mark - Setter

- (void)setHistoryList:(NSMutableArray *)historyList {
    _historyList = historyList;
    [self.tableView reloadData];
}

@end

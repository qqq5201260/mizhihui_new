//
//  SRIntegralDetailViewController.m
//  Mizward
//
//  Created by zhangjunbo on 15/11/5.
//  Copyright © 2015年 Mizward. All rights reserved.
//

#import "SRIntegralDetailViewController.h"
#import "SRTableViewCell.h"
#import "SRPortal+User.h"
#import "SRPointRecordInfo.h"
#import "SRCustomer.h"
#import "SRUIUtil.h"
#import <MJRefresh/MJRefresh.h>

@interface SRIntegralDetailViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *lb_point;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

//@property (weak, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NSArray *records;

@end


@implementation SRIntegralDetailViewController

#pragma mark - 生命周期

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"积分详情";
    
    self.lb_point.text = [NSString stringWithFormat:@"%zd分", [SRPortal sharedInterface].customer.point];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self initViews];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
//    [self snapshortNavBar];
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
//    return 20.0f;
    return .0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    return indexPath.section==0?44.0f:60.0f;
    return 60.0f;
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
//    return 2;
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//    return section==0?1:self.records.count;
    return self.records.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
//    if (indexPath.section == 0) {
//        static NSString *CellIdentifier = @"Section0" ;
//        SRTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
//        if (cell == nil) {
//            cell = [[SRTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
//                                          reuseIdentifier:CellIdentifier];
//        }
//        
//        cell.textLabel.text = @"剩余积分";
//        cell.textLabel.font = [UIFont systemFontOfSize:16.0f];
//        UILabel *lb = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 40)];
//        lb.font = [UIFont systemFontOfSize:14.0f];
//        lb.textAlignment = NSTextAlignmentRight;
//        lb.textColor = [UIColor darkGrayColor];
//        lb.text = [NSString stringWithFormat:@"%zd分", [SRPortal sharedInterface].customer.point];
//        cell.accessoryView = lb;
//        
//        return cell;
//    } else {
        static NSString *CellIdentifier = @"Section1" ;
        SRTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[SRTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                          reuseIdentifier:CellIdentifier];
        }
        
        SRPointRecordInfo *info = self.records[indexPath.row];
        
        cell.textLabel.text = info.typeStr;
        cell.textLabel.font = [UIFont systemFontOfSize:14.0f];
        cell.detailTextLabel.text = info.createTime;
        cell.detailTextLabel.textColor = [UIColor darkGrayColor];
        cell.detailTextLabel.font = [UIFont systemFontOfSize:12.0f];
        
        UILabel *lb = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 40)];
        lb.font = [UIFont systemFontOfSize:15.0f];
        lb.textAlignment = NSTextAlignmentRight;
        lb.text = [NSString stringWithFormat:@"%@%zd分", info.updateType==SRPointRecordType_Add?@"+":@"-", info.pointUpdate];
        cell.accessoryView = lb;
        
        return cell;
//    }
}

#pragma mark - 交互操作


#pragma mark - Getter


#pragma mark - 私有方法

- (void)initViews
{
//    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero];
//    tableView.backgroundColor = [UIColor clearColor];
//    tableView.backgroundView.backgroundColor = [UIColor clearColor];
//    tableView.delegate = self;
//    tableView.dataSource = self;
//    tableView.allowsSelection = NO;
//    tableView.tableFooterView = [[UIView alloc] init];
//    [self.view addSubview:tableView];
//    [tableView makeConstraints:^(MASConstraintMaker *make) {
//        make.top.left.right.bottom.equalTo(self.view);
//    }];
//    
//    self.tableView = tableView;
    
    self.records = [NSArray array];
    
    self.tableView.backgroundView.backgroundColor = [UIColor clearColor];
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [SRPortal queryPointRecordIsRefresh:YES andCompleteBlock:^(NSError *error, id responseObject) {
            [self.tableView.mj_header endRefreshing];
            if (!error) {
                self.records = responseObject;
                [self.tableView reloadData];
            }
        }];
    }];
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [SRPortal queryPointRecordIsRefresh:NO andCompleteBlock:^(NSError *error, id responseObject) {
            [self.tableView.mj_footer endRefreshing];
            if (!error) {
                self.records = responseObject;
                [self.tableView reloadData];
            }
        }];
    }];
    self.tableView.mj_footer.hidden = YES;
    
    self.tableView.mj_header.state = MJRefreshStateRefreshing;
}

@end

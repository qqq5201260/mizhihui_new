//
//  SRTerminalManageViewController.m
//  Mizward
//
//  Created by zhangjunbo on 15/9/14.
//  Copyright (c) 2015年 Mizward. All rights reserved.
//

#import "SRTerminalManageViewController.h"
#import "SRTableViewCell.h"
#import "SRPortal.h"
#import "SRUIUtil.h"

@interface SRTerminalManageViewController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) NSArray *titles;
@property (strong, nonatomic) NSArray *titleDescriptions;

@end

@implementation SRTerminalManageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.title = SRLocal(@"title_terminal_manage");
    
    self.titles = @[SRLocal(@"title_terminal_bind"), SRLocal(@"title_terminal_change_add")];
    self.titleDescriptions = @[SRLocal(@"description_terminal_bind"), SRLocal(@"description_terminal_change_add")];
    
    
    self.tableView.backgroundView.backgroundColor = [UIColor clearColor];
    self.tableView.backgroundColor = [UIColor clearColor];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 15.0f;
    } else {
        return .0f;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 50.0f;
}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section
{
    view.tintColor = [UIColor defaultBackgroundColor];
}

- (void)tableView:(UITableView *)tableView willDisplayFooterView:(UIView *)view forSection:(NSInteger)section
{
    view.tintColor = [UIColor defaultBackgroundColor];
    
    UILabel *label = (UILabel *)[view viewWithTag:100];
    if (!label) {
        label = [[UILabel alloc] initWithFrame:CGRectZero];
        label.font = [UIFont systemFontOfSize:13.0f];
        label.tag = 100;
        label.textColor = [UIColor darkGrayColor];
        [view addSubview:label];
        [label makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(view).with.offset(10.0f);
            make.bottom.equalTo(view).with.offset(-10.0f);
            make.left.equalTo(view).with.offset(20.0f);
            make.right.equalTo(view).with.offset(-20.0f);
        }];
    }
    
    label.text = self.titleDescriptions[section];
    
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(SRTableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [cell setFisrtCell:indexPath.row==0
              lastCell:indexPath.row == [self tableView:tableView numberOfRowsInSection:indexPath.section]-1];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    return 44.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        [self performSegueWithIdentifier:@"PushSRTerminalBindViewController" sender:nil];
    } else {
        if ([SRPortal sharedInterface].allVehicles.count == 0) {
            [SRUIUtil showAlertMessage:@"请先绑定车辆"];
        } else {
            UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:SRLocal(@"nav_back")
                                                                     style:UIBarButtonItemStylePlain target:nil action:nil];
            self.navigationItem.backBarButtonItem = item;
            [self performSegueWithIdentifier:@"PushSRTerminalChangeOrAddViewController" sender:nil];
        }
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
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
    }
    
    cell.textLabel.text = self.titles[indexPath.section];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;

}

@end

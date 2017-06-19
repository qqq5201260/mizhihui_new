//
//  SRSettingsViewController.m
//  SiRuiV4.0
//
//  Created by zhangjunbo on 15/6/15.
//  Copyright (c) 2015年 SiRui. All rights reserved.
//

#import "SRSettingsViewController.h"
#import "SRUserDefaults.h"
#import "SRConfigViewController.h"
#import "SRPortal+Login.h"
#import "SRUIUtil.h"
#import "SRTableViewCell.h"
#import "SRCustomer.h"
#import "SRPortal+Message.h"
#import "SRDataBase+Customer.h"
#import "SRVehicleBasicInfo.h"
#import <KVOController/FBKVOController.h>

@interface SRSettingsViewController ()
{
    FBKVOController *kvoController;
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;
//@property (weak, nonatomic) IBOutlet UIButton *button;

@property (strong, nonatomic) NSArray *titles;
@property (strong, nonatomic) NSArray *titleImages;

@end

@implementation SRSettingsViewController

#pragma mark - 生命周期

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = SRLocal(@"nav_title_settings");
    
    NSString *loginLogout = [SRUserDefaults isLogin]?SRLocal(@"title_logout"):SRLocal(@"title_login_register");
    self.titles = @[@[SRLocal(@"title_order_start"), SRLocal(@"title_security_settings"), SRLocal(@"title_terminal_info"),  SRLocal(@"title_terminal_manage")],
                    @[SRLocal(@"title_message_center"), SRLocal(@"title_customer_service"), SRLocal(@"title_about")],
                    @[loginLogout]];
    
    self.titleImages = @[@[@"ic_order_start", @"ic_security_settings", @"ic_terminal_info", @"ic_terminal_manage"],
                         @[@"ic_message_center", @"ic_customer_service", @"ic_about"]];
    
    self.tableView.backgroundView.backgroundColor = [UIColor clearColor];
    self.tableView.backgroundColor = [UIColor clearColor];
    
    kvoController = [[FBKVOController alloc] initWithObserver:self];
    
    if ([SRUserDefaults isLogin]) {
        [self queryUnreadMessage];
    }
    
#if DEBUG
    [self addConfigButton];
#endif
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.tableView reloadData];
    [kvoController observe:[SRPortal sharedInterface].customer keyPaths:@[@"hasNewMessageInIm", @"hasNewMessageInAlert", @"hasNewMessageInRemind", @"hasNewMessageInFunction"] options:NSKeyValueObservingOptionNew block:^(id observer, id object, NSDictionary *change) {
        [self executeOnMain:^{
            [self.tableView reloadData];
        } afterDelay:0];
    }];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self snapshortNavBar];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [kvoController unobserveAll];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {

}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return section==0?15.0f:30.0f;
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1 && indexPath.row == 2) {
        
    } else if (![self checkLoginStatus]) {
        return;
    }
    
    if (indexPath.section == 0) {
        switch (indexPath.row) {
            case 0: //预约启动
                if ([SRPortal sharedInterface].allVehicles.count == 0) {
                    [SRUIUtil showAlertMessage:@"请先绑定车辆"];
                } else if ([SRPortal sharedInterface].currentVehicleBasicInfo.onlyPPKE) {
                    [SRUIUtil showAlertMessage:SRLocal(@"error_no_ost")];
                } else {
                    [self performSegueWithIdentifier:@"PushSROrderStartViewController" sender:nil];
                }
                break;
            case 1: //安全设置
                [self performSegueWithIdentifier:@"PushSRSecuritySettingsViewController" sender:nil];
                break;
            case 2: //终端资料
                if ([SRPortal sharedInterface].allVehicles.count == 0) {
                    [SRUIUtil showAlertMessage:@"请先绑定车辆"];
                } else {
                    [self performSegueWithIdentifier:@"PushSRTerminalInfoViewController" sender:nil];
                }
                break;
            case 3: //终端管理
//                if ([SRPortal sharedInterface].allVehicles.count == 0) {
//                    [SRUIUtil showAlertMessage:@"请先绑定车辆"];
//                } else {
                    [self performSegueWithIdentifier:@"PushSRTerminalManageViewController" sender:nil];
//                }
                break;
                
            default:
                break;
        }
        
    } else if (indexPath.section == 1) {
        switch (indexPath.row) {
            case 0: //消息中心
            {
                //本地清空未读消息条数
                [self performSegueWithIdentifier:@"PushSRMessageCenterViewController" sender:nil];
            }
                break;
            case 1: //咪智汇客服
            {
                [SRPortal sharedInterface].customer.hasNewMessageInIm = NO;
                [self performSegueWithIdentifier:@"PushSRCustomerServiceViewController" sender:nil];
            }
                break;
            case 2: //关于咪智汇
                [self performSegueWithIdentifier:@"PushSRAboutViewController" sender:nil];
                break;
                
            default:
                break;
        }
    } else {
        if ([SRUserDefaults isLogin]) {
            [SRPortal logoutWithCompleteBlock:nil];
            [SRUIUtil ModalSRLoginViewController];
        } else {
            [SRUIUtil ModalSRLoginViewController];
        }
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.titles[section] count];
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
    
    if (indexPath.section < 2) {
        cell.imageView.image = [UIImage imageNamed:self.titleImages[indexPath.section][indexPath.row]];
        
        cell.textLabel.text = self.titles[indexPath.section][indexPath.row];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    if (indexPath.section == 1 && (indexPath.row == 0 || indexPath.row == 1)) {
        
        UIView *badge = [cell.contentView viewWithTag:100];
        if (!badge) {
            CGSize size = [cell.textLabel.text sizeWithWidth:cell.textLabel.width font:cell.textLabel.font];
            CGSize badgeSize = CGSizeMake(10.0f, 10.0f);
            badge = [[UIView alloc] init];
            badge.tag = 100;
            badge.backgroundColor = [UIColor redColor];
            badge.layer.cornerRadius = badgeSize.width/2;
            [cell.textLabel addSubview:badge];
            [badge makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(cell.textLabel).with.offset(-badgeSize.height/2);
                make.left.equalTo(cell.textLabel).with.offset(size.width*1.1f);
                make.size.equalTo(badgeSize);
            }];
        }
        
        SRCustomer *customer = [SRPortal sharedInterface].customer;
        if (indexPath.row == 0) {
            badge.hidden = ![customer hasUnreadMessageInMessageCenter];
        } else {
            badge.hidden = !customer.hasNewMessageInIm;
        }
    } else if (indexPath.section == 2) {
        UILabel *lb = (UILabel *)[cell.contentView viewWithTag:100];
        if (!lb) {
            lb = [[UILabel alloc] initWithFrame:CGRectZero];
            lb.tag = 100;
            [cell.contentView addSubview:lb];
            [lb makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.bottom.top.equalTo(cell.contentView);
            }];
        }
        
        lb.textColor = [SRUserDefaults isLogin]?[UIColor redColor]:[UIColor defaultColor];
        lb.textAlignment = NSTextAlignmentCenter;
        
        NSString *loginLogout = [SRUserDefaults isLogin]?SRLocal(@"title_logout"):SRLocal(@"title_login_register");
        lb.text = loginLogout;
    }
    
    return cell;
}

#pragma mark - 交互事件

- (IBAction)buttonLoginLogoutPressed:(id)sender {
    if ([SRUserDefaults isLogin]) {
        [SRPortal logoutWithCompleteBlock:nil];
        [SRUIUtil popToRootViewControllerAnimated:YES];
    } else {
        [SRUIUtil ModalSRLoginViewController];
    }
}

#pragma mark - 私有方法

- (void)queryUnreadMessage
{
    [SRPortal queryMessageUnreadCountWithCompleteBlock:^(NSError *error, id responseObject) {
        if (!error) {
            [self.tableView reloadData];
        }
    }];
}

#pragma mark - DEBUG

- (void)addConfigButton {
    UIBarButtonItem *configItem = [[UIBarButtonItem alloc] bk_initWithTitle:@"配置" style:UIBarButtonItemStyleDone handler:^(id sender) {
        SRConfigViewController *vc = [[SRConfigViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }];
    
    self.navigationItem.rightBarButtonItem = configItem;
}



@end

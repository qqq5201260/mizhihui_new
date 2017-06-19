//
//  SRSecuritySettingsViewController.m
//  SiRuiV4.0
//
//  Created by zhangjunbo on 15/6/15.
//  Copyright (c) 2015年 SiRui. All rights reserved.
//

#import "SRSecuritySettingsViewController.h"
#import "SRConfigViewController.h"
#import "SRKeychain.h"
#import "SRUIUtil.h"
#import "SRPortal+User.h"
#import "SRPortal+Login.h"
#import "SRCustomer.h"
#import "SRUserDefaults.h"
#import "SRPortalRequest.h"
#import "SRTableViewCell.h"
#import "SRVehicleBasicInfo.h"
#import <KVOController/FBKVOController.h>

@interface SRSecuritySettingsViewController ()
{
    FBKVOController *kvoController;
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) NSArray *titles;

@end

@implementation SRSecuritySettingsViewController

#pragma mark - 生命周期

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = SRLocal(@"title_security_settings");
    
    kvoController = [[FBKVOController alloc] initWithObserver:self];
    
    self.tableView.backgroundView.backgroundColor = [UIColor clearColor];
    self.tableView.backgroundColor = [UIColor clearColor];
    
#if DEBUG
    [self addConfigButton];
#endif
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [kvoController observe:[SRPortal sharedInterface].customer keyPaths:@[@"bindingStatus"] options:NSKeyValueObservingOptionNew block:^(id observer, id object, NSDictionary *change) {
        [self executeOnMain:^{
            [self.tableView reloadData];
        } afterDelay:0];
    }];
    
    [self.tableView reloadData];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [kvoController unobserveAll];
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return section==0||section==4?15.0f:0.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 0 || section == 2) {
        return 20.0f;
    } else if (section == 1) {
        return 50.0f;
    } else {
        return 50.0f;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44.0f;
}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section
{
    view.tintColor = [UIColor defaultBackgroundColor];
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.width, [self tableView:tableView heightForFooterInSection:section])];
    view.tintColor = [UIColor defaultBackgroundColor];
    if (section == 1) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, SCREEN_WIDTH-20, 50.0f)];
        label.backgroundColor = [UIColor clearColor];
        label.textColor = [UIColor lightGrayColor];
        label.text = SRLocal(@"description_avoid_password");
        label.font = [UIFont systemFontOfSize:13.0f];
        label.numberOfLines = 0;
        
        [view addSubview:label];
        [label makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(view).with.offset(20.0f);
            make.top.equalTo(view).with.offset(10.0f);
            make.right.equalTo(view).with.offset(-20.0f);
        }];
        
    } else if (section == 3) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, SCREEN_WIDTH-20, 50.0f)];
        label.backgroundColor = [UIColor clearColor];
        label.textColor = [UIColor lightGrayColor];
        label.text = SRLocal(@"description_bind");
        label.font = [UIFont systemFontOfSize:13.0f];
        label.numberOfLines = 0;
        
        [view addSubview:label];
        [label makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(view).with.offset(20.0f);
            make.top.equalTo(view).with.offset(10.0f);
            make.right.equalTo(view).with.offset(-20.0f);
        }];
    }
    
    return view;
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
    if (indexPath.section == 0) {
        
        if (![self checkLoginStatus]) return;
        
        switch (indexPath.row) {
            case 0:
            {
                if ([[SRPortal sharedInterface].customer hasPermissionWithType:SRPermissionType_Phone]) {
                    //更改手机号
                    UIViewController *vc = [SRUIUtil SRModifyPhoneViewController];
                    [self.navigationController pushViewController:vc animated:YES];
                } else if ([[SRPortal sharedInterface].customer hasPermissionWithType:SRPermissionType_NamePassword]) {
                    //更改用户名
                    UIViewController *vc = [SRUIUtil SRModifyUserNameViewController];
                    [self.navigationController pushViewController:vc animated:YES];
                } else {
                    //实名认证
                    UIViewController *vc = [SRUIUtil SRAuthenticateViewController];
                    [self.navigationController pushViewController:vc animated:YES];
                }
            }
                break;
            case 1:
            {
                if ([[SRPortal sharedInterface].customer hasPermissionWithType:SRPermissionType_NamePassword]) {
                    if ([[SRPortal sharedInterface].customer hasPermissionWithType:SRPermissionType_Phone]) {
                        //更改用户名
                        UIViewController *vc = [SRUIUtil SRModifyUserNameViewController];
                        [self.navigationController pushViewController:vc animated:YES];
                    } else {
                        //更改密码
                        UIViewController *vc = [SRUIUtil SRModifyPasswordViewController];
                        [self.navigationController pushViewController:vc animated:YES];
                    }
                } else {
                    //实名认证
                    UIViewController *vc = [SRUIUtil SRAuthenticateViewController];
                    [self.navigationController pushViewController:vc animated:YES];
                }
            }
                break;
            case 2:
            {
                if ([[SRPortal sharedInterface].customer hasPermissionWithType:SRPermissionType_NamePassword]) {
                    //更改密码
                    UIViewController *vc = [SRUIUtil SRModifyPasswordViewController];
                    [self.navigationController pushViewController:vc animated:YES];
                } else {
                    //实名认证
                    UIViewController *vc = [SRUIUtil SRAuthenticateViewController];
                    [self.navigationController pushViewController:vc animated:YES];
                }
            }
                break;
            case 3: //实名认证
            {
                UIViewController *vc = [SRUIUtil SRAuthenticateViewController];
                [self.navigationController pushViewController:vc animated:YES];
            }
                break;
                
            default:
                break;
        }
        
    } else if (indexPath.section == 1) {
        //密码验证
        if (![self checkLoginStatus]) return;
        
    } else if (indexPath.section == 2) {
        
        if (![self checkLoginStatus]) return;
        
        switch (indexPath.row) {
            case 0: //轨迹管理
            {
                if ([SRPortal sharedInterface].currentVehicleBasicInfo.onlyPPKE) {
                    [SRUIUtil showAlertMessage:SRLocal(@"error_no_ost")];
                } else {
                    UIViewController *vc = [SRUIUtil SRTripHiddenViewController];
                    [self.navigationController pushViewController:vc animated:YES];
                }
            }
                break;
            case 1: //诊断设置
            {
                if ([SRPortal sharedInterface].currentVehicleBasicInfo.onlyPPKE) {
                    [SRUIUtil showAlertMessage:SRLocal(@"error_no_ost")];
                } else {
                    UIViewController *vc = [SRUIUtil SROBDConfigViewController];
                    [self.navigationController pushViewController:vc animated:YES];
                }
            }
                break;
//            case 2: //防骚扰设置
//            {
//                UIViewController *vc = [SRUIUtil SRHarassSettingViewController];
//                [self.navigationController pushViewController:vc animated:YES];
//            }
                break;
                
            default:
                break;
        }
    } else if (indexPath.section == 3)  {
        //手机绑定
        if (![self checkLoginStatus]) return;
    } else {
        //登陆注销
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
    if (section < self.titles.count) {
        return [self.titles[section] count];
    } else {
        return 1;
    }
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.titles.count+1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CellIdentifier" ;
    SRTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[SRTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:CellIdentifier];
        
        UILabel *detail = [[UILabel alloc] initWithFrame:CGRectZero];
        detail.textAlignment = NSTextAlignmentRight;
        detail.textColor = [UIColor lightGrayColor];
        detail.font = [UIFont systemFontOfSize:12.0f];
        detail.tag = 100;
        [cell.contentView addSubview:detail];
        [detail makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(cell.contentView).with.offset(50.0f);
            make.right.equalTo(cell.contentView);
            make.height.centerY.equalTo(cell.contentView);
        }];
        
        UILabel *login = [[UILabel alloc] initWithFrame:CGRectZero];
        login.textAlignment = NSTextAlignmentCenter;
        login.tag = 101;
        login.backgroundColor = [UIColor clearColor];
        [cell.contentView addSubview:login];
        [login makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.top.equalTo(cell.contentView);
        }];
    }
    
    cell.textLabel.text = indexPath.section<self.titles.count?self.titles[indexPath.section][indexPath.row]:nil;
    UILabel *detail = (UILabel *)[cell.contentView viewWithTag:100];
    UILabel *login = (UILabel *)[cell.contentView viewWithTag:101];
    login.text = nil;
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    if (indexPath.section == 0) {
        switch (indexPath.row) {
            case 0:
            {
                //更改手机号
                if ([[SRPortal sharedInterface].customer hasPermissionWithType:SRPermissionType_Phone]) {
                    detail.text = [SRUserDefaults isLogin]?[SRPortal sharedInterface].customer.customerPhone.encodePhoneNumber:nil;
                } else if ([[SRPortal sharedInterface].customer hasPermissionWithType:SRPermissionType_NamePassword]) {
                    //更改用户名
                    detail.text = [SRUserDefaults isLogin]?[SRKeychain UserName]:nil;
                } else {
                    //实名认证
                    SRCustomer *customer = [SRPortal sharedInterface].customer;
                    if (customer.realNameAuthentication == AuthenticationStatus_WaitForUpload) {
                        detail.text = @"未认证";
                    } else if (customer.realNameAuthentication == AuthenticationStatus_InReview) {
                        detail.text = @"审核中";
                    } else if (customer.realNameAuthentication == AuthenticationStatus_Approved) {
                        detail.text = @"审核通过";
                    } else {
                        detail.text = @"未通过审核";
                    }
                }
            }
                break;
            case 1:
            {
                if ([[SRPortal sharedInterface].customer hasPermissionWithType:SRPermissionType_NamePassword]) {
                    if ([[SRPortal sharedInterface].customer hasPermissionWithType:SRPermissionType_Phone]) {
                        //更改用户名
                        detail.text = [SRUserDefaults isLogin]?[SRKeychain UserName]:nil;
                    } else {
                        //更改密码
                        detail.text = nil;
                    }
                    
                } else {
                    //实名认证
                    SRCustomer *customer = [SRPortal sharedInterface].customer;
                    if (customer.realNameAuthentication == AuthenticationStatus_WaitForUpload) {
                        detail.text = @"未认证";
                    } else if (customer.realNameAuthentication == AuthenticationStatus_InReview) {
                        detail.text = @"审核中";
                    } else if (customer.realNameAuthentication == AuthenticationStatus_Approved) {
                        detail.text = @"审核通过";
                    } else {
                        detail.text = @"未通过审核";
                    }
                }
            }
                break;
            case 2:
                if ([[SRPortal sharedInterface].customer hasPermissionWithType:SRPermissionType_NamePassword]) {
                    //更改密码
                    detail.text = nil;
                } else {
                    //实名认证
                    SRCustomer *customer = [SRPortal sharedInterface].customer;
                    if (customer.realNameAuthentication == AuthenticationStatus_WaitForUpload) {
                        detail.text = @"未认证";
                    } else if (customer.realNameAuthentication == AuthenticationStatus_InReview) {
                        detail.text = @"审核中";
                    } else if (customer.realNameAuthentication == AuthenticationStatus_Approved) {
                        detail.text = @"审核通过";
                    } else {
                        detail.text = @"未通过审核";
                    }
                }
                break;
            case 3: //实名认证
            {
                SRCustomer *customer = [SRPortal sharedInterface].customer;
                if (customer.realNameAuthentication == AuthenticationStatus_WaitForUpload) {
                    detail.text = @"未认证";
                } else if (customer.realNameAuthentication == AuthenticationStatus_InReview) {
                    detail.text = @"审核中";
                } else if (customer.realNameAuthentication == AuthenticationStatus_Approved) {
                    detail.text = @"审核通过";
                } else {
                    detail.text = @"未通过审核";
                }
            }
                break;
                
            default:
                break;
        }
        
    } else if (indexPath.section == 1) {
        
        UISwitch *sw = [[UISwitch alloc] initWithFrame:CGRectMake(0, 0, 50, 30)];
        sw.onTintColor = [UIColor defaultColor];
        cell.accessoryView = sw;
        
        if (indexPath.row == 0 && [SRUIUtil TouchIDAuthorization]) {
            //TouchID
            sw.userInteractionEnabled = [SRUserDefaults isLogin];
            sw.on = [SRUserDefaults isTouchIDOpen];
            [sw bk_addEventHandler:^(UISwitch *sender) {
//                if (sender.on) {
//                    [SRUserDefaults updateTouchID:YES];
//                    [SRUIUtil showAutoDisappearHUDWithMessage:@"TouchID已开启"
//                                                     isDetail:NO];
//                } else {
//                    [SRUIUtil showPasswordInputAlertWithTitle:@"请输入密码" andConfirmBlock:^{
//                        [SRUserDefaults updateTouchID:NO];
//                        sender.on = NO;
//                        [SRUIUtil showAutoDisappearHUDWithMessage:@"TouchID已关闭"
//                                                         isDetail:NO];
//                    } cancelBlock:^{
//                        [SRUserDefaults updateTouchID:YES];
//                        sender.on = YES;
//                    }];
//                }
                
                [SRUIUtil showPasswordInputAlertWithTitle:@"请输入密码" andConfirmBlock:^{
                    [SRUserDefaults updateTouchID:sender.on];
                    [SRUIUtil showAutoDisappearHUDWithMessage:[NSString stringWithFormat:@"TouchID已%@", sender.on?@"开启":@"关闭"]
                                                     isDetail:NO];
                } cancelBlock:^{
                    sender.on ^= 1;
                }];
                
            } forControlEvents:UIControlEventValueChanged];
        } else {
            //密码验证
            sw.userInteractionEnabled = [SRUserDefaults isLogin];
            sw.on = ![SRUserDefaults passwordAvoidStatus];
            [sw bk_addEventHandler:^(UISwitch *sender) {
                if (sender.on) {
                    [SRUserDefaults updatePasswrodAvoidStatus:NO];
                    [SRUIUtil showAutoDisappearHUDWithMessage:@"密码验证已开启"
                                                     isDetail:NO];
                } else {
                    [SRUIUtil showPasswordInputAlertWithTitle:@"请输入密码" andConfirmBlock:^{
                        [SRUserDefaults updatePasswrodAvoidStatus:YES];
                        sender.on = NO;
                        [SRUIUtil showAutoDisappearHUDWithMessage:@"密码验证已关闭"
                                                         isDetail:NO];
                    } cancelBlock:^{
                        [SRUserDefaults updatePasswrodAvoidStatus:NO];
                        sender.on = YES;
                    }];
                }
                
            } forControlEvents:UIControlEventValueChanged];
        }
        
    } else if (indexPath.section == 2) {
        switch (indexPath.row) {
            case 0: //隐藏行踪
                detail.text = nil;
                break;
            case 1:
                break;
//            case 2: //防骚扰设置
//                detail.text = [SRUserDefaults isLogin]?@"开启":nil;
//                break;
                
            default:
                break;
        }
    } else if (indexPath.section == 3) {
        //手机绑定
        UISwitch *sw = [[UISwitch alloc] initWithFrame:CGRectMake(0, 0, 50, 30)];
        sw.onTintColor = [UIColor defaultColor];
        cell.accessoryView = sw;
        sw.userInteractionEnabled = [SRUserDefaults isLogin];
        sw.on = [SRUserDefaults isLogin]?[SRPortal sharedInterface].customer.bindingStatus!=SRBindingStatus_Unbind:NO;
        [sw bk_addEventHandler:^(id sender) {
            
            if (![SRUserDefaults isLogin]) {
                sw.on ^= 1;
                [SRUIUtil ModalSRLoginViewController];
                return ;
            } else if ([self checkExperienceUserStatus]) {
                sw.on ^= 1;
                return ;
            } else if ([SRPortal sharedInterface].customer.bindingStatus == SRBindingStatus_Bind_Others) {
                sw.on ^= 1;
                [SRUIUtil showAlertMessage:SRLocal(@"alert_bind_others")];
                return;
            }
            
            [SRUIUtil showLoadingHUDWithTitle:nil];
            [SRPortal updateBindStatus:[SRPortal sharedInterface].customer.bindingStatus == SRBindingStatus_Unbind withCompleteBlock:^(NSError *error, id responseObject) {
                [SRUIUtil dissmissLoadingHUD];
                if (error) {
                    [SRUIUtil showAlertMessage:error.domain];
                    sw.on ^= 1;
                } else {
                    [SRUIUtil showAutoDisappearHUDWithMessage:[NSString stringWithFormat:@"手机绑定已%@", sw.on?@"开启":@"关闭"]
                                                     isDetail:NO];
                }
            }];
        } forControlEvents:UIControlEventValueChanged];
    } else {
        detail.text = nil;
        cell.accessoryType = UITableViewCellAccessoryNone;
        login.textColor = [SRUserDefaults isLogin]?[UIColor redColor]:[UIColor defaultColor];
        login.text = [SRUserDefaults isLogin]?SRLocal(@"title_logout"):SRLocal(@"title_login_register");
    }
    
    return cell;
}

#pragma mark - 交互事件

#pragma mark - Private


#pragma mark Getter

- (NSArray *)titles {
    if (!_titles) {

        NSMutableArray *section0 = [NSMutableArray array];
        if ([[SRPortal sharedInterface].customer hasPermissionWithType:SRPermissionType_Phone]) {
            [section0 addObject:SRLocal(@"title_modify_phone")];
        }
        
        if ([[SRPortal sharedInterface].customer hasPermissionWithType:SRPermissionType_NamePassword]) {
            [section0 addObjectsFromArray:@[SRLocal(@"title_modify_userName"), SRLocal(@"title_modify_password")]];
        }
        
        [section0 addObject:SRLocal(@"title_authenticate")];
        
        NSMutableArray *section1 = [NSMutableArray array];
        if ([SRUIUtil TouchIDAuthorization]) {
            [section1 addObject:SRLocal(@"title_touchid")];
        }
        [section1 addObject:SRLocal(@"title_avoid_password")];
        
        _titles = @[section0,
                    section1,
                    @[SRLocal(@"title_trip_hidden"), SRLocal(@"title_obd")],
                    @[SRLocal(@"title_bind")]];
    }
    
    return _titles;
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

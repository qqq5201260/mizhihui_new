//
//  SRPasswordResetViewController.m
//  SiRuiV4.0
//
//  Created by zhangjunbo on 15/7/9.
//  Copyright (c) 2015年 SiRui. All rights reserved.
//

#import "SRPasswordResetViewController.h"
#import "SRTableViewCell.h"
#import "SRUIUtil.h"
#import "SRPortal+Regist.h"
#import "SRPortalRequest.h"

@interface SRPasswordResetViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *bt_done;

@property (weak, nonatomic) UITextField *tx_password;

@property (strong, nonatomic) NSArray *titles;
@property (strong, nonatomic) NSArray *placeHolders;

@end

@implementation SRPasswordResetViewController
{
    BOOL hasAddRACObserver;
}

#pragma mark - 生命周期

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.title = @"找回密码";
    
    self.tableView.backgroundView.backgroundColor = [UIColor clearColor];
    self.tableView.backgroundColor = [UIColor clearColor];
    
    [self.bt_done setTitle:@"完成" forState:UIControlStateNormal];
    self.bt_done.layer.cornerRadius = 5.0f;
    RAC(self.bt_done, backgroundColor) = [RACSignal combineLatest:@[RACObserve(self.bt_done, enabled)] reduce:^(NSNumber *enabled){
        return enabled.boolValue?[UIColor defaultColor]:[UIColor disableColor];
    }];
    self.bt_done.enabled = NO;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self initRAC];
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 50.0f;
}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section
{
    view.tintColor = [UIColor defaultBackgroundColor];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
    label.font = [UIFont systemFontOfSize:13.0f];
    label.text = @"验证成功，请输入新密码";
    label.textColor = [UIColor darkGrayColor];
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
    }
    
    cell.textLabel.text = self.titles[indexPath.row];
    
    UITextField *tx = [[UITextField alloc] initWithFrame:CGRectZero];
    tx.tag = 100;
    tx.font = [UIFont systemFontOfSize:15.0f];
    [cell.contentView addSubview:tx];
    [tx makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(cell.contentView).with.offset(100.0f);
        make.right.equalTo(cell.contentView).with.offset(-10.0f);
        make.top.bottom.equalTo(cell.contentView);
    }];
    self.tx_password = tx;
    self.tx_password.secureTextEntry = YES;
    self.tx_password.placeholder = self.placeHolders[indexPath.row];
    self.tx_password.keyboardType = UIKeyboardTypeNumberPad;
    
    UIButton *bt_encrypted = [[UIButton alloc] initWithFrame:CGRectMake(.0f, .0f, cell.height, cell.height)];
    [bt_encrypted setImage:[UIImage imageNamed:@"ic_encrypted"] forState:UIControlStateNormal];
    [bt_encrypted setImage:[UIImage imageNamed:@"ic_unencrypted"] forState:UIControlStateSelected];
    [bt_encrypted bk_whenTapped:^{
        bt_encrypted.selected ^= 1;
        self.tx_password.secureTextEntry ^= 1;
    }];
    
    cell.accessoryView = bt_encrypted;
    
    return cell;
}

#pragma mark - 交互操作

- (IBAction)buttonDonePressed:(id)sender {
    [SRUIUtil showLoadingHUDWithTitle:nil];
    SRPortalRequestResetPassword *request = [[SRPortalRequestResetPassword alloc] init];
    request.phone = self.phone;
    request.authCode = self.authCode;
    request.password = self.tx_password.text;
    [SRPortal resetPasswordWithRequest:request andCompleteBlock:^(NSError *error, id responseObject) {
        [SRUIUtil dissmissLoadingHUD];
        if (error) {
            [SRUIUtil showAlertMessage:error.domain];
        } else {
            [SRUIUtil showAutoDisappearHUDWithMessage:@"密码已重置" isDetail:NO];
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
    }];
}

#pragma mark - 私有方法

- (void)initRAC {
    
    self.bt_done.enabled = self.tx_password.text.length>0;
    
    if (hasAddRACObserver) return;
    
    hasAddRACObserver = YES;
    RAC(self.bt_done, enabled) = [RACSignal combineLatest:@[self.tx_password.rac_textSignal]
                                                   reduce:^(NSString *password){
                                                       return @(password.length>0);
                                                   }];
}

#pragma mark - Getter

- (NSArray *)titles
{
    if (_titles) {
        return _titles;
    }
    
    _titles = @[@"新密码"];
    return _titles;
}

- (NSArray *)placeHolders {
    if (_placeHolders) {
        return _placeHolders;
    }
    
    _placeHolders = @[@"请填写您的新密码"];
    
    return _placeHolders;
}


@end

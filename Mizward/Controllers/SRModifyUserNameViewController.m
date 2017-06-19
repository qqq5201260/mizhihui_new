//
//  SRModifyUserNameViewController.m
//  SiRuiV4.0
//
//  Created by zhangjunbo on 15/6/24.
//  Copyright (c) 2015年 SiRui. All rights reserved.
//

#import "SRModifyUserNameViewController.h"
#import "SRPortal+User.h"
#import "SRCustomer.h"
#import "SRTableViewCell.h"
#import "SRUIUtil.h"
#import "SRPortalRequest.h"

@interface SRModifyUserNameViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *bt_done;

@property (weak, nonatomic) UITextField *tx_userName;

@end

@implementation SRModifyUserNameViewController
{
    BOOL hasAddRACObserver;
}

#pragma mark - 生命周期

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = SRLocal(@"title_modify_userName");
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.backgroundView.backgroundColor = [UIColor clearColor];
    
    self.bt_done.layer.cornerRadius = 5.0f;
    [self.bt_done setTitle:SRLocal(@"bt_done") forState:UIControlStateNormal];
    RAC(self.bt_done, backgroundColor) = [RACSignal combineLatest:@[RACObserve(self.bt_done, enabled)] reduce:^(NSNumber *enabled){
        return enabled.boolValue?[UIColor defaultColor]:[UIColor disableColor];
    }];
    self.bt_done.enabled = NO;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self initRAC];
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 50.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44.0f;
}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section
{
    view.tintColor = [UIColor defaultBackgroundColor];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
    label.font = [UIFont systemFontOfSize:13.0f];
    label.text = [NSString stringWithFormat:@"当前用户名：%@", [SRPortal sharedInterface].customer.customerUserName];
    label.textColor = [UIColor darkGrayColor];
    [view addSubview:label];
    [label makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(view).with.offset(10.0f);
        make.left.equalTo(view).with.offset(20.0f);
        make.right.equalTo(view).with.offset(20.0f);
        make.bottom.equalTo(view).with.offset(-10.0f);
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
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CellIdentifier" ;
    SRTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[SRTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:CellIdentifier];
    }
    
    UITextField *tx = [[UITextField alloc] initWithFrame:CGRectZero];
    tx.tag = 100;
    tx.font = [UIFont systemFontOfSize:15.0f];
    tx.placeholder = @"请输入用户名";
    [cell.contentView addSubview:tx];
    [tx makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(cell.contentView).with.offset(20.0f);
        make.right.equalTo(cell.contentView).with.offset(-10.0f);
        make.top.bottom.equalTo(cell.contentView);
    }];
    
    self.tx_userName = tx;
    
    return cell;
}


#pragma mark - 交互操作

- (IBAction)buttonDonePressed:(id)sender {

    [SRUIUtil endEditing];
    
    [SRUIUtil showPasswordInputAlertWithTitle:@"为保障账户安全，请输入密码" andConfirmBlock:^{
        [SRUIUtil showLoadingHUDWithTitle:nil];
        SRPortalRequestModifyUserRecord *request = [[SRPortalRequestModifyUserRecord alloc] initWithCustomer:[SRPortal sharedInterface].customer];
        request.customerUserName = [self.tx_userName.text stringByReplacingOccurrencesOfString:@" " withString:@""];
        [SRPortal modifyUserRecordWithRequest:request andCompleteBlock:^(NSError *error, id responseObject) {
            [SRUIUtil dissmissLoadingHUD];
            if (error) {
                [SRUIUtil showAlertMessage:error.domain];
            } else {
                [self.navigationController popViewControllerAnimated:YES];
                [SRUIUtil showAutoDisappearHUDWithMessage:@"修改成功" isDetail:NO];
            }
        }];
    }];
}

#pragma mark - 私有方法

- (void)initRAC
{
    self.bt_done.enabled = self.tx_userName.text.length>0;
    
    if (hasAddRACObserver) return;
    
    hasAddRACObserver = YES;
    RAC(self.bt_done, enabled) = [RACSignal combineLatest:@[self.tx_userName.rac_textSignal]
                                                   reduce:^(NSString *userName){
                                                       return @(userName.length>0);
                                                   }];
}

@end

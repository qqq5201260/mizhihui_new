//
//  SRModifyPasswordViewController.m
//  SiRuiV4.0
//
//  Created by zhangjunbo on 15/6/24.
//  Copyright (c) 2015年 SiRui. All rights reserved.
//

#import "SRModifyPasswordViewController.h"
#import "SRTableViewCell.h"
#import "SRPortalRequest.h"
#import "SRPortal+User.h"
#import "SRUIUtil.h"
#import "SRKeychain.h"

@interface SRModifyPasswordViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *bt_done;

@property (weak, nonatomic) UITextField *tx_old;
@property (weak, nonatomic) UITextField *tx_new;

@property (strong, nonatomic) NSArray *titles;
@property (strong, nonatomic) NSArray *placeHolders;

@end

@implementation SRModifyPasswordViewController
{
    BOOL hasAddRACObserver;
}

#pragma mark - 生命周期

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = SRLocal(@"title_modify_password");
    
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
    label.text = [NSString stringWithFormat:@"修改密码涉及账号安全，请输入旧密码"];
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
    return self.titles.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CellIdentifier" ;
    SRTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[SRTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:CellIdentifier];
        UITextField *tx = [[UITextField alloc] initWithFrame:CGRectZero];
        tx.tag = 100;
        tx.font = [UIFont systemFontOfSize:15.0f];
        tx.placeholder = self.placeHolders[indexPath.row];
        [cell.contentView addSubview:tx];
        [tx makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(cell.contentView).with.offset(100.0f);
            make.right.equalTo(cell.contentView);
            make.top.bottom.equalTo(cell.contentView);
        }];
        
        UIButton *bt_encrypted = [[UIButton alloc] initWithFrame:CGRectMake(.0f, .0f, cell.height, cell.height)];
        [bt_encrypted setImage:[UIImage imageNamed:@"ic_encrypted"] forState:UIControlStateNormal];
        [bt_encrypted setImage:[UIImage imageNamed:@"ic_unencrypted"] forState:UIControlStateSelected];
        cell.accessoryView = bt_encrypted;
    }
    
    cell.textLabel.text = self.titles[indexPath.row];
    
    UITextField *tx = (UITextField *)[cell.contentView viewWithTag:100];
    
    UIButton *bt_encrypted = (UIButton *)cell.accessoryView;
    
    if (indexPath.row == 0) {
        self.tx_old = tx;
        self.tx_old.keyboardType = [SRKeychain Password].isNumber?UIKeyboardTypeNumberPad:UIKeyboardTypeDefault;
        self.tx_old.secureTextEntry = YES;
        [bt_encrypted bk_whenTapped:^{
            bt_encrypted.selected ^= 1;
            self.tx_old.secureTextEntry ^= 1;
        }];
    } else {
        self.tx_new = tx;
        self.tx_new.keyboardType = UIKeyboardTypeNumberPad;
        self.tx_new.secureTextEntry = NO;
        bt_encrypted.selected = YES;
        [bt_encrypted bk_whenTapped:^{
            bt_encrypted.selected ^= 1;
            self.tx_new.secureTextEntry ^= 1;
        }];
    }
    
    return cell;
}


#pragma mark - 交互操作

- (IBAction)buttonDonePressed:(id)sender {
    
    [SRUIUtil showLoadingHUDWithTitle:nil];
    SRPortalRequestModifyUserRecord *request = [[SRPortalRequestModifyUserRecord alloc] initWithCustomer:[SRPortal sharedInterface].customer];
    request.customerPassword = self.tx_new.text;
    [SRPortal modifyUserRecordWithRequest:request andCompleteBlock:^(NSError *error, id responseObject) {
        [SRUIUtil dissmissLoadingHUD];
        if (error) {
            [SRUIUtil showAlertMessage:error.domain];
        } else {
            [self.navigationController popViewControllerAnimated:YES];
            [SRUIUtil showAutoDisappearHUDWithMessage:@"修改成功" isDetail:NO];
        }
    }];
}

#pragma mark - 私有方法

- (void)initRAC
{
    self.bt_done.enabled = self.tx_old.text.length>0
                            && [self.tx_old.text isEqualToString:[SRKeychain Password]]
                            && self.tx_new.text.length>0;
    
    if (hasAddRACObserver) return;
    
    hasAddRACObserver = YES;
    RAC(self.bt_done, enabled) = [RACSignal combineLatest:@[self.tx_old.rac_textSignal,
                                                            self.tx_new.rac_textSignal]
                                                   reduce:^(NSString *old, NSString *new){
                                                       return @(old.length>0 && [old isEqualToString:[SRKeychain Password]]
                                                       && new.length>0);
                                                   }];
}

#pragma mark - Getter

- (NSArray *)titles {
    if (!_titles) {
        _titles = @[@"旧密码", @"新密码"];
    }
    
    return _titles;
}

- (NSArray *)placeHolders {
    if (!_placeHolders) {
        _placeHolders = @[@"请输入旧密码", @"请输入新密码"];
    }
    
    return _placeHolders;
}

@end

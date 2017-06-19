//
//  SRAuthenticateViewController.m
//  SiRuiV4.0
//
//  Created by zhangjunbo on 15/6/24.
//  Copyright (c) 2015年 SiRui. All rights reserved.
//

#import "SRAuthenticateViewController.h"
#import "SRTableViewCell.h"
#import "SRPortalRequest.h"
#import "SRUIUtil.h"
#import "SRPortal+User.h"
#import "SRCustomer.h"

@interface SRAuthenticateViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableViewConstraintsHeight;

@property (weak, nonatomic) IBOutlet UIButton *bt_done;

@property (weak, nonatomic) UITextField *tx_name;
@property (weak, nonatomic) UITextField *tx_IDNumber;

@property (strong, nonatomic) NSArray *placeHolders;
@property (strong, nonatomic) NSArray *titles;
@property (copy, nonatomic) NSString *defaultString;

@property (strong, nonatomic) SRCustomer *customer;

@end

@implementation SRAuthenticateViewController
{
    BOOL hasAddRACObserver;
}

#pragma mark - 生命周期

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = SRLocal(@"title_authenticate");
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.backgroundView.backgroundColor = [UIColor clearColor];
    
    self.bt_done.layer.cornerRadius = 5.0f;
    [self.bt_done setTitle:SRLocal(@"bt_done") forState:UIControlStateNormal];
    RAC(self.bt_done, backgroundColor) = [RACSignal combineLatest:@[RACObserve(self.bt_done, enabled)] reduce:^(NSNumber *enabled){
        return enabled.boolValue?[UIColor defaultColor]:[UIColor disableColor];
    }];
    self.bt_done.enabled = NO;

    self.customer = [SRPortal sharedInterface].customer;
    
    if (self.customer.realNameAuthentication == AuthenticationStatus_InReview
        || self.customer.realNameAuthentication == AuthenticationStatus_Approved) {
        self.bt_done.hidden = YES;
        self.tableViewConstraintsHeight.constant = 288.0f;
    } else if (self.customer.realNameAuthentication == AuthenticationStatus_Rejected) {
        [self.bt_done setTitle:@"重新提交" forState:UIControlStateNormal];
        [self.bt_done setBackgroundColor:[UIColor redColor]];
        self.tableViewConstraintsHeight.constant = 288.0f;
    } else {
        [self.bt_done setTitle:SRLocal(@"bt_done") forState:UIControlStateNormal];
        [self.bt_done setBackgroundColor:[UIColor defaultColor]];
        self.tableViewConstraintsHeight.constant = 138.0f;
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self initRAC];
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return self.customer.realNameAuthentication==AuthenticationStatus_WaitForUpload?50.0f:200.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44.0f;
}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section
{
    view.tintColor = [UIColor defaultBackgroundColor];
    
    if (self.customer.realNameAuthentication!=AuthenticationStatus_WaitForUpload) {
        NSString *imageName = [NSString stringWithFormat:@"ic_authentication_%zd", self.customer.realNameAuthentication];
        UIImageView *image = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imageName]];
        [view addSubview:image];
        [image makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(view);
            make.centerY.equalTo(view).with.offset(-10.0f);
            make.size.equalTo(CGSizeMake(140.0f, 160.0f));
        }];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
        label.text = self.defaultString;
        label.textColor = [UIColor darkGrayColor];
        label.font = [UIFont systemFontOfSize:13.0f];
        label.textAlignment = NSTextAlignmentCenter;
        [view addSubview:label];
        [label makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(image.mas_bottom);
            make.left.right.bottom.equalTo(view);
        }];
    } else {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
        label.text = self.defaultString;
        label.textColor = [UIColor darkGrayColor];
        label.font = [UIFont systemFontOfSize:13.0f];
        [view addSubview:label];
        [label makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.equalTo(view).with.offset(20.0f);
            make.right.bottom.equalTo(view).with.offset(-20.0f);
        }];
    }
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
    SRTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[SRTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:CellIdentifier];
        UITextField *tx = [[UITextField alloc] initWithFrame:CGRectZero];
        tx.tag = 100;
        tx.textAlignment = NSTextAlignmentRight;
        tx.font = [UIFont systemFontOfSize:15.0f];
        tx.placeholder = self.placeHolders[indexPath.row];
        [cell.contentView addSubview:tx];
        [tx makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(cell.contentView).with.offset(40.0f);
            make.right.equalTo(cell.contentView).with.offset(-20.0f);;
            make.top.bottom.equalTo(cell.contentView);
        }];
    }
    
    cell.textLabel.text = self.titles[indexPath.row];
    
    UITextField *tx = (UITextField *)[cell.contentView viewWithTag:100];
    
    if (indexPath.row == 0) {
        self.tx_name = tx;
        self.tx_name.placeholder = self.placeHolders[indexPath.row];
        self.tx_name.text = self.customer.name;
    } else {
        self.tx_IDNumber = tx;
        self.tx_IDNumber.placeholder = self.placeHolders[indexPath.row];
        self.tx_IDNumber.text = self.customer.customerIDNumber.encodeIDNumber;
        self.tx_IDNumber.bk_didEndEditingBlock = ^(UITextField *tx){
            self.bt_done.enabled = self.tx_name.text.length>0&&[tx.text.uppercaseString isIDNumber];
        };
    }
    
    if (self.customer.realNameAuthentication == AuthenticationStatus_WaitForUpload
        || self.customer.realNameAuthentication == AuthenticationStatus_Rejected) {
        //允许编辑
        tx.textColor = [UIColor blackColor];
        tx.userInteractionEnabled = YES;
        if (self.customer.realNameAuthentication == AuthenticationStatus_Rejected) {
            tx.text = nil;
        }
    } else {
        //不允许编辑
        tx.textColor = [UIColor darkGrayColor];
        tx.userInteractionEnabled = NO;
    }
    
    return cell;
}

#pragma mark - 交互操作

- (IBAction)buttonDonePressed:(id)sender {
    [SRUIUtil endEditing];
    
    [SRUIUtil showLoadingHUDWithTitle:nil];
    SRPortalRequestAuthentication *request = [[SRPortalRequestAuthentication alloc] init];
    request.name = self.tx_name.text;
    request.customerIDNumber = self.tx_IDNumber.text.uppercaseString;
    [SRPortal realNameAuthenticationWithRequest:request andCompleteBlock:^(NSError *error, id responseObject) {
        [SRUIUtil dissmissLoadingHUD];
        if (error) {
            [SRUIUtil showAlertMessage:error.domain];
        } else {
//            [self.tableView reloadData];
            
            [self.navigationController popViewControllerAnimated:YES];
            [SRUIUtil showAutoDisappearHUDWithMessage:@"修改成功" isDetail:NO];
        }
    }];
}

#pragma mark - 私有方法

- (void)initRAC
{
    self.bt_done.enabled = self.tx_name.text.length>0
                            && self.tx_IDNumber.text.length>0
                            && [self.tx_IDNumber.text.uppercaseString isIDNumber];
    if (hasAddRACObserver) return;
    
    hasAddRACObserver = YES;
    RAC(self.bt_done, enabled) = [RACSignal combineLatest:@[self.tx_name.rac_textSignal,
                                                            self.tx_IDNumber.rac_textSignal]
                                                   reduce:^(NSString *name, NSString *idNumber){
                                                       return @(name.length>0 && idNumber.length>0 && [idNumber.uppercaseString isIDNumber]);
                                                   }];
}

#pragma mark - Getter

- (NSArray *)titles {
    if (!_titles) {
        _titles = @[@"真实姓名", @"身份证号"];
    }
    
    return _titles;
}

- (NSArray *)placeHolders {
    if (!_placeHolders) {
        _placeHolders = @[@"请输入您的真实姓名", @"请输入您的身份证号"];
    }
    
    return _placeHolders;
}

- (NSString *)defaultString {
    if (!_defaultString) {
        switch (self.customer.realNameAuthentication) {
            case AuthenticationStatus_WaitForUpload:
                _defaultString = @"请输入您的真实姓名和身份证号码";
                break;
            case AuthenticationStatus_InReview:
                _defaultString = @"审核中";
                break;
            case AuthenticationStatus_Approved:
                _defaultString = @"审核通过";
                break;
            case AuthenticationStatus_Rejected:
                _defaultString = @"审核未通过";
                break;
                
            default:
                break;
        }
    }
    
    return _defaultString;
}


@end

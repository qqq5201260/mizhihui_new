//
//  SRModifyPhoneViewController.m
//  SiRuiV4.0
//
//  Created by zhangjunbo on 15/6/24.
//  Copyright (c) 2015年 SiRui. All rights reserved.
//

#import "SRModifyPhoneViewController.h"
#import "SRTableViewCell.h"
#import "SRUIUtil.h"
#import "SRPortalRequest.h"
#import "SRPortal+User.h"
#import "SRPortal+Regist.h"
#import "SRURLUtil.h"
#import "SRCustomer.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import <pop/POP.h>

@interface SRModifyPhoneViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *bt_done;

@property (weak, nonatomic) UIButton *bt_authCode;
@property (weak, nonatomic) UITextField *tx_phoneNumber;
@property (weak, nonatomic) UITextField *tx_authCode;
@property (weak, nonatomic) UIImageView *im_authCode;

@property (strong, nonatomic) NSArray *titles;
@property (strong, nonatomic) NSArray *placeHolders;

@property (copy, nonatomic) NSString *authCode;

@end

@implementation SRModifyPhoneViewController
{
    BOOL hasAddRACObserver;
}

#pragma mark - 生命周期

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = SRLocal(@"title_modify_phone");
    
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
    NSString *phone = [SRPortal sharedInterface].customer.customerPhone;
    label.text = [NSString stringWithFormat:@"当前手机号：%@", phone?phone.encodePhoneNumber:@""];
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
    }
    
    cell.textLabel.text = self.titles[indexPath.row];
    
    UITextField *tx = (UITextField *)[cell.contentView viewWithTag:100];
    
    if (indexPath.row == 0) {
        self.tx_phoneNumber = tx;
        self.tx_phoneNumber.keyboardType = UIKeyboardTypePhonePad;
        cell.accessoryView = [self buttonGetAuthCode];
    } else {
        self.tx_authCode = tx;
        self.tx_authCode.keyboardType = UIKeyboardTypeNumberPad;
        
        UIImageView *im_authCode = [[UIImageView alloc] initWithFrame:CGRectMake(.0f, .0f, 60.0f, 35.0f)];
        cell.accessoryView = im_authCode;
        
        self.im_authCode = im_authCode;
        self.im_authCode.hidden = YES;
    }
    
    return cell;
}


#pragma mark - 交互操作

- (IBAction)buttonDonePressed:(id)sender {
    [SRUIUtil endEditing];
    
    [SRUIUtil showPasswordInputAlertWithTitle:@"为保障账户安全，请输入密码" andConfirmBlock:^{
        [SRUIUtil showLoadingHUDWithTitle:nil];
        SRPortalRequestModifyUserRecord *request = [[SRPortalRequestModifyUserRecord alloc] initWithCustomer:[SRPortal sharedInterface].customer];
        request.customerPhone = self.tx_phoneNumber.text;
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

- (IBAction)buttonGetAuthCodePressed:(id)sender {
    
    self.im_authCode.hidden = YES;
    
    [SRUIUtil showLoadingHUDWithTitle:nil];
    SRPortalRequestSendAuthCodeToPhone *request = [[SRPortalRequestSendAuthCodeToPhone alloc] init];
    request.phone = self.tx_phoneNumber.text;
    [SRPortal sendAuthCodeToPhoneWithRequest:request andCompleteBlock:^(NSError *error, id responseObject) {
        [SRUIUtil dissmissLoadingHUD];
        
        if (!error) {
            [SRUIUtil showAutoDisappearHUDWithMessage:@"验证码已发送" isDetail:NO];
            self.authCode = responseObject;
            [self startCountDown];
        }else if (error.code == -1 || error.code == 4 || !responseObject) {
            [SRUIUtil showAlertMessage:error.domain];
        } else {
            self.im_authCode.hidden = NO;
            [SRUIUtil showAutoDisappearHUDWithMessage:@"请输入右侧验证码" isDetail:NO];
            self.authCode = responseObject;
            
           [self.im_authCode sd_setImageWithURL:[NSURL URLWithString:[SRURLUtil Portal_AuthCodeImageUrl:responseObject]]];
        }
    }];
}

#pragma mark - 私有方法

- (void)initRAC
{
    self.bt_done.enabled = self.tx_phoneNumber.text.length>0
                            && [self.tx_phoneNumber.text isPhoneNumber]
                            && [self.tx_authCode.text isEqualToString:self.authCode];
    
    if (hasAddRACObserver) return;
    
    hasAddRACObserver = YES;
    RAC(self.bt_done, enabled) = [RACSignal combineLatest:@[self.tx_phoneNumber.rac_textSignal,
                                                            self.tx_authCode.rac_textSignal]
                                                   reduce:^(NSString *phoneNumber, NSString *authCode){
                                                       return @(phoneNumber.length>0 && [phoneNumber isPhoneNumber]
                                                       && [authCode isEqualToString:self.authCode]);
                                                   }];
}

- (void)startCountDown {
    
    POPBasicAnimation *anim = [POPBasicAnimation linearAnimation];
    anim.duration = 60.0f;
    POPAnimatableProperty *prop = [POPAnimatableProperty propertyWithName:@"cout" initializer:^(POPMutableAnimatableProperty *prop) {
        prop.writeBlock = ^(UIButton *obj, const CGFloat values[]) {
            [obj setTitle:[NSString stringWithFormat:@"%zd", @(values[0]).integerValue] forState:UIControlStateNormal];
            obj.enabled = NO;
        };
    }];
    anim.property = prop;
    anim.completionBlock = ^(POPAnimation *anim, BOOL finished){
        [self.bt_authCode setTitle:SRLocal(@"bt_authcode") forState:UIControlStateNormal];
        self.bt_authCode.enabled = YES;
    };
    anim.fromValue = @(60.0f);
    anim.toValue = @(0.0f);
    
    self.bt_authCode.enabled = NO;
    [self.bt_authCode pop_addAnimation:anim forKey:@"CountDownAnimation"];
}

- (void)stopCountDown
{
    [self.bt_authCode pop_removeAllAnimations];
}

#pragma mark - Getter

- (NSArray *)titles {
    if (!_titles) {
        _titles = @[@"+86", @"验证码"];
    }
    
    return _titles;
}

- (NSArray *)placeHolders {
    if (!_placeHolders) {
        _placeHolders = @[@"请填写新手机号", @"请填写验证码"];
    }
    
    return _placeHolders;
}

- (UIButton *)buttonGetAuthCode {
    
    if (!self.bt_authCode) {
        @weakify(self)
        UIButton *bt_authCode = [[UIButton alloc] initWithFrame:CGRectMake(.0f, .0f, 70.0f, 25.0f)];
        bt_authCode.titleLabel.font = [UIFont systemFontOfSize:12.0f];
        [bt_authCode setTitle:SRLocal(@"bt_authcode") forState:UIControlStateNormal];
        bt_authCode.backgroundColor = [UIColor defaultColor];
        bt_authCode.layer.cornerRadius = 5.0f;
        [bt_authCode bk_whenTapped:^{
            @strongify(self)
            [self buttonGetAuthCodePressed:bt_authCode];
        }];
        
        self.bt_authCode = bt_authCode;
        RAC(self.bt_authCode, enabled) = [RACSignal combineLatest:@[self.tx_phoneNumber.rac_textSignal]
                                                           reduce:^(NSString *phone){
                                                               return @(phone.length>0 && [phone isPhoneNumber]);
                                                           }];
        RAC(self.bt_authCode, backgroundColor) = [RACSignal combineLatest:@[RACObserve(self.bt_authCode, enabled)] reduce:^(NSNumber *enabled){
            return enabled.boolValue?[UIColor defaultColor]:[UIColor disableColor];
        }];
    }
    
    return self.bt_authCode;
}

@end

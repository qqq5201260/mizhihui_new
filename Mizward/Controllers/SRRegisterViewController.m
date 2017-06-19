//
//  SRRegisterViewController.m
//  SiRuiV4.0
//
//  Created by zhangjunbo on 15/6/18.
//  Copyright (c) 2015年 SiRui. All rights reserved.
//

#import "SRRegisterViewController.h"
#import "SRUIUtil.h"
#import "SRPortal+Regist.h"
#import "SRPortal+Login.h"
#import "SRPortalRequest.h"
#import "SRPortalResponse.h"
#import "SRURLUtil.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import <pop/POP.h>
#import "SRUserDefaults.h"
#import "FZKTDispatch_after.h"

@interface SRRegisterViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *bt_register;
@property (weak, nonatomic) IBOutlet UILabel *lb_protocol;

@property (weak, nonatomic) UITextField *tx_phone;
@property (weak, nonatomic) UITextField *tx_authcode;
@property (weak, nonatomic) UITextField *tx_password;

@property (weak, nonatomic) UIButton *bt_authCode;
@property (weak, nonatomic) UIImageView *im_authCode;

@property (strong, nonatomic) NSArray *placeHolders;

@property (copy, nonatomic) NSString *authCode;

@end

@implementation SRRegisterViewController
{
    BOOL hasAddRACObserver;
}

#pragma mark - 生命周期

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = SRLocal(@"title_register");
    
    [self.bt_register setTitle:SRLocal(@"title_register") forState:UIControlStateNormal];
    self.bt_register.layer.cornerRadius = 5.0f;
    
    self.lb_protocol.text = SRLocal(@"descrition_register_protocol");
    
    self.tableView.backgroundView.backgroundColor = [UIColor clearColor];
    self.tableView.backgroundColor = [UIColor clearColor];
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

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section
{
    view.tintColor = [UIColor defaultBackgroundColor];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
    label.font = [UIFont systemFontOfSize:13.0f];
    label.text = SRLocal(@"description_register");
    label.textColor = [UIColor darkGrayColor];
    [view addSubview:label];
    [label makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(view).with.offset(10.0f);
        make.bottom.equalTo(view).with.offset(-10.0f);
        make.left.equalTo(view).with.offset(20.0f);
        make.right.equalTo(view).with.offset(-20.0f);
    }];
}

#pragma mark - UITableViewDataSource

//- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
//{
//    return SRLocal(@"description_register");
//}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.placeHolders.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CellIdentifier" ;
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:CellIdentifier];
    }
    
    UITextField *input = (UITextField *)[cell.contentView viewWithTag:100];
    input.placeholder = self.placeHolders[indexPath.row];
    
    if (indexPath.row == 0) {
        input.keyboardType = UIKeyboardTypePhonePad;
        self.tx_phone = input;
        cell.accessoryView = [self buttonGetAuthCode];
    } else if (indexPath.row == 1) {
        input.keyboardType = UIKeyboardTypeNumberPad;
        self.tx_authcode = input;
        
        UIImageView *im_authCode = [[UIImageView alloc] initWithFrame:CGRectMake(.0f, .0f, 60.0f, 35.0f)];
        cell.accessoryView = im_authCode;
        
        self.im_authCode = im_authCode;
        self.im_authCode.hidden = YES;
    } else {
        input.keyboardType = UIKeyboardTypeNumberPad;
        input.secureTextEntry = YES;
        self.tx_password = input;
        
        UIButton *bt_encrypted = [[UIButton alloc] initWithFrame:CGRectMake(.0f, .0f, cell.height, cell.height)];
        [bt_encrypted setImage:[UIImage imageNamed:@"ic_encrypted"] forState:UIControlStateNormal];
        [bt_encrypted setImage:[UIImage imageNamed:@"ic_unencrypted"] forState:UIControlStateSelected];
        [bt_encrypted bk_whenTapped:^{
            bt_encrypted.selected ^= 1;
            self.tx_password.secureTextEntry ^= 1;
        }];
        
        cell.accessoryView = bt_encrypted;
    }
    
    return cell;
}

#pragma mark - 交互事件

- (IBAction)buttonGetAuthCodePressed:(id)sender {
    self.im_authCode.hidden = YES;
    
    [SRUIUtil showLoadingHUDWithTitle:nil];
    SRPortalRequestSendAuthCodeToPhone *request = [[SRPortalRequestSendAuthCodeToPhone alloc] initWithRegiste];
    request.phone = self.tx_phone.text;
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

- (IBAction)buttonRegisterPressed:(id)sender {
    
    [SRUIUtil showLoadingHUDWithTitle:nil];
    SRPortalRequestRegist *request = [[SRPortalRequestRegist alloc] init];
    request.customerPassword = self.tx_password .text;
    request.customerPhone = self.tx_phone.text;
    request.authcode = self.tx_authcode.text;
    [SRPortal registeWithRequest:request andCompleteBlock:^(NSError *error, id responseObject) {
        if (error) {
            [SRUIUtil dissmissLoadingHUD];
            [SRUIUtil showAlertMessage:error.domain];
        } else {
            [self login];
        }
    }];
}

#pragma mark - Getter

- (NSArray *)placeHolders {
    if (!_placeHolders) {
        _placeHolders = @[SRLocal(@"placeholder_phone"), SRLocal(@"placeholder_authcode"), SRLocal(@"placeholder_password")];
    }
    
    return _placeHolders;
}

- (UIButton *)buttonGetAuthCode {
    
    if (!self.bt_authCode) {
        @weakify(self)
        UIButton *bt_authCode = [[UIButton alloc] initWithFrame:CGRectMake(.0f, .0f, 80.0f, 30.0f)];
        bt_authCode.titleLabel.font = [UIFont systemFontOfSize:12.0f];
        [bt_authCode setTitle:SRLocal(@"bt_authcode") forState:UIControlStateNormal];
        bt_authCode.backgroundColor = [UIColor defaultColor];
        bt_authCode.layer.cornerRadius = 5.0f;
        [bt_authCode bk_whenTapped:^{
            @strongify(self)
            [self buttonGetAuthCodePressed:bt_authCode];
        }];
        
        self.bt_authCode = bt_authCode;
        RAC(self.bt_authCode, enabled) = [RACSignal combineLatest:@[self.tx_phone.rac_textSignal]
                                                           reduce:^(NSString *phone){
                                                               return @(phone.length>0 && [phone isPhoneNumber]);
                                                           }];
        
        RAC(self.bt_authCode, backgroundColor) = [RACSignal combineLatest:@[RACObserve(self.bt_authCode, enabled)] reduce:^(NSNumber *enabled){
            return enabled.boolValue?[UIColor defaultColor]:[UIColor disableColor];
        }];
    }
    
    return self.bt_authCode;
}

#pragma mark - 私有函数

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

- (void)login {
    SRPortalRequestLogin *request = [[SRPortalRequestLogin alloc] init];
    request.userName = self.tx_phone.text;
    request.passWord = self.tx_password.text;
    [SRPortal loginWithRequest:request andCompleteBlock:^(NSError *error, SRPortalResponseLogin *responseObject) {
        [SRUIUtil dissmissLoadingHUD];
        if (error) {
            [SRUIUtil showAlertMessage:error.domain];
        } else {
            if ([responseObject.updateVersion compare:CurrentAPPVersion]!=NSOrderedDescending
                || !responseObject.needUpdate) {
//                [SRUIUtil popToRootViewControllerAnimated:YES];
                [[SRUserDefaults standardUserDefaults] setObject:@(YES) forKey:@"kLogin5mins"];
                [[SRUserDefaults standardUserDefaults] synchronize];
                [[FZKTDispatch_after sharedInterface] runDispatch_after:300 block:^{
                    if([SRUserDefaults loginStatus]==SRLoginStatus_DidLogin){
                        [[SRUserDefaults standardUserDefaults] setObject:@(NO) forKey:@"kLogin5mins"];
                        [[SRUserDefaults standardUserDefaults] synchronize];
                    }
                }];
                [SRUIUtil DissmissSRLoginViewControllerPopToRoot];
            }
        }
    }];
}

- (void)initRAC {
    
    self.bt_register.enabled = self.tx_phone.text.length>0
                                && [self.tx_phone.text isPhoneNumber]
                                && self.tx_authcode.text.length>0
                                && [self.tx_authcode.text isEqualToString:self.authCode]
                                && self.tx_password.text.length>0;
    
    if (hasAddRACObserver) return;
    
    hasAddRACObserver = YES;
    RAC(self.bt_register, enabled) = [RACSignal combineLatest:@[
                                                                self.tx_phone.rac_textSignal,
                                                                self.tx_authcode.rac_textSignal,
                                                                self.tx_password.rac_textSignal
                                                                ]
                                                       reduce:^(NSString *phone, NSString *authCode, NSString *password){
                                                           return @(phone.length>0 && [phone isPhoneNumber]
                                                           && authCode.length>0 && [authCode isEqualToString:self.authCode]
                                                           && password.length>0);
                                                       }];
    
    RAC(self.bt_register, backgroundColor) = [RACSignal combineLatest:@[RACObserve(self.bt_register, enabled)] reduce:^(NSNumber *enabled){
        return enabled.boolValue?[UIColor defaultColor]:[UIColor disableColor];
    }];
}

@end

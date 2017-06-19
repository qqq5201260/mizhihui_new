//
//  SRLoginViewController.m
//  SiRuiV4.0
//
//  Created by zhangjunbo on 15/6/18.
//  Copyright (c) 2015年 SiRui. All rights reserved.
//

#import "SRLoginViewController.h"
#import "SRPortal+Login.h"
#import "SRPortalRequest.h"
#import "SRUIUtil.h"
#import "SRKeychain.h"
#import "SREventCenter.h"
#import "SRPortalResponse.h"
#import "SRUserDefaults.h"
#import "SRScanViewController.h"
#import "SRTableViewCell.h"
#import "FZKTDispatch_after.h"

@interface SRLoginViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *bt_login;
@property (weak, nonatomic) IBOutlet UIButton *bt_register;
@property (weak, nonatomic) IBOutlet UIButton *bt_reset;

@property (weak, nonatomic) UITextField *tx_account;
@property (weak, nonatomic) UITextField *tx_password;

@end

@implementation SRLoginViewController
{
    BOOL hasAddRACObserver;
}

#pragma mark - 生命周期

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.title = SRLocal(@"title_login");
    
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.backgroundView.backgroundColor = [UIColor clearColor];
    self.tableView.separatorInset = UIEdgeInsetsMake(0, 10, 0, 0);
    
    [self addCloseButton];
    [self addScanButton];
    
    [self.bt_login setTitle:@"登录" forState:UIControlStateNormal];
    [self.bt_login setBackgroundImage:[UIImage imageNamed:@"bt_login_enable"] forState:UIControlStateNormal];
    [self.bt_login setBackgroundImage:[UIImage imageNamed:@"bt_login_disable"] forState:UIControlStateDisabled];
    
    [self.bt_register setTitle:@"注册账号" forState:UIControlStateNormal];
    [self.bt_reset setTitle:@"忘记密码" forState:UIControlStateNormal];
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self.tx_account becomeFirstResponder];
    [self initRAC];
}

#pragma mark - Navigation
 
// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
    UIViewController *vc = segue.destinationViewController;
    if ([vc isKindOfClass:[SRScanViewController class]]) {
        [vc setValue:@(SRScanViewControllerType_Visitor) forKey:@"type"];
    }
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 150.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44.0f;
}

//grouped调用此方法
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, [self tableView:tableView heightForHeaderInSection:section])];
    
    view.tintColor = [UIColor defaultBackgroundColor];
    
    UIImageView *image = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ic_login"]];
    [view addSubview:image];
    [image makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(view);
    }];
    
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

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
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
    
    cell.imageView.image = [UIImage imageNamed:indexPath.row==0?@"ic_login_account":@"ic_login_password"];
    
    UITextField *tx = [[UITextField alloc] initWithFrame:CGRectZero];
    tx.font = [UIFont systemFontOfSize:15.0f];
    tx.clearButtonMode = UITextFieldViewModeWhileEditing;
    [cell.contentView addSubview:tx];
    [tx makeConstraints:^(MASConstraintMaker *make) {
        make.right.top.bottom.equalTo(cell.contentView);
        make.left.equalTo(cell.contentView).with.offset(50.0f);
    }];
    
    if (indexPath.row == 0) {
        self.tx_account = tx;
        self.tx_account.placeholder = @"请输入账号";
        self.tx_account.text = [SRKeychain UserName];
    } else {
        self.tx_password = tx;
        self.tx_password.placeholder = @"请输入密码";
        self.tx_password.secureTextEntry = YES;
        
        UIButton *bt_encrypted = [[UIButton alloc] initWithFrame:CGRectMake(.0f, .0f, 40.0f, 40.0f)];
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

- (IBAction)buttonRegistorPressed:(id)sender {
    [self performSegueWithIdentifier:@"PushSRRegisterViewController" sender:nil];
}

- (IBAction)buttonResetPerssed:(id)sender {
    [self performSegueWithIdentifier:@"PushSRFindPasswordViewController" sender:nil];
}

- (IBAction)buttonLoginPressed:(id)sender {
    [SRUIUtil showLoadingHUDWithTitle:nil];
    SRPortalRequestLogin *request = [[SRPortalRequestLogin alloc] init];
    request.userName = [self.tx_account.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    request.passWord = self.tx_password.text;
    [SRPortal loginWithRequest:request andCompleteBlock:^(NSError *error, SRPortalResponseLogin *responseObject) {
        [SRUIUtil dissmissLoadingHUD];
        if (error) {
            [SRUIUtil showAlertMessage:error.domain];
        } else {
            if ([responseObject.updateVersion compare:CurrentAPPVersion]!=NSOrderedDescending
                || !responseObject.needUpdate) {
                
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

- (IBAction)buttonVistorPressed:(id)sender {
    [SRUIUtil showLoadingHUDWithTitle:nil];
    SRPortalRequestLogin *request = [[SRPortalRequestLogin alloc] init];
    request.userName = SRExperienceAccount;
    request.passWord = SRExperiencePassword;
    [SRPortal loginWithRequest:request andCompleteBlock:^(NSError *error, SRPortalResponseLogin *responseObject) {
        [SRUIUtil dissmissLoadingHUD];
        if (error) {
            [SRUIUtil showAlertMessage:error.domain];
        } else {
            if ([responseObject.updateVersion compare:CurrentAPPVersion]!=NSOrderedDescending
                || !responseObject.needUpdate) {
                [SRUIUtil DissmissSRLoginViewControllerPopToRoot];
            }
        }
    }];
}

#pragma mark - 私有函数

- (void)addCloseButton {
    UIBarButtonItem *closeItem = [[UIBarButtonItem alloc] bk_initWithImage:[UIImage imageNamed:@"ic_login_close"] style:UIBarButtonItemStyleDone handler:^(id sender) {
        [SRUIUtil endEditing];
        [SRUIUtil DissmissSRLoginViewController];
    }];
    
    self.navigationItem.leftBarButtonItem = closeItem;
    
}

- (void)addScanButton {

    UIBarButtonItem *scanItem = [[UIBarButtonItem alloc] bk_initWithImage:[UIImage imageNamed:@"ic_login_scan"] style:UIBarButtonItemStyleDone handler:^(id sender) {

        if ([SRUIUtil cameraAuthorization]) {
            [self performSegueWithIdentifier:@"PushSRScanViewController" sender:nil];
        }
    }];
    
    self.navigationItem.rightBarButtonItem = scanItem;
}

- (void)initRAC {
    
    self.bt_login.enabled = self.tx_account.text.length>0
                            && self.tx_password.text.length>0;
    
    if (hasAddRACObserver) return;
    
    hasAddRACObserver = YES;
    RAC(self.bt_login, enabled) = [RACSignal combineLatest:@[self.tx_account.rac_textSignal,
                                                             self.tx_password.rac_textSignal]
                                                    reduce:^(NSString *account, NSString *password){
                                                        return @(account.length>0 && password.length>0);
                                                    }];
//    RAC(self.bt_login, backgroundColor) = [RACSignal combineLatest:@[RACObserve(self.bt_login, enabled)] reduce:^(NSNumber *enabled){
//        return enabled.boolValue?[UIColor defaultColor]:[UIColor disableColor];
//    }];
    
//    [RACObserve(self.bt_login, enabled) subscribeNext:^(NSNumber *enable) {
//        
//    }]

    
}

@end

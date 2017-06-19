//
//  SRPhoneVerifyViewController.m
//  SiRuiV4.0
//
//  Created by zhangjunbo on 15/7/16.
//  Copyright (c) 2015年 SiRui. All rights reserved.
//

#import "SRPhoneVerifyViewController.h"
#import "SRTableViewCell.h"
#import "SRPortalRequest.h"
#import "SRPortal+Regist.h"
#import "SRUIUtil.h"
#import "SRURLUtil.h"
#import <pop/POP.h>
#import <ReactiveCocoa/ReactiveCocoa.h>
#import <SDWebImage/UIImageView+WebCache.h>

@interface SRPhoneVerifyViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableViewConstrintsHeight;
@property (weak, nonatomic) IBOutlet UIButton *bt_next;

@property (weak, nonatomic) UITextField *tx_vin;
@property (weak, nonatomic) UITextField *tx_phone;
@property (weak, nonatomic) UITextField *tx_authCode;

@property (weak, nonatomic) UIButton *bt_authCode;
@property (weak, nonatomic) UIImageView *im_authCode;

@property (strong, nonatomic) NSArray *titles;
@property (strong, nonatomic) NSArray *placeHolders;

//@property (copy, nonatomic) NSString *authCode;

@end

@implementation SRPhoneVerifyViewController

#pragma mark - 生命周期

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.title = @"找回密码";
    
    self.tableView.backgroundView.backgroundColor = [UIColor clearColor];
    self.tableView.backgroundColor = [UIColor clearColor];
    
    [self.bt_next setTitle:@"下一步" forState:UIControlStateNormal];
    self.bt_next.layer.cornerRadius = 5.0f;
    RAC(self.bt_next, backgroundColor) = [RACSignal combineLatest:@[RACObserve(self.bt_next, enabled)] reduce:^(NSNumber *enabled){
        return enabled.boolValue?[UIColor defaultColor]:[UIColor disableColor];
    }];
    self.bt_next.enabled = NO;
    
    self.tableViewConstrintsHeight.constant = self.verifyType == SRPhoneVerifyType_WithTernimal?182.0f:138.0f;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.tx_authCode.text = nil;
//    self.authCode = nil;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear: animated];
    self.tx_authCode.text = nil;
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    UIViewController *vc = segue.destinationViewController;
    if ([segue.identifier isEqualToString:@"PushSRPasswordResetViewController"]) {
        [vc setValue:self.tx_phone.text forKey:@"phone"];
        [vc setValue:self.tx_authCode.text forKey:@"authCode"];
    }
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
    label.numberOfLines = 0;
    label.text =  self.descriptionString;
    label.textColor = [UIColor darkGrayColor];
    [view addSubview:label];
    [label makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(view).with.offset(10.0f);
        make.bottom.equalTo(view).with.offset(-10.0f);
        make.left.equalTo(view).with.offset(20.0f);
        make.right.equalTo(view).with.offset(0.0f);
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
        [cell.contentView addSubview:tx];
        [tx makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(cell.contentView).with.offset(100.0f);
            make.right.equalTo(cell.contentView).with.offset(-10.0f);
            make.top.bottom.equalTo(cell.contentView);
        }];
    }
    
    cell.textLabel.text = self.titles[indexPath.row];

    if (self.verifyType == SRPhoneVerifyType_WithTernimal) {
        return [self withTernimalCell:cell forRowAtIndexPath:indexPath];
    } else {
        return [self withoutTernimalCell:cell forRowAtIndexPath:indexPath];
    }
    
    return cell;
}

#pragma mark - 交互操作

- (IBAction)buttonNextPressed:(id)sender {
    [SRUIUtil showLoadingHUDWithTitle:nil];
    SRPortalRequestPhoneVerifyWithAuthcode *request = [[SRPortalRequestPhoneVerifyWithAuthcode alloc] init];
    request.phone = self.tx_phone.text;
    request.authCode = self.tx_authCode.text;
    [SRPortal phoneVerifyWithAuthcodeWithRequest:request andCompleteBlock:^(NSError *error, id responseObject) {
        [SRUIUtil dissmissLoadingHUD];
        if (error) {
            [self stopCountDown];
            [SRUIUtil showAlertMessage:error.domain];
        } else {
            [self performSegueWithIdentifier:@"PushSRPasswordResetViewController" sender:nil];
        }
    }];
}

- (IBAction)buttonGetAuthCodePressed:(id)sender {
    self.im_authCode.hidden = YES;

    [SRUIUtil showLoadingHUDWithTitle:nil];
    
    CompleteBlock endBlock = ^(NSError *error, id responseObject){
        [SRUIUtil dissmissLoadingHUD];
        if (!error) {
            [SRUIUtil showAutoDisappearHUDWithMessage:@"验证码已发送" isDetail:NO];
//            self.authCode = responseObject;
            [self startCountDown];
        } else if (error.code == SRHTTP_Need_Vin) {
            [SRUIUtil showAlertCancelableWithTitle:@"提示" message:error.domain doneButton:@"已绑定设备" andDoneBlock:^{
                [self changeToVerifyType:SRPhoneVerifyType_WithTernimal];
            }];
        } else if (error.code == SRHTTP_Vin_Not_Exist) {
            [SRUIUtil showAlertCancelableWithTitle:@"提示" message:error.domain doneButton:@"没有绑定设备" andDoneBlock:^{
                [self changeToVerifyType:SRPhoneVerifyType_WithoutTernimal];
            }];
        } else if (error.code == SRHTTP_Phone_Not_Exist) {
            [SRUIUtil showAlertCancelableWithTitle:@"提示" message:error.domain doneButton:@"账号申诉" andDoneBlock:^{
                [self performSegueWithIdentifier:@"PushSRAccountAppealViewController" sender:nil];
            }];
        } else {
            [SRUIUtil showAlertCancelableWithTitle:@"提示" message:error.domain doneButton:@"账号申诉" andDoneBlock:^{
                [self performSegueWithIdentifier:@"PushSRAccountAppealViewController" sender:nil];
            }];
        }
    };
    
    if (self.verifyType == SRPhoneVerifyType_WithTernimal) {
        SRPortalRequestPhoneVerifyWithTernimal *request = [[SRPortalRequestPhoneVerifyWithTernimal alloc] init];
        request.phone = self.tx_phone.text;
        request.vin = self.tx_vin.text;
        [SRPortal phoneVerifyWithTernimalNoAuthCodeWithRequest:request andCompleteBlock:endBlock];
    } else {
        SRPortalRequestPhoneVerifyWithoutTernimal *request = [[SRPortalRequestPhoneVerifyWithoutTernimal alloc] init];
        request.phone = self.tx_phone.text;
        [SRPortal phoneVerifyWithoutTernimalNoAuthcodeWithRequest:request andCompleteBlock:endBlock];
    }
}

#pragma mark - 私有方法

- (SRTableViewCell *)withTernimalCell:(SRTableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    cell.accessoryView = nil;
    
    UITextField *tx = (UITextField *)[cell.contentView viewWithTag:100];
    tx.placeholder = self.placeHolders[indexPath.row];
    tx.text = nil;
    
    switch (indexPath.row) {
        case 0:
        {
            self.tx_vin = tx;
            tx.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
            self.tx_authCode.bk_didEndEditingBlock = ^(UITextField *textField){
                self.bt_next.enabled = textField.text.length>0&&self.tx_authCode.text.length>0;
            };
        }
            break;
        case 1:
        {
            self.tx_phone = tx;
            tx.keyboardType = UIKeyboardTypePhonePad;
            cell.accessoryView = self.buttonGetAuthCode;
        }
            
            break;
        case 2:
        {
            self.tx_authCode = tx;
            tx.keyboardType = UIKeyboardTypeNumberPad;
            self.tx_authCode.bk_didEndEditingBlock = ^(UITextField *textField){
                self.bt_next.enabled = textField.text.length>0&&self.tx_vin.text.length>0;
            };
            
            UIImageView *im_authCode = [[UIImageView alloc] initWithFrame:CGRectMake(.0f, .0f, 60.0f, 35.0f)];
            cell.accessoryView = im_authCode;
            
            self.im_authCode = im_authCode;
            self.im_authCode.hidden = YES;
        }
            break;
            
        default:
            break;
    }
    
    return cell;
}

- (SRTableViewCell *)withoutTernimalCell:(SRTableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    cell.accessoryView = nil;
    
    UITextField *tx = (UITextField *)[cell.contentView viewWithTag:100];
    tx.placeholder = self.placeHolders[indexPath.row];
    tx.text = nil;
    
    switch (indexPath.row) {
        case 0:
            self.tx_phone = tx;
            tx.keyboardType = UIKeyboardTypePhonePad;
            cell.accessoryView = self.buttonGetAuthCode;
            break;
        case 1:
        {
            self.tx_authCode = tx;
            tx.keyboardType = UIKeyboardTypeNumberPad;
            self.tx_authCode.bk_didEndEditingBlock = ^(UITextField *textField){
                self.bt_next.enabled = textField.text.length>0;
            };
            
            UIImageView *im_authCode = [[UIImageView alloc] initWithFrame:CGRectMake(.0f, .0f, 60.0f, 35.0f)];
            cell.accessoryView = im_authCode;
            
            self.im_authCode = im_authCode;
            self.im_authCode.hidden = YES;
        }
            break;
            
        default:
            break;
    }
    
    return cell;
}

- (void)changeToVerifyType:(SRPhoneVerifyType)verifyType
{
    self.verifyType = verifyType;
    self.titles = nil;
    self.placeHolders = nil;
    
    self.tableViewConstrintsHeight.constant = self.verifyType == SRPhoneVerifyType_WithTernimal?200.0f:150.0f;
    [self.tableView reloadData];
}

- (void)startCountDown
{
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

- (NSArray *)titles
{
    if (_titles) {
        return _titles;
    }
    
    if (self.verifyType == SRPhoneVerifyType_WithTernimal) {
        _titles = @[@"车架号", @"+86", @"验证码"];
    } else {
        _titles = @[@"+86", @"验证码"];
    }
    
    return _titles;
}

- (NSString *)descriptionString {
    if (self.verifyType == SRPhoneVerifyType_WithTernimal) {
        return @"找回密码涉及您的账户安全，请验证手机号及车架号";
    } else {
        return @"找回密码涉及您的账户安全，请验证手机号";
    }
}

- (NSArray *)placeHolders {
    if (_placeHolders) {
        return _placeHolders;
    }
    
    if (self.verifyType == SRPhoneVerifyType_WithTernimal) {
        _placeHolders = @[@"请填写您的车架号", @"请填写您的手机号", @"请填写您的验证码"];
    } else {
        _placeHolders = @[@"请填写您的手机号", @"请填写您的验证码"];
    }
    
    return _placeHolders;
}

- (UIButton *)buttonGetAuthCode {
    
    @weakify(self)
    UIButton *bt_authCode = [[UIButton alloc] initWithFrame:CGRectMake(.0f, .0f, 70.0f, 25.0f)];
    bt_authCode.titleLabel.font = [UIFont systemFontOfSize:12.0f];
    [bt_authCode setTitle:SRLocal(@"bt_authcode") forState:UIControlStateNormal];
    bt_authCode.enabled = NO;
    bt_authCode.layer.cornerRadius = 5.0f;
    [bt_authCode bk_whenTapped:^{
        @strongify(self)
        [self buttonGetAuthCodePressed:bt_authCode];
    }];
    
    self.bt_authCode = bt_authCode;
    
    if (self.verifyType == SRPhoneVerifyType_WithTernimal) {
        RAC(self.bt_authCode, enabled) = [RACSignal combineLatest:@[self.tx_vin.rac_textSignal, self.tx_phone.rac_textSignal]
                                                           reduce:^(NSString *vin, NSString *phone){
                                                               return @(vin.length>0 && phone.length>0 && [phone isPhoneNumber]);
                                                           }];
    } else {
        RAC(self.bt_authCode, enabled) = [RACSignal combineLatest:@[self.tx_phone.rac_textSignal]
                                                           reduce:^(NSString *phone){
                                                               return @(phone.length>0 && [phone isPhoneNumber]);
                                                           }];
    }
    
    RAC(self.bt_authCode, backgroundColor) = [RACSignal combineLatest:@[RACObserve(self.bt_authCode, enabled)] reduce:^(NSNumber *enabled){
        return enabled.boolValue?[UIColor defaultColor]:[UIColor disableColor];
    }];
    
    
    return self.bt_authCode;
}

@end

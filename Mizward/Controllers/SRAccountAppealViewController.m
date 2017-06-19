//
//  SRAccountAppealViewController.m
//  SiRuiV4.0
//
//  Created by zhangjunbo on 15/7/9.
//  Copyright (c) 2015年 SiRui. All rights reserved.
//

#import "SRAccountAppealViewController.h"
#import "SRTableViewCell.h"
#import "SRUIUtil.h"
#import "SRPortalRequest.h"
#import "SRPortal+Regist.h"
#import "SRURLUtil.h"
#import <pop/POP.h>
#import <ReactiveCocoa/ReactiveCocoa.h>
#import <SDWebImage/UIImageView+WebCache.h>

@interface SRAccountAppealViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *bt_next;

@property (weak, nonatomic) UITextField *tx_phone;
@property (weak, nonatomic) UITextField *tx_authCode;

@property (weak, nonatomic) UIButton *bt_authCode;
@property (weak, nonatomic) UIImageView *im_authCode;

@property (strong, nonatomic) NSArray *titles;
@property (strong, nonatomic) NSArray *placeHolders;
@property (strong, nonatomic) NSArray *descriptions;

@property (copy, nonatomic) NSString *authCode;

@end

@implementation SRAccountAppealViewController
{
    BOOL hasAddRACObserver;
}

#pragma mark - 生命周期

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.title = @"人工申诉";
    
    self.tableView.backgroundView.backgroundColor = [UIColor clearColor];
    self.tableView.backgroundColor = [UIColor clearColor];
    
    [self.bt_next setTitle:@"下一步" forState:UIControlStateNormal];
    self.bt_next.layer.cornerRadius = 5.0f;
    RAC(self.bt_next, backgroundColor) = [RACSignal combineLatest:@[RACObserve(self.bt_next, enabled)] reduce:^(NSNumber *enabled){
        return enabled.boolValue?[UIColor defaultColor]:[UIColor disableColor];
    }];
    self.bt_next.enabled = NO;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.tx_authCode.text = nil;
    self.authCode = nil;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self initRAC];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    UIViewController *vc = segue.destinationViewController;
    if ([segue.identifier isEqualToString:@"PushSRAccountAppealSubmitViewController"]) {
        [vc setValue:self.tx_phone.text forKey:@"phone"];
    }
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 155.0f;
}

//grouped调用此方法
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, [self tableView:tableView heightForHeaderInSection:section])];
    
    view.tintColor = [UIColor defaultBackgroundColor];
    
    UIImage *image = [UIImage imageNamed:@"ic_accout_appeal"];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    [view addSubview:imageView];
    [imageView makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(view);
        make.top.equalTo(view).with.offset(16.0f);
        make.size.equalTo(image.size);
    }];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
    label.font = [UIFont systemFontOfSize:12.0f];
    label.numberOfLines = 0;
    label.textColor = [UIColor darkGrayColor];
    label.attributedText = self.attributedString;
    [view addSubview:label];
    
    [label makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(imageView.mas_bottom).with.offset(10.0f);
        make.bottom.equalTo(view).with.offset(-10.0f);
        make.left.equalTo(view).with.offset(15.0f);
        make.right.equalTo(view).with.offset(-15.0f);
    }];

    
    return view;
}
//plain调用此方法
//- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section
//{
//    view.tintColor = [UIColor defaultBackgroundColor];
//    
//    UIImage *image = [UIImage imageNamed:@"ic_accout_appeal"];
//    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
//    [view addSubview:imageView];
//    [imageView makeConstraints:^(MASConstraintMaker *make) {
//        make.centerX.equalTo(view);
//        make.top.equalTo(view).with.offset(16.0f);
//        make.size.equalTo(image.size);
//    }];
//    
//    UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
//    label.font = [UIFont systemFontOfSize:12.0f];
//    label.numberOfLines = 0;
//    label.textColor = [UIColor darkGrayColor];
//    label.attributedText = self.attributedString;
//    [view addSubview:label];
//    
//    [label makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(imageView.mas_bottom).with.offset(10.0f);
//        make.bottom.equalTo(view).with.offset(-10.0f);
//        make.left.equalTo(view).with.offset(15.0f);
//        make.right.equalTo(view).with.offset(-15.0f);
//    }];
//}

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
    
    UITextField *tx = (UITextField *)[cell.contentView viewWithTag:100];
    tx.placeholder = self.placeHolders[indexPath.row];
    
    if (indexPath.row == 0) {
        self.tx_phone = tx;
        self.tx_phone.keyboardType = UIKeyboardTypePhonePad;
        cell.accessoryView = self.buttonGetAuthCode;
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

- (IBAction)buttonNextPressed:(id)sender {
    [self performSegueWithIdentifier:@"PushSRAccountAppealSubmitViewController" sender:nil];
}

- (IBAction)buttonGetAuthCodePressed:(id)sender
{
    self.im_authCode.hidden = YES;
    
    [SRUIUtil showLoadingHUDWithTitle:nil];
    SRPortalRequestSendAuthCodeToPhone *request = [[SRPortalRequestSendAuthCodeToPhone alloc] initWithAccoutAppeal];
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

#pragma mark - 私有方法

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

- (void)initRAC {
    
    self.bt_next.enabled = self.tx_phone.text.length>0
                            && [self.tx_phone.text isPhoneNumber]
                            && self.tx_authCode.text.length>0
                            && [self.tx_authCode.text isEqualToString:self.authCode];
    
    if (hasAddRACObserver) return;
    
    hasAddRACObserver = YES;
    RAC(self.bt_next, enabled) = [RACSignal combineLatest:@[self.tx_phone.rac_textSignal,
                                                            self.tx_authCode.rac_textSignal]
                                                   reduce:^(NSString *phone, NSString *authCode){
                                                       return @(phone.length>0 && [phone isPhoneNumber]
                                                       && authCode.length>0 && [authCode isEqualToString:self.authCode]);
                                                   }];
}


#pragma mark - Getter

- (NSArray *)titles
{
    if (_titles) {
        return _titles;
    }
    
    _titles = @[@"+86", @"验证码"];
    
    return _titles;
}

- (NSArray *)descriptions {
    if (_descriptions) {
        return _descriptions;
    }
    
    _descriptions = @[@"●申诉适用范围：忘记用户名、不能通过绑定手机找回用户名和密码", @"●申诉成功后，原密码将自动失效，联系手机自动作为绑定手机，密码默认重置为绑定手机号码后六位"];
    
    return _descriptions;
}

- (NSArray *)placeHolders {
    if (_placeHolders) {
        return _placeHolders;
    }
    
    _placeHolders = @[@"请填写联系手机号", @"请填写您的验证码"];
    
    return _placeHolders;
}

- (NSAttributedString *)attributedString
{
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.headIndent = 7.0f;//设置缩进
    paragraphStyle.hyphenationFactor = 1.0;//设置每行的最后单词是否截断，在0.0-1.0之间，默认为0.0，越接近1.0单词被截断的可能性越大
    NSDictionary *attributes = @{NSParagraphStyleAttributeName : paragraphStyle};
    
    NSString *description = [NSString stringWithFormat:@"%@\n%@", self.descriptions[0], self.descriptions[1]];
    
    NSRange range = [description rangeOfString:self.descriptions[1]];
    
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:description
                                                                               attributes:attributes];
    [string addAttribute:NSForegroundColorAttributeName value:[UIColor defaultColor] range:NSMakeRange(0, 1)];
    [string addAttribute:NSForegroundColorAttributeName value:[UIColor defaultColor] range:NSMakeRange(range.location, 1)];
    
    
    return string;
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
    
    RAC(self.bt_authCode, enabled) = [RACSignal combineLatest:@[self.tx_phone.rac_textSignal]
                                                       reduce:^(NSString *phone){
                                                           return @(phone.length>0 && [phone isPhoneNumber]);
                                                       }];
    
    RAC(self.bt_authCode, backgroundColor) = [RACSignal combineLatest:@[RACObserve(self.bt_authCode, enabled)] reduce:^(NSNumber *enabled){
        return enabled.boolValue?[UIColor defaultColor]:[UIColor disableColor];
    }];
    
    
    return self.bt_authCode;
}


@end

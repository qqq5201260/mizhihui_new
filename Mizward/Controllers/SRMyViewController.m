//
//  SRMyViewController.m
//  Mizward
//
//  Created by zhangjunbo on 15/11/4.
//  Copyright © 2015年 Mizward. All rights reserved.
//

#import "SRMyViewController.h"
#import "SRUIUtil.h"
#import "SRUserDefaults.h"
#import "SRConfigViewController.h"
#import "SRPortal+Login.h"
#import "SRPortal+User.h"
#import "SRUIUtil.h"
#import "SRTableViewCell.h"
#import "SRCustomer.h"
#import "SRPortal+Message.h"
#import "SRDataBase+Customer.h"
#import "SRVehicleBasicInfo.h"
#import "SREventCenter.h"
#import "SRIntegralDetailViewController.h"
#import <KVOController/FBKVOController.h>
#import <SDWebImage/UIImageView+WebCache.h>

const NSInteger rows        = 3;//3列
const NSInteger lines       = 3;//3行
const NSInteger myTotalItems  = 8;//总共8个
const NSInteger padding     = 1;//间距1像素



@interface SRMyViewController () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>
{
    FBKVOController *kvoController;
}

@property (weak, nonatomic) IBOutlet UIButton *buttonLogin;

@property (weak, nonatomic) IBOutlet UIImageView *iconHead;

@property (weak, nonatomic) IBOutlet UILabel *labelName;
@property (weak, nonatomic) IBOutlet UIButton *buttonVIP;

@property (weak, nonatomic) IBOutlet UIButton *buttonSignIn;
@property (weak, nonatomic) IBOutlet UILabel *labelSignInfo;
@property (weak, nonatomic) IBOutlet UILabel *labelDays;

@property (weak, nonatomic) IBOutlet UIView *middleView;
@property (weak, nonatomic) IBOutlet UILabel *labelBalance;
@property (weak, nonatomic) IBOutlet UILabel *labelIntegral;

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (strong, nonatomic) NSArray *buttonIcons;
@property (strong, nonatomic) NSArray *buttonTitles;

@end

@implementation SRMyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.collectionView.backgroundColor = [UIColor defaultBackgroundColor];
    
    kvoController = [[FBKVOController alloc] initWithObserver:self];
    
    self.labelBalance.userInteractionEnabled = YES;
    [self.labelBalance bk_whenTapped:^{
        if (![self checkLoginStatus]) {
            return;
        } else if ([self checkExperienceUserStatus]) {
            return;
        }
        [self performSegueWithIdentifier:@"PushSRExtendViewController" sender:nil];
    }];
    
    self.labelIntegral.userInteractionEnabled = YES;
    [self.labelIntegral bk_whenTapped:^{
//        SRIntegralDetailViewController *vc = [[SRIntegralDetailViewController alloc] init];
//        [self.navigationController pushViewController:vc animated:YES];
        [self performSegueWithIdentifier:@"PushSRIntegralDetailViewController" sender:nil];
    }];
    
    [self initViews];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [[SREventCenter sharedInterface] addObserver:self observerQueue:dispatch_get_main_queue()];
    [self observeForUnreadMessages];
    
    [SRUIUtil rootViewController].navigationBarHidden = YES;
    
//    self.parentVC.navigationItem.rightBarButtonItem = nil;
//    self.parentVC.navigationItem.titleView = nil;
//    self.parentVC.navigationItem.leftBarButtonItem = nil;
    
    [self updateViews];
    
    [self updateCustomerInfo];
    
    if ([SRUserDefaults isLogin]) {
        [SRPortal queryCustomerWithCompleteBlock:^(NSError *error, id responseObject) {
            if (error) return ;
            [self updateCustomerInfo];
        }];
    }
    

}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    //如果是弹出登陆页面 不显示导航栏
//    [SRUIUtil rootViewController].navigationBarHidden = [SRUIUtil rootViewController].presentedViewController?YES:NO;
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [[SREventCenter sharedInterface] removeObserver:self observerQueue:dispatch_get_main_queue()];
    [kvoController unobserveAll];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - SREventCenter

- (void)loginStatusChange:(SRLoginStatus)status
{
    if (status != SRLoginStatus_NotLogin) {
        self.labelName.text = [SRPortal sharedInterface].customer.customerPhone.encodePhoneNumber;
        [self observeForUnreadMessages];
        [self updateCustomerInfo];
    }
}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return myTotalItems+1;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString * const reuseIdentifier = @"Cell";
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    cell.backgroundColor = [UIColor whiteColor];

    [(UIImageView *)[cell.contentView viewWithTag:100] setImage:indexPath.row<self.buttonIcons.count?self.buttonIcons[indexPath.row]:nil];
    [(UILabel *)[cell.contentView viewWithTag:101] setText:indexPath.row<self.buttonTitles.count?self.buttonTitles[indexPath.row]:nil];
    
    UIView *badge = [cell.contentView viewWithTag:102];
    badge.layer.cornerRadius = badge.width/2;
    badge.hidden = (indexPath.row!=1 && indexPath.row!=6)
                    || (indexPath.row==1 && ![SRPortal sharedInterface].customer.hasUnreadMessageInMessageCenter)
                    || (indexPath.row==6 && ![SRPortal sharedInterface].customer.hasNewMessageInIm);
//    NSLog(@"%zd %zd %zd", indexPath.row, [SRPortal sharedInterface].customer.hasUnreadMessageInMessageCenter, [SRPortal sharedInterface].customer.hasNewMessageInIm);
    
    return cell;
}

#pragma mark <UICollectionViewDelegate>

- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row!=2 && indexPath.row!=7 && ![self checkLoginStatus]) {
        return;
    }
    
    switch (indexPath.row) {
        case 0://预约启动
            if ([SRPortal sharedInterface].allVehicles.count == 0) {
                [SRUIUtil showAlertMessage:@"请先绑定车辆"];
            } else if ([SRPortal sharedInterface].currentVehicleBasicInfo.onlyPPKE) {
                [SRUIUtil showAlertMessage:SRLocal(@"error_no_ost")];
            } else {
                [self performSegueWithIdentifier:@"PushSROrderStartViewController" sender:nil];
            }
            break;
        case 1://消息中心
            [self performSegueWithIdentifier:@"PushSRMessageCenterViewController" sender:nil];
            break;
        case 2://安全设置
            [self performSegueWithIdentifier:@"PushSRSecuritySettingsViewController" sender:nil];
            break;
        case 3://车辆资料
            if ([SRPortal sharedInterface].allVehicles.count == 0) {
                [SRUIUtil showAlertMessage:@"请先绑定车辆"];
            } else {
                [self performSegueWithIdentifier:@"PushSRVehicleInfoViewController" sender:nil];
            }
            break;
        case 4://终端资料
            if ([SRPortal sharedInterface].allVehicles.count == 0) {
                [SRUIUtil showAlertMessage:@"请先绑定车辆"];
            } else {
                [self performSegueWithIdentifier:@"PushSRTerminalInfoViewController" sender:nil];
            }
            break;
        case 5://终端管理
            [self performSegueWithIdentifier:@"PushSRTerminalManageViewController" sender:nil];
            break;
        case 6://咪智汇客服
            [SRPortal sharedInterface].customer.hasNewMessageInIm = NO;
            [self performSegueWithIdentifier:@"PushSRCustomerServiceViewController" sender:nil];
            break;
        case 7://关于咪智汇
            [self performSegueWithIdentifier:@"PushSRAboutViewController" sender:nil];
            break;
            
        default:
            break;
    }
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
}

#pragma mark <UICollectionViewDelegateFlowLayout>

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake((collectionView.width-(rows-1)*padding)/rows,
                      (collectionView.width-(rows-1)*padding)/rows);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return padding;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return padding;
}

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsZero;
}

#pragma mark - Private

- (void)initViews {
    UIColor *vipColor = [UIColor colorWithRed:249.0/255.0 green:180.0/255.0 blue:48.0/255.0 alpha:1.0];
//    UIColor *extendColor = [UIColor colorWithRed:65.0/255.0 green:65.0/255.0 blue:65.0/255.0 alpha:1.0];
    UIColor *vipTitleColor = [UIColor colorWithRed:162.0/255.0 green:73.0/255.0 blue:4.0/255.0 alpha:1.0];
//    UIColor *extendTitleColor = [UIColor whiteColor];
//    @weakify(self)
//    [RACObserve(self.buttonVIP, enabled) subscribeNext:^(NSNumber *enabled) {
//        @strongify(self)
//        self.buttonVIP.backgroundColor = enabled.boolValue?extendColor:vipColor;
//        [self.buttonVIP setTitle:enabled.boolValue?@"续费":@"VIP" forState:UIControlStateNormal];
//        [self.buttonVIP setTitleColor:enabled.boolValue?extendTitleColor:vipTitleColor forState:UIControlStateNormal];
//    }];
    self.buttonVIP.backgroundColor = vipColor;
    [self.buttonVIP setTitle:@"续费" forState:UIControlStateNormal];
    [self.buttonVIP setTitleColor:vipTitleColor forState:UIControlStateNormal];
    self.buttonVIP.layer.cornerRadius = 8.0f;
    self.buttonVIP.layer.masksToBounds = YES;
    
    [[self.buttonVIP rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(UIButton *bt) {
        //跳转到续费页面
        if (![self checkLoginStatus]) {
            return;
        }
        
//        [SRPortal sharedInterface].customer.hasNewMessageInIm ^= 1;
//        [SRPortal sharedInterface].customer.hasNewMessageInAlert ^= 1;
    }];
    
    @weakify(self)
    [RACObserve(self.buttonSignIn, enabled) subscribeNext:^(NSNumber *enabled) {
        @strongify(self)
        [self.buttonSignIn setTitle:enabled.boolValue?@"签到":@"已签到" forState:UIControlStateNormal];
    }];
    [[self.buttonSignIn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(UIButton *bt) {
        if (![self checkLoginStatus]) {
            return;
        }
    }];
    
    self.middleView.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.35];
    self.middleView.alpha = 1.0;
    
    [self.labelBalance bk_whenTapped:^{
        if (![self checkLoginStatus]) {
            return;
        }
    }];
    
    [self.labelIntegral bk_whenTapped:^{
        if (![self checkLoginStatus]) {
            return;
        }
    }];
    
    [self.buttonLogin bk_whenTapped:^{
        if (![self checkLoginStatus]) {
            return;
        } else if ([SRUserDefaults isExperienceUser]) {
//            [SRPortal logoutWithCompleteBlock:nil];
            [SRUIUtil ModalSRLoginViewController];
        }
    }];
    
    [self updateBalance:.0f];
    [self updateIntergral:0];
}

- (void)updateBalance:(CGFloat)balance {
    NSString *balanceStr = [NSString stringWithFormat:@"%.2f", balance];
    NSString *string = [NSString stringWithFormat:@"%@ 元\n我的账户", balanceStr];
    NSRange balanceStrRange = [string rangeOfString:balanceStr];
    NSRange otherRange = NSMakeRange(balanceStrRange.length, string.length - balanceStrRange.length);
    NSMutableAttributedString *attributedstr = [[NSMutableAttributedString alloc] initWithString:string];
    [attributedstr addAttribute:NSFontAttributeName
                          value:[UIFont boldSystemFontOfSize:iPhone6Plus?20.0f:17.0f]
                          range:balanceStrRange];
    [attributedstr addAttribute:NSFontAttributeName
                          value:[UIFont boldSystemFontOfSize:iPhone6Plus?12.0f:10.0f]
                          range:otherRange];
    [attributedstr addAttribute:NSKernAttributeName
                          value:@(2)
                          range:otherRange];
    self.labelBalance.attributedText = attributedstr;
    self.labelBalance.textColor = [UIColor whiteColor];
}

- (void)updateIntergral:(NSInteger)intergral {
    NSString *intergralStr = [NSString stringWithFormat:@"%@", @(intergral)];
    NSString *string = [NSString stringWithFormat:@"%@\n我的积分", intergralStr];
    NSRange intergralStrRange = [string rangeOfString:intergralStr];
    NSRange otherRange = NSMakeRange(intergralStr.length, string.length - intergralStr.length);
    NSMutableAttributedString *attributedstr = [[NSMutableAttributedString alloc] initWithString:string];
    [attributedstr addAttribute:NSFontAttributeName
                          value:[UIFont boldSystemFontOfSize:iPhone6Plus?20.0f:17.0f]
                          range:intergralStrRange];
    [attributedstr addAttribute:NSFontAttributeName
                          value:[UIFont boldSystemFontOfSize:iPhone6Plus?12.0f:10.0f]
                          range:otherRange];
    [attributedstr addAttribute:NSKernAttributeName
                          value:@(2)
                          range:otherRange];
    self.labelIntegral.attributedText = attributedstr;
    self.labelIntegral.textColor = [UIColor whiteColor];
}

- (void)observeForUnreadMessages {
    
    void (^refreshImageBlock)() = ^(){
        [self.collectionView reloadItemsAtIndexPaths:@[[NSIndexPath indexPathForRow:1 inSection:0],
                                                       [NSIndexPath indexPathForRow:6 inSection:0]]];
    };
    
    [kvoController unobserveAll];
    [kvoController observe:[SRPortal sharedInterface].customer keyPaths:@[@"hasNewMessageInIm", @"hasNewMessageInAlert", @"hasNewMessageInRemind", @"hasNewMessageInFunction"] options:NSKeyValueObservingOptionNew block:^(id observer, id object, NSDictionary *change) {
        [self executeOnMain:^{
            refreshImageBlock();
        } afterDelay:0];
    }];
    
    refreshImageBlock();
    
//    if ([SRUserDefaults isLogin]) {
//        [SRPortal queryMessageUnreadCountWithCompleteBlock:nil];
//    }
}

- (void)updateViews {
    
    if ([SRUserDefaults isExperienceUser]) {
        [self updateBalance:0.0f];
        [self updateIntergral:0.0f];
        self.labelName.text = nil;
        self.labelName.hidden = YES;
        self.iconHead.hidden = YES;
        self.buttonVIP.hidden = YES;
        self.labelDays.hidden = YES;
        self.buttonSignIn.hidden = YES;
        self.labelSignInfo.hidden = YES;
        
        self.buttonLogin.hidden = NO;
//        [self.buttonLogin setTitle:@"注册" forState:UIControlStateNormal];
    } else {
        [self updateBalance:[SRUserDefaults isLogin]?[SRPortal sharedInterface].customer.accountCash:0.0f];
        [self updateIntergral:[SRUserDefaults isLogin]?[SRPortal sharedInterface].customer.point:0.0f];
        self.labelName.text = [SRUserDefaults isLogin]?[SRPortal sharedInterface].customer.customerPhone.encodePhoneNumber:nil;
        self.labelName.hidden = ![SRUserDefaults isLogin];
        self.iconHead.hidden = ![SRUserDefaults isLogin];
        self.buttonVIP.hidden = ![SRUserDefaults isLogin];
        self.labelDays.hidden = ![SRUserDefaults isLogin];
        self.buttonSignIn.hidden = ![SRUserDefaults isLogin];
        self.labelSignInfo.hidden = ![SRUserDefaults isLogin];
        
        self.buttonLogin.hidden = [SRUserDefaults isLogin];
//        [self.buttonLogin setTitle:@"登陆/注册" forState:UIControlStateNormal];
    }

}

- (void)updateCustomerInfo
{
    self.labelName.text = [SRPortal sharedInterface].customer.customerPhone.encodePhoneNumber;
//            self.labelName.text = [SRUserDefaults isLogin]?[SRPortal sharedInterface].customer.customerPhone.encodePhoneNumber:nil;
//            self.buttonLogin.hidden = [SRUserDefaults isLogin];

    if ([SRPortal sharedInterface].customer.headImg) {
        [self.iconHead sd_setImageWithURL:[NSURL URLWithString:[SRPortal sharedInterface].customer.headImg]];
    }
    self.labelDays.hidden = ![SRPortal sharedInterface].customer.hasCarNeedRenew;
    self.labelDays.text = @"即将有车辆服务到期";
    self.labelSignInfo.text = [NSString stringWithFormat:@"已连续签到%zd天", [SRPortal sharedInterface].customer.continuousSignDay];
    self.buttonSignIn.enabled = ![SRPortal sharedInterface].customer.isSigned;
    [self updateBalance:[SRPortal sharedInterface].customer.accountCash];
    [self updateIntergral:[SRPortal sharedInterface].customer.point];
}

#pragma mark -
#pragma mark 按钮事件

- (IBAction)buttonVIPPressed:(id)sender {
    if (![self checkLoginStatus]) {
        return;
    } else if ([self checkExperienceUserStatus]) {
        return;
    }
    
    [self performSegueWithIdentifier:@"PushSRExtendViewController" sender:nil];
}

- (IBAction)buttonSignInPressed:(id)sender {
    [SRUIUtil showLoadingHUDWithTitle:nil];
    [SRPortal signDailyWithCompleteBlock:^(NSError *error, id responseObject) {
        [SRUIUtil dissmissLoadingHUD];
        if (error) {
            [SRUIUtil showAlertMessage:error.domain];
        } else {
            [self updateCustomerInfo];
        }
    }];
}

#pragma mark - Getter

- (NSArray *)buttonIcons {
    if (_buttonIcons) {
        return _buttonIcons;
    }
    
    _buttonIcons = @[[UIImage imageNamed:@"ic_order_start_my"],
                     [UIImage imageNamed:@"ic_message_center_my"],
                     [UIImage imageNamed:@"ic_security_my"],
                     [UIImage imageNamed:@"ic_vehicle_info_my"],
                     [UIImage imageNamed:@"ic_terminal_info_my"],
                     [UIImage imageNamed:@"ic_terminal_manage_my"],
                     [UIImage imageNamed:@"ic_service_my"],
                     [UIImage imageNamed:@"ic_about_my"]];
    return _buttonIcons;
}

- (NSArray *)buttonTitles {
    if (_buttonTitles) {
        return _buttonTitles;
    }
    
    _buttonTitles = @[@"预约启动",
                      @"消息中心",
                      @"账户安全",
                      @"车辆资料",
                      @"终端资料",
                      @"终端管理",
                      @"在线客服",
                      @"关于我们"];
    return _buttonTitles;
}

@end

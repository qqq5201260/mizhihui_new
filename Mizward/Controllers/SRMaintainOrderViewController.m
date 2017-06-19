//
//  SRMaintainOrderViewController.m
//  SiRuiV4.0
//
//  Created by zhangjunbo on 15/7/14.
//  Copyright (c) 2015年 SiRui. All rights reserved.
//

#import "SRMaintainOrderViewController.h"
#import "SRMaintainProgressView.h"
#import "SRTableViewCell.h"
#import "SRMaintainOrderCell.h"
#import "SRMaintainSpecialCell.h"
#import "SRUIUtil.h"
#import "SRMaintainDetailViewController.h"
#import "SRPortal.h"
#import "SRVehicleBasicInfo.h"
#import "SRVehicleStatusInfo.h"
#import "SRMaintain.h"
#import "SRMaintainReserveInfo.h"
#import "SRMaintainRequest.h"
#import "SRUserDefaults.h"
#import "SRPortal+CarInfo.h"
#import "SRDataBase+MaintainReserve.h"
#import <pop/POP.h>

@interface SRMaintainOrderViewController ()
@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet SRMaintainProgressView *progressView;

@property (weak, nonatomic) IBOutlet UILabel *lb_current;
@property (weak, nonatomic) IBOutlet UITextField *tx_current;
@property (weak, nonatomic) IBOutlet UILabel *lb_next;
@property (weak, nonatomic) IBOutlet UITextField *tx_next;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) UIButton *bt_more;

@property (strong, nonatomic) SRMaintainReserveInfo *reserveInfo;

@end

@implementation SRMaintainOrderViewController
{
    BOOL isExpand;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.topView.backgroundColor = [UIColor defaultColor];
    
    [self initView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self updateView];
    
    [[SRDataBase sharedInterface] queryMaintainReserveInfoByVehicleID:[SRUserDefaults currentVehicleID] withCompleteBlock:^(NSError *error, id responseObject) {
        self.reserveInfo = responseObject;
        [self.tableView reloadData];
    }];
    
    SRMaintainRequestQueryReserve *request = [[SRMaintainRequestQueryReserve alloc] init];
    request.vehicleID = [SRUserDefaults currentVehicleID];
    [SRMaintain queryMaintainReserveWithRequest:request andCompleteBlock:^(NSError *error, id responseObject) {
//        if (responseObject) {
            self.reserveInfo = responseObject;
            [self.tableView reloadData];
//        }
    }];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    self.tx_current.bk_didBeginEditingBlock = nil;
    self.tx_current.bk_didEndEditingBlock = nil;
    self.tx_next.bk_didBeginEditingBlock = nil;
    self.tx_next.bk_didEndEditingBlock = nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return section==0?30.0f:10.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return section==0?0:40.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section != 0) return nil;
    
    UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, [self tableView:tableView heightForHeaderInSection:section])];
    
    UIImage *image = [UIImage imageNamed:@"ic_appeal"];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    imageView.image = image;
    [header addSubview:imageView];
    [imageView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(header).with.offset(20.0f);
        make.centerY.equalTo(header);
        make.size.equalTo(image.size);
    }];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
    label.font = [UIFont systemFontOfSize:14.0f];
    label.text = @"下次保养项目";
    [header addSubview:label];
    [label makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(imageView.mas_right).with.offset(10.0f);
        make.centerY.equalTo(header);
        make.right.equalTo(header);
    }];
    
    return header;
}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section
{
    view.tintColor = [UIColor defaultBackgroundColor];
}

- (void)tableView:(UITableView *)tableView willDisplayFooterView:(UIView *)view forSection:(NSInteger)section {
    view.tintColor = [UIColor defaultBackgroundColor];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(SRTableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [cell setFisrtCell:indexPath.row==0
              lastCell:indexPath.row == [self tableView:tableView numberOfRowsInSection:indexPath.section]-1];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section!=1 && indexPath.row!=1) {
        return;
    }
    
    isExpand ^= 1;
    
    NSMutableArray *indexPaths = [NSMutableArray array];
    [self.reserveInfo.uncommonMaintenItems enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
       [indexPaths addObject:[NSIndexPath indexPathForRow:idx+1 inSection:1]];
    }];
    SRTableViewCell *cell = (SRTableViewCell *)[tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]];
    if (isExpand) {
        [cell setFisrtCell:YES lastCell:NO];
        [tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationFade];
    } else {
        [cell setFisrtCell:YES lastCell:YES];
        [tableView deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationFade];
    }
    
    CGSize size = self.bt_more.viewSize;
    POPBasicAnimation *rotationAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerRotation];
    rotationAnimation.duration = 0.35;
    rotationAnimation.fromValue = isExpand?@(0):@(M_PI);
    rotationAnimation.toValue = isExpand?@(M_PI):@(0);
    [self.bt_more.layer pop_addAnimation:rotationAnimation forKey:@"rotationAnimation"];
    self.bt_more.viewSize = size;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return [SRMaintainOrderCell heightWithSpecialTypes:self.hasSpecialMaintain];
    } else {
        return 44.0f;
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    } else if (isExpand) {
        return 1 + self.reserveInfo.uncommonMaintenItems.count;
    } else {
        return 1;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.hasSpecialAlert?2:1;
}

static NSString *OrderCellIdentifier = @"OrderCellIdentifier" ;
static NSString *SpecialCellIdentifier = @"SpecialCellIdentifier" ;
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return [self tableView:tableView cellForOrderWithRowAtIndexPath:indexPath];
    } else {
        return [self tableView:tableView cellForSpecialWithRowAtIndexPath:indexPath];
    }
}

#pragma mark - 私有方法

- (void)initView
{
    UIView *view1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 5)];
    UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 20, self.tx_current.height)];
    label1.text = @"km";
    label1.textColor = [UIColor whiteColor];
    label1.font = [UIFont systemFontOfSize:12.0f];
    self.tx_current.rightView = label1;
    self.tx_current.rightViewMode = UITextFieldViewModeAlways;
    self.tx_current.leftView = view1;
    self.tx_current.leftViewMode = UITextFieldViewModeAlways;
    self.tx_current.textColor = [UIColor whiteColor];
    self.tx_current.layer.borderWidth = 1.0f;
    self.tx_current.layer.borderColor = [UIColor colorWithWhite:1.0 alpha:0.6].CGColor;
    self.tx_current.layer.cornerRadius = 5.0f;
    self.tx_current.tintColor = [UIColor whiteColor];
    self.tx_current.keyboardType = UIKeyboardTypeNumberPad;
    
    UIView *view2 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 5)];
    UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 20, self.tx_next.height)];
    label2.text = @"km";
    label2.textColor = [UIColor whiteColor];
    label2.font = [UIFont systemFontOfSize:12.0f];
    self.tx_next.rightView = label2;
    self.tx_next.rightViewMode = UITextFieldViewModeAlways;
    self.tx_next.leftView = view2;
    self.tx_next.leftViewMode = UITextFieldViewModeAlways;
    self.tx_next.textColor = [UIColor whiteColor];
    self.tx_next.layer.borderWidth = 1.0f;
    self.tx_next.layer.borderColor = [UIColor colorWithWhite:1.0 alpha:0.6].CGColor;
    self.tx_next.layer.cornerRadius = 5.0f;
    self.tx_next.tintColor = [UIColor whiteColor];
    self.tx_next.keyboardType = UIKeyboardTypeNumberPad;
    
    UINib *nib = [UINib nibWithNibName:@"SRMaintainOrderCell" bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:OrderCellIdentifier];
    UINib *nib1 = [UINib nibWithNibName:@"SRMaintainSpecialCell" bundle:nil];
    [self.tableView registerNib:nib1 forCellReuseIdentifier:SpecialCellIdentifier];
}

- (void)updateView {
    NSInteger mileage = [SRPortal sharedInterface].currentVehicleBasicInfo.status.mileAge;
    NSInteger preMaintenMileage = [SRPortal sharedInterface].currentVehicleBasicInfo.preMaintenMileage;
    NSInteger nextMaintenMileage = [SRPortal sharedInterface].currentVehicleBasicInfo.nextMaintenMileage;
    
    self.lb_current.text = @"当前行驶里程";
    self.tx_current.text = [NSString stringWithFormat:@"%zd", mileage];
    self.lb_next.text = @"下次保养里程";
    self.tx_next.text = [NSString stringWithFormat:@"%zd", nextMaintenMileage];
    
    if (mileage >= nextMaintenMileage) {
        self.progressView.progress = 1.0;
    } else {
        self.progressView.progress = (mileage-preMaintenMileage)*1.0f/(nextMaintenMileage-preMaintenMileage);
    }
    
    self.tx_current.bk_didBeginEditingBlock = ^(UITextField *textField){
        if (![self checkLoginStatus]) {
            [textField resignFirstResponder];
        } else if (![[SRPortal sharedInterface].currentVehicleBasicInfo hasTerminal]) {
            [textField resignFirstResponder];
            [SRUIUtil showBindTerminalAlert];
        }
    };
    self.tx_current.bk_didEndEditingBlock = ^(UITextField *textField){
        if ([self checkExperienceUserStatus]) {
            return ;
        }
        if (mileage != textField.text.integerValue) {
            [self updateCurrentMileage:textField.text.integerValue];
        }
    };
    
    self.tx_next.bk_didBeginEditingBlock = ^(UITextField *textField){
        if (![self checkLoginStatus]) {
            [textField resignFirstResponder];
        } else if (![[SRPortal sharedInterface].currentVehicleBasicInfo hasTerminal]) {
            [textField resignFirstResponder];
            [SRUIUtil showBindTerminalAlert];
        }
    };
    self.tx_next.bk_didEndEditingBlock = ^(UITextField *textField){
        if ([self checkExperienceUserStatus]) {
            return ;
        }
        if (nextMaintenMileage != textField.text.integerValue) {
            [self updateNextMaintainMileage:textField.text.integerValue];
        }
    };
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForOrderWithRowAtIndexPath:(NSIndexPath *)indexPath
{
    SRMaintainOrderCell *cell = [tableView dequeueReusableCellWithIdentifier:OrderCellIdentifier];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.orderPressedBlock = ^(){
        if (![self checkLoginStatus]) {
            return ;
        }
        
        if (![[SRPortal sharedInterface].currentVehicleBasicInfo hasTerminal]) {
            [SRUIUtil showBindTerminalAlert];
            return;
        }
        
        [self performSegueWithIdentifier:@"PushSRMaintainStroeViewController" sender:nil];
    };
    
    cell.recordPressedBlock = ^(){
        if (![self checkLoginStatus]) {
            return ;
        }
        
        if (![[SRPortal sharedInterface].currentVehicleBasicInfo hasTerminal]) {
            [SRUIUtil showBindTerminalAlert];
            return;
        }
        
        SRMaintainDetailViewController *vc = [[SRUIUtil MaintainStoryBoard] instantiateViewControllerWithIdentifier:@"SRMaintainDetailViewController"];
        vc.isAdd = @(YES);
        [self.navigationController pushViewController:vc animated:YES];
    };
    
    cell.reserveInfo = self.reserveInfo;
    
    return cell;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForSpecialWithRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        SRTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CellIdentifier"];
        if (cell == nil) {
            cell = [[SRTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                          reuseIdentifier:@"CellIdentifier"];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.imageView.image = [UIImage imageNamed:@"ic_special_alert"];
        cell.textLabel.text = @"以下几项非常规保养请留意";
        cell.textLabel.font = [UIFont systemFontOfSize:13.0f];
        
        [cell.contentView addSubview:self.bt_more];
        [self.bt_more makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(cell.contentView);
            make.size.equalTo(CGSizeMake(cell.height, cell.height));
            make.trailing.equalTo(cell.contentView).with.offset(-10.0f);
        }];
        
        if (isExpand) {
            CGAffineTransform rotation = CGAffineTransformMakeRotation(M_PI);
            [self.bt_more setTransform:rotation];
        }
        
        return cell;
    } else {
        SRMaintainSpecialCell *cell = [tableView dequeueReusableCellWithIdentifier:SpecialCellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.uncommonItem = self.reserveInfo.uncommonMaintenItems[indexPath.row-1];
        
        return cell;
    }
}

- (void)updateCurrentMileage:(NSInteger)mileage {
    [SRUIUtil showLoadingHUDWithTitle:nil];
    SRPortalRequestUpdateCurrentMileage *request = [[SRPortalRequestUpdateCurrentMileage alloc] init];
    request.vehicleID = [SRUserDefaults currentVehicleID];
    request.mileAge = mileage;
    [SRPortal updateCurrentMileageWithRequest:request andCompleteBlock:^(NSError *error, id responseObject) {
        [SRUIUtil dissmissLoadingHUD];
        if (error) {
            [SRUIUtil showAlertMessage:error.domain];
        } else {
            self.reserveInfo = responseObject;
            [self.tableView reloadData];
        }
        
        [self updateView];
    }];
}

- (void)updateNextMaintainMileage:(NSInteger)mileage {
    [SRUIUtil showLoadingHUDWithTitle:nil];
    SRPortalRequestUpdateNextMaintainMileage *request = [[SRPortalRequestUpdateNextMaintainMileage alloc] init];
    request.vehicleID = [SRUserDefaults currentVehicleID];
    request.nextMaintenMileage = mileage;
    [SRPortal updateNextMaintainMileageWithRequest:request andCompleteBlock:^(NSError *error, id responseObject) {
        [SRUIUtil dissmissLoadingHUD];
        if (error) {
            [SRUIUtil showAlertMessage:error.domain];
        } else {
            self.reserveInfo = responseObject;
            [self.tableView reloadData];
        }
        [self updateView];
    }];
}

#pragma mark - Getter

- (BOOL)hasSpecialMaintain
{
    return self.reserveInfo && self.reserveInfo.commonMaintenItemsBottom && self.reserveInfo.commonMaintenItemsBottom.count>0;
}

- (BOOL)hasSpecialAlert
{
    return self.reserveInfo && self.reserveInfo.uncommonMaintenItems && self.reserveInfo.uncommonMaintenItems.count>0;
}

- (UIButton *)bt_more
{
    if (_bt_more) {
        return _bt_more;
    }
    
    UIImage *ic = [UIImage imageNamed:@"ic_special_more"];
    UIButton *bt_more = [UIButton buttonWithType:UIButtonTypeCustom];
    [bt_more setImage:ic forState:UIControlStateNormal];
    bt_more.layer.anchorPoint = CGPointMake(0.5, 0.5);
    bt_more.userInteractionEnabled = NO;
    
    _bt_more = bt_more;
    return _bt_more;
}

@end

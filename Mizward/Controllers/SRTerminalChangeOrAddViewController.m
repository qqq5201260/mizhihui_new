//
//  SRTerminalChangeOrAddViewController.m
//  Mizward
//
//  Created by zhangjunbo on 15/10/17.
//  Copyright © 2015年 Mizward. All rights reserved.
//

#import "SRTerminalChangeOrAddViewController.h"
#import "SRScanViewController.h"
#import "SRTableViewCell.h"
#import "SRUIUtil.h"
#import "SRPortal+Bluetooth.h"
#import "SRPortalRequest.h"
#import "SRPortalResponse.h"
#import "SRPortal+Regist.h"
#import "SRPortal+CarInfo.h"
#import "SRVehicleBasicInfo.h"
#import "SRUserDefaults.h"
#import <ActionSheetPicker-3.0/ActionSheetPicker.h>

@interface SRTerminalChangeOrAddViewController () <SRScanViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *bt_done;

@property (weak, nonatomic) UITextField *tx_imei;
@property (weak, nonatomic) UILabel *lb_plateNumber;

@property (nonatomic, assign) NSInteger selectedVehicleID;

@property (nonatomic, strong) NSArray *desctiptions;
@property (nonatomic, strong) NSMutableArray *plateNumbers;

@end

@implementation SRTerminalChangeOrAddViewController
{
    BOOL hasAddRACObserver;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.title = SRLocal(@"title_terminal_change_add");
    
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.backgroundView.backgroundColor = [UIColor clearColor];
    
    [self.bt_done setTitle:SRLocal(@"bt_done") forState:UIControlStateNormal];
    self.bt_done.layer.cornerRadius = 5.0f;
    RAC(self.bt_done, backgroundColor) = [RACSignal combineLatest:@[RACObserve(self.bt_done, enabled)] reduce:^(NSNumber *enabled){
        return enabled.boolValue?[UIColor defaultColor]:[UIColor disableColor];
    }];
    
    self.selectedVehicleID = [SRUserDefaults currentVehicleID];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self initRAC];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
//    [self.tableView reloadData];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [SRUIUtil endEditing];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
//    self.tx_imei.bk_didEndEditingBlock = nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    label.text = self.desctiptions[section];
    label.textColor = [UIColor darkGrayColor];
    [view addSubview:label];
    [label makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(view).with.offset(10.0f);
        make.bottom.equalTo(view).with.offset(-10.0f);
        make.left.equalTo(view).with.offset(20.0f);
        make.right.equalTo(view).with.offset(-20.0f);
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0 && [SRPortal sharedInterface].vehicleDic.count>1) {
        [self presentVehicleSelectPicker];
    } else if (indexPath.section == 1) {
        [self presentQrScanViewController];
    }
}


#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.desctiptions.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CellIdentifier" ;
    SRTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[SRTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:CellIdentifier];
    }
    
    UITextField *input = (UITextField *)[cell.contentView viewWithTag:100];
    
    if (indexPath.section == 0) {
        input.userInteractionEnabled = NO;
        self.lb_plateNumber = cell.textLabel;
        cell.textLabel.text = [self selectedVehiclePlatenumber];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    } else {
        input.userInteractionEnabled = YES;
        input.placeholder = SRLocal(@"placeholder_imei");
        self.tx_imei = input;
        self.tx_imei.bk_didEndEditingBlock = ^(UITextField *textField){
            if (textField.text.length>0) {
                [self validateIMEI:textField.text];
            }
        };
        
        UIImage *ic = [UIImage imageNamed:@"bt_bind_scan"];
        UIButton *bt_scan = [[UIButton alloc] initWithFrame:CGRectMake(.0f, .0f, ic.size.width, ic.size.height)];
        [bt_scan setImage:ic forState:UIControlStateNormal];
        [bt_scan bk_whenTapped:^{
            [self presentQrScanViewController];
        }];
        cell.accessoryView = bt_scan;
    }
    
    return cell;
}

#pragma mark - SRScanViewControllerDelegate

- (void)scanResult:(NSString *)result withVehicleInfo:(SRVehicleInfo *)vehicleInfo
{
    self.tx_imei.text = result;
    self.selectedVehicleID = self.selectedVehicleID;
}

#pragma mark - 交互事件

- (IBAction)buttonDonepressed:(id)sender {
    
    if ([self checkExperienceUserStatus]) {
        return;
    }
    
    [SRUIUtil showLoadingHUDWithTitle:nil];
    SRPortalRequestChangeOrAddDevice *request = [[SRPortalRequestChangeOrAddDevice alloc] init];
    request.imei = self.tx_imei.text;
    request.vehicleID = self.selectedVehicleID;
    [SRPortal changeOrAddDeviceWithRequest:request andCompleteBlock:^(NSError *error, id responseObject) {
        [SRUIUtil dissmissLoadingHUD];
        if (error) {
            [SRUIUtil showAlertMessage:error.domain];
        } else {
            //后台重新查询车辆基本信息
            SRPortalRequestQueryCarBasicInfo *request = [[SRPortalRequestQueryCarBasicInfo alloc] init];
            request.plateNumber = self.lb_plateNumber.text;
            request.vehicleID = self.selectedVehicleID;
            [SRPortal queryVehicleBasicInfoWithRequest:request andCompleteBlock:^(NSError *error, NSMutableDictionary *dic) {
                if (error) return ;
                
                NSArray *vehicles = dic.allValues;
                [vehicles enumerateObjectsUsingBlock:^(SRVehicleBasicInfo *obj, NSUInteger idx, BOOL *stop) {
                    SRPortalRequestQueryCarStatusInfo *request = [[SRPortalRequestQueryCarStatusInfo alloc] init];
                    request.vehicleID = obj.vehicleID;
                    [SRPortal queryVehicleStatusInfoWithRequest:request andCompleteBlock:nil];
                }];
                [SRPortal querySMSCommandsWithCompleteBlock:nil];
            }];
            
            [self.navigationController popViewControllerAnimated:YES];
            [SRUIUtil showAutoDisappearHUDWithMessage:@"操作成功" isDetail:NO];
        }
    }];
}

#pragma mark - Getter

- (NSArray *)desctiptions {
    if (!_desctiptions) {
        _desctiptions = @[@"请选择您的爱车",SRLocal(@"description_imei")];
    }
    
    return _desctiptions;
}

- (NSArray *)plateNumbers {
    if (!_plateNumbers) {
        _plateNumbers = [NSMutableArray array];
        [[SRPortal sharedInterface].vehicleDic.allValues enumerateObjectsUsingBlock:^(SRVehicleBasicInfo *obj, NSUInteger idx, BOOL *stop) {
            [self->_plateNumbers addObject:obj.plateNumber];
        }];
    }
    
    return _plateNumbers;
}

#pragma mark - 私有方法

- (void)presentQrScanViewController {
    if ([SRUIUtil cameraAuthorization]) {
        SRScanViewController *vc = (SRScanViewController *)[SRUIUtil SRScanViewController];
        vc.delegate = self;
        vc.type = @(SRScanViewControllerType_Terminal);
        UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:SRLocal(@"nav_back")
                                                                 style:UIBarButtonItemStylePlain target:nil action:nil];
        self.navigationItem.backBarButtonItem = item;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (void)presentVehicleSelectPicker {
    NSInteger defaultSelection = [self.plateNumbers indexOfObject:self.lb_plateNumber.text];
    ActionSheetStringPicker *picker = [[ActionSheetStringPicker alloc] initWithTitle:nil rows:self.plateNumbers initialSelection:defaultSelection doneBlock:^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue) {
        self.lb_plateNumber.text = self.plateNumbers[selectedIndex];
        self.selectedVehicleID = [[SRPortal sharedInterface] vehicleBasicInfoWithPlateNubmer:self.plateNumbers[selectedIndex]].vehicleID;
    } cancelBlock:^(ActionSheetStringPicker *picker) {
        
    } origin:self.view];
    picker.tapDismissAction = TapActionCancel;
    [picker showActionSheetPicker];
}

- (void)initRAC {
    
    self.bt_done.enabled = self.tx_imei.text.length>0 && self.selectedVehicleID>0;
    
    if (hasAddRACObserver) return;
    
    hasAddRACObserver = YES;
    RAC(self.bt_done, enabled) = [RACSignal combineLatest:@[self.tx_imei.rac_textSignal,
                                                            RACObserve(self, selectedVehicleID)]
                                                   reduce:^(NSString *imei, NSInteger vehicleID){
                                                       return @(self.tx_imei.text.length>0 && self.selectedVehicleID>0);
                                                   }];
}

- (NSString *)selectedVehiclePlatenumber {
    if (self.selectedVehicleID<=0) {
        return @"请选车车辆";
    } else {
        return [[SRPortal sharedInterface] vehicleBasicInfoWithVehicleID:self.selectedVehicleID].plateNumber;
    }
}

- (void)validateIMEI:(NSString *)imei {
    [SRUIUtil showLoadingHUDWithTitle:nil];
    SRPortalRequestValidateIMEI *request = [[SRPortalRequestValidateIMEI alloc] init];
    request.imei = imei;
//    @weakify(self)
    [SRPortal validateIMEIWithRequest:request andCompleteBlock:^(NSError *error, SRPortalResponseValideIMEI *info) {
        [SRUIUtil dissmissLoadingHUD];
//        @strongify(self)
        if (error) {
            [SRUIUtil showAlertMessage:error.domain];
        }
//        else if (info && info.bname && info.bname.length > 0) {
//            self.tx_vehicle.text = info.vmname;
//            SRVehicleInfo *vehicleInfo = [[SRVehicleInfo alloc] init];
//            vehicleInfo.vehicleName = info.vmname;
//            vehicleInfo.vehicleModelID = info.vmid;
//            self.vehicleInfo = vehicleInfo;
//        }
    }];
}


@end

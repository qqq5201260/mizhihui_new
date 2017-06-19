//
//  SRTerminalBindViewController.m
//  
//
//  Created by zhangjunbo on 15/6/15.
//
//

#import "SRTerminalBindViewController.h"
#import "SRUIUtil.h"
#import "SRPortal+Regist.h"
#import "SRPortal+CarInfo.h"
#import "SRVehicleInfo.h"
#import "SRPortalRequest.h"
#import "SRVehicleBasicInfo.h"
#import "SRBrandVehicleViewController.h"
#import "SRKeychain.h"
#import "SRTableViewCell.h"
#import "SRPortalResponse.h"
#import "SRScanViewController.h"

@interface SRTerminalBindViewController ()
<SRBrandVehicleViewControllerDelegate,
SRScanViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *bt_done;

@property (weak, nonatomic) UITextField *tx_imei;
@property (weak, nonatomic) UITextField *tx_vehicle;

@property (nonatomic, strong) NSArray *desctiptions;
@property (nonatomic, strong) NSArray *placeHolders;

@property (nonatomic, strong) SRVehicleInfo *vehicleInfo;

@end

@implementation SRTerminalBindViewController
{
    BOOL hasAddRACObserver;
}

#pragma mark - 生命周期

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.title = SRLocal(@"title_terminal_bind");
    
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.backgroundView.backgroundColor = [UIColor clearColor];
    
    [self.bt_done setTitle:SRLocal(@"bt_done") forState:UIControlStateNormal];
    self.bt_done.layer.cornerRadius = 5.0f;
    RAC(self.bt_done, backgroundColor) = [RACSignal combineLatest:@[RACObserve(self.bt_done, enabled)] reduce:^(NSNumber *enabled){
        return enabled.boolValue?[UIColor defaultColor]:[UIColor disableColor];
    }];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self initRAC];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    self.tx_imei.bk_didEndEditingBlock = nil;
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
    input.placeholder = self.placeHolders[indexPath.section];
    
    if (indexPath.section == 0) {
        self.tx_vehicle = input;
        self.tx_vehicle.userInteractionEnabled = NO;
        if (self.vehicleInfo) {
            self.tx_vehicle.text = self.vehicleInfo.vehicleName;
        }
        
        UIButton *bt_vehicle = [[UIButton alloc] initWithFrame:CGRectMake(.0f, .0f, 40.0f, 40.0f)];
        [bt_vehicle setImage:[UIImage imageNamed:@"bt_bind_vehicle"] forState:UIControlStateNormal];
        [bt_vehicle bk_whenTapped:^{
            [self presendBrandVehicleViewController];
        }];
        
        cell.accessoryView = bt_vehicle;
    } else {
        self.tx_imei = input;
        self.tx_imei.bk_didEndEditingBlock = ^(UITextField *textField){
            if (textField.text.length>0) {
                [self validateIMEI:textField.text];
            }
        };
        
        UIButton *bt_scan = [[UIButton alloc] initWithFrame:CGRectMake(.0f, .0f, 40.0f, 40.0f)];
        [bt_scan setImage:[UIImage imageNamed:@"bt_bind_scan"] forState:UIControlStateNormal];
        [bt_scan bk_whenTapped:^{
            [self presentQrScanViewController];
        }];
        cell.accessoryView = bt_scan;
    }
    
    return cell;
}


#pragma mark - SRBrandVehicleViewControllerDelegate

- (void)selectedBrandInfo:(SRBrandInfo *)brandInfo seriesInfo:(SRSeriesInfo *)seriesInfo andVehicleInfo:(SRVehicleInfo *)vehicleInfo
{
    if (vehicleInfo) {
        self.vehicleInfo = vehicleInfo;
        self.tx_vehicle.text = self.vehicleInfo.vehicleName;
    }
}

#pragma mark - SRScanViewControllerDelegate

- (void)scanResult:(NSString *)result withVehicleInfo:(SRVehicleInfo *)vehicleInfo
{
    self.tx_imei.text = result;
    if (vehicleInfo && vehicleInfo.vehicleModelID>0) {
        self.vehicleInfo = vehicleInfo;
    }
    self.tx_vehicle.text = self.vehicleInfo.vehicleName;
}

#pragma mark - 交互事件

- (IBAction)buttonDonepressed:(id)sender {
    
    if ([self checkExperienceUserStatus]) {
        return;
    }
    
    [SRUIUtil showLoadingHUDWithTitle:nil];
    SRPortalRequestBindTerminal *request = [[SRPortalRequestBindTerminal alloc] init];
    request.imei = self.tx_imei.text;
    request.vehicleModelID = self.vehicleInfo.vehicleModelID;
    [SRPortal bindTerminalWithRequest:request andCompleteBlock:^(NSError *error, id responseObject) {
        [SRUIUtil dissmissLoadingHUD];
        if (error) {
            [SRUIUtil showAlertMessage:error.domain];
        } else {
            //后台重新查询车辆基本信息
            SRPortalRequestQueryCarBasicInfo *request = [[SRPortalRequestQueryCarBasicInfo alloc] init];
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
            
            [self.navigationController popToRootViewControllerAnimated:YES];
            [SRUIUtil showAutoDisappearHUDWithMessage:@"设备绑定成功" isDetail:NO];
        }
    }];
}

#pragma mark - Getter

- (NSArray *)placeHolders {
    if (!_placeHolders) {
        _placeHolders = @[ SRLocal(@"placeholder_vehicle"), SRLocal(@"placeholder_imei")];
    }
    
    return _placeHolders;
}

- (NSArray *)desctiptions {
    if (!_desctiptions) {
        _desctiptions = @[SRLocal(@"descrition_vehicle"),SRLocal(@"description_imei")];
    }
    
    return _desctiptions;
}

#pragma mark - 私有方法

- (void)presentQrScanViewController {
    if ([SRUIUtil cameraAuthorization]) {
        SRScanViewController *vc = (SRScanViewController *)[SRUIUtil SRScanViewController];
        vc.delegate = self;
        vc.type = @(SRScanViewControllerType_Terminal);
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (void)presendBrandVehicleViewController {
    SRBrandVehicleViewController *vc = [[SRBrandVehicleViewController alloc] init];
    vc.tableType = BrandVehicleType_Both;
    vc.delegate = self;
    [self.navigationController presentViewController:vc animated:YES completion:NULL];
}

- (void)initRAC {
    
    self.bt_done.enabled = self.tx_imei.text.length>0 && self.vehicleInfo && self.vehicleInfo.vehicleModelID>0;
    if (hasAddRACObserver) return;
    
    hasAddRACObserver = YES;
    RAC(self.bt_done, enabled) = [RACSignal combineLatest:@[self.tx_imei.rac_textSignal,
                                                            RACObserve(self, vehicleInfo)]
                                                   reduce:^(NSString *imei, SRVehicleInfo *vehicle){
                                                       return @(self.tx_imei.text.length>0 && vehicle && vehicle.vehicleModelID!=0);
                                                   }];
}

- (void)validateIMEI:(NSString *)imei {
    [SRUIUtil showLoadingHUDWithTitle:nil];
    SRPortalRequestValidateIMEI *request = [[SRPortalRequestValidateIMEI alloc] init];
    request.imei = imei;
    @weakify(self)
    [SRPortal validateIMEIWithRequest:request andCompleteBlock:^(NSError *error, SRPortalResponseValideIMEI *info) {
        [SRUIUtil dissmissLoadingHUD];
        @strongify(self)
        if (error) {
            [SRUIUtil showAlertMessage:error.domain];
        } else if (info && info.bname && info.bname.length > 0) {
            self.tx_vehicle.text = info.vmname;
            SRVehicleInfo *vehicleInfo = [[SRVehicleInfo alloc] init];
            vehicleInfo.vehicleName = info.vmname;
            vehicleInfo.vehicleModelID = info.vmid;
            self.vehicleInfo = vehicleInfo;
        }
    }];
}

@end

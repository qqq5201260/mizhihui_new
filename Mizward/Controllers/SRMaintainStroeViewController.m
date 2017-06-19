//
//  SRMaintainStroeViewController.m
//  SiRuiV4.0
//
//  Created by zhangjunbo on 15/7/14.
//  Copyright (c) 2015年 SiRui. All rights reserved.
//

#import "SRMaintainStroeViewController.h"
#import "UIView+FDCollapsibleConstraints.h"
#import "SRMaintainStoreCell.h"
#import "SRMaintain.h"
#import "SRUIUtil.h"
#import "SRDataBase+MaintainDep.h"
#import "SRPortal.h"
#import "SRCustomer.h"
#import "SRMaintainDepInfo.h"
#import "SRMaintainRequest.h"
#import "SRUserDefaults.h"
#import "UITableView+FDTemplateLayoutCell.h"
#import <ActionSheetPicker-3.0/ActionSheetPicker.h>
#import <DateTools/DateTools.h>

@interface SRMaintainStroeViewController () <CLLocationManagerDelegate, UISearchBarDelegate>

@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UIView *v_top;
@property (weak, nonatomic) IBOutlet UIView *v_day;
@property (weak, nonatomic) IBOutlet UITextField *tx_day;
@property (weak, nonatomic) IBOutlet UIView *v_time;
@property (weak, nonatomic) IBOutlet UITextField *tx_time;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *v_bottom;
@property (weak, nonatomic) IBOutlet UIButton *bt_order;

@property (weak, nonatomic) UILabel *lb_title;
@property (weak, nonatomic) UIBarButtonItem *searchItem;

@property (strong, nonatomic) CLLocationManager *locationManager;

@property (copy, nonatomic) NSString *address;
@property (strong, nonatomic) NSArray *timeBucket;

@property (strong, nonatomic) NSMutableArray *maintainDeps;

@property (strong, nonatomic) SRMaintainDepInfo *selectedDep;
@property (strong, nonatomic) NSDate *selectedDate;
@property (assign, nonatomic) NSInteger selectedTimeBucket;

@end

@implementation SRMaintainStroeViewController
{
    BOOL isSearchMod;
}

#pragma mark - 生命周期

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self initView];
    
    [[SRDataBase sharedInterface] queryAllMaintainDepsWithCompleteBlock:^(NSError *error, id responseObject) {
        if (responseObject) {
            self.maintainDeps = responseObject;
        }
    }];
    
    
    [SRMaintain queryMaintainDepWithCompleteBlock:^(NSError *error, id responseObject) {
        
        if (responseObject) {
            self.maintainDeps = responseObject;
        }
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.searchBar.fd_collapsed = YES;
    
    if ([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        [self.locationManager requestWhenInUseAuthorization];
    }
    [self.locationManager startUpdatingLocation];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.locationManager stopUpdatingLocation];
    
    self.maintainDeps = nil;
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

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [tableView fd_heightForCellWithIdentifier:CellIdentifier configuration:^(SRMaintainStoreCell *cell) {
        [self configureCell:cell atIndexPath:indexPath];
    }];
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
    if (isSearchMod) {
        self.selectedDep = self.maintainDeps[indexPath.row];
    } else if (indexPath.section == 0) {
        self.selectedDep = [self.maintainDeps firstObject];
    } else {
        self.selectedDep = self.maintainDeps[indexPath.row+1];
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (isSearchMod) {
        return self.maintainDeps.count;
    } else {
        return section==0?1:self.maintainDeps.count-1;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (!self.maintainDeps || self.maintainDeps.count == 0) {
        return 0;
    } else if (self.maintainDeps.count == 1 || isSearchMod) {
        return 1;
    } else {
        return 2;
    }
}

static NSString *CellIdentifier = @"CellIdentifier" ;
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SRMaintainStoreCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    [self configureCell:cell atIndexPath:indexPath];
    
    return cell;
}

- (void)configureCell:(SRMaintainStoreCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    if (isSearchMod) {
        cell.depInfo = self.maintainDeps[indexPath.row];
    }else if (indexPath.section == 0) {
        cell.depInfo = [self.maintainDeps firstObject];
    } else {
        cell.depInfo = self.maintainDeps[indexPath.row + 1];
    }
}

#pragma mark - CLLocationManagerDelegate

//获得位置信息
-(void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
    
    [manager stopUpdatingLocation];
    //重新计算距离
    self.maintainDeps = self.maintainDeps;
    
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder reverseGeocodeLocation:newLocation completionHandler:^(NSArray *placemarks, NSError *error) {
        if (error == nil && [placemarks count] > 0){
            CLPlacemark *placemark = [placemarks objectAtIndex:0];
            self.address = placemark.name;
            self.lb_title.attributedText = self.attributtedTitles;
        }
        else if (error == nil && [placemarks count] == 0){
            NSLog(@"No results were returned.");
        }
        else if (error != nil){
            NSLog(@"An error occurred = %@", error);
        }
    }];
}

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    switch (status) {
        case kCLAuthorizationStatusAuthorizedAlways:
        case kCLAuthorizationStatusAuthorizedWhenInUse:
            [_locationManager startUpdatingLocation];
            break;
        case kCLAuthorizationStatusNotDetermined:
            if ([_locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
                [_locationManager requestWhenInUseAuthorization];
            }
        default:
            break;
    }
}

#pragma mark - UISearchBarDelegate

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    isSearchMod = YES;
    [[SRDataBase sharedInterface] queryAllMaintainDepsNameLike:searchText withCompleteBlock:^(NSError *error, id responseObject) {
        if (responseObject) {
            self.maintainDeps = responseObject;
        }
    }];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    isSearchMod = YES;
    [SRUIUtil endEditing];
    [[SRDataBase sharedInterface] queryAllMaintainDepsNameLike:searchBar.text withCompleteBlock:^(NSError *error, id responseObject) {
        if (responseObject) {
            self.maintainDeps = responseObject;
        }
    }];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    [SRUIUtil endEditing];
    
    isSearchMod = NO;
    
    self.searchBar.fd_collapsed = YES;
    
    [[SRDataBase sharedInterface] queryAllMaintainDepsWithCompleteBlock:^(NSError *error, id responseObject) {
        if (responseObject) {
            self.maintainDeps = responseObject;
        }
    }];
}

#pragma mark - 交互操作

- (IBAction)buttonOrderPressed:(id)sender {
    
    if ([self checkExperienceUserStatus]) {
        return;
    }
    
    SRMaintainRequestAddReserve *request = [[SRMaintainRequestAddReserve alloc] init];
    request.vehicleID = [SRUserDefaults currentVehicleID];
    request.depID = self.selectedDep?self.selectedDep.depID:[SRPortal sharedInterface].customer.depID
    ;
    request.depName = self.selectedDep?self.selectedDep.name:[SRPortal sharedInterface].customer.depName;
    NSArray *timeBucket = [self.timeBucket[self.selectedTimeBucket] componentsSeparatedByString:@"-"];
    request.startTime = [NSString stringWithFormat:@"%@ %@:00", [self.selectedDate stringOfDateWithFormatYYYYMMdd], timeBucket[0]];
    request.endTime = [NSString stringWithFormat:@"%@ %@:00", [self.selectedDate stringOfDateWithFormatYYYYMMdd], timeBucket[1]];
    
    [SRUIUtil showLoadingHUDWithTitle:nil];
    [SRMaintain addMaintainReserveWithRequest:request andCompleteBlock:^(NSError *error, id responseObject) {
        [SRUIUtil dissmissLoadingHUD];
        if (error) {
            [SRUIUtil showAlertMessage:error.domain];
        } else {
            [self.navigationController popViewControllerAnimated:YES];
            [SRUIUtil showAutoDisappearHUDWithMessage:@"提交成功" isDetail:NO];
        }
    }];
}

#pragma mark - 私有方法

- (void)initView
{
    self.navigationItem.titleView = self.lb_title;
    self.navigationItem.rightBarButtonItem = self.searchItem;
    
    [self.searchBar setBarTintColor:[UIColor defaultColor]];
    
    UIBarButtonItem *searchCancel = [UIBarButtonItem appearanceWhenContainedIn:[UISearchBar class], nil];
    [searchCancel setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}
                                forState:UIControlStateNormal];
    
    UIImageView *padding1 = [[UIImageView  alloc] initWithImage:[UIImage imageNamed:@"ic_special_more"]];
    padding1.contentMode = UIViewContentModeCenter;
    padding1.frame = CGRectMake(0, 0, self.tx_day.height, self.tx_day.height);
    self.tx_day.rightView = padding1;
    self.tx_day.rightViewMode = UITextFieldViewModeAlways;
    self.tx_day.text = [[NSDate date] stringOfDateWithFormatYYYYMMdd];
    [self.v_day bk_whenTapped:^{
        [ActionSheetDatePicker showPickerWithTitle:@"请选择日期"
                                    datePickerMode:UIDatePickerModeDate
                                      selectedDate:[NSDate date]
                                       minimumDate:[NSDate date]
                                       maximumDate:[[NSDate date] dateByAddingDays:5]
                                         doneBlock:^(ActionSheetDatePicker *picker, id selectedDate, id origin) {
                                             self.tx_day.text = [selectedDate stringOfDateWithFormatYYYYMMdd];
                                             self.selectedDate = selectedDate;
                                         }
                                       cancelBlock:^(ActionSheetDatePicker *picker) {
                                           
                                       } origin:self.view];
    }];

    UIImageView *padding2 = [[UIImageView  alloc] initWithImage:[UIImage imageNamed:@"ic_special_more"]];
    padding2.contentMode = UIViewContentModeCenter;
    padding2.frame = CGRectMake(0, 0, self.tx_time.height, self.tx_time.height);
    self.tx_time.rightView = padding2;
    self.tx_time.rightViewMode = UITextFieldViewModeAlways;
    
    NSInteger hour = [NSDate date].hour;
    NSInteger index = MIN(8, MAX(0, hour-9));
    self.selectedDate = [NSDate date];
    self.tx_time.text = self.timeBucket[index];
    self.selectedTimeBucket = index;
//    self.tx_time.text = self.timeBucket[[NSDate date].hour];
    [self.v_time bk_whenTapped:^{
        [ActionSheetStringPicker showPickerWithTitle:@"请选择时间"
                                                rows:self.timeBucket
                                    initialSelection:self.selectedTimeBucket
                                           doneBlock:^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue) {
                                               self.tx_time.text = self.timeBucket[selectedIndex];
                                               self.selectedTimeBucket = selectedIndex;
                                           } cancelBlock:^(ActionSheetStringPicker *picker) {
                                               
                                           } origin:self.view];
    }];
    
    self.bt_order.layer.cornerRadius = 5.0f;
    [self.bt_order setTitle:@"预约" forState:UIControlStateNormal];
    
    UINib *nib = [UINib nibWithNibName:@"SRMaintainStoreCell" bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:CellIdentifier];
    self.tableView.backgroundView.backgroundColor = [UIColor clearColor];
    self.tableView.backgroundColor = [UIColor clearColor];
    
    [self.v_top bottomLine];
    [self.v_bottom topLine];
}

- (CGFloat)distanceToLocation:(CLLocationCoordinate2D)coordinate
{
    CLLocation *user = self.locationManager.location;
    CLLocation *store = [[CLLocation alloc] initWithLatitude:coordinate.latitude longitude:coordinate.longitude];
    return [user distanceFromLocation:store];
}

#pragma mark - Getter

- (CLLocationManager *)locationManager
{
    if (_locationManager) {
        return _locationManager;
    }
    
    CLLocationManager *locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    locationManager.distanceFilter = 1000.0f;
    
    _locationManager = locationManager;
    
    return _locationManager;
}

- (UILabel *)lb_title
{
    if (_lb_title) {
        return _lb_title;
    }
    
    UILabel *lb_title = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, NavigationBar_HEIGHT)];
    lb_title.textAlignment = NSTextAlignmentCenter;
    lb_title.numberOfLines = 0;
    lb_title.textColor = [UIColor whiteColor];
    lb_title.text = @"保养预约";
    
    _lb_title = lb_title;
    return _lb_title;
}

- (NSAttributedString *)attributtedTitles
{
    NSString *title = @"保养预约";
    NSString *address = self.address?self.address:@"正在获取位置信息...";
    
    NSString *string = [NSString stringWithFormat:@"%@\n%@", title, address];
    NSRange rowFirst = [string rangeOfString:title];
    NSRange secondRow = [string rangeOfString:address];
    
    NSMutableAttributedString *attributedstr = [[NSMutableAttributedString alloc] initWithString:string];
    [attributedstr addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:13.0f] range:rowFirst];
    [attributedstr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:10.0f] range:secondRow];
    
    return attributedstr;
}

- (UIBarButtonItem *)searchItem
{
    if (_searchItem) {
        return _searchItem;
    }
    
    UIBarButtonItem *searchItem = [[UIBarButtonItem alloc] bk_initWithImage:[UIImage imageNamed:@"bt_search_store"] style:UIBarButtonItemStylePlain handler:^(id sender) {
        self.searchBar.fd_collapsed ^= 1;
        self->isSearchMod = !self.searchBar.fd_collapsed;
    }];
    
    _searchItem = searchItem;
    return _searchItem;
}

- (NSArray *)timeBucket {
    if (_timeBucket) {
        return _timeBucket;
    }
    
    _timeBucket =  @[@"09:00-10:00",
                @"10:00-11:00",
                @"11:00-12:00",
                @"12:00-13:00",
                @"13:00-14:00",
                @"14:00-15:00",
                @"15:00-16:00",
                @"16:00-17:00",
                @"17:00-18:00"];
    return _timeBucket;
}

#pragma mark - Setter

- (void)setMaintainDeps:(NSMutableArray *)maintainDeps {
    
    if (!maintainDeps || maintainDeps.count<=0) {
        _maintainDeps = maintainDeps;
        [self.tableView reloadData];
        return;
    }
    
    NSMutableArray *temp = maintainDeps;
    [temp enumerateObjectsUsingBlock:^(SRMaintainDepInfo *obj, NSUInteger idx, BOOL *stop) {
        obj.distance = [self distanceToLocation:obj.coordinate];
    }];
    
    SRCustomer *customer = [SRPortal sharedInterface].customer;
    SRMaintainDepInfo *first = [temp firstObject];
    
    NSMutableArray *sort;
    if (first.depID == customer.depID) {
        sort = [NSMutableArray arrayWithArray:[temp subarrayWithRange:NSMakeRange(1, temp.count-1)]];
    } else {
        sort = [NSMutableArray arrayWithArray:[temp subarrayWithRange:NSMakeRange(0, temp.count)]];
    }
    [sort sortWithOptions:NSSortConcurrent usingComparator:^NSComparisonResult(SRMaintainDepInfo *obj1, SRMaintainDepInfo *obj2) {
        return obj1.distance > obj2.distance;
    }];
    
    if (first.depID == customer.depID) {
        _maintainDeps = [NSMutableArray arrayWithObject:[temp firstObject]];
        [_maintainDeps addObjectsFromArray:sort];
    } else {
        _maintainDeps = sort;
    }

    [self.tableView reloadData];
}

@end

//
//  SRTripViewController.m
//  SiRuiV4.0
//
//  Created by zhangjunbo on 15/6/24.
//  Copyright (c) 2015年 SiRui. All rights reserved.
//

#import "SRTripViewController.h"
#import "SRPortal+Trip.h"
#import "SRDataBase+Trip.h"
#import "SRUserDefaults.h"
#import "SRPortalRequest.h"
#import "SRUIUtil.h"
#import "SRTripInfo.h"
#import "SRCalendarSwipeView.h"
#import "SRTripInfoCell.h"
#import "SRCalendarPickerView.h"
#import <DateTools/DateTools.h>
#import <JTCalendar/JTCalendar.h>
#import <MJRefresh/MJRefresh.h>

@interface SRTripViewController () <SRCalendarSwipeViewDelegate, SRCalendarPickerViewDelegate>

@property (weak, nonatomic) IBOutlet SRCalendarSwipeView *calendarSwipeView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, weak) SRCalendarPickerView *calendarPickerView;

@property (nonatomic, strong) NSDate *selectedDate;
@property (nonatomic, strong) NSMutableArray *tripList;
@property (nonatomic, strong) NSArray *tripPoints;

@end

@implementation SRTripViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = SRLocal(@"title_trip");
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.selectedDate = [NSDate date];
    self.tripList = [NSMutableArray array];
    
    UINib *nib = [UINib nibWithNibName:@"SRTripInfoCell" bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:CellIdentifier];
    
    self.tableView.backgroundView.backgroundColor = [UIColor clearColor];
    self.tableView.backgroundColor = [UIColor clearColor];
    @weakify(self)
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        @strongify(self)
        [self queryTripWithDate:self.selectedDate];
    }];
    
    self.tableView.mj_header.state = MJRefreshStateRefreshing;
    
    [self addCalendarButton];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.calendarSwipeView.delegate = self;
    self.calendarPickerView.delegate = self;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    self.calendarSwipeView.delegate = nil;
    self.calendarPickerView.delegate = nil;
    [self.calendarPickerView removeFromSuperview];
    self.calendarPickerView = nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
    if (!self.isViewLoaded || self.view.window) return;
    
//    NSLog(@"test");
}


#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    UIViewController *vc = segue.destinationViewController;
    [vc setValue:self.tripPoints forKey:@"tripPoints"];
    SRTripInfo *info = self.tripList[[self.tableView indexPathForSelectedRow].row];
    [vc setValue:info forKey:@"tripInfo"];
}

#pragma mark - SRCalendarSwipeViewDelegate

- (void)calendarSwipeViewDidSelectedDate:(NSDate *)date
{
    self.selectedDate = date;
    [self.calendarPickerView setSelectedDate:self.selectedDate];
    self.tableView.mj_header.state = MJRefreshStateRefreshing;
}

#pragma mark - SRCalendarPickerViewDelegate

- (void)calendarPickerViewDidSelectedDate:(NSDate *)date
{
     self.selectedDate = date;
    [self.calendarSwipeView setDate: date];
    self.tableView.mj_header.state = MJRefreshStateRefreshing;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 20.0f;
}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section
{
    view.tintColor = [UIColor defaultBackgroundColor];
}

- (void)tableView:(UITableView *)tableView willDisplayFooterView:(UIView *)view forSection:(NSInteger)section {
    view.tintColor = [UIColor defaultBackgroundColor];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(SRTripInfoCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [cell setFisrtCell:indexPath.row == 0
              lastCell:indexPath.row == [self tableView:tableView numberOfRowsInSection:indexPath.section]-1];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    SRTripInfo *info = self.tripList[indexPath.row];
    [self queryTripPointWithTripID:info.tripID];
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.tripList.count;
}

static NSString *CellIdentifier = @"CellIdentifier" ;
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SRTripInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    cell.tripInfo = self.tripList[indexPath.row];
    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        SRTripInfo *info = self.tripList[indexPath.row];
        
        @weakify(self)
        [UIAlertView bk_showAlertViewWithTitle:@"提示"
                                       message:@"是否删除该轨迹段？"
                             cancelButtonTitle:@"取消"
                             otherButtonTitles:@[@"确定"]
                                       handler:^(UIAlertView *alertView, NSInteger buttonIndex) {
                                           @strongify(self)
                                           if (buttonIndex != alertView.cancelButtonIndex)
                                               [self deleteTrip:info];
                                       }];
    }
}

#pragma mark - Getter

- (SRCalendarPickerView *)calendarPickerView
{
    if (_calendarPickerView) {
        return _calendarPickerView;
    }
    
    SRCalendarPickerView *calendarPickerView = [[SRCalendarPickerView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.width)];
    calendarPickerView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:calendarPickerView];
    @weakify(self)
    [calendarPickerView makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self)
        make.bottom.equalTo(self.view.mas_top).with.offset(NavigationBar_HEIGHT + StatusBar_HEIGHT);
        make.left.right.equalTo(self.view);
        make.height.equalTo(self.view.width);
    }];

    _calendarPickerView = calendarPickerView;
    
    return _calendarPickerView;
}

#pragma mark - 私有方法

- (void)addCalendarButton {
    @weakify(self)
    UIBarButtonItem *configItem = [[UIBarButtonItem alloc] bk_initWithImage:[UIImage imageNamed:@"ic_calendar"] style:UIBarButtonItemStylePlain handler:^(id sender) {
        @strongify(self)
        if (self.calendarPickerView.isShowing) {
            [self.calendarPickerView dissmissCalendarPickerView];
        } else {
            [self.calendarPickerView setSelectedDate:self.selectedDate];
            [self.calendarPickerView showCalendarPickerView];
        }
    }];
    
    self.navigationItem.rightBarButtonItem = configItem;
}

- (void)queryTripWithDate:(NSDate *)date
{
    self.tripList = [NSMutableArray array];
    [self.tableView reloadData];
    @weakify(self)
    [[SRDataBase sharedInterface] queryTripByDate:date vehicleID:[SRUserDefaults currentVehicleID] withCompleteBlock:^(NSError *error, id responseObject) {
        @strongify(self)
        if (error) return ;
        
        self.tripList = responseObject;
        [self.tableView reloadData];
    }];
    
    SRPortalRequestQueryTrip *request = [[SRPortalRequestQueryTrip alloc] init];
    request.date = date;
    request.vehicleID = [SRUserDefaults currentVehicleID];
    [SRPortal queryVehicleTripsWithRequest:request andCompleteBlock:^(NSError *error, id responseObject) {
        @strongify(self)
        [self.tableView.mj_header endRefreshing];
        
        if (error) {
//            [SRUIUtil showAlertMessage:error.domain];
        } else {
            self.tripList = responseObject;
            [self.tableView reloadData];
        }
    }];
}

- (void)queryTripPointWithTripID:(NSString *)tripID
{
    [SRUIUtil showLoadingHUDWithTitle:nil];
    self.tripPoints = nil;
    SRPortalRequestQueryTripGPSPoints *request = [[SRPortalRequestQueryTripGPSPoints alloc] init];
    request.tripID = tripID;
    @weakify(self)
    [SRPortal queryVehicleTripGPSPointsWithRequest:request andCompleteBlock:^(NSError *error, NSArray *responseObject) {
        @strongify(self)
        [SRUIUtil dissmissLoadingHUD];
        if (error) {
            [SRUIUtil showAlertMessage:error.domain];
        } else if (!responseObject || responseObject.count == 0) {
            [SRUIUtil showAlertMessage:@"该时间段内无有效轨迹"];
        } else {
            self.tripPoints = responseObject;
            [self performSegueWithIdentifier:@"PushSRTripDetailViewController" sender:nil];
        }
    }];
}

- (void)deleteTrip:(SRTripInfo *)trip
{
    [SRUIUtil showLoadingHUDWithTitle:nil];
    @weakify(self)
    [SRPortal deleteTrips:@[trip] withCompleteBlock:^(NSError *error, id responseObject) {
        @strongify(self)
        [SRUIUtil dissmissLoadingHUD];
        if (error) {
            [SRUIUtil showAlertMessage:error.domain];
        } else {
            @weakify(self)
            [[SRDataBase sharedInterface] queryTripByDate:self.selectedDate vehicleID:[SRUserDefaults currentVehicleID] withCompleteBlock:^(NSError *error, id responseObject) {
                @strongify(self)
                if (error) return ;
                
                self.tripList = responseObject;
                [self.tableView reloadData];
            }];
        }
    }];
}

@end

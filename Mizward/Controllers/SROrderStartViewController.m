//
//  SROrderStartViewController.m
//  SiRuiV4.0
//
//  Created by zhangjunbo on 15/6/15.
//  Copyright (c) 2015年 SiRui. All rights reserved.
//

#import "SROrderStartViewController.h"
#import "SROrderStartInfo.h"
#import "SRDataBase+OrderStart.h"
#import "SRUserDefaults.h"
#import "SRPortal+OrderStart.h"
#import "SRPortalRequest.h"
#import "SRVehicleBasicInfo.h"
#import "SRUIUtil.h"
#import "SRTableViewCell.h"

@interface SROrderStartViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSMutableDictionary *orderDic;
@property (nonatomic, strong) NSArray   *keys; //vehicleID

@end

@implementation SROrderStartViewController

#pragma mark - 生命周期

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.title = SRLocal(@"title_order_start");
    
    self.tableView.backgroundView.backgroundColor = [UIColor clearColor];
    self.tableView.backgroundColor = [UIColor clearColor];
    
    self.orderDic = [NSMutableDictionary dictionary];
    
    [RACObserve(self, orderDic) subscribeNext:^(NSMutableDictionary *dic) {
        self.keys = [dic.allKeys sortedArrayUsingComparator:^NSComparisonResult(NSNumber *obj1, NSNumber *obj2) {
            return [obj1 compare:obj2] == NSOrderedDescending;
        }];
    }];
    
    //网络获取
    [SRPortal queryOrderStartWithCompleteBlock:^(NSError *error, id responseObject) {
        if (error) return ;
        self.orderDic = responseObject;
        [self.tableView reloadData];
    }];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    //本地读取
    [[SRDataBase sharedInterface] queryOrderStartByCustomerID:[SRUserDefaults customerID] withCompleteBlock:^(NSError *error, id responseObject) {
        if (error) return ;
        self.orderDic = responseObject;
        [self.tableView reloadData];
    }];
}

#pragma mark - Nav

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    UIViewController *vc = segue.destinationViewController;
    NSIndexPath *selectedIndexPath = self.tableView.indexPathForSelectedRow;
    if (selectedIndexPath) {
        if (self.orderDic.count > 0) {
            NSArray *list = self.orderDic[self.keys[selectedIndexPath.section]];
            SROrderStartInfo *info = list[selectedIndexPath.row];
            [vc setValue:info forKey:@"info"];
            [vc setValue:@(info.type) forKey:@"type"];
        } else {
            [vc setValue:selectedIndexPath.row==0?@(SROrderStartType_GoOffice):@(SROrderStartType_GoHome)
                  forKey:@"type"];
        }
    } else {
        [vc setValue:@(SROrderStartType_Customer) forKey:@"type"];
    }
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self performSegueWithIdentifier:@"PushSROrderStartSettingsViewController" sender:self];
}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section
{
    view.tintColor = [UIColor defaultBackgroundColor];
}

- (void)tableView:(UITableView *)tableView willDisplayFooterView:(UIView *)view forSection:(NSInteger)section {
    view.tintColor = [UIColor defaultBackgroundColor];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (self.orderDic.count == 0) return nil;
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, [self tableView:tableView heightForHeaderInSection:section])];
    view.backgroundColor = [UIColor defaultBackgroundColor];
    
    UILabel *label = [[UILabel alloc] initWithFrame:view.bounds];
    label.backgroundColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.text = [NSString stringWithFormat:@"爱车%zd", section+1];
    label.textColor = [UIColor blackColor];
    [view addSubview:label];
    
    return view;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(SRTableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [cell setFisrtCell:indexPath.row==0
              lastCell:indexPath.row == [self tableView:tableView numberOfRowsInSection:indexPath.section]-1];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return self.orderDic.count>0?30.0f:20.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return self.orderDic.count==0?44.0f:70.0f;
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
//    if (self.orderDic.count == 0) {
//        return 1;
//    } else {
        return self.orderDic.count;
//    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.orderDic.count == 0) {
        return 0;
    } else {
        NSArray *list = self.orderDic[self.keys[section]];
        return list.count;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    if (self.orderDic.count > 0) {
        return [self configCellNormalAtIndexPath:indexPath];
//    } else {
//        return [self configCellNotSetAtIndexPath:indexPath];
//    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return self.orderDic.count>0;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle != UITableViewCellEditingStyleDelete) {
        return;
    }
    
    [UIAlertView bk_showAlertViewWithTitle:SRLocal(@"title_alert")
                                   message:SRLocal(@"string_order_delete")
                         cancelButtonTitle:SRLocal(@"bt_cancel")
                         otherButtonTitles:@[SRLocal(@"bt_sure")]
                                   handler:^(UIAlertView *alertView, NSInteger buttonIndex) {
                                       if (buttonIndex != alertView.cancelButtonIndex) {
                                           
                                           NSMutableArray *list = self.orderDic[self.keys[indexPath.section]];
                                           SROrderStartInfo *info = list[indexPath.row];
                                           [SRUIUtil showLoadingHUDWithTitle:nil];
                                           SRPortalRequestDeleteOrderStart *request = [[SRPortalRequestDeleteOrderStart alloc] init];
                                           request.startClockID = info.startClockID;
                                           [SRPortal deleteOrderStartWithRequest:request andCompleteBlock:^(NSError *error, id responseObject) {
                                               [SRUIUtil dissmissLoadingHUD];
                                               if (error) {
                                                   [SRUIUtil showAlertMessage:error.domain];
                                                   return ;
                                               }
                                               
                                               [list removeObject:info];
                                               if (list.count == 0) {
                                                   [self.orderDic removeObjectForKey:self.keys[indexPath.section]];
                                                   self.orderDic = [NSMutableDictionary dictionaryWithDictionary:self.orderDic];
                                               }
                                               
                                               [tableView reloadData];
                                           }];
                                       }
                                   }];
}

#pragma mark - Setter

#pragma mark - 交互操作

- (IBAction)buttonAddPressed:(id)sender {
    [self performSegueWithIdentifier:@"PushSROrderStartSettingsViewController" sender:self];
}

- (IBAction)switchAction:(UISwitch *)sw {
    
    if ([self checkExperienceUserStatus]) {
        sw.on ^= 1;
        return;
    }
    
    SROrderStartInfo *info = [sw bk_associatedValueForKey:@"OrderStartInfo"];
    [SRUIUtil showLoadingHUDWithTitle:nil];
    SRPortalRequestUpdateOrderStart *request = [[SRPortalRequestUpdateOrderStart alloc] initWithOrderStartInfo:info];
    request.isOpen = sw.on;
    [SRPortal updateOrderStartWithRequest:request andCompleteBlock:^(NSError *error, SROrderStartInfo *responseObject) {
        [SRUIUtil dissmissLoadingHUD];
        if (error) {
            sw.on ^= 1;
            [SRUIUtil showAlertMessage:error.domain];
            return ;
        }
        
        SRTableViewCell *cell = (SRTableViewCell *)[self.tableView cellForRowAtIndexPath:[sw bk_associatedValueForKey:@"IndexPath"]];
        UILabel *time = (UILabel *)[cell.contentView viewWithTag:100];
        UILabel *detail = (UILabel *)[cell.contentView viewWithTag:101];
        info.isOpen = responseObject.isOpen;
        time.textColor = info.isOpen?[UIColor blackColor]:[UIColor lightGrayColor];
        detail.textColor = info.isOpen?[UIColor blackColor]:[UIColor lightGrayColor];
        
        UITextField *plateNumber = (UITextField *)[cell.contentView viewWithTag:102];
        plateNumber.textColor = info.isOpen?[UIColor blackColor]:[UIColor lightGrayColor];
        UIImageView *icCar = (UIImageView *)plateNumber.leftView;
        icCar.image = [UIImage imageNamed:info.isOpen?@"ic_order_car_black":@"ic_order_car_grey"];
        
        UITextField *length = (UITextField *)[cell.contentView viewWithTag:103];
        length.textColor = info.isOpen?[UIColor blackColor]:[UIColor lightGrayColor];
        UIImageView *icTime = (UIImageView *)length.leftView;
        icTime.image = [UIImage imageNamed:info.isOpen?@"ic_order_length_black":@"ic_order_length_grey"];
    }];
    
}

#pragma mark - 私有方法

- (UITableViewCell *)configCellNotSetAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CellNotSet";
    SRTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[SRTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    UIImageView *image = (UIImageView *)[cell.contentView viewWithTag:100];
    image.image = [UIImage imageNamed:indexPath.row==0?@"ic_order_office":@"ic_order_home"];
    
    UILabel *label = (UILabel *)[cell.contentView viewWithTag:101];
    label.text = indexPath.row==0?SRLocal(@"string_go_office"):SRLocal(@"string_go_home");
    
    UILabel *text = (UILabel *)[cell.contentView viewWithTag:102];
    text.text = [NSString stringWithFormat:SRLocal(@"string_order_default"),
                 indexPath.row==0?SRLocal(@"string_go_office"):SRLocal(@"string_go_home")];
    
    UIButton *button = (UIButton *)[cell.contentView viewWithTag:103];
    [button bk_removeEventHandlersForControlEvents:UIControlEventTouchUpInside];
    [button bk_addEventHandler:^(id sender) {
        [self performSegueWithIdentifier:@"PushSROrderStartSettingsViewController" sender:self];
    } forControlEvents:UIControlEventTouchUpInside];
    
    return cell;
}

- (UITableViewCell *)configCellNormalAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CellSetted";
    SRTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[SRTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    NSArray *list = self.orderDic[self.keys[indexPath.section]];
    __block SROrderStartInfo *info = list[indexPath.row];
    
    UILabel *time = (UILabel *)[cell.contentView viewWithTag:100];
    time.text = [info.startTime substringWithRange:NSMakeRange(11, 5)];
    time.textColor = info.isOpen?[UIColor blackColor]:[UIColor lightGrayColor];
    
    SRVehicleBasicInfo *vehicle = [SRPortal sharedInterface].vehicleDic[self.keys[indexPath.section]];
    
    UILabel *repeat = (UILabel *)[cell.contentView viewWithTag:101];
    repeat.text = info.repeatTypeDetail;
    repeat.textColor = info.isOpen?[UIColor blackColor]:[UIColor lightGrayColor];
    
    UITextField *plateNumber = (UITextField *)[cell.contentView viewWithTag:102];
    plateNumber.text = vehicle.plateNumber;
    plateNumber.textColor = info.isOpen?[UIColor blackColor]:[UIColor lightGrayColor];
    UIImageView *icCar = [[UIImageView  alloc] initWithImage:[UIImage imageNamed:info.isOpen?@"ic_order_car_black":@"ic_order_car_grey"]];
    icCar.frame = CGRectMake(0.0f, 0.0f, plateNumber.height, plateNumber.height);
    icCar.contentMode = UIViewContentModeCenter;
    plateNumber.leftView = icCar;
    plateNumber.leftViewMode = UITextFieldViewModeAlways;
    
    UITextField *length = (UITextField *)[cell.contentView viewWithTag:103];
    length.text = [NSString stringWithFormat:SRLocal(@"string_start_length"), info.startTimeLength];
    length.textColor = info.isOpen?[UIColor blackColor]:[UIColor lightGrayColor];
    UIImageView *icTime = [[UIImageView  alloc] initWithImage:[UIImage imageNamed:info.isOpen?@"ic_order_length_black":@"ic_order_length_grey"]];
    icTime.frame = CGRectMake(0.0f, 0.0f, plateNumber.height, plateNumber.height);
    icTime.contentMode = UIViewContentModeCenter;
    length.leftView = icTime;
    length.leftViewMode = UITextFieldViewModeAlways;
    
    UISwitch *sw = (UISwitch *)[cell.contentView viewWithTag:104];
    sw.onTintColor = [UIColor defaultColor];
    [sw setOn:info.isOpen];
    [sw bk_associateValue:info withKey:@"OrderStartInfo"];
    [sw bk_associateValue:indexPath withKey:@"IndexPath"];
    
    [sw addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
    
    return cell;
}

@end

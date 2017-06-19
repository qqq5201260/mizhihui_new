//
//  SROrderStartSettingsViewController.m
//  SiRuiV4.0
//
//  Created by zhangjunbo on 15/6/15.
//  Copyright (c) 2015年 SiRui. All rights reserved.
//

#import "SROrderStartSettingsViewController.h"
#import "SRPortal.h"
#import "SRPortal+OrderStart.h"
#import "SRUIUtil.h"
#import "SRVehicleBasicInfo.h"
#import "SROrderStartInfo.h"
#import "SRPortalRequest.h"
#import "SRUserDefaults.h"
#import "SRRepeatTimePicker.h"
#import "SRTableViewCell.h"
#import <DateTools/DateTools.h>
#import <ActionSheetPicker-3.0/ActionSheetPicker.h>

const NSInteger  TAG_label_detail = 100;

@interface SROrderStartSettingsViewController ()
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *bt_done;

@property (nonatomic, strong) NSMutableArray *plateNumbers;
@property (nonatomic, strong) NSArray *repeatTimes;

@end

@implementation SROrderStartSettingsViewController
{
    BOOL isUpdate;
}

#pragma mark - 生命周期

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = SRLocal(@"title_order_setting");
    
    self.tableView.backgroundView.backgroundColor = [UIColor clearColor];
    self.tableView.backgroundColor = [UIColor clearColor];
    
    [self.bt_done setTitle:SRLocal(@"bt_done") forState:UIControlStateNormal];
    self.bt_done.layer.cornerRadius = 5.0f;
    
    NSDate *now = [NSDate date];
    
    
    _datePicker.datePickerMode = UIDatePickerModeTime;
    
    if (self.info) {
        isUpdate = YES;
        NSDate *startDate = [NSDate convertDateFromStringWithFormatYYYYMMddHHmmss:self.info.startTime];
        self.datePicker.date = [NSDate dateWithYear:now.year
                                              month:now.month
                                                day:now.day
                                               hour:startDate.hour
                                             minute:startDate.minute
                                             second:startDate.second];
    } else {
        isUpdate = NO;
        self.info = [[SROrderStartInfo alloc] init];
        self.info.repeatType = repeateTypeWithNoRepeat;
        self.info.vehicleID = [SRUserDefaults currentVehicleID];
        self.info.type = self.type.integerValue;
        self.info.startTimeLength = 5;
        
        if (self.info.type == SROrderStartType_GoHome) {
            NSArray *time = [[SRPortal sharedInterface].currentVehicleBasicInfo.goHomeTime componentsSeparatedByString:@":"];
            self.datePicker.date = [NSDate dateWithYear:now.year
                                                  month:now.month
                                                    day:now.day
                                                   hour:[time[0] integerValue]
                                                 minute:[time[1] integerValue]
                                                 second:now.second];
        } else if (self.info.type == SROrderStartType_GoOffice) {
            NSArray *time = [[SRPortal sharedInterface].currentVehicleBasicInfo.workTime componentsSeparatedByString:@":"];
            self.datePicker.date = [NSDate dateWithYear:now.year
                                                  month:now.month
                                                    day:now.day
                                                   hour:[time[0] integerValue]
                                                 minute:[time[1] integerValue]
                                                 second:now.second];
        }
    }
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44.0f;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(SRTableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [cell setFisrtCell:indexPath.row==0
              lastCell:indexPath.row == [self tableView:tableView numberOfRowsInSection:indexPath.section]-1];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0) {
        [self showRepeatePickerView];
    } else if (indexPath.row == 1) {
        SRVehicleBasicInfo *info = [[SRPortal sharedInterface] vehicleBasicInfoWithVehicleID:self.info.vehicleID];
        NSInteger index = [self.plateNumbers indexOfObject:info.plateNumber];
        ActionSheetStringPicker *picker = [[ActionSheetStringPicker alloc] initWithTitle:nil rows:self.plateNumbers initialSelection:index  doneBlock:^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue) {
            UITableViewCell *cell = [tableView cellForRowAtIndexPath:tableView.indexPathForSelectedRow];
            UILabel *detail = (UILabel *)[cell.contentView viewWithTag:TAG_label_detail];
            detail.text = self.plateNumbers[selectedIndex];
            
            SRVehicleBasicInfo *info = [[SRPortal sharedInterface] vehicleBasicInfoWithPlateNubmer:detail.text];
            self.info.vehicleID = info.vehicleID;
            
        } cancelBlock:^(ActionSheetStringPicker *picker) {
            
        } origin:self.view];
        picker.tapDismissAction = TapActionCancel;
        [picker showActionSheetPicker];
    } else {
        SRVehicleBasicInfo *info = [[SRPortal sharedInterface] vehicleBasicInfoWithVehicleID:self.info.vehicleID];
        NSMutableArray *rows = [NSMutableArray array];
        for (NSInteger index = 0; index < info.maxStartTimeLength/5; ++index) {
            [rows addObject:[NSString stringWithFormat:SRLocal(@"%@ minute"), @((index+1)*5)]];
        }
        
        NSInteger defaultSelection = self.info.startTimeLength/5 - 1;
        ActionSheetStringPicker *picker = [[ActionSheetStringPicker alloc] initWithTitle:nil rows:rows initialSelection:defaultSelection doneBlock:^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue) {
            UITableViewCell *cell = [tableView cellForRowAtIndexPath:tableView.indexPathForSelectedRow];
            UILabel *detail = (UILabel *)[cell.contentView viewWithTag:TAG_label_detail];
            detail.text = rows[selectedIndex];
            
            self.info.startTimeLength = (selectedIndex + 1) * 5;
            
        } cancelBlock:^(ActionSheetStringPicker *picker) {
            
        } origin:self.view];
        picker.tapDismissAction = TapActionCancel;
        [picker showActionSheetPicker];
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    SRTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[SRTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        
        UILabel *detail = [[UILabel alloc] initWithFrame:CGRectZero];
        detail.textColor = [UIColor lightGrayColor];
        detail.font = [UIFont systemFontOfSize:12.0f];
        detail.textAlignment = NSTextAlignmentRight;
        detail.tag = TAG_label_detail;
        [cell.contentView addSubview:detail];
        [detail makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.height.centerY.equalTo(cell.contentView);
        }];
    }
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    switch (indexPath.row) {
        case 0:
        {
            cell.imageView.image = [UIImage imageNamed:@"ic_order_repeat"];
            cell.textLabel.text = SRLocal(@"string_order_repeat");
            
            UILabel *detail = (UILabel *)[cell.contentView viewWithTag:TAG_label_detail];
            detail.text = self.info.repeatTypeDetail;
        }
            break;
        case 1:
        {
            cell.imageView.image = [UIImage imageNamed:@"ic_order_car"];
            cell.textLabel.text = SRLocal(@"string_order_car");
            
            UILabel *detail = (UILabel *)[cell.contentView viewWithTag:TAG_label_detail];
            SRVehicleBasicInfo *info = [[SRPortal sharedInterface] vehicleBasicInfoWithVehicleID:self.info.vehicleID];
            detail.text = info.plateNumber;
        }
            break;
        case 2:
        {
            cell.imageView.image = [UIImage imageNamed:@"ic_order_length"];
            cell.textLabel.text = SRLocal(@"string_order_length");
            
            UILabel *detail = (UILabel *)[cell.contentView viewWithTag:TAG_label_detail];
            detail.text = [NSString stringWithFormat:SRLocal(@"%@ minute"), @(self.info.startTimeLength)];
        }
            break;
            
        default:
            break;
    }
    
    return cell;
}


#pragma mark - 交互操作

- (IBAction)buttonDonePressed:(id)sender {
    
    if ([self checkExperienceUserStatus]) {
        return;
    }
    
    NSDate *date = self.datePicker.date;
    if ([date isEarlierThan:[NSDate date]]) {
        date = [date dateByAddingDays:1];
    }
    
    self.info.startTime = [date stringOfDateWithFormatYYYYMMddHHmmss];
    self.info.isRepeat = ![self.info.repeatType isEqualToString:repeateTypeWithNoRepeat];
    
    [SRUIUtil showLoadingHUDWithTitle:nil];
    if (isUpdate) {
        SRPortalRequestUpdateOrderStart *request = [[SRPortalRequestUpdateOrderStart alloc] initWithOrderStartInfo:self.info];
        request.isOpen = YES;
        [SRPortal updateOrderStartWithRequest:request andCompleteBlock:^(NSError *error, id responseObject) {
            [SRUIUtil dissmissLoadingHUD];
            if (error) {
                [SRUIUtil showAlertMessage:error.domain];
                return ;
            }else{
            
            [self.navigationController popViewControllerAnimated:YES];
             [SRUIUtil showCenterAutoDisappearHUDWithMessage:@"修改成功"];
                
            
            
            }
        }];
    } else {
        SRPortalRequestAddOrderStart *request = [[SRPortalRequestAddOrderStart alloc] initWithOrderStartInfo:self.info];
        request.isOpen = YES;
        [SRPortal addOrderStartWithRequest:request andCompleteBlock:^(NSError *error, id responseObject) {
            [SRUIUtil dissmissLoadingHUD];
            if (error) {
                [SRUIUtil showAlertMessage:error.domain];
                return ;
            }else{
                [self.navigationController popViewControllerAnimated:YES];
                [SRUIUtil showCenterAutoDisappearHUDWithMessage:@"添加成功"];
                
                
            }
            
            self.info = responseObject;
            self->isUpdate = YES;
        }];
    }
}


#pragma mark - 私有方法

- (void)showRepeatePickerView
{
    UIView *mask = [[UIView alloc] initWithFrame:[UIApplication sharedApplication].keyWindow.bounds];
    mask.tag = 4321;
    mask.backgroundColor = [UIColor blackColor];
    mask.alpha = 0.0f;
    
    SRRepeatTimePicker *picker = [SRRepeatTimePicker instanceRepeatTimePicker];
    picker.repeatString = self.info.repeatType;
    picker.tag = 1234;
    CGFloat height = picker.frame.size.height;
    picker.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, height);
    [picker setDoneBlock:^(NSArray *obj, NSString *string) {
        UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:self.tableView.indexPathForSelectedRow];
        UILabel *detail = (UILabel *)[cell.contentView viewWithTag:TAG_label_detail];
        if (obj && obj.count > 0) {
            detail.text = [obj componentsJoinedByString:@" "];
            self.info.isRepeat = YES;
        } else {
            detail.text = @"不重复";
            self.info.isRepeat = NO;
        }
        
        self.info.repeatType = string;
        
        UIView *view = [[SRUIUtil rootViewController].view viewWithTag:1234];
        UIView *mask = [[SRUIUtil rootViewController].view viewWithTag:4321];
        [UIView animateWithDuration:0.35f animations:^{
            mask.alpha =  0.0f;
            view.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, height);
        } completion:^(BOOL finished) {
            [view removeFromSuperview];
            [mask removeFromSuperview];
        }];
        
//        [self.tableView reloadData];
    }];
    [picker setCancelBlock:^() {
        UIView *view = [[SRUIUtil rootViewController].view viewWithTag:1234];
        UIView *mask = [[SRUIUtil rootViewController].view viewWithTag:4321];
        [UIView animateWithDuration:0.35f animations:^{
            mask.alpha =  0.0f;
            view.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, height);
        } completion:^(BOOL finished) {
            [view removeFromSuperview];
            [mask removeFromSuperview];
        }];
    }];
    
    [mask bk_whenTapped:^{
        UIView *view = [[SRUIUtil rootViewController].view viewWithTag:1234];
        UIView *mask = [[SRUIUtil rootViewController].view viewWithTag:4321];
        [UIView animateWithDuration:0.35f animations:^{
            mask.alpha =  0.0f;
            view.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, height);
        } completion:^(BOOL finished) {
            [view removeFromSuperview];
            [mask removeFromSuperview];
        }];
    }];
    
    [[SRUIUtil rootViewController].view addSubview:picker];
    [[SRUIUtil rootViewController].view insertSubview:mask belowSubview:picker];
    
    [UIView animateWithDuration:0.35f animations:^{
        mask.alpha =  0.5f;
        picker.frame = CGRectMake(0, SCREEN_HEIGHT-height, SCREEN_WIDTH, height);
    } completion:^(BOOL finished) {
    }];
}


#pragma mark - Getter

- (NSMutableArray *)plateNumbers {
    if (!_plateNumbers) {
        _plateNumbers = [NSMutableArray array];
        [[SRPortal sharedInterface].vehicleDic.allValues enumerateObjectsUsingBlock:^(SRVehicleBasicInfo *obj, NSUInteger idx, BOOL *stop) {
            [self->_plateNumbers addObject:obj.plateNumber];
        }];
    }
    
    return _plateNumbers;
}

- (NSArray *)repeatTimes {
    if (!_repeatTimes) {
        _repeatTimes = @[SRLocal(@"string_length_5"), SRLocal(@"string_length_10"), SRLocal(@"string_length_15")];
    }
    
    return _repeatTimes;
}

@end

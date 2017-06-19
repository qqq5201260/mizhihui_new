//
//  SRMaintainDetailViewController.m
//  SiRuiV4.0
//
//  Created by zhangjunbo on 15/7/14.
//  Copyright (c) 2015年 SiRui. All rights reserved.
//

#import "SRMaintainDetailViewController.h"
#import "SRTableViewCell.h"
#import "SRMaintainReserveInfo.h"
#import "SRUIUtil.h"
#import "SRMaintainHistory.h"
#import "SRMaintainRequest.h"
#import "SRVehicleBasicInfo.h"
#import "SRVehicleStatusInfo.h"
#import "SRPortal.h"
#import "SRMaintain.h"
#import "SRMaintainUncommonItem.h"
#import "SRUserDefaults.h"
#import "UIView+FDCollapsibleConstraints.h"
#import <IQKeyboardManager/IQKeyboardManager.h>
#import <ActionSheetPicker-3.0/ActionSheetPicker.h>

@interface SRMaintainDetailViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *v_add;
@property (weak, nonatomic) IBOutlet UIButton *bt_add;

@property (weak, nonatomic) UIBarButtonItem *editItem;
@property (weak, nonatomic) UIBarButtonItem *saveItem;

@property (weak, nonatomic) UITextField *tx_4S;
@property (weak, nonatomic) UIButton *bt_time;
@property (weak, nonatomic) UITextField *tx_mileage;
@property (weak, nonatomic) UITextField *tx_cost;

@property (strong, nonatomic) NSArray *section0Icons;
@property (strong, nonatomic) NSArray *section0Titles;

@property (strong, nonatomic) NSArray *commonMaintainItems; //常规保养title
@property (strong, nonatomic) NSArray *uncommonMaintainItems;//非常规保养title
@property (strong, nonatomic) NSMutableArray *customerMaintainItems;//自定义保养title

@property (strong, nonatomic) SRMaintainRequestUpdateHistory *updateRequest;
@property (strong, nonatomic) SRMaintainRequestAddHistory   *addRequest;

@property (assign, nonatomic) BOOL isEditting;

@end

@implementation SRMaintainDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"保养详情";
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.tableView.backgroundView.backgroundColor = [UIColor clearColor];
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.allowsSelection = NO;
    
    self.v_add.backgroundColor = [UIColor defaultBackgroundColor];
    [self.v_add topLine];
    [self.bt_add setTitle:@"添加项目" forState:UIControlStateNormal];
    self.bt_add.layer.cornerRadius = 5.0f;
    
    if (self.canEdit.boolValue || self.isAdd.boolValue) {
        [self bk_addObserverForKeyPath:@"isEditting" task:^(id target) {
            self.v_add.fd_collapsed = !self.isEditting;
            self.v_add.hidden = !self.isEditting;
            self.navigationItem.rightBarButtonItem = self.isEditting?self.saveItem:self.editItem;
            [self.tableView reloadData];
        }];
    } else {
        self.v_add.fd_collapsed = YES;
        self.v_add.hidden = YES;
    }
    
    self.isEditting = self.isAdd.boolValue;
    
    [self bk_addObserverForKeyPath:@"customerItems" task:^(id target) {
        [self.tableView reloadData];
    }];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    [self bk_removeAllBlockObservers];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return section==0?20.0f:40.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44.0f;
}

//- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
//{
//    return section==0?0.0f:20.0f;
//}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section
{
    view.tintColor = [UIColor defaultBackgroundColor];
    
    if (section != 1) return;
    
    UIImage *image = [UIImage imageNamed:@"ic_appeal"];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    imageView.image = image;
    [view addSubview:imageView];
    [imageView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view).with.offset(20.0f);
        make.centerY.equalTo(view);
        make.size.equalTo(image.size);
    }];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
    label.font = [UIFont systemFontOfSize:16.0f];
    label.text = @"保养项目";
    [view addSubview:label];
    [label makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(imageView.mas_right).with.offset(10.0f);
        make.centerY.equalTo(view);
        make.right.equalTo(view);
    }];
}

- (void)tableView:(UITableView *)tableView willDisplayFooterView:(UIView *)view forSection:(NSInteger)section {
    view.tintColor = [UIColor defaultBackgroundColor];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(SRTableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [cell setFisrtCell:indexPath.row == 0
              lastCell:indexPath.row == [self tableView:tableView numberOfRowsInSection:indexPath.section]-1];
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return self.section0Titles.count;
    } else {
        return self.commonMaintainItems.count + self.uncommonMaintainItems.count + self.customerMaintainItems.count;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return [self tableView:tableView section0CellForRowAtIndexPath:indexPath];
    } else {
        return [self tableView:tableView section1CellForRowAtIndexPath:indexPath];
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 || !self.isEditting) {
        return NO;
    } else if (indexPath.row < self.commonMaintainItems.count + self.uncommonMaintainItems.count) {
        return NO;
    } else {
        return YES;
    }
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self.customerMaintainItems removeObjectAtIndex:indexPath.row - self.commonMaintainItems.count - self.uncommonMaintainItems.count];
        [self.tableView reloadData];
    }
}

#pragma mark - 交互操作

- (IBAction)buttonAddPressed:(id)sender {
    
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8.0")) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"请输入保养项目" message:nil preferredStyle:UIAlertControllerStyleAlert];
        [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        }];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        }];
        
        UIAlertAction *otherAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            UITextField *textField = alert.textFields.firstObject;
            if (textField.text.length<=0) return ;
            
            [self.customerMaintainItems addObject:textField.text];
            [self.tableView reloadData];
            
            if (self.isAdd.boolValue) {
                self.addRequest.defineMaintenItems = [self.customerMaintainItems componentsJoinedByString:@","];
            } else {
                self.updateRequest.defineMaintenItems = [self.customerMaintainItems componentsJoinedByString:@","];
            }
        }];
        
        [alert addAction:cancelAction];
        [alert addAction:otherAction];
        
        [self presentViewController:alert animated:YES completion:nil];

    } else {
        UIAlertView *alert = [UIAlertView bk_showAlertViewWithTitle:@"请输入保养项目" message:nil cancelButtonTitle:@"取消" otherButtonTitles:@[@"确定"] handler:^(UIAlertView *alertView, NSInteger buttonIndex) {
            
            if (buttonIndex == alert.cancelButtonIndex) {
                return ;
            }
            
            UITextField *textField = [alertView textFieldAtIndex:0];
            if (textField.text.length<=0) return ;
            
            [self.customerMaintainItems addObject:textField.text];
            [self.tableView reloadData];
            
            if (self.isAdd.boolValue) {
                self.addRequest.defineMaintenItems = [self.customerMaintainItems componentsJoinedByString:@","];
            } else {
                self.updateRequest.defineMaintenItems = [self.customerMaintainItems componentsJoinedByString:@","];
            }
        }];
        alert.alertViewStyle = UIAlertViewStylePlainTextInput;
        
        [alert show];
    }
}

- (IBAction)buttonSavePressed:(id)sender {
    
    if ([self checkExperienceUserStatus]) {
        return;
    }
    
    if ((self.isAdd.boolValue && self.addRequest.currentMileage <= 0)
        || (!self.isAdd.boolValue && self.updateRequest.currentMileage <= 0)) {
        [SRUIUtil showAlertMessage:@"请输入保养里程"];
        return;
    }
    
    if ((self.isAdd.boolValue && !self.addRequest.startTime)
        || (!self.isAdd.boolValue && !self.updateRequest.startTime)) {
        [SRUIUtil showAlertMessage:@"请选择保养时间"];
        return;
    }
    
    if ((self.isAdd.boolValue && self.addRequest.type == SRMaintainGeneralType_Reserved)
        || (!self.isAdd.boolValue && self.updateRequest.type == SRMaintainGeneralType_Reserved)) {
        [SRUIUtil showAlertMessage:@"请选择保养类型"];
        return;
    }
    
    [SRUIUtil showLoadingHUDWithTitle:nil];
    if (self.isAdd.boolValue) {
        [SRMaintain addMaintainHistoryWithRequest:self.addRequest andCompleteBlock:^(NSError *error, id responseObject) {
            [SRUIUtil dissmissLoadingHUD];
            if (error) {
                [SRUIUtil showAlertMessage:error.domain];
            } else {
                self.isAdd = @(NO);
                
                self.updateRequest = [[SRMaintainRequestUpdateHistory alloc] initWithMaintainHistory:responseObject];
                self.history = responseObject;
                self.isEditting = NO;
                
                if (self.delegate) {
                    [self.delegate localInfoDidChange];
                }
            }
        }];
    } else {
        [SRMaintain updateMaintainHistoryWithRequest:self.updateRequest andCompleteBlock:^(NSError *error, id responseObject) {
            [SRUIUtil dissmissLoadingHUD];
            if (error) {
                [SRUIUtil showAlertMessage:error.domain];
            } else {
                self.updateRequest = [[SRMaintainRequestUpdateHistory alloc] initWithMaintainHistory:responseObject];
                self.history = responseObject;
                self.isEditting = NO;
                
                if (self.delegate) {
                    [self.delegate localInfoDidChange];
                }
            }
        }];
    }
}

#pragma mark - 私有方法

- (UIButton *)cellButton:(SRTableViewCell *)cell
{
    UIButton *bt = (UIButton *)[cell.contentView viewWithTag:101];
    if (!bt) {
        bt = [[UIButton alloc] initWithFrame:CGRectZero];
        bt.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        bt.tag = 101;
        bt.titleLabel.font = [UIFont systemFontOfSize:13.0f];
        [cell.contentView addSubview:bt];
        [bt makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(cell.contentView).with.offset(100.0f);
            make.right.equalTo(cell.contentView);
            make.top.bottom.equalTo(cell.contentView);
        }];
        
        [bt bk_whenTapped:^{
            [SRUIUtil endEditing];
            NSDate *date = [NSDate convertDateFromStringWithFormatYYYYMMddChinese:bt.titleLabel.text];
            [ActionSheetDatePicker showPickerWithTitle:@"请选择时间"
                                        datePickerMode:UIDatePickerModeDate
                                          selectedDate:date?:[NSDate date]
                                           minimumDate:nil
                                           maximumDate:self.isAdd?[NSDate date]:nil
                                             doneBlock:^(ActionSheetDatePicker *picker, id selectedDate, id origin) {
                                                 [bt setTitle:[selectedDate stringOfDateWithFormatYYYYMMddChinese] forState:UIControlStateNormal];
                                                 if (self.isAdd.boolValue) {
                                                     self.addRequest.startTime = [selectedDate stringOfDateWithFormatYYYYMMddHHmmss];
                                                 } else {
                                                     self.updateRequest.startTime = [selectedDate stringOfDateWithFormatYYYYMMddHHmmss];
                                                 }
                                             } cancelBlock:^(ActionSheetDatePicker *picker) {
                                             } origin:self.view];
        }];
    }
    
    return bt;
}

- (UITextField *)cellTextField:(SRTableViewCell *)cell
{
    UITextField *tx = (UITextField *)[cell.contentView viewWithTag:100];
    if (!tx) {
        tx = [[UITextField alloc] initWithFrame:CGRectZero];
        tx.tag = 100;
        tx.font = [UIFont systemFontOfSize:13.0f];
        [cell.contentView addSubview:tx];
        [tx makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(cell.contentView).with.offset(100.0f);
            make.right.equalTo(cell.contentView);
            make.top.bottom.equalTo(cell.contentView);
        }];
    }
    
    return tx;
}

- (void)config4STextField:(UITextField *)textField {
    
    textField.placeholder = @"请输入4S店名称";
    textField.enabled = self.isEditting;
    textField.keyboardType = UIKeyboardTypeDefault;
    
    if (self.isAdd.boolValue) {
        //新增记录
        textField.text = self.addRequest.depName;
    } else if (self.isEditting) {
        //修改记录
        textField.text = self.updateRequest.depName;
    } else {
        textField.text = self.history.depName;
    }
    
    textField.textColor = self.isEditting?[UIColor blackColor]:[UIColor lightGrayColor];
    
    textField.bk_didEndEditingBlock = ^(UITextField *textField){
        if (self.isAdd.boolValue) {
            self.addRequest.depID = [self.addRequest.depName isEqualToString:textField.text]?self.addRequest.depID:0;
            self.addRequest.depName = textField.text;
        } else {
            self.updateRequest.depID = [self.updateRequest.depName isEqualToString:textField.text]?self.updateRequest.depID:0;
            self.updateRequest.depName = textField.text;
        }
    };
}

- (void)configTimeButton:(UIButton *)button {
    
    button.enabled = self.isEditting;
    [button setTitle:@"请选择时间(必填)" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateDisabled];
    
    if (self.isAdd.boolValue && self.addRequest.startTime) {
        [button setTitle:self.addRequest.startTime forState:UIControlStateNormal];
    } else if (self.isEditting && self.updateRequest.startTime) {
        [button setTitle:self.updateRequest.startTime forState:UIControlStateNormal];
    } else if (self.history.startTimeStr) {
        [button setTitle:self.history.startTimeStr forState:UIControlStateNormal];
    }
}

- (void)configMileageTextField:(UITextField *)textField {
    textField.placeholder = @"请输入保养里程(必填)";
    textField.enabled = self.isEditting;
    textField.keyboardType = UIKeyboardTypeNumberPad;
    
    if (self.isAdd.boolValue) {
        //新增记录
        textField.text = [NSString stringWithFormat:@"%zd", (NSInteger)self.addRequest.currentMileage];
    } else if (self.isEditting) {
        //修改记录
        textField.text = [NSString stringWithFormat:@"%zd", (NSInteger)self.updateRequest.currentMileage];
    } else {
        textField.text = [NSString stringWithFormat:@"%zd", (NSInteger)self.history.currentMileage];
    }
    
    textField.textColor = self.isEditting?[UIColor blackColor]:[UIColor lightGrayColor];
    textField.bk_didEndEditingBlock = ^(UITextField *textField){
        
        if (self.isAdd.boolValue) {
            self.addRequest.currentMileage = textField.text.floatValue;
        } else {
            self.updateRequest.currentMileage = textField.text.floatValue;
        }
    };
    [(UILabel *)textField.rightView setTextColor:self.isEditting?[UIColor blackColor]:[UIColor lightGrayColor]];
    
    UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    label2.text = @"km";
    label2.textColor = self.isEditting?[UIColor blackColor]:[UIColor lightGrayColor];
    label2.font = [UIFont systemFontOfSize:12.0f];
    textField.rightView = label2;
    textField.rightViewMode = UITextFieldViewModeAlways;
}

- (void)configFeeTextField:(UITextField *)textField {
    textField.placeholder = @"请输入保养费用";
    textField.enabled = self.isEditting;
    textField.keyboardType = UIKeyboardTypeNumberPad;
    
    if (self.isAdd.boolValue) {
        //新增记录
        textField.text = [NSString stringWithFormat:@"%zd", (NSInteger)self.addRequest.fee];
    } else if (self.isEditting) {
        //修改记录
        textField.text = [NSString stringWithFormat:@"%zd", (NSInteger)self.updateRequest.fee];
    } else {
        textField.text = [NSString stringWithFormat:@"%zd", (NSInteger)self.history.fee];
    }
    
    textField.textColor = self.isEditting?[UIColor blackColor]:[UIColor lightGrayColor];
    
    textField.bk_didEndEditingBlock = ^(UITextField *textField){
        if (self.isAdd.boolValue) {
            self.addRequest.fee = textField.text.floatValue;
        } else {
            self.updateRequest.fee = textField.text.floatValue;
        }
    };
    
    UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    label2.text = @"元";
    label2.textColor = self.isEditting?[UIColor blackColor]:[UIColor lightGrayColor];
    label2.font = [UIFont systemFontOfSize:12.0f];
    textField.rightView = label2;
    textField.rightViewMode = UITextFieldViewModeAlways;
}

- (UITableViewCell *)tableView:(UITableView *)tableView section0CellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"InfoCellIdentifier" ;
    SRTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[SRTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:CellIdentifier];
    }
    
    cell.imageView.image = self.section0Icons[indexPath.row];
    cell.textLabel.text = self.section0Titles[indexPath.row];
    cell.textLabel.font = [UIFont systemFontOfSize:15.0f];
    
    [cell.contentView.subviews enumerateObjectsUsingBlock:^(UIView *obj, NSUInteger idx, BOOL *stop) {
        [obj removeFromSuperview];
    }];
    
    if (indexPath.row == 1) {
        self.bt_time = [self cellButton:cell];
        [self configTimeButton:self.bt_time];
    } else {
        UITextField *tx = [self cellTextField:cell];
        if (indexPath.row == 0) {
            self.tx_4S = tx;
            [self config4STextField:self.tx_4S];
        } else if (indexPath.row == 2) {
            self.tx_mileage = tx;
            [self configMileageTextField:self.tx_mileage];
        } else {
            self.tx_cost = tx;
            [self configFeeTextField:self.tx_cost];
        }
    }
    
    return cell;
}

- (void)configCommomMaintainCell:(SRTableViewCell *)cell {
    NSString *name = [cell bk_associatedValueForKey:@"CommonItemName"];
    cell.textLabel.text = name;
    
    [cell.contentView.subviews enumerateObjectsUsingBlock:^(UIView *obj, NSUInteger idx, BOOL *stop) {
        [obj removeFromSuperview];
    }];
    cell.accessoryView = nil;
    
    if (self.isEditting) {
        UISwitch *sw = [[UISwitch alloc] initWithFrame:CGRectMake(0, 0, 50.0, 30.0)];
        sw.onTintColor = [UIColor defaultColor];
        cell.accessoryView = sw;
        
        if (self.isAdd.boolValue) {
            sw.on = self.addRequest.type == [[SRMaintainReserveInfo commonMaintainTypeDic][name] integerValue];
        } else {
            sw.on = self.updateRequest.type == [[SRMaintainReserveInfo commonMaintainTypeDic][name] integerValue];
        }
        
        [sw bk_associateValue:name withKey:@"CommonItemName"];
        [sw bk_addEventHandler:^(UISwitch *sender) {
            NSString *name = [sender bk_associatedValueForKey:@"CommonItemName"];
            if ([name isEqualToString:SRLocal(@"maintain_common_big")]) {
                if (sender.isOn) {
                    self.commonMaintainItems = @[SRLocal(@"maintain_common_big")];
                } else {
                    self.commonMaintainItems = @[SRLocal(@"maintain_common_big"), SRLocal(@"maintain_common_little")];
                }
            } else {
                if (sender.isOn) {
                    self.commonMaintainItems = @[SRLocal(@"maintain_common_little")];
                } else {
                    self.commonMaintainItems = @[SRLocal(@"maintain_common_big"), SRLocal(@"maintain_common_little")];
                }
            }
            
            [self.tableView reloadData];

        } forControlEvents:UIControlEventValueChanged];
    }
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
    label.textColor = [UIColor defaultColor];
    label.font = [UIFont systemFontOfSize:12.0f];
    label.textAlignment = NSTextAlignmentRight;
    [cell.contentView addSubview:label];
    [label makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.equalTo(cell.contentView);
        make.right.equalTo(cell.contentView.mas_right).with.offset(-10.0f);
    }];
    
    if ([name isEqualToString:SRLocal(@"maintain_common_big")]) {
        label.text = [[SRMaintainReserveInfo commonBigMaintainTitles] componentsJoinedByString:@" "];
    } else {
        label.text = [[SRMaintainReserveInfo commonLittleMaintainTitles] componentsJoinedByString:@" "];
    }
}

- (void)configUncommonMaintainCell:(SRTableViewCell *)cell {
    NSString *name = [cell bk_associatedValueForKey:@"UncommonItemName"];
    cell.textLabel.text = name;
    
    [cell.contentView.subviews enumerateObjectsUsingBlock:^(UIView *obj, NSUInteger idx, BOOL *stop) {
        [obj removeFromSuperview];
    }];
    cell.accessoryView = nil;
    
    //输入框
    UITextField *text = [[UITextField alloc] initWithFrame:CGRectZero];
    text.textColor = [UIColor defaultColor];
    text.font = [UIFont systemFontOfSize:12.0f];
    text.textAlignment = NSTextAlignmentRight;
    text.keyboardType = UIKeyboardTypeNumberPad;
    [cell.contentView addSubview:text];
    [text makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(cell.contentView);
        make.right.equalTo(cell.contentView).with.offset(-10.0f);
        make.width.equalTo(70.0f);
    }];
    
    //单位
    UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 20, 40)];
    label2.text = @"km";
    label2.textAlignment = NSTextAlignmentRight;
    label2.textColor = [UIColor defaultColor];
    label2.font = [UIFont systemFontOfSize:12.0f];
    text.rightView = label2;
    text.rightViewMode = UITextFieldViewModeAlways;
    
    if (self.isAdd.boolValue) {
        text.text = [NSString stringWithFormat:@"%zd", (NSInteger)[self.addRequest remainMileageWithItemName:name]];
    } else if (self.isEditting) {
        text.text = [NSString stringWithFormat:@"%zd", (NSInteger)[self.updateRequest remainMileageWithItemName:name]];
    } else {
        SRMaintainUncommonItem *item = [self.history uncommonMaintenItemWithName:name];
        text.text = [NSString stringWithFormat:@"%zd", (NSInteger)item.remainMileage];
    }
    
    text.bk_didBeginEditingBlock = ^(UITextField *textField){
        if (textField.text.integerValue == 0) {
            textField.text = nil;
        }
    };
    
    text.bk_didEndEditingBlock = ^(UITextField *textField){
        if (self.isAdd.boolValue) {
            [self.addRequest updateUncommonMaintainItemsWithItemName:name remainMileage:@(textField.text.floatValue)];
        } else {
            [self.updateRequest updateUncommonMaintainItemsWithItemName:name remainMileage:@(textField.text.floatValue)];
        }
    };
    
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
    label.textColor = [UIColor lightGrayColor];
    label.font = [UIFont systemFontOfSize:12.0f];
    label.textAlignment = NSTextAlignmentRight;
    label.text = @"距离下次保养剩余";
    [cell.contentView addSubview:label];
    [label makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(text.mas_left).with.offset(-10.0f);
        make.top.bottom.equalTo(cell.contentView);
        make.width.equalTo(100.0f);
    }];
    
    if (self.isEditting) {
        UISwitch *sw = [[UISwitch alloc] initWithFrame:CGRectMake(0, 0, 50.0, 30.0)];
        sw.onTintColor = [UIColor defaultColor];
        cell.accessoryView = sw;
        
        if (self.isAdd.boolValue) {
            sw.on = ![self.addRequest isCloseWithItemName:name];
        } else {
            sw.on = ![self.updateRequest isCloseWithItemName:name];
        }
        
        [sw bk_associateValue:name withKey:@"UncommonItemName"];
        [sw bk_addEventHandler:^(UISwitch *sender) {
            NSString *name = [sender bk_associatedValueForKey:@"UncommonItemName"];
            if (self.isAdd.boolValue) {
                [self.addRequest updateUncommonMaintainItemsWithItemName:name isClose:@(!sender.on)];
            } else {
                [self.updateRequest updateUncommonMaintainItemsWithItemName:name isClose:@(!sender.on)];
            }
            
            text.enabled = sender.on;
            sender.on?[text becomeFirstResponder]:[text resignFirstResponder];
            text.textColor = text.enabled?[UIColor defaultColor]:[UIColor disableColor];
            label2.textColor = text.textColor;
            
        } forControlEvents:UIControlEventValueChanged];
        
        text.enabled = sw.on;
        text.textColor = text.enabled?[UIColor defaultColor]:[UIColor disableColor];
        label2.textColor = text.textColor;
    } else {
        text.enabled = NO;
        text.textColor = [UIColor disableColor];
        label2.textColor = text.textColor;
    }
}

- (void)congfigCustomerMaintainCell:(SRTableViewCell *)cell {
    NSString *name = [cell bk_associatedValueForKey:@"CustomerItemName"];
    cell.textLabel.text = name;
    
    [cell.contentView.subviews enumerateObjectsUsingBlock:^(UIView *obj, NSUInteger idx, BOOL *stop) {
        [obj removeFromSuperview];
    }];
    cell.accessoryView = nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView section1CellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"ItemCellIdentifier" ;
    SRTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[SRTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:CellIdentifier];
    }
    
    cell.textLabel.font = [UIFont systemFontOfSize:15.0f];
    
    if (indexPath.row < self.commonMaintainItems.count) {
        [cell bk_associateValue:self.commonMaintainItems[indexPath.row] withKey:@"CommonItemName"];
        [self configCommomMaintainCell:cell];
    } else if (indexPath.row < self.commonMaintainItems.count + self.uncommonMaintainItems.count) {
        [cell bk_associateValue:self.uncommonMaintainItems[indexPath.row - self.commonMaintainItems.count]
                        withKey:@"UncommonItemName"];
        [self configUncommonMaintainCell:cell];
    } else {
        [cell bk_associateValue:self.customerMaintainItems[indexPath.row - self.commonMaintainItems.count - self.uncommonMaintainItems.count]
                        withKey:@"CustomerItemName"];
        [self congfigCustomerMaintainCell:cell];
    }
    
    return cell;
}

#pragma mark - Getter

- (UIBarButtonItem *)editItem {
    if (_editItem) {
        return _editItem;
    }
    
    UIBarButtonItem *editItem = [[UIBarButtonItem alloc] bk_initWithImage:[UIImage imageNamed:@"bt_maintain_detail_edit"] style:UIBarButtonItemStyleDone handler:^(id sender) {
        self.isEditting ^= 1;
    }];
    
    _editItem = editItem;
    
    return _editItem;
}

- (UIBarButtonItem *)saveItem {
    if (_saveItem) {
        return _saveItem;
    }
    
    UIBarButtonItem *saveItem = [[UIBarButtonItem alloc] bk_initWithTitle:@"保存" style:UIBarButtonItemStyleDone handler:^(id sender) {
//        self.isEditting ^= 1;
        [self buttonSavePressed:nil];
    }];
    
    _saveItem = saveItem;
    return _saveItem;
}

- (NSArray *)section0Icons {
    if (_section0Icons) {
        return _section0Icons;
    }
    
    _section0Icons = @[[UIImage imageNamed:@"ic_maintain_detail_store"],
                       [UIImage imageNamed:@"ic_maintain_detail_time"],
                       [UIImage imageNamed:@"ic_maintain_detail_mileage"],
                       [UIImage imageNamed:@"ic_maintain_detail_cost"]];
    return _section0Icons;
}

- (NSArray *)section0Titles {
    if (_section0Titles) {
        return _section0Titles;
    }
    
    _section0Titles = @[@"4S", @"时间", @"里程", @"费用"];
    return _section0Titles;
}

- (NSArray *)commonMaintainItems {
    if (_commonMaintainItems) {
        return _commonMaintainItems;
    }
    
    if (self.isAdd.boolValue) {
        _commonMaintainItems = @[SRLocal(@"maintain_common_big"), SRLocal(@"maintain_common_little")];
    } else {
        if (self.history.type == SRMaintainGeneralType_Big) {
            _commonMaintainItems = @[SRLocal(@"maintain_common_big")];
        } else {
            _commonMaintainItems = @[SRLocal(@"maintain_common_little")];
        }
    }
    
    
    [self bk_addObserverForKeyPath:@"commonMaintainItems" options:NSKeyValueObservingOptionNew task:^(id obj, NSDictionary *change) {
        NSArray *commonMaintainItems = change[NSKeyValueChangeNewKey];
        SRMaintainGeneralType type = SRMaintainGeneralType_Reserved;
        if (commonMaintainItems.count == 1 && [[commonMaintainItems firstObject] isEqualToString:SRLocal(@"maintain_common_big")]) {
            type = SRMaintainGeneralType_Big;
        } else if (commonMaintainItems.count == 1 && [[commonMaintainItems firstObject] isEqualToString:SRLocal(@"maintain_common_little")]) {
            type = SRMaintainGeneralType_Little;
        }
        
        if (self.isAdd.boolValue) {
            self.addRequest.type = type;
        } else {
            self.updateRequest.type = type;
        }
    }];
    
    return _commonMaintainItems;
}

- (NSArray *)uncommonMaintainItems {
    if (self.isEditting) {
        _uncommonMaintainItems = [SRMaintainReserveInfo uncommonMaintainItems];
    } else {
        NSArray *defaultOrder = [SRMaintainReserveInfo uncommonMaintainItems];
        NSMutableArray *temp = [NSMutableArray array];
        [defaultOrder enumerateObjectsUsingBlock:^(NSString *name, NSUInteger idx, BOOL *stop) {
            SRMaintainUncommonItem *item = [self.history uncommonMaintenItemWithName:name];
            if (!item.isIgnore) {
                [temp addObject:item.name];
            }
        }];
        _uncommonMaintainItems = temp;
    }
    
    return _uncommonMaintainItems;
}

- (NSMutableArray *)customerMaintainItems {
    
    if (_customerMaintainItems) {
        return _customerMaintainItems;
    }
    
    if (self.history && self.history.defineMaintenItems) {
        _customerMaintainItems = [NSMutableArray arrayWithArray:self.history.defineMaintenItems];
    } else {
        _customerMaintainItems = [NSMutableArray array];
    }
    
    return _customerMaintainItems;
}

- (SRMaintainRequestUpdateHistory *)updateRequest {
    if (_updateRequest) {
        return _updateRequest;
    }
    
    _updateRequest = [[SRMaintainRequestUpdateHistory alloc] initWithMaintainHistory:self.history];
    
    return _updateRequest;
}

- (SRMaintainRequestAddHistory *)addRequest {
    if (_addRequest) {
        return _addRequest;
    }
    
    _addRequest = [[SRMaintainRequestAddHistory alloc] init];
    _addRequest.currentMileage = [SRPortal sharedInterface].currentVehicleBasicInfo.status.mileAge;
    _addRequest.vehicleID = [SRUserDefaults currentVehicleID];
    
    return _addRequest;
}

@end

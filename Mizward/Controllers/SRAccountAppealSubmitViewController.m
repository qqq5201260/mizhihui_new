//
//  SRAccountAppealSubmitViewController.m
//  SiRuiV4.0
//
//  Created by zhangjunbo on 15/7/16.
//  Copyright (c) 2015年 SiRui. All rights reserved.
//

#import "SRAccountAppealSubmitViewController.h"
#import "SRTableViewCell.h"
#import "SRUIUtil.h"
#import "SRPortal+Regist.h"
#import "SRUIUtil.h"
#import "SRPortalRequest.h"

@interface SRAccountAppealSubmitViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *lb_descripe1;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIButton *bt_photo;
@property (weak, nonatomic) IBOutlet UILabel *lb_descripe2;
@property (weak, nonatomic) IBOutlet UIButton *bt_done;

@property (weak, nonatomic) UITextField *tx_name;
@property (weak, nonatomic) UITextField *tx_id;
@property (weak, nonatomic) UITextField *tx_vin;

@property (strong, nonatomic) NSArray *placeHolders;
@property (strong, nonatomic) NSArray *descriptions;

@end

@implementation SRAccountAppealSubmitViewController
{
    BOOL hasAddRACObserver;
}

#pragma mark - 生命周期

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.title = @"人工申诉";
    
    self.lb_descripe1.text = self.descriptions[1];
    self.lb_descripe2.text = self.descriptions[2];
    
    self.tableView.backgroundView.backgroundColor = [UIColor clearColor];
    self.tableView.backgroundColor = [UIColor clearColor];
    
    self.bt_done.layer.cornerRadius = 5.0f;
    [self.bt_done setTitle:SRLocal(@"bt_done") forState:UIControlStateNormal];
    RAC(self.bt_done, backgroundColor) = [RACSignal combineLatest:@[RACObserve(self.bt_done, enabled)] reduce:^(NSNumber *enabled){
        return enabled.boolValue?[UIColor defaultColor]:[UIColor disableColor];
    }];
    self.bt_done.enabled = NO;
    
    [self.bt_photo setTitle:@"点此选取照片" forState:UIControlStateNormal];
    self.bt_photo.layer.borderWidth = 2.0f;
    self.bt_photo.layer.borderColor = [UIColor defaultColor].CGColor;
    self.bt_photo.backgroundColor = [UIColor colorWithWhite:01.0 alpha:0.7];
    
    [self.imageView bk_whenTapped:^{
        [self takePhoto];
    }];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self initRAC];
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
    label.font = [UIFont systemFontOfSize:12.0f];
    label.numberOfLines = 0;
    label.textColor = [UIColor darkGrayColor];
    label.text = self.descriptions[0];
    [view addSubview:label];
    
    [label makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(view).with.offset(10.0f);
        make.bottom.equalTo(view).with.offset(-10.0f);
        make.left.equalTo(view).with.offset(15.0f);
        make.right.equalTo(view).with.offset(-15.0f);
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
    return self.placeHolders.count;
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
            make.left.equalTo(cell.contentView).with.offset(10.0f);
            make.right.equalTo(cell.contentView).with.offset(-10.0f);
            make.top.bottom.equalTo(cell.contentView);
        }];
    }
    
    UITextField *tx = (UITextField *)[cell.contentView viewWithTag:100];
    tx.placeholder = self.placeHolders[indexPath.row];
    
    if (indexPath.row == 0) {
        self.tx_name = tx;
    } else if (indexPath.row == 1) {
        self.tx_id = tx;
    } else {
        self.tx_vin = tx;
    }
    
    return cell;
}

#pragma mark - 交互操作

- (IBAction)buttonTakePhotoPressed:(id)sender {
    [self takePhoto];
}

- (IBAction)buttonDonePressed:(id)sender {
    [SRUIUtil showLoadingHUDWithTitle:nil];
    SRPortalRequestAccountAppeal *request = [[SRPortalRequestAccountAppeal alloc] init];
    request.name = self.tx_name.text;
    request.vin = self.tx_vin.text;
    request.phone = self.phone;
    request.idNumber = self.tx_id.text;
    request.photoContent = self.imageView.image;
    [SRPortal accountAppealWithRequest:request andCompleteBlock:^(NSError *error, id responseObject) {
        [SRUIUtil dissmissLoadingHUD];
        if (error) {
            [SRUIUtil showAlertMessage:error.domain];
        } else {
            [self.navigationController popToRootViewControllerAnimated:YES];
            [SRUIUtil showAutoDisappearHUDWithMessage:@"资料提交成功，工作人员会尽快处理，处理结果会通过短信或邮件通知您，请注意查收"
                                             isDetail:YES];
        }
    }];
    
}

#pragma mark - 私有方法

- (void)initRAC {
    
    self.bt_done.enabled = self.tx_name.text.length>0
                            && self.tx_id.text.length>0
                            && [self.tx_id.text.uppercaseString isIDNumber]
                            && self.tx_vin.text.length>0
                            && self.imageView.image;
    
    if (hasAddRACObserver) return;
    
    hasAddRACObserver = YES;
    RAC(self.bt_done, enabled) = [RACSignal combineLatest:@[self.tx_name.rac_textSignal,
                                                            self.tx_id.rac_textSignal,
                                                            self.tx_vin.rac_textSignal,
                                                            RACObserve(self.imageView, image)]
                                                   reduce:^(NSString *tName, NSString *tID, NSString *tVin, UIImage *image){
                                                       return @(tName.length>0 && tID.length>0 && [tID.uppercaseString isIDNumber] && tVin.length>0 && image);
                                                   }];
}

- (void)takePhoto
{
    [SRUIUtil endEditing];
    
    UIImagePickerController * picker = [[UIImagePickerController alloc] init];
    
    picker.bk_didFinishPickingMediaBlock = ^(UIImagePickerController *picker, NSDictionary *info){
        UIImage * image=[info objectForKey:UIImagePickerControllerOriginalImage];
        
        if (picker.sourceType == UIImagePickerControllerSourceTypeCamera) {
            UIImageWriteToSavedPhotosAlbum(image, nil, nil,nil);
        }
        
        [picker dismissViewControllerAnimated:YES completion:^{
            self.imageView.image = image;
            self.bt_photo.hidden = (nil!=image);
        }];
    };
    
    picker.bk_didCancelBlock = ^(UIImagePickerController *picker){
        [picker dismissViewControllerAnimated:YES completion:NULL];
    };
    
    UIActionSheet *sheet = [UIActionSheet bk_actionSheetWithTitle:nil];
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        [sheet bk_addButtonWithTitle:@"拍照" handler:^{
            picker.sourceType=UIImagePickerControllerSourceTypeCamera;
            
            [self presentViewController:picker animated:YES completion:NULL];
        }];
    }
    [sheet bk_addButtonWithTitle:@"从手机相册选择" handler:^{
        picker.sourceType=UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentViewController:picker animated:YES completion:NULL];
    }];
    
    [sheet bk_setCancelButtonWithTitle:@"取消" handler:NULL];
    [sheet showInView:self.view];
}

#pragma mark - Getter

- (NSArray *)descriptions {
    if (_descriptions) {
        return _descriptions;
    }
    
    _descriptions = @[@"为保证您的账号安全，请如实填写以下资料", @"上传头像所在面", @"拍照时请确保姓名、身份证号等信息清晰可见"];
    
    return _descriptions;
}

- (NSArray *)placeHolders {
    if (_placeHolders) {
        return _placeHolders;
    }
    
    _placeHolders = @[@"请填写您的真实姓名", @"请填写您的身份证号", @"请输入您的车架号"];
    
    return _placeHolders;
}


@end

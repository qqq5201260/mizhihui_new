//
//  SRFindPasswordViewController.m
//  SiRuiV4.0
//
//  Created by zhangjunbo on 15/7/16.
//  Copyright (c) 2015年 SiRui. All rights reserved.
//

#import "SRFindPasswordViewController.h"
#import "SRTableViewCell.h"
#import "SRPhoneVerifyViewController.h"

@interface SRFindPasswordViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) NSArray *titles;

@end

@implementation SRFindPasswordViewController

#pragma mark - 生命周期

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.title = @"找回密码";
    
    self.tableView.backgroundView.backgroundColor = [UIColor clearColor];
    self.tableView.backgroundColor = [UIColor clearColor];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    UIViewController *vc = segue.destinationViewController;
    if ([vc isKindOfClass:[SRPhoneVerifyViewController class]]) {
        [(SRPhoneVerifyViewController *)vc setVerifyType:self.tableView.indexPathForSelectedRow.row];
    }
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
    label.text = @"找回密码涉及你的账号安全，请如实进行验证";
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row != 2) {
        [self performSegueWithIdentifier:@"PushSRPhoneVerifyViewController" sender:nil];
    } else {
        [self performSegueWithIdentifier:@"PushSRAccountAppealViewController" sender:nil];
    }
}


#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.titles.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CellIdentifier" ;
    SRTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[SRTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:CellIdentifier];
    }
    
    cell.textLabel.text = self.titles[indexPath.row];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}

#pragma mark - Getter

- (NSArray *)titles
{
    if (_titles) {
        return _titles;
    }
    
    _titles = @[@"账户未绑定硬件", @"账户已绑定硬件", @"人工申诉"];
    return _titles;
}


@end

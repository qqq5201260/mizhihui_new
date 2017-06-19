//
//  SRAboutViewController.m
//  SiRuiV4.0
//
//  Created by zhangjunbo on 15/6/15.
//  Copyright (c) 2015年 SiRui. All rights reserved.
//

#import "SRAboutViewController.h"
#import "SRTableViewCell.h"
#import "SRUIUtil.h"
#import "SRShare.h"
#import "SRShareInfo.h"
#import "SRHelpViewController.h"
#import "SRWelcomeViewController.h"
#import "SRFadeoutAnimation.h"
#import "SRFadeinAnimation.h"
#import "SRWebViewController.h"
#import "SRURLUtil.h"

@interface SRAboutViewController () <UIViewControllerTransitioningDelegate, SRWelcomeViewControllerDelegate>
{
    SRFadeinAnimation *welcomeVCFadeinAnimation;
    SRFadeoutAnimation *welcomVCFadeoutAnimation;
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) NSArray *titles;

@end

@implementation SRAboutViewController

#pragma mark - 生命周期

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = SRLocal(@"title_about");
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    welcomeVCFadeinAnimation = [[SRFadeinAnimation alloc] init];
    welcomVCFadeoutAnimation = [[SRFadeoutAnimation alloc] init];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.tableView reloadData];
}

#pragma mark - SRWelcomeViewControllerDelegate

-(void)dismissViewController:(SRWelcomeViewController *)viewcontroller{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - TransitioningDelegate

- (id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source{
    if ([presented isKindOfClass:[SRWelcomeViewController class]]) {
        return [[SRFadeinAnimation alloc] init];
    } else {
        return nil;
    }
}

-(id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed
{
    if ([dismissed isKindOfClass:[SRWelcomeViewController class]]) {
        return [[SRFadeoutAnimation alloc] init];
    } else {
        return nil;
    }
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 165.0f;
}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section
{
    view.tintColor = [UIColor defaultBackgroundColor];
    
    UIImage *image = [UIImage imageNamed:@"ic_about_large"];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    [view addSubview:imageView];
    [imageView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view).with.offset(20.0f);
        make.top.equalTo(view).with.offset(20.0f);
//        make.centerY.equalTo(view);
        make.size.equalTo(image.size);
    }];
    
    UILabel *labelVersion = [[UILabel alloc] initWithFrame:CGRectZero];
    labelVersion.text = [NSString stringWithFormat:@"版本号：%@", CurrentAPPVersion];
    [view addSubview:labelVersion];
    [labelVersion makeConstraints:^(MASConstraintMaker *make) {
//        make.top.bottom.equalTo(imageView);
        make.left.equalTo(imageView.mas_right).with.offset(20.0f);
        make.centerY.equalTo(imageView);
//        make.right.equalTo(view).with.offset(-20.0f);
    }];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
    label.font = [UIFont systemFontOfSize:12.0f];
    label.textColor = [UIColor lightGrayColor];
    label.numberOfLines = 0;
    label.text = @"咪智汇专注汽车电子智能平台，给汽车插上智慧的翅膀，为您保驾护航，实现爱车的自主管理，开启车主全新车生活。";
    [view addSubview:label];
    [label makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(imageView.mas_bottom).with.offset(20.0f);
        make.left.equalTo(view).with.offset(20.0f);
        make.right.equalTo(view).with.offset(-20.0f);
//        make.bottom.equalTo(view).with.offset(-20.0f);
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
    switch (indexPath.row) {
        case 0: //功能介绍
            [self.navigationController pushViewController:[[SRHelpViewController alloc] init]
                                                 animated:YES];
            break;
        case 1: //欢迎页
        {
            SRWelcomeViewController *vc = [[SRWelcomeViewController alloc] init];
            vc.transitioningDelegate = self;
            vc.delegate = self;
            [self presentViewController:vc animated:YES completion:nil];
        }
            break;
        case 2://帮助
        {
            SRWebViewController *vc = [[SRWebViewController alloc] init];
            vc.title = @"帮助";
            vc.url = [SRURLUtil Portal_FAQUrl];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 3: //推荐我们
            [self share];
            break;
            
        default:
            break;
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

#pragma mark - 私有函数

- (void)share
{
    SRShareInfo *info = [[SRShareInfo alloc] init];
    info.content = @"咪智汇专注汽车电子智能平台，给汽车插上智慧的翅膀，为您保驾护航，实现爱车的自主管理，开启车主全新车生活。体验下载：http://www.mizway.com/app.html";
    info.image = [UIImage imageNamed:@"ic_about_large"];
    
    [SRShare share:info];
}

#pragma mark - Getter

- (NSArray *)titles
{
    if (_titles) {
        return _titles;
    }
    
    _titles = @[@"功能介绍", @"欢迎页", @"帮助", @"推荐我们"];
    
    return _titles;
}


@end

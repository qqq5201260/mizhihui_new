//
//  SRBrandVehicleViewController.m
//  SiRuiV4.0
//
//  Created by zhangjunbo on 15/6/15.
//  Copyright (c) 2015年 SiRui. All rights reserved.
//

#import "SRBrandVehicleViewController.h"
#import "SRPortal+Regist.h"
#import "SRIndexBar.h"
#import "SRBrandInfo.h"
#import "SRSeriesInfo.h"
#import "SRVehicleInfo.h"
#import "SRUIUtil.h"
#import "SRTableViewCell.h"
#import "SRDataBase+BrandInfo.h"
#import <MBProgressHUD/MBProgressHUD.h>
#import <BlocksKit/UIBarButtonItem+BlocksKit.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import <MJRefresh/MJRefresh.h>

const CGFloat kLeadingWith = 100.0f;

@interface SRBrandVehicleViewController () <SRIndexBarDelegate, UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) UINavigationBar *navBar;
@property (weak, nonatomic) UITableView *table1;
@property (weak, nonatomic) UIView *containerView;
@property (weak, nonatomic) UITableView *table2;

@property (strong, nonatomic) MBProgressHUD *hud;

@property (nonatomic, strong) SRIndexBar *indexBar;

@property (nonatomic, strong) SRBrandInfo *selectedBrandInfo;
@property (nonatomic, strong) SRVehicleInfo *selectedVehicleInfo;
@property (nonatomic, strong) SRSeriesInfo *selectedSeriesInfo;

@property (nonatomic, strong) NSMutableDictionary *brandDic;
@property (nonatomic, strong) NSArray *brandKeys;

@end

@implementation SRBrandVehicleViewController
{
    BOOL isSubTableShow;
    NSInteger selectedSection;
}

#pragma mark -
#pragma mark 生命周期

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self initNavBar];
    [self initTableViews];
    
    selectedSection = -1;
    
    self.brandDic = [NSMutableDictionary dictionary];
    
    if (self.tableType == BrandVehicleType_Both
        || self.tableType == BrandVehicleType_Brand) {
        [self.view insertSubview:self.indexBar aboveSubview:self.table1];
        [self.indexBar makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.table1);
            make.trailing.equalTo(self.table1);
            make.width.equalTo(20);
            make.height.equalTo(self.brandKeys.count * 17);
        }];
        
        [self.indexBar reloadTitles];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self hideContainerViewAnimated:NO];
    
    if (self.tableType == BrandVehicleType_Vehicle) {
        if (self.brandInfo.seriesList.count == 0) {
            self.table1.mj_header.state = MJRefreshStateRefreshing;
        }
    } else {
        self.table1.mj_header.state = MJRefreshStateRefreshing;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark - Button Action


#pragma mark - 
#pragma mark - SRIndexBarDelegate

- (NSArray *)indexBarTitles:(SRIndexBar *)indexBar {
    return self.brandKeys;
}

- (void)indexSelectionDidChange:(SRIndexBar *)indexBar index:(NSInteger)index title:(NSString *)title {
    CGRect rect = [self.table1 rectForSection:index];
    [self.table1 scrollRectToVisible:rect animated:NO];
    
    if (self.hud) {
        [(UILabel *)self.hud.customView setText:title];
    }
}

- (void)indexBarTouchesBegan:(SRIndexBar *)indexBar {
    self.hud.dimBackground = NO;
    [self.hud show:YES];
}


- (void)indexBarTouchesEnd:(SRIndexBar *)indexBar {
    if (self.hud) {
        [self.hud hide:YES];
    }
}

#pragma mark -
#pragma mark UIScrollViewDelegate

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (isSubTableShow && [(UITableView *)scrollView isEqual:self.table1]) {
        isSubTableShow = NO;
        [self hideContainerViewAnimated:YES];
    }
}

#pragma mark -
#pragma mark UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (self.tableType == BrandVehicleType_Brand || self.tableType == BrandVehicleType_Both) {
        if ([tableView isEqual:self.table1]) {
            return self.brandKeys?self.brandKeys.count:1;
        } else {
            return self.selectedBrandInfo.seriesList.count;
        }
    } else {
        return self.brandInfo.seriesList.count;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.tableType == BrandVehicleType_Brand || self.tableType == BrandVehicleType_Both) {
        if ([tableView isEqual:self.table1]) {
            NSMutableArray *brandList = [self.brandDic objectForKey:self.brandKeys[section]];
            return brandList.count;
        } else {
            if (section == selectedSection) {
                SRSeriesInfo *seriesInfo = self.selectedBrandInfo.seriesList[section];
                return seriesInfo.vehicleModelVOs.count;
            } else {
                return 0;
            }
        }
    } else {
        if (section == selectedSection) {
            SRSeriesInfo *seriesInfo = self.brandInfo.seriesList[section];
            return seriesInfo.vehicleModelVOs.count;
        } else {
            return 0;
        }
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:CellIdentifier];
    }
    
    if (self.tableType == BrandVehicleType_Both || self.tableType == BrandVehicleType_Brand) {
        if ([tableView isEqual:self.table1]) {
            NSMutableArray *brandList = self.brandDic[self.brandKeys[indexPath.section]];
            SRBrandInfo *info = brandList[indexPath.row];
            cell.textLabel.text = info.name;
            cell.textLabel.font = [UIFont systemFontOfSize:14.0];
            cell.textLabel.textColor = [UIColor blackColor];
            [cell.imageView sd_setImageWithURL:[NSURL URLWithString:info.logoUrl]
                              placeholderImage:[UIImage imageNamed:@"ic_about_large"]
                                       options:SDWebImageRetryFailed | SDWebImageLowPriority | SDWebImageRefreshCached];
            cell.imageView.contentMode = UIViewContentModeScaleToFill;
            cell.contentView.backgroundColor = [UIColor whiteColor];
        } else {
            SRSeriesInfo *seriesInfo = self.selectedBrandInfo.seriesList[indexPath.section];
            SRVehicleInfo *vehicleInfo = seriesInfo.vehicleModelVOs[indexPath.row];
            cell.textLabel.text = vehicleInfo.vehicleName;
            cell.textLabel.font = [UIFont systemFontOfSize:12.0];
            cell.textLabel.textColor = [UIColor blackColor];
            cell.textLabel.numberOfLines = 0;
        }
    } else {
        SRSeriesInfo *seriesInfo = self.brandInfo.seriesList[indexPath.section];
        SRVehicleInfo *vehicleInfo = seriesInfo.vehicleModelVOs[indexPath.row];
        cell.textLabel.text = vehicleInfo.vehicleName;
        cell.textLabel.font = [UIFont systemFontOfSize:12.0];
        cell.textLabel.textColor = [UIColor blackColor];
        cell.textLabel.numberOfLines = 0;
    }
    
    return cell;
}

#pragma mark -
#pragma mark UITableViewDelegate

//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return 44.0f;
//}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (self.tableType == BrandVehicleType_Brand || self.tableType == BrandVehicleType_Both) {
        if ([tableView isEqual:self.table1]) {
            return 35.0f;
        } else {
            return 30.0f;
        }
    } else {
        return 30.0f;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (self.tableType == BrandVehicleType_Brand || self.tableType == BrandVehicleType_Both) {
        if ([tableView isEqual:self.table1]) {
            UIView *view = [[UIView alloc] init] ;
            view.backgroundColor = [UIColor colorWithRed:231.0/255.0 green:231.0/255.0 blue:231.0/255.0 alpha:1.0];
            UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 300, 35)];
            titleLabel.textColor = [UIColor blackColor];
            titleLabel.backgroundColor = [UIColor clearColor];
            titleLabel.text = self.brandKeys[section];
            [view addSubview:titleLabel];
            return view;
        } else {
            SRSeriesInfo *seriesInfo = self.selectedBrandInfo.seriesList[section];
            
            UIControl *view = [[UIControl alloc] init] ;
            view.backgroundColor = [UIColor colorWithRed:236.0/255.0 green:236.0/255.0 blue:236.0/255.0 alpha:1.0];
            UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 300, 30)];
            titleLabel.font = [UIFont systemFontOfSize:12.0];
            titleLabel.textColor = [UIColor darkGrayColor];
            titleLabel.backgroundColor = [UIColor clearColor];
            titleLabel.text = seriesInfo.seriesName;
            [view addSubview:titleLabel];
            
            [view bk_whenTapped:^{
                if (self->selectedSection == section) {
                    self->selectedSection = -1;
                } else {
                    self->selectedSection = section;
                }
                
                if (self.tableType == BrandVehicleType_Vehicle) {
                    [self.table1 reloadData];
                } else {
                    [self.table2 reloadData];
                }
            }];
            
            return view;
        }
    } else {
        SRSeriesInfo *seriesInfo = self.brandInfo.seriesList[section];
        
        UIControl *view = [[UIControl alloc] init] ;
        view.tag = section;
        view.backgroundColor = [UIColor colorWithRed:236.0/255.0 green:236.0/255.0 blue:236.0/255.0 alpha:1.0];
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 300, 35)];
        titleLabel.font = [UIFont systemFontOfSize:12.0];
        titleLabel.textColor = [UIColor darkGrayColor];
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.text = seriesInfo.seriesName;
        [view addSubview:titleLabel];
        
        [view bk_whenTapped:^{
            if (self->selectedSection == section) {
                self->selectedSection = -1;
            } else {
                self->selectedSection = section;
            }
            
            if (self.tableType == BrandVehicleType_Vehicle) {
                [self.table1 reloadData];
            } else {
                [self.table2 reloadData];
            }
        }];
        
        return view;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor clearColor];
    return view;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.tableType == BrandVehicleType_Brand) {
        NSMutableArray *brandList = self.brandDic[self.brandKeys[indexPath.section]];
        self.selectedBrandInfo = brandList[indexPath.row];
    } else if (self.tableType == BrandVehicleType_Vehicle) {
        self.selectedSeriesInfo = self.brandInfo.seriesList[indexPath.section];
        self.selectedVehicleInfo = self.selectedSeriesInfo.vehicleModelVOs[indexPath.row];
    } else {
        if ([tableView isEqual:self.table1]) {
            NSMutableArray *brandList = self.brandDic[self.brandKeys[indexPath.section]];
            self.selectedBrandInfo = brandList[indexPath.row];
            self.selectedSeriesInfo = nil;
            self.selectedVehicleInfo = nil;
            selectedSection = -1;
            
            if (self.selectedBrandInfo.seriesList.count == 0) {
                self.table2.mj_header.state = MJRefreshStateRefreshing;
            } else {
                if (!isSubTableShow) [self showContainerViewAnimated:YES];
                
                [self.table2 reloadData];
                [self.table2 setContentOffset:CGPointZero];
            }
        } else {
            self.selectedSeriesInfo = self.selectedBrandInfo.seriesList[indexPath.section];
            self.selectedVehicleInfo = self.selectedSeriesInfo.vehicleModelVOs[indexPath.row];
        }
    }
}

#pragma mark -
#pragma mark - Handle Gesture Recognizer


#pragma mark -
#pragma mark Animation

- (void)showContainerViewAnimated:(BOOL)animated{
    
    if (self.tableType != BrandVehicleType_Both) return;
    
    [self.containerView updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).with.offset(StatusBar_HEIGHT+NavigationBar_HEIGHT);
        make.leading.equalTo(self.view).with.offset(kLeadingWith);
        make.trailing.bottom.equalTo(self.view);
        make.bottom.equalTo(self.view);
    }];
    
    [self.view setNeedsUpdateConstraints];
    [self.view  updateConstraintsIfNeeded];
    [UIView  animateWithDuration:animated?0.35:0 animations:^{
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {
        self->isSubTableShow = YES;
        [self.table2 reloadData];
    }];
}

- (void)hideContainerViewAnimated:(BOOL)animated{
    
    [self.containerView updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).with.offset(StatusBar_HEIGHT+NavigationBar_HEIGHT);
        make.leading.equalTo(self.view).with.offset(SCREEN_WIDTH);
        make.bottom.equalTo(self.view);
        make.width.equalTo(SCREEN_WIDTH - kLeadingWith);
    }];
    
    [self.view setNeedsUpdateConstraints];
    [self.view updateConstraintsIfNeeded];
    [UIView  animateWithDuration:animated?0.35:0 animations:^{
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {
        self->isSubTableShow = NO;
    }];
}

#pragma mark - 
#pragma mark - Getter

- (SRIndexBar *)indexBar {
    
    if (!_indexBar) {
        _indexBar = [[SRIndexBar alloc] init];
        _indexBar.backgroundColor = [UIColor clearColor];
        _indexBar.textColor = [UIColor colorWithRed:0.0f green:0.49f blue:0.96f alpha:1.0f];
        _indexBar.highlightedBackgroundColor = [UIColor clearColor];
        _indexBar.textFont = [UIFont systemFontOfSize:13.0f];
        _indexBar.delegate = self;
    }
    
    return _indexBar;
}

- (MBProgressHUD *)hud {
    if (!_hud) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [UIColor colorWithRed:0.0f green:0.49f blue:0.96f alpha:1.0f];
        label.font = [UIFont boldSystemFontOfSize:40.0f];
        
        _hud = [[MBProgressHUD alloc] init];
        _hud.customView = label;
        _hud.mode = MBProgressHUDModeCustomView;
        _hud.color = [UIColor clearColor];
        [self.view addSubview:_hud];
        [self.view bringSubviewToFront:_hud];
    }
    
    return _hud;
}

#pragma mark -
#pragma mark - Setter

- (void)setBrandDic:(NSMutableDictionary *)brandDic {
    _brandDic = brandDic;
    self.brandKeys = brandDic.sortedKeysDescending;
}

#pragma mark -
#pragma mark - 私有方法

- (void)initNavBar {
    
    self.view.backgroundColor = [UIColor defaultColor];
    
    UINavigationBar *navBar = [[UINavigationBar alloc] initWithFrame:CGRectZero];
    navBar.barTintColor = [UIColor clearColor];
    UINavigationItem * navItem = [[UINavigationItem alloc] initWithTitle:@""];
    [navBar pushNavigationItem: navItem animated:YES];
    [self.view addSubview: navBar];
    [navBar makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).with.offset(StatusBar_HEIGHT);
        make.height.equalTo(NavigationBar_HEIGHT);
        make.width.equalTo(SCREEN_WIDTH);
    }];
    
    [navBar setBarTintColor:[UIColor defaultNavBarTintColor]];
    [navBar setTintColor:[UIColor whiteColor]];
    [navBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    [navBar setShadowImage:[[UIImage alloc] init]];
    
    self.navBar = navBar;
//    [navBar setBackgroundImage:[UIImage imageWithColor:[UIColor defaultNavBarTintColor] size:CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT)]
//                forBarPosition:UIBarPositionTopAttached
//                    barMetrics:UIBarMetricsDefault];
    
    UIBarButtonItem *cancelItem = [[UIBarButtonItem alloc] bk_initWithTitle:SRLocal(@"bt_cancel") style:UIBarButtonItemStyleDone handler:^(id sender) {
        if (self.delegate) {
            [self.delegate selectedBrandInfo:nil seriesInfo:nil andVehicleInfo:nil];
        }
        
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
    UIBarButtonItem *doneItem = [[UIBarButtonItem alloc] bk_initWithTitle:SRLocal(@"bt_done") style:UIBarButtonItemStyleDone handler:^(id sender) {
        
        if (self.tableType == BrandVehicleType_Brand && !self.selectedBrandInfo) {
            [SRUIUtil showAlertMessage:@"请选择品牌"];
        } else if (self.tableType == BrandVehicleType_Vehicle && !self.selectedSeriesInfo) {
            [SRUIUtil showAlertMessage:@"请选择车型"];
        } else if (self.tableType == BrandVehicleType_Both && (!self.selectedBrandInfo || !self.selectedSeriesInfo)) {
            [SRUIUtil showAlertMessage:@"请选择品牌车型"];
        } else {
            if (self.delegate) {
                [self.delegate selectedBrandInfo:self.brandInfo?self.brandInfo:self.selectedBrandInfo seriesInfo:self.selectedSeriesInfo andVehicleInfo:self.selectedVehicleInfo];
            }
            [self dismissViewControllerAnimated:YES completion:nil];
        }
    }];
    
    UIBarButtonItem *leftSpacer = [[ UIBarButtonItem alloc ] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                                                                  target:nil action:nil];
    leftSpacer.width = 0 ;
    [navItem setLeftBarButtonItems:@[leftSpacer, cancelItem]];
    UIBarButtonItem *rightSpacer = [[ UIBarButtonItem alloc ]
                                    initWithBarButtonSystemItem : UIBarButtonSystemItemFixedSpace
                                    target : nil action : nil ];
    rightSpacer. width = 0 ;
    [navItem setRightBarButtonItems:@[rightSpacer, doneItem]];
}

- (void)initTableViews {

    UITableView *table1 = [[UITableView alloc] initWithFrame:CGRectZero];
    table1.delegate = self;
    table1.dataSource = self;
    [table1 setTableFooterView:[[UIView alloc] init]];
    [self.view addSubview:table1];
    [table1 makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).with.offset(StatusBar_HEIGHT+NavigationBar_HEIGHT);
        make.leading.trailing.bottom.equalTo(self.view);
    }];
    self.table1 = table1;
    
    UIView *containerView = [[UIView alloc] initWithFrame:CGRectZero];
    containerView.layer.shadowOffset = CGSizeMake(-5.0f, 7.0f);
    containerView.layer.shadowOpacity = 0.5f;
    containerView.layer.shadowColor = [UIColor lightGrayColor].CGColor;
    containerView.layer.shadowRadius = 5;
    [self.view addSubview:containerView];
    [containerView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).with.offset(StatusBar_HEIGHT+NavigationBar_HEIGHT);
        make.leading.equalTo(self.view).with.offset(SCREEN_WIDTH);
        make.bottom.equalTo(self.view);
        make.width.equalTo(SCREEN_WIDTH - kLeadingWith);
    }];
    
    self.containerView = containerView;
    
    UITableView *table2 = [[UITableView alloc] initWithFrame:CGRectZero];
    table2.delegate = self;
    table2.dataSource = self;
    [table2 setTableFooterView:[[UIView alloc] init]];
    UISwipeGestureRecognizer *swipe = [UISwipeGestureRecognizer bk_recognizerWithHandler:^(UIGestureRecognizer *sender, UIGestureRecognizerState state, CGPoint location) {
        UISwipeGestureRecognizer *recognizer = (UISwipeGestureRecognizer *)sender;
        if (recognizer.direction == UISwipeGestureRecognizerDirectionRight) {
            [self hideContainerViewAnimated:YES];
        }
    }];
    [table2 addGestureRecognizer:swipe];
    [self.containerView addSubview:table2];
    [table2 makeConstraints:^(MASConstraintMaker *make) {
        make.top.trailing.bottom.leading.equalTo(self.containerView);
    }];
    self.table2 = table2;
    
    self.table1.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        if (self.tableType == BrandVehicleType_Vehicle) {
            [SRPortal getSeriesAndVehiclesWithBrandInfo:self.brandInfo andCompleteBlock:^(NSError *error, id responseObject) {
                [self.table1.mj_header endRefreshing];
                if (error) {
                    [SRUIUtil showAlertMessage:error.domain];
                    return ;
                }
                
                [self.table1 reloadData];
            }];
            
            [[SRDataBase sharedInterface] queryBrandInfoByBrandID:self.brandInfo.entityID withCompleteBlock:^(NSError *error, id responseObject) {
                if (!responseObject || [responseObject count] == 0
                    || [(SRBrandInfo *)[responseObject firstObject] seriesList].count == 0) {
                    return ;
                }
                self.brandInfo = [responseObject firstObject];
                [self.table1 reloadData];
            }];
        } else {
            [SRPortal getBrandListWithCompleteBlock:^(NSError *error, id responseObject){
                [self.table1.mj_header endRefreshing];
                if (error) {
                    [SRUIUtil showAlertMessage:error.domain];
                    return ;
                }
                
                self.brandDic = responseObject;
                
                [self.table1 reloadData];
                
                [self.indexBar reloadTitles];
                
                [self.indexBar updateConstraints:^(MASConstraintMaker *make) {
                    make.centerY.equalTo(self.table1);
                    make.trailing.equalTo(self.table1);
                    make.width.equalTo(20);
                    make.height.equalTo(self.brandKeys.count * 17);
                }];
            }];
            
            [[SRDataBase sharedInterface] queryAllBrandInfosWithCompleteBlock:^(NSError *error, id responseObject) {
                if (!responseObject || [responseObject count] == 0) {
                    return ;
                }
                
                NSMutableDictionary *brandDic = [NSMutableDictionary dictionary];
                [responseObject enumerateObjectsUsingBlock:^(SRBrandInfo *obj, NSUInteger idx, BOOL *stop) {
                    if (obj.entityID < 0) return ;
                    
                    NSMutableArray *array = [brandDic objectForKey:obj.brandFirstLetter];
                    if (!array) {
                        array = [NSMutableArray arrayWithObject:obj];
                        [brandDic setObject:array forKey:obj.brandFirstLetter];
                    } else {
                        [array addObject:obj];
                    }
                }];
                self.brandDic = brandDic;
                
                [self.table1 reloadData];
                
                [self.indexBar reloadTitles];
                
                [self.indexBar updateConstraints:^(MASConstraintMaker *make) {
                    make.centerY.equalTo(self.table1);
                    make.trailing.equalTo(self.table1);
                    make.width.equalTo(20);
                    make.height.equalTo(self.brandKeys.count * 17);
                }];
            }];
        }
    }];
    
    self.table2.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self.table2 reloadData];
        [SRPortal getSeriesAndVehiclesWithBrandInfo:self.selectedBrandInfo andCompleteBlock:^(NSError *error, id responseObject) {
            [self.table2.mj_header endRefreshing];
            
            if (error) {
                [SRUIUtil showAlertMessage:error.domain];
                return ;
            }
            
            if (!self->isSubTableShow) [self showContainerViewAnimated:YES];
            
            [self.table2 reloadData];
            [self.table2 setContentOffset:CGPointZero];
        }];
        
        [[SRDataBase sharedInterface] queryBrandInfoByBrandID:self.selectedBrandInfo.entityID withCompleteBlock:^(NSError *error, id responseObject) {
            if (!responseObject || [responseObject count] == 0
                || [(SRBrandInfo *)[responseObject firstObject] seriesList].count == 0) {
                return ;
            }
            self.selectedBrandInfo = [responseObject firstObject];
            
            if (!self->isSubTableShow) [self showContainerViewAnimated:YES];
            
            [self.table2 reloadData];
            [self.table2 setContentOffset:CGPointZero];
        }];
    }];
}

@end

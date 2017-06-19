//
//  SRMessageViewController.m
//  SiRuiV4.0
//
//  Created by zhangjunbo on 15/6/29.
//  Copyright (c) 2015年 SiRui. All rights reserved.
//

#import "SRMessageViewController.h"
#import "SRMessageCell.h"
#import "SRDataBase+Message.h"
#import "SRPortalRequest.h"
#import "SRPortal+Message.h"
#import "SRUIUtil.h"
#import "SRCustomer.h"
#import "UITableView+FDTemplateLayoutCell.h"
#import <MJRefresh/MJRefresh.h>
#import <KVOController/FBKVOController.h>

@interface SRMessageViewController () <UITableViewDataSource, UITableViewDelegate>
{
    FBKVOController *kvoController;
    BOOL isFirstTime;
}

@property (weak, nonatomic) UITableView *tableView;

@property (strong, nonatomic) NSArray *messages;

@end

@implementation SRMessageViewController

- (instancetype)initWithType:(SRMessageType)type
{
    if (self = [super init]) {
        _type = type;
    }
    
    return self;
}

#pragma mark - 生命周期

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero];
    tableView.backgroundColor = [UIColor clearColor];
    tableView.backgroundView.backgroundColor = [UIColor clearColor];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.allowsSelection = NO;
    tableView.tableFooterView = [[UIView alloc] init];
    tableView.needAddEmptyView = @(YES);
    [self.view addSubview:tableView];
    [tableView makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.right.equalTo(self.view);
    }];
    
    UINib *nib = [UINib nibWithNibName:@"SRMessageCell" bundle:nil];
    [tableView registerNib:nib forCellReuseIdentifier:CellIdentifier];
    
    self.tableView = tableView;
    
    self.messages = [NSArray array];
    [[SRDataBase sharedInterface] queryMessageInfoWithMessageType:self.type CompleteBlock:^(NSError *error, id responseObject) {
        self.messages = responseObject;
    }];
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        SRPortalRequestQueryMessagePage *request = [[SRPortalRequestQueryMessagePage alloc] init];
        request.type = self.type;
        [SRPortal queryMessageWithRequest:request isRefresh:YES andCompleteBlock:^(NSError *error, id responseObject) {
            [self.tableView.mj_header endRefreshing];
            if (!error) {
                self.messages = responseObject?responseObject:self.messages;
            }
        }];
    }];
    
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        SRPortalRequestQueryMessagePage *request = [[SRPortalRequestQueryMessagePage alloc] init];
        request.type = self.type;
        [SRPortal queryMessageWithRequest:request isRefresh:NO andCompleteBlock:^(NSError *error, id responseObject) {
            [self.tableView.mj_footer endRefreshing];
            if (!error) {
                self.messages = responseObject?responseObject:self.messages;
            }
        }];
    }];
    
//    self.tableView.mj_header.state = MJRefreshStateRefreshing;
    isFirstTime = YES;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (isFirstTime) {
        isFirstTime = NO;
        self.tableView.mj_header.state = MJRefreshStateRefreshing;
    }
    
    NSString *keyPath;
    if (self.type == SRMessageType_Alert) {
        keyPath = @"hasNewMessageInAlert";
    } else if (self.type == SRMessageType_Remind) {
        keyPath = @"hasNewMessageInRemind";
    } else {
        keyPath = @"hasNewMessageInFunction";
    }
    
    [kvoController observe:[SRPortal sharedInterface].customer keyPath:keyPath options:NSKeyValueObservingOptionNew block:^(id observer, id object, NSDictionary *change) {
        if (![change[NSKeyValueChangeNewKey] boolValue]) {
            return ;
        }
        [self executeOnMain:^{
            self.tableView.mj_header.state = MJRefreshStateRefreshing;
        } afterDelay:0];
    }];
    
    if ((self.type == SRMessageType_Alert && [SRPortal sharedInterface].customer.hasNewMessageInAlert)
        ||(self.type == SRMessageType_Remind && [SRPortal sharedInterface].customer.hasNewMessageInRemind)
        ||(self.type == SRMessageType_Function && [SRPortal sharedInterface].customer.hasNewMessageInFunction)) {
        self.tableView.mj_header.state = MJRefreshStateRefreshing;
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [kvoController unobserveAll];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section
{
    view.tintColor = [UIColor defaultBackgroundColor];
}

- (void)tableView:(UITableView *)tableView willDisplayFooterView:(UIView *)view forSection:(NSInteger)section {
    view.tintColor = [UIColor defaultBackgroundColor];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(SRMessageCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [cell setFisrtCell:indexPath.row==0
              lastCell:indexPath.row == [self tableView:tableView numberOfRowsInSection:indexPath.section]-1];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    return [tableView fd_heightForCellWithIdentifier:CellIdentifier configuration:^(SRMessageCell *cell) {
        [self configureCell:cell atIndexPath:indexPath];
    }];
}

- (void)configureCell:(SRMessageCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    cell.info = self.messages[indexPath.row];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.messages.count;
}

static NSString *CellIdentifier = @"CellIdentifier" ;
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SRMessageCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    [self configureCell:cell atIndexPath:indexPath];
    
    return cell;
}

#pragma mark - Setter

- (void)setMessages:(NSArray *)messages {
    _messages = messages;
    [self.tableView reloadData];
    [self.tableView.mj_footer scrollViewContentSizeDidChange:[NSDictionary dictionary]];
}

@end

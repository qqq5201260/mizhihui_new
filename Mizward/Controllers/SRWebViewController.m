//
//  SRWebViewController.m
//  Mizward
//
//  Created by zhangjunbo on 15/8/18.
//  Copyright (c) 2015年 Mizward. All rights reserved.
//

#import "SRWebViewController.h"
#import "SRWebProgress.h"
#import "SRWebProgressView.h"
#import "SRURLUtil.h"
#import <MJRefresh/MJRefresh.h>

@interface SRWebViewController () <SRWebViewProgressDelegate, UIWebViewDelegate>

@property (weak, nonatomic) SRWebProgressView *progressView;
@property (weak, nonatomic) UIWebView *webView;

@property (strong, nonatomic) SRWebProgress *webProgress;

@end

@implementation SRWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//    self.title = self.titleStr;
    
    self.view.backgroundColor = [UIColor defaultBackgroundColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.webView.delegate = self.webProgress;
    
    [self loadWebView];
    
    self.webView.scrollView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self loadWebView];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - SRWebViewProgressDelegate

-(void)webViewProgress:(SRWebProgress *)webViewProgress updateProgress:(float)progress
{
    [self.progressView setProgress:progress animated:YES];
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = (progress==1.0f?NO:YES);
    self.progressView.hidden = (progress==1.0f?YES:NO);
    
    if (progress == 1.0f) {
        [self.webView.scrollView.mj_header endRefreshing];
    }
}

#pragma mark - 私有方法

- (void)loadWebView {
    NSURLRequest *req = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:self.url]];
    [self.webView loadRequest:req];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - Getter

- (SRWebProgressView *)progressView {
    if (_progressView) {
        return _progressView;
    }
    
    SRWebProgressView *progressView = [[SRWebProgressView alloc] init];
    [self.view addSubview:progressView];
    [progressView makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.mas_topLayoutGuide);
        make.height.equalTo(3.0f);
    }];
    
    _progressView = progressView;
    return _progressView;
}

- (UIWebView *)webView {
    if (_webView) {
        return _webView;
    }
    
    UIWebView *webView = [[UIWebView alloc] init];
    webView.backgroundColor = [UIColor defaultBackgroundColor];
    [self.view insertSubview:webView belowSubview:self.progressView];
    [webView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_topLayoutGuide);
        make.left.right.bottom.equalTo(self.view);
    }];
    
    _webView = webView;
    return _webView;
}

- (SRWebProgress *)webProgress {
    if (_webProgress) {
        return _webProgress;
    }
    
    _webProgress = [[SRWebProgress alloc] init];
    _webProgress.webViewProxyDelegate = self;
    _webProgress.progressDelegate = self;
    
    return _webProgress;
}

@end

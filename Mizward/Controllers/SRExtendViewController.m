//
//  SRExtendViewController.m
//  Mizward
//
//  Created by zhangjunbo on 15/12/5.
//  Copyright © 2015年 Mizward. All rights reserved.
//

#import "SRExtendViewController.h"
#import "SRPortal.h"
#import "SRCustomer.h"
#import "SRURLUtil.h"
#import <AFNetworking/AFNetworking.h>

@interface SRExtendViewController ()
@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation SRExtendViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"账户";
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    NSString *pt = [NSString stringWithFormat:@"%zd", [SRPortal sharedInterface].customer.customerID].RSAEncode.urlEncode;
    NSString *url = [NSString stringWithFormat:@"%@?pt=%@", [SRURLUtil Portal_AccountQuery], pt];
    
//    NSURL *webUrl = [NSURL URLWithString:url];
//    NSURLRequest *request =[NSURLRequest requestWithURL:webUrl cachePolicy:NSURLRequestReloadRevalidatingCacheData timeoutInterval:60];
//    
//    [self.webView loadRequest:request];
    
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"preLoad" ofType:@"html"];
    NSString *htmlString = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
    htmlString = [htmlString stringByReplacingOccurrencesOfString:@"destinationAddress" withString:url];
    [self.webView loadHTMLString:htmlString baseURL:[NSURL URLWithString:filePath]];
}

#pragma mark -
#pragma mark UIWebViewDelegate

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    
    return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{

}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    //修改服务器页面的meta的值
//    NSString *meta = [NSString stringWithFormat:@"document.getElementsByName(\"viewport\")[0].content = \"width=%f, initial-scale=1.0, minimum-scale=1.0, maximum-scale=1.0, user-scalable=no\"", webView.frame.size.width];
//    [webView stringByEvaluatingJavaScriptFromString:meta];
    
//    NSString *lJs = @"document.documentElement.innerHTML";
//    NSString *lJs2 = @"document.title";
//    
//    NSString *lHtml1 = [self.webView stringByEvaluatingJavaScriptFromString:lJs];
//    NSString *lHtml2 = [self.webView stringByEvaluatingJavaScriptFromString:lJs2];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(nullable NSError *)error
{

}

@end

//
//  SRHelpViewController.m
//  SiRuiV4.0
//
//  Created by zhangjunbo on 15/7/13.
//  Copyright (c) 2015年 SiRui. All rights reserved.
//

#import "SRHelpViewController.h"

@interface SRHelpViewController ()

@end

@implementation SRHelpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"功能介绍";
    
    UIScrollView *scroll = [[UIScrollView alloc] initWithFrame:CGRectZero];
    [self.view addSubview:scroll];
    [scroll makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.left.right.equalTo(self.view);
    }];
    
    NSString *path = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"im_help"] ofType:@"jpg"];
    UIImage *image = [UIImage imageWithContentsOfFile:path];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    imageView.frame = CGRectMake(0, 0, self.view.width, self.view.width*image.size.height/image.size.width);
    [scroll addSubview:imageView];
    scroll.contentSize = CGSizeMake(imageView.width, imageView.height);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

//
//  HomePageOtherDetailsViewController.m
//  Emeat
//
//  Created by liuheshun on 2018/3/6.
//  Copyright © 2018年 liuheshun. All rights reserved.
//

#import "HomePageOtherDetailsViewController.h"

@interface HomePageOtherDetailsViewController ()<UIWebViewDelegate>

@end

@implementation HomePageOtherDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;

    self.navItem.title = @"详情";
    self.view.backgroundColor = RGB(238, 238, 238, 1);

    UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, kBarHeight, kWidth, kHeight-kBarHeight-LL_TabbarSafeBottomMargin)];
    
    webView.scalesPageToFit = YES;//自动对页面进行缩放以适应屏幕
    webView.detectsPhoneNumbers = YES;//自动检测网页上的电话号码，单击可以拨打
    [self.view addSubview:webView];
    
    NSURL* url = [NSURL URLWithString:self.detailsURL];//创建URL
    NSURLRequest* request = [NSURLRequest requestWithURL:url];//创建NSURLRequest
    [webView loadRequest:request];//加载

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

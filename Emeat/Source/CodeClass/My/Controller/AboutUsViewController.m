//
//  AboutUsViewController.m
//  Emeat
//
//  Created by liuheshun on 2017/12/22.
//  Copyright © 2017年 liuheshun. All rights reserved.
//

#import "AboutUsViewController.h"

@interface AboutUsViewController ()

@end

@implementation AboutUsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = RGB(238, 238, 238, 1);

    self.navItem.title = @"关于我们";
    

    UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, kBarHeight, kWidth, kHeight - kBarHeight - LL_TabbarSafeBottomMargin)];
    [self.view addSubview:webView];
    webView.scalesPageToFit = YES;
    webView.detectsPhoneNumbers = YES;
    //如：http://dev.cyberfresh.cn/html/about_us.html
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/html/about_us.html" ,baseUrl]];
    NSURLRequest* request = [NSURLRequest requestWithURL:url];
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

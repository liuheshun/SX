//
//  HomePageOtherDetailsViewController.m
//  Emeat
//
//  Created by liuheshun on 2018/3/6.
//  Copyright © 2018年 liuheshun. All rights reserved.
//

#import "HomePageOtherDetailsViewController.h"

#import "HomePageDetailsViewController.h"

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
    webView.delegate = self;
    [self.view addSubview:webView];
    
    NSURL* url = [NSURL URLWithString:self.detailsURL];//创建URL
    NSURLRequest* request = [NSURLRequest requestWithURL:url];//创建NSURLRequest
    [webView loadRequest:request];//加载

}


-(void)webViewDidFinishLoad:(UIWebView *)webView{
      NSString *tit = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];//获取当前页面的title
    DLog(@"标题 ==== == == = == = == ==== %@" ,tit);
    self.navItem.title = tit;

}

#pragma mark = webview 代理方法
-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    
    NSString *requestString = [[request URL] absoluteString];
    DLog(@"webView========== %@" ,requestString);
    if ([requestString rangeOfString:@"SP"].location != NSNotFound){
        
        
        
        NSArray *array = [requestString componentsSeparatedByString:@"SP"]; //从字符A中分隔成2个元素的数组
        HomePageDetailsViewController *VC = [HomePageDetailsViewController new];
        VC.hidesBottomBarWhenPushed = YES;
        VC.fromBaner = @"1";
        VC.detailsId = [NSString stringWithFormat:@"SP%@" ,[array lastObject]];
        [self.navigationController pushViewController:VC animated:YES];
        
        return NO;
        
    }else if ([requestString rangeOfString:@"999"].location != NSNotFound){
        
        return  YES;
        
    }else {
        
//        NSString *jsStr = [NSString stringWithFormat:@"getCount()"];
//        NSString *a=   [self.myWebView stringByEvaluatingJavaScriptFromString:jsStr];
//        if ([a isEqualToString:@"1"]) {
//            self.attendPeople = @"1";
//        }
        return YES;
    }
   
    
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

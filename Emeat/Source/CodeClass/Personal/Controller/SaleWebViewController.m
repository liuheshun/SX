//
//  SaleWebViewController.m
//  Emeat
//
//  Created by liuheshun on 2018/8/29.
//  Copyright © 2018年 liuheshun. All rights reserved.
//

#import "SaleWebViewController.h"
#import "WebViewJavascriptBridge.h"

#import "HomePageDetailsViewController.h"


@interface SaleWebViewController ()<UIWebViewDelegate>

@property (nonatomic,strong) UIWebView *webView;
@property WebViewJavascriptBridge* bridge;

///分销商id
@property (nonatomic,strong) NSString *distributorUid;

//是否是APP返回
@property (nonatomic,strong) NSString *isApp;


@end

@implementation SaleWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    
    self.navItem.title = @"详情";
    self.view.backgroundColor = RGB(238, 238, 238, 1);
    [self setWebView];

    [self showNavBarLeftItem];
}


-(void)showNavBarLeftItem{
    NSArray *viewcontrollers=self.navigationController.viewControllers;
    if (viewcontrollers.count>1) {
        if ([viewcontrollers objectAtIndex:viewcontrollers.count-1]==self) {
            //push方式 判断页面是否存在push
            //创建一个左边按钮
            self.leftButton = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"fanhui"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]style:UIBarButtonItemStylePlain target:self action:@selector(leftItemAction)];
            [self.navBar pushNavigationItem:self.navItem animated:NO];
            [self.navItem setLeftBarButtonItem:self.leftButton];
            
        }
    }
    else{
        //present方式
    }
    
    
    
}


-(void)leftItemAction{
    
    if ([self.isApp isEqualToString:@"0"]) {
        //返回到活动详情webview页面
        if (self.webView.canGoBack){
            
            [self.webView goBack];
            self.isApp = @"1";
        }
    }else{
        [self.navigationController popViewControllerAnimated:YES];

    }
    
//    [SVProgressHUD dismiss];
//    if (self.presentingViewController) {
//        [self dismissViewControllerAnimated:YES completion:nil];
//    } else {
//        [self.navigationController popViewControllerAnimated:YES];
//    }
}


-(void)setWebView{
    self.webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, kBarHeight, kWidth, kHeight-kBarHeight-LL_TabbarSafeBottomMargin)];
    
    self.webView.scalesPageToFit = YES;//自动对页面进行缩放以适应屏幕
    self.webView.detectsPhoneNumbers = YES;//自动检测网页上的电话号码，单击可以拨打
    self.webView.delegate = self;
    [self.view addSubview:self.webView];
    
    //初始化  WebViewJavascriptBridge
    if (_bridge) { return; }
    [WebViewJavascriptBridge enableLogging];
    _bridge = [WebViewJavascriptBridge bridgeForWebView:self.webView];
    [_bridge setWebViewDelegate:self];
    
    
    
    
    
    
    // NSURL* url = [NSURL URLWithString:self.detailsURL];//创建URL
    NSURL* url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/distributor/distribution_login_ios.html" ,baseUrl]];//创建URL
    
    
    NSURLRequest* request = [NSURLRequest requestWithURL:url];//创建NSURLRequest
    [self.webView loadRequest:request];//加载
    
    
    //申明js调用oc方法的处理事件，这里写了后，h5那边只要请求了，oc内部就会响应
    [self JS2OC];
    
    
    //模拟操作：2秒后，oc会调用js的方法
    //注意：这里厉害的是，我们不需要等待html加载完成，就能处理oc的请求事件；此外，webview的request 也可以在这个请求后面执行（可以把上面的[self loadExamplePage:webView]放到[self OC2JS]后面执行，结果是一样的）
    //    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
    //        [self OC2JS];
    //
    //    });
    
    [self OC2JS];
    
}



/**
 JS  调用  OC
 */
-(void)JS2OC{
    /*
     含义：JS调用OC
     @param registerHandler 要注册的事件名称(比如这里我们为loginAction)
     @param handel 回调block函数 当后台触发这个事件的时候会执行block里面的代码
     */
    [_bridge registerHandler:@"loginAction" handler:^(id data, WVJBResponseCallback responseCallback) {
        // data js页面传过来的参数  假设这里是用户名和姓名，字典格式
        //NSLog(@"JS调用OC，并传值过来");
        
        // 利用data参数处理自己的逻辑
        NSDictionary *dict = (NSDictionary *)data;
        NSString *str = [NSString stringWithFormat:@"用户名：%@  姓名：%@",@"余小鱼",@"你为什么这么可爱啊"];
        [self renderButtons:str];
        
        // responseCallback 给后台的回复
        responseCallback(@"报告，oc已收到js的请求");
    }];
    
}

-(void)loginAction{
   // DLog(@"哈哈哈哈");
}

/**
 OC  调用  JS
 */
-(void)OC2JS{
    /*
     含义：OC调用JS
     @param callHandler 商定的事件名称,用来调用网页里面相应的事件实现
     @param data id类型,相当于我们函数中的参数,向网页传递函数执行需要的参数
     注意，这里callHandler分3种，根据需不需要传参数和需不需要后台返回执行结果来决定用哪个
     */
    
    //[_bridge callHandler:@"registerAction" data:@"我是oc请求js的参数"];
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *islogin = [user valueForKey:@"isLoginState"];
    NSString *ticket = [user valueForKey:@"ticket"];
   // DLog(@"传过去ticket === %@" ,ticket);
    
    [_bridge callHandler:@"registerAction" data:[NSString stringWithFormat:@"%@"  ,ticket] responseCallback:^(id responseData) {
        //NSLog(@"oc请求js后接受的回调结果：%@",responseData);
    }];
    
}


- (void)renderButtons:(NSString *)str {
    //NSLog(@"JS调用OC，取到参数为： %@",str);
    
}

- (void)disableSafetyTimeout {
    [self.bridge disableJavscriptAlertBoxSafetyTimeout];
}




-(void)webViewDidFinishLoad:(UIWebView *)webView{
    NSString *tit = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];//获取当前页面的title
    //DLog(@"标题 ==== == == = == = == ==== %@" ,tit);
    self.navItem.title = tit;
    
    //[webView stringByEvaluatingJavaScriptFromString:@"appids(0)"];
    
    
}

#pragma mark = webview 代理方法
-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    
    NSString *requestString = [[request URL] absoluteString];
    //DLog(@"webView========== %@" ,requestString);
    if ([requestString rangeOfString:@"beef_detailxxx.html"].location != NSNotFound || [requestString rangeOfString:@"distribution_copywriter.html"].location != NSNotFound || [requestString rangeOfString:@"payment_details.html"].location != NSNotFound){
        
        //
        self.isApp = @"0";
        
        NSArray *array = [requestString componentsSeparatedByString:@"SP"]; //从字符A中分隔成2个元素的数组
//        HomePageDetailsViewController *VC = [HomePageDetailsViewController new];
//        VC.hidesBottomBarWhenPushed = YES;
//        VC.fromBaner = @"1";
//        VC.detailsId = [NSString stringWithFormat:@"SP%@" ,[array lastObject]];
//        [self.navigationController pushViewController:VC animated:YES];
        
        return YES;
        
    }else if ([requestString rangeOfString:@"beef_detail.html"].location != NSNotFound){
        
        
        NSArray *array = [requestString componentsSeparatedByString:@"ds="]; //从字符A中分隔成2个元素的数组
        
        array = [[array lastObject] componentsSeparatedByString:@"&"];
        
        HomePageDetailsViewController *VC = [HomePageDetailsViewController new];
        VC.hidesBottomBarWhenPushed = YES;
//        VC.fromBaner = @"1";
        VC.detailsId = [NSString stringWithFormat:@"%@" ,[array firstObject]];
        [self.navigationController pushViewController:VC animated:YES];
        
        return NO;
    }
    
    
    else if ([requestString rangeOfString:@"999"].location != NSNotFound){
        
        return  YES;
        
    }else {
        
        self.isApp = @"1";
        
        //        NSString *jsStr = [NSString stringWithFormat:@"getCount()"];
        //        NSString *a=   [self.myWebView stringByEvaluatingJavaScriptFromString:jsStr];
        //        if ([a isEqualToString:@"1"]) {
        //            self.attendPeople = @"1";
        //        }
        return YES;
    }
    
    
}



-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
   // DLog(@"error=========%@" ,error);
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

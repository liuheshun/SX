//
//  HomePageOtherDetailsViewController.m
//  Emeat
//
//  Created by liuheshun on 2018/3/6.
//  Copyright © 2018年 liuheshun. All rights reserved.
//

#import "HomePageOtherDetailsViewController.h"

#import "HomePageDetailsViewController.h"
#import "WebViewJavascriptBridge.h"

#import "AppDelegate.h"
#import "PersonalPageViewController.h"

@interface HomePageOtherDetailsViewController ()<UIWebViewDelegate>
@property (nonatomic,strong) UIWebView *webView;
@property WebViewJavascriptBridge* bridge;

@end

@implementation HomePageOtherDetailsViewController

-(void)viewWillAppear:(BOOL)animated{
    
    //获取通知中心单例对象
    NSNotificationCenter * center = [NSNotificationCenter defaultCenter];
    //添加当前类对象为一个观察者
    [center addObserver:self selector:@selector(InfoNotificationAction:) name:@"refreshControllerWithNotification" object:nil];
    //[self setWebView];

}
-(void)InfoNotificationAction:(NSNotification*)notification{
    //DLog(@"use == %@" , notification.userInfo)
    self.detailsURL =  notification.userInfo[@"detailsURL"];
    [self setWebView];
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"refreshControllerWithNotification" object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;

    self.navItem.title = @"详情";
    self.view.backgroundColor = RGB(238, 238, 238, 1);

    [MMPopupWindow sharedWindow].touchWildToHide = YES;
    MMAlertViewConfig1 *alertConfig = [MMAlertViewConfig1 globalConfig1];
    alertConfig.defaultTextOK = @"确定";
    alertConfig.defaultTextCancel = @"取消";
    alertConfig.titleFontSize = 17*kScale;
    alertConfig.detailFontSize = 14*kScale;
    alertConfig.buttonFontSize = 15*kScale;
    alertConfig.buttonHeight = 40*kScale;
    alertConfig.width = 315*kScale;
    alertConfig.buttonBackgroundColor = [UIColor redColor];
    alertConfig.detailColor = RGB(136, 136, 136, 1);
    alertConfig.itemNormalColor = [UIColor whiteColor];
    
    alertConfig.splitColor = [UIColor whiteColor];
    [self setWebView];


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
    NSURL* url = [NSURL URLWithString:self.detailsURL];//创建URL

    
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
    [_bridge registerHandler:@"app.immediatelychange" handler:^(id data, WVJBResponseCallback responseCallback) {
        // data js页面传过来的参数  假设这里是用户名和姓名，字典格式
       // NSLog(@"JS调用OC，并传值过来");
        
        // 利用data参数处理自己的逻辑
        NSDictionary *dict = (NSDictionary *)data;
        NSString *str = [NSString stringWithFormat:@"用户名：%@  姓名：%@",@"余小鱼",@"你为什么这么可爱啊"];
        [self renderButtons:str];
        
        // responseCallback 给后台的回复
        responseCallback(@"报告，o 'c已收到js的请求");
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
    //DLog(@"传过去ticket === %@" ,ticket);
    
    [_bridge callHandler:@"registerAction" data:[NSString stringWithFormat:@"%@,%@" ,islogin ,ticket] responseCallback:^(id responseData) {
        NSLog(@"oc请求js后接受的回调结果：%@",responseData);
    }];
    
}


- (void)renderButtons:(NSString *)str {
    NSLog(@"JS调用OC，取到参数为： %@",str);
    
}

- (void)disableSafetyTimeout {
    [self.bridge disableJavscriptAlertBoxSafetyTimeout];
}




-(void)webViewDidFinishLoad:(UIWebView *)webView{
      NSString *tit = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];//获取当前页面的title
   // DLog(@"标题 ==== == == = == = == ==== %@" ,tit);
    self.navItem.title = tit;
    
  NSString *jsStr =  [webView stringByEvaluatingJavaScriptFromString:@"immediatelychange()"];
    DLog(@"jsStr==============  %@" ,jsStr);
//    NSString *jsStr = [NSString stringWithFormat:@"login()"];
//    NSString *a=   [self.webView stringByEvaluatingJavaScriptFromString:jsStr];

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
        
    }else if ([requestString rangeOfString:@"add"].location != NSNotFound){
        NSUserDefaults *user = [NSUserDefaults standardUserDefaults];

        NSArray *array = [requestString componentsSeparatedByString:@"&"]; //从字符A中分隔成2个元素的数组
        if (array.count !=0) {
            
            if ([[user valueForKey:@"isLoginState"] isEqualToString:@"0"]) {
                [GlobalHelper shareInstance].merchantsIsLoginStated = @"2";
                [GlobalHelper shareInstance].isMerchantsIsLoginEnter = @"2";

            }
            
            
            NSString *isloginStatus = array[1];
            NSArray *isloginArray = [isloginStatus componentsSeparatedByString:@"="];
            isloginStatus = [isloginArray lastObject];
            
            NSString *iosticket = [array lastObject];
            NSArray *iosticketArray = [iosticket componentsSeparatedByString:@"="];
            iosticket = [iosticketArray lastObject];
          //  DLog(@"hahahha=== %@ %@" ,isloginStatus ,iosticket );
            [GlobalHelper shareInstance].isLoginState = isloginStatus;
            [user setValue:isloginStatus forKey:@"isLoginState"];
            [user setValue:iosticket forKey:@"ticket"];
            
            
        }
        [self.navigationController popViewControllerAnimated:YES];
       // DLog(@"中秋");
        return NO;

    }else if ([requestString rangeOfString:@"personal_zones_index.html"].location != NSNotFound){///东航大礼包
        
        NSArray *array = [requestString componentsSeparatedByString:@"ticket="]; //从字符A中分隔成2个元素的数组
        DLog(@"ticket= ====== %@" ,array);
        if (array.count !=0) {
           array = [[array lastObject] componentsSeparatedByString:@"&statuss="];
            NSString *ticket = [array firstObject];
            
            array = [[array lastObject] componentsSeparatedByString:@"&phonenum="];
            NSString *status = [array firstObject];
            
            array = [[array lastObject] componentsSeparatedByString:@"&ordernos="];
            NSString *phoneNum = [array firstObject];
            
            NSString *orderNo = [array lastObject];
            
            DLog(@"ticketsss= ====== %@ = %@ = %@  =%@" ,ticket ,status ,phoneNum ,orderNo);
            if (ticket.length != 0) {
                NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
//                NSString * currentphoneNum = [user valueForKey:@"phoneNum"];
//                if ([currentphoneNum isEqualToString:phoneNum]) {
                     [user setValue:ticket forKey:@"ticket"];
               // }
               
                [user setValue:@"1" forKey:@"isLoginState"];
                    [GlobalHelper shareInstance].isLoginState = [user valueForKey:@"isLoginState"];
            }
           
            if ([status isEqualToString:@"200"]){///领券成功
               
                MMPopupItemHandler block = ^(NSInteger index){
                    // NSLog(@"clickd %@ button",@(index));
                    if (index == 0) {///查看订单
                        OrderDetailesViewController *VC = [OrderDetailesViewController new];
                        VC.orderNo = orderNo;
                        VC.fromPayVC = @"1";
                        [self.navigationController pushViewController:VC animated:YES];
                        
                    }else{//逛逛商场

                        [self.navigationController popToRootViewControllerAnimated:YES];
                    }
                };
                NSArray *items = @[MMItemMake(@"查看订单", MMItemTypeNormal, block) , MMItemMake(@"逛逛商城", MMItemTypeNormal, block)];
                MMMyCustomView *alertView =  [[MMMyCustomView alloc] initWithTitle:@"礼盒兑换成功" detail:@"赛鲜正在为您安排发货" items:items];
                
                alertView.attachedView.mm_dimBackgroundBlurEnabled = NO;
                
                alertView.attachedView.mm_dimBackgroundBlurEffectStyle = UIBlurEffectStyleDark;
                
                [alertView show];
                
            }else if ([status isEqualToString:@"202"] ||[status isEqualToString:@"203"] ||[status isEqualToString:@"204"] ||[status isEqualToString:@"205"] ||[status isEqualToString:@"206"]){///兑换码有误或已失效，请重新输入!
              
                MMPopupItemHandler block = ^(NSInteger index){
                    // NSLog(@"clickd %@ button",@(index));
                    if (index == 0) {
                        NSString *str = [NSString stringWithFormat:@"tel:%@",@"4001106111"];
                        dispatch_async(dispatch_get_main_queue(), ^(){
                            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
                        });
                    }else{///逛逛商场
                       [self.navigationController popToRootViewControllerAnimated:YES];

                    }
                };
                NSArray *items = @[MMItemMake(@"联系客服", MMItemTypeNormal, block) , MMItemMake(@"逛逛商城", MMItemTypeNormal, block)];
                MMMyCustomView *alertView =  [[MMMyCustomView alloc] initWithTitle:@"" detail:@"兑换码有误或已失效，请重新输入!" items:items];
                
                alertView.attachedView.mm_dimBackgroundBlurEnabled = NO;
                
                alertView.attachedView.mm_dimBackgroundBlurEffectStyle = UIBlurEffectStyleDark;
                
                [alertView show];
                
            }else{///礼盒兑换失败，请稍后再试!
                MMPopupItemHandler block = ^(NSInteger index){
                    // NSLog(@"clickd %@ button",@(index));
                    if (index == 0) {
                        NSString *str = [NSString stringWithFormat:@"tel:%@",@"4001106111"];
                        dispatch_async(dispatch_get_main_queue(), ^(){
                            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
                        });
                    }else{///逛逛商城
                         [self.navigationController popToRootViewControllerAnimated:YES];

                    }
                };
                NSArray *items = @[MMItemMake(@"联系客服", MMItemTypeNormal, block) , MMItemMake(@"逛逛商城", MMItemTypeNormal, block)];
                MMMyCustomView *alertView =  [[MMMyCustomView alloc] initWithTitle:@"" detail:@"礼盒兑换失败，请稍后再试!" items:items];
                
                alertView.attachedView.mm_dimBackgroundBlurEnabled = NO;
                
                alertView.attachedView.mm_dimBackgroundBlurEffectStyle = UIBlurEffectStyleDark;
                
                [alertView show];
                
            }
        }
        return NO;

    }else if ([requestString rangeOfString:@"999"].location != NSNotFound){
        
        return  YES;
        
    }else {
        
        NSString *jsStr = [NSString stringWithFormat:@"immediatelychange()"];
        NSString *a=   [self.webView stringByEvaluatingJavaScriptFromString:jsStr];
        DLog(@"hhh========= %@  ==  %@" ,jsStr ,a);
        if ([a isEqualToString:@"1"]) {
        }
        
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

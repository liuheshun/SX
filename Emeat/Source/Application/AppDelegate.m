//
//  AppDelegate.m
//  Emeat
//
//  Created by liuheshun on 2017/11/3.
//  Copyright © 2017年 liuheshun. All rights reserved.
//

#import "AppDelegate.h"
#import "HomePageViewController.h"
#import "ShoppingCartViewController.h"
#import "MyViewController.h"
#import "IQKeyboardManager.h"
#import <AMapFoundationKit/AMapFoundationKit.h>
#import "RealReachability.h"
#import "WXApi.h"
#import "LaunchIntroductionView.h"

//高德地图key
static NSString * const amapServiceKey = @"e18a4fcdbab49ef870d1d5700a033163";

@interface AppDelegate ()<UITabBarControllerDelegate,WXApiDelegate>
@property (strong, nonatomic) UITabBarController *tabBars;

@end

@implementation AppDelegate




- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [NSThread sleepForTimeInterval:1.0];//设置启动页面时间
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    self.window.rootViewController = [self setTabBar];
    
  
    
    if (@available(iOS 11.0, *)) {
        UITableView.appearance.estimatedRowHeight = 0;
        UITableView.appearance.estimatedSectionFooterHeight = 0;
        UITableView.appearance.estimatedSectionHeaderHeight = 0;
    }
    //
    
    
    
    //开启网络监测
    [GLobalRealReachability startNotifier];
    //微信注册
    [WXApi registerApp:@"wxbd69c8d0e62710fa"];
    
    //配置高德地图
    [AMapServices sharedServices].apiKey = amapServiceKey;
    //键盘遮挡
    IQKeyboardManager * manager = [IQKeyboardManager sharedManager];
    manager.enable = YES;
    manager.shouldResignOnTouchOutside = YES;
    manager.shouldToolbarUsesTextFieldTintColor = YES;
    manager.enableAutoToolbar = YES;
    //配置引导页
    
 //   由于iPhone X高度发生变化,图片铺满整个屏幕时候造成图片拉伸,现在需要UI切一个1125*2436的3x图片和以前做iPhone X机型判断1124*2001图片,并且对图片contentMode属性进行设置
    NSArray *coverImageNames;
    CGFloat Y ;
    if (LL_iPhoneX) {
        coverImageNames = @[@"X0",@"X1",@"X2",@"X3"];
        Y = 505+145-10;
    }else{
        
        coverImageNames = @[@"launch0",@"launch1",@"launch2",@"launch3"];
        Y = 505*kScale;
    }
    DLog(@"kkkkkk------------=== %f" ,kScale);
    LaunchIntroductionView *launch = [LaunchIntroductionView sharedWithImages:coverImageNames buttonImage:@"login" buttonFrame:CGRectMake((kWidth-137*kScale)/2,Y, 137*kScale, 38*kScale)];
    launch.currentColor = RGB(137, 137, 137, 1);
    launch.nomalColor = RGB(221, 221, 221, 1);
//    imageView.clipsToBounds = YES;//超出区域裁剪
//
//    imageView.contentMode = UIViewContentModeScaleAspectFill;//图片等比例拉伸，会填充整个区域，但是会有一部分过大而超出整个区域
//
    
    return YES;
}


//9.0前的方法，为了适配低版本 保留
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url{
    return [WXApi handleOpenURL:url delegate:self];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation{
    if ([url.host isEqualToString:@"oauth"]) {//微信登陆
        
        [WXApi handleOpenURL:url delegate:self];
        
    }else if ([url.host isEqualToString:@"safepay"]) {//支付宝支付
        // 支付跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"result = %@",resultDic);
            [[NSNotificationCenter defaultCenter] postNotificationName:@"Alipay_Result" object:resultDic];

        }];
        
        // 授权跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processAuth_V2Result:url standbyCallback:^(NSDictionary *resultDic) {
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"Alipay_Result" object:resultDic];

            NSLog(@"result = %@",resultDic);
            // 解析 auth code
            NSString *result = resultDic[@"result"];
            NSString *authCode = nil;
            if (result.length>0) {
                NSArray *resultArr = [result componentsSeparatedByString:@"&"];
                for (NSString *subResult in resultArr) {
                    if (subResult.length > 10 && [subResult hasPrefix:@"auth_code="]) {
                        authCode = [subResult substringFromIndex:10];
                        break;
                    }
                }
            }
            NSLog(@"授权结果 authCode = %@", authCode?:@"");
        }];
    }else if ([url.host isEqualToString:@"pay"]){//微信支付
        
        [WXApi handleOpenURL:url delegate:self];
        
    }
    //银联支付处理支付结果
   else if([url.host isEqualToString:@"uppayresult"]){
        [[UPPaymentControl defaultControl] handlePaymentResult:url completeBlock:^(NSString *code, NSDictionary *data) {
            if([code isEqualToString:@"success"]) {
                
                //            //如果想对结果数据验签，可使用下面这段代码，但建议不验签，直接去商户后台查询交易结果
                //            if(data != nil){
                //                //数据从NSDictionary转换为NSString
                //                NSData *signData = [NSJSONSerialization dataWithJSONObject:data
                //                                                                   options:0
                //                                                                     error:nil];
                //                NSString *sign = [[NSString alloc] initWithData:signData encoding:NSUTF8StringEncoding];
                //
                //                //此处的verify建议送去商户后台做验签，如要放在手机端验，则代码必须支持更新证书
                //                if([self verify:sign]) {
                //                    //验签成功
                //                }
                //                else {
                //                    //验签失败
                //                }
                //            }
                //
                //            //结果code为成功时，去商户后台查询一下确保交易是成功的再展示成功
                [[NSNotificationCenter defaultCenter] postNotificationName:@"YINLIANPAYS" object:nil];
            }else if([code isEqualToString:@"fail"]) {
                //交易失败
                [[NSNotificationCenter defaultCenter] postNotificationName:@"YINLIANPAYF" object:nil];
            }else if([code isEqualToString:@"cancel"]) {
                //交易取消
                [[NSNotificationCenter defaultCenter] postNotificationName:@"YINLIANPAYC" object:nil];
            }
        }];
    }
   
    
    
    return YES;
}


// NOTE: 9.0以后使用新API接口

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString*, id> *)options{
    DLog(@"hhhhhhhh==== %@  == %@" ,url , options);
    if ([url.host isEqualToString:@"oauth"]) {//微信登陆
        
        [WXApi handleOpenURL:url delegate:self];

    }else if ([url.host isEqualToString:@"safepay"]) {
        // 支付跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"appppppdpppresult = %@",resultDic);
            
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"Alipay_Result" object:resultDic];

            
            NSString *resultStatus = resultDic[@"resultStatus"];
            //9000  订单支付成功 正常流程会进入这里 如果中断了就去外面delegate那里的Block
            if ([resultStatus isEqualToString:@"9000"])
            {
            }
            
        }];
        
        // 授权跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processAuth_V2Result:url standbyCallback:^(NSDictionary *resultDic) {
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"Alipay_Result" object:resultDic];

            //NSLog(@"支付宝钱包esult = %@",resultDic);
            
            // 解析 auth code
            NSString *result = resultDic[@"result"];
            NSString *authCode = nil;
            if (result.length>0) {
                NSArray *resultArr = [result componentsSeparatedByString:@"&"];
                for (NSString *subResult in resultArr) {
                    if (subResult.length > 10 && [subResult hasPrefix:@"auth_code="]) {
                        authCode = [subResult substringFromIndex:10];
                        break;
                    }
                }
            }
          //  NSLog(@"授权结果 authCode = %@", authCode?:@"");
        }];
        
    }else if ([url.host isEqualToString:@"pay"]){
        //微信支付
      [WXApi handleOpenURL:url delegate:self];
        
    }//银联支付处理支付结果
  else if([url.host isEqualToString:@"uppayresult"]){
        [[UPPaymentControl defaultControl] handlePaymentResult:url completeBlock:^(NSString *code, NSDictionary *data) {
            if([code isEqualToString:@"success"]) {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"YINLIANPAYS" object:nil];
            }else if([code isEqualToString:@"fail"]) {
                //交易失败
                [[NSNotificationCenter defaultCenter] postNotificationName:@"YINLIANPAYF" object:nil];
            }else if([code isEqualToString:@"cancel"]) {
                //交易取消
                [[NSNotificationCenter defaultCenter] postNotificationName:@"YINLIANPAYC" object:nil];
            }
        }];
    }
   
    
    return YES;

 
}


//微信SDK自带的方法，处理从微信客户端完成操作后返回程序之后的回调方法,显示支付结果的
-(void) onResp:(BaseResp*)resp
{
    if ([resp isKindOfClass:[PayResp class]]) {
        PayResp *response = (PayResp *)resp;
        DLog(@"resp=======%@" ,resp);

        DLog(@"response=======%@" ,response);
        DLog(@"response.errCode========%d" ,response.errCode);
        switch (response.errCode) {
            case WXSuccess:
                [[NSNotificationCenter defaultCenter] postNotificationName:@"WX_PAY_RESULT" object:@"成功"];
                break;
                
            default:
                [[NSNotificationCenter defaultCenter] postNotificationName:@"WX_PAY_RESULT" object:@"失败"];
                
                break;
                
        }
        
        
//
//        switch (response.errCode) {
//            case WXSuccess:
//                ////服务端查询
//                //服务器端查询支付通知或查询API返回的结果再提示成功
//               // NSLog(@"支付成功");
//                //通过通知告诉支付界面该做哪些操作
//                [[NSNotificationCenter defaultCenter] postNotificationName:@"WEIXINPAYS" object:nil];
//                break;
//            case WXErrCodeCommon:
//               // NSLog(@"支付失败");
//                [[NSNotificationCenter defaultCenter] postNotificationName:@"WEIXINPAYF" object:nil];
//                break;
//            case WXErrCodeUserCancel:
//               // NSLog(@"用户取消");
//                [[NSNotificationCenter defaultCenter] postNotificationName:@"WEIXINPAYC" object:nil];
//                break;
//            default:
//               // NSLog(@"支付结果：失败！retcode = %d, retstr = %@", resp.errCode,resp.errStr);
//                break;
//        }
    }else if ([resp isKindOfClass:[SendAuthResp class]]){//微信登陆
        
        [self getWeiXinCodeFinishedWithResp:resp];
        
    }else if ([resp isKindOfClass:[SendMessageToWXResp class]]){//微信分享
       // [WMLoginHelper shareInstance].isShare = @"1";
    }
}
- (void)getWeiXinCodeFinishedWithResp:(BaseResp *)resp
{
    if (resp.errCode == 0)
    {
        //statusCodeLabel.text = @"用户同意";
        SendAuthResp *aresp = (SendAuthResp *)resp;
        
        [self getAccessTokenWithCode:aresp.code];
        
    }else if (resp.errCode == -4){
        //"用户拒绝";
    }else if (resp.errCode == -2){
        //"用户取消";
    }
}

#pragma mark======================通过code获取accessToken===============
- (void)getAccessTokenWithCode:(NSString *)code{
    
    NSString *urlString =[NSString stringWithFormat:@"https://api.weixin.qq.com/sns/oauth2/access_token?appid=%@&secret=%@&code=%@&grant_type=authorization_code",KWeixinAPP_ID,KWeixinAPP_SECRET,code];
    NSURL *url = [NSURL URLWithString:urlString];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSString *dataStr = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:nil];
        NSData *data = [dataStr dataUsingEncoding:NSUTF8StringEncoding];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if (data){
                NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                
                if ([dict objectForKey:@"errcode"]){
                    //获取token错误
                }else{
                    //存储AccessToken OpenId RefreshToken以便下次直接登陆
                    //AccessToken有效期两小时，RefreshToken有效期三十天
                    
                    [[NSUserDefaults standardUserDefaults] setObject:dict[@"access_token"] forKey:@"access_token"];
                    [[NSUserDefaults standardUserDefaults] setObject:dict[@"openid"] forKey:@"openid"];
                    [[NSUserDefaults standardUserDefaults] setObject:dict[@"refresh_token"] forKey:@"refresh_token"];
                    
                    [self getUserInfoWithAccessToken:[dict objectForKey:@"access_token"] andOpenId:[dict objectForKey:@"openid"]];
                    
                    
                }
                
            }
            
        });
        
        
    });
    
    /*
     30      正确返回
     31      "access_token" = “Oez*****8Q";
     32      "expires_in" = 7200;
     33      openid = ooVLKjppt7****p5cI;
     34      "refresh_token" = “Oez*****smAM-g";
     35      scope = "snsapi_userinfo";
     36      */
    /*
     39      错误返回
     40      errcode = 40029;
     41      errmsg = "invalid code";
     42      */
}

#pragma mark ===============微信登陆获取用户信息 传给服务端======================

- (void)getUserInfoWithAccessToken:(NSString *)accessToken andOpenId:(NSString *)openId
{
    
    NSString *urlString =[NSString stringWithFormat:@"https://api.weixin.qq.com/sns/userinfo?access_token=%@&openid=%@",accessToken,openId];
    NSURL *url = [NSURL URLWithString:urlString];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSString *dataStr = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:nil];
        NSData *data = [dataStr dataUsingEncoding:NSUTF8StringEncoding];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if (data){
                NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                if ([dic objectForKey:@"errcode"]){
                    
                    //AccessToken失效,重新获取accessToken
                    [self getAccessTokenWithRefreshToken:[[NSUserDefaults standardUserDefaults]objectForKey:@"refresh_token"]];
                    
                    
                }else{
                    DLog(@"微信登陆成功=====");
//                    [SVProgressHUD show];
//                    //获取需要的数据用户信息发给服务器
//                    //  LRLog(@"微信名字==%@",[dic objectForKey:@"nickname"]);
//                    NSString*url = [NSString stringWithFormat:@"%@/mobile/appWeixinRegiest.action?nickName=%@&openid=%@&unionid=%@&logo=%@&appType=1&appToken=%@",baseUrl,[dic objectForKey:@"nickname"], [[NSUserDefaults standardUserDefaults] objectForKey:@"openid"],[dic objectForKey:@"unionid"],[dic objectForKey:@"headimgurl"],[WMLoginHelper shareInstance].deviceToken];
//
//                    NSString *endUrl = [url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
//
//
//                    [MHNetworkManager postReqeustWithURL:endUrl params:nil successBlock:^(NSDictionary *returnData) {
//
//                        LRLog(@"微信登陆=======  %@",returnData);
//                        if ([returnData[@"status"] isEqualToString:@"success"]) {
//                            //  LRLog(@"微信用户信息===== %@",returnData);
//                            NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
//                            //存储用户信息
//                            [user setObject:returnData[@"user"][@"id"] forKey:@"userId"];
//
//
//                            [user setObject:returnData[@"user"][@"name"] forKey:@"attendName"];
//
//                            [user setObject:returnData[@"user"][@"phoneNumber"] forKey:@"mobile"];
//
//                            [user setObject:returnData[@"user"][@"companyName"] forKey:@"unit"];
//
//                            [user setObject:returnData[@"user"][@"job"] forKey:@"job"];
//
//                            [user setObject:returnData[@"user"][@"emailAddress"] forKey:@"email"];
//
//                            [user setObject:returnData[@"user"][@"logo"] forKey:@"image"];
//
//                            [user setObject:returnData[@"user"][@"city"] forKey:@"city"];
//
//                            [user setObject:returnData[@"user"][@"mobileStatus"] forKey:@"mobileStatus"];
//                            [user setObject:returnData[@"user"][@"openid"] forKey:@"openid"];
//
//                            if ([WMLoginHelper shareInstance].wechatAuthorize == YES
//                                ) {
//                                [WMLoginHelper shareInstance].wechatAuthorize = NO;
//                                UINavigationController *nav= [[UINavigationController alloc] initWithRootViewController:[MyEarningViewController new]];
//                                [nav popViewControllerAnimated:YES];
//                                [SVProgressHUD dismiss];
//
//                                return ;
//                            }else{
//                                [SVProgressHUD dismiss];
//
//                            }
//
//                            if ([returnData[@"user"][@"mobileStatus"] integerValue]== 1) {
//                                //NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
//
//                                [user setObject:@"0" forKey:@"login_type"];////状态0微信登陆
//
//                                [self login];//登陆
//                                [SVProgressHUD dismiss];
//
//                            }else if ([returnData[@"user"][@"mobileStatus"] integerValue]== 0){
//
//                                [SVProgressHUD dismiss];
//                                [self validate];//验证手机号
//                            }
//
//                        }
//                    } failureBlock:^(NSError *error) {
//                        // LRLog(@"微信登陆失败方法");
//                        [SVProgressHUD dismiss];
//                        [SVProgressHUD showErrorWithStatus:@"操作失败,请稍后重试"];
//
//                    } showHUD:NO];
//
//
//                    //
//                    //                             [[NSUserDefaults standardUserDefaults] setObject:[dic objectForKey:@"nickname"] forKey:@"weixin_attendName"];
//                    //                            [[NSUserDefaults standardUserDefaults] setObject:[dic objectForKey:@"headimgurl"] forKey:@"weixin_image"];
//                    //
//
//
//                    [[NSNotificationCenter defaultCenter] postNotificationName:@"Note" object:nil]; // 发送通知
//
                }
                
            }
            
            
        });
        
        
    });
    
    /*
     29      city = ****;
     30      country = CN;
     31      headimgurl = "http://wx.qlogo.cn/mmopen/q9UTH59ty0K1PRvIQkyydYMia4xN3gib2m2FGh0tiaMZrPS9t4yPJFKedOt5gDFUvM6GusdNGWOJVEqGcSsZjdQGKYm9gr60hibd/0";
     32      language = "zh_CN";
     33      nickname = “****";
     34      openid = oo*********;
     35      privilege =     (
     36      );
     37      province = *****;
     38      sex = 1;
     39      unionid = “o7VbZjg***JrExs";
     40      */
    
    /*
     43      错误代码
     44      errcode = 42001;
     45      errmsg = "access_token expired";
     46      */
}
- (void)getAccessTokenWithRefreshToken:(NSString *)refreshToken
{
    NSString *urlString =[NSString stringWithFormat:@"https://api.weixin.qq.com/sns/oauth2/refresh_token?appid=%@&grant_type=refresh_token&refresh_token=%@",KWeixinAPP_ID,refreshToken];
    NSURL *url = [NSURL URLWithString:urlString];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        
        NSString *dataStr = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:nil];
        NSData *data = [dataStr dataUsingEncoding:NSUTF8StringEncoding];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if (data)
            {
                NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                
                if ([dict objectForKey:@"errcode"])
                {
                    //授权过期
                }else{
                    
                    //重新使用AccessToken获取信息
                    
                    [[NSUserDefaults standardUserDefaults] setObject:dict[@"access_token"] forKey:@"access_token"];
                    [[NSUserDefaults standardUserDefaults] setObject:dict[@"openid"] forKey:@"openid"];
                    [[NSUserDefaults standardUserDefaults] setObject:dict[@"refresh_token"] forKey:@"refresh_token"];
                    
                    
                }
            }
        });
    });
    
    
    /*
     30      "access_token" = “Oez****5tXA";
     31      "expires_in" = 7200;
     32      openid = ooV****p5cI;
     33      "refresh_token" = “Oez****QNFLcA";
     34      scope = "snsapi_userinfo,";
     35      */
    /*
     38      错误代码
     39      "errcode":40030,
     40      "errmsg":"invalid refresh_token"
     41      */
}



- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    
    //保证注册时 倒计时计时器能够后台运行
    UIApplication*   app = [UIApplication sharedApplication];
    
    __block  UIBackgroundTaskIdentifier bgTask;
    
    bgTask = [app beginBackgroundTaskWithExpirationHandler:^{
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if (bgTask != UIBackgroundTaskInvalid)
                
            {
                
                bgTask = UIBackgroundTaskInvalid;
                
            }
            
        });
        
    }];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if (bgTask != UIBackgroundTaskInvalid)
                
            {
                
                bgTask = UIBackgroundTaskInvalid;
                
            }
            
        });
        
    });
    
    
    
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    [[NSNotificationCenter defaultCenter] postNotificationName:@"versionUpdate" object:nil];

}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


#pragma mark = 创建tabBar控制器

-(UITabBarController*)setTabBar{
    
    HomePageViewController *homePageVC = [[HomePageViewController alloc] init];
    UINavigationController *navHomePageVC = [[UINavigationController alloc] initWithRootViewController:homePageVC];
    homePageVC.tabBarItem.title = @"首页";
    homePageVC.tabBarItem.image = [[UIImage imageNamed:@"首页_normal"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] ;
    homePageVC.tabBarItem.selectedImage = [[UIImage imageNamed:@"首页_sel"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];

    
    
    ShoppingCartViewController *cartVC = [[ShoppingCartViewController alloc ] init];
    UINavigationController *navCartVC = [[UINavigationController alloc] initWithRootViewController:cartVC];
    cartVC.tabBarItem.title = @"购物车";
    cartVC.tabBarItem.image = [[UIImage imageNamed:@"购物车_normal"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    cartVC.tabBarItem.selectedImage = [[UIImage imageNamed:@"购物车_sel"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    MyViewController *myVC = [[MyViewController alloc] init];
    UINavigationController *navMyVC = [[UINavigationController alloc] initWithRootViewController:myVC];
    navMyVC.tabBarItem.title = @"我的";
    navMyVC.tabBarItem.image = [[UIImage imageNamed:@"我_normal"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    navMyVC.tabBarItem.selectedImage = [[UIImage imageNamed:@"我_sel"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    self.tabBars = [[UITabBarController alloc] init];
    self.tabBars.delegate = self;
    self.tabBars.viewControllers = @[navHomePageVC  , navCartVC , navMyVC];

    
    
    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:RGB(236, 31, 35, 1), NSForegroundColorAttributeName, nil] forState:UIControlStateSelected];
    return  self.tabBars;

    
}


-(BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController{
    
    
    //这里我判断的是当前点击的tabBarItem的标题
    if ([viewController.tabBarItem.title isEqualToString:@"购物车"]) {
        //如果用户ID存在的话，说明已登陆
        NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
        
        
        if ([[user valueForKey:@"isLoginState"] isEqualToString:@"1"])
        {
            return YES;
            
            
            
        }
        else
        {
            //跳到登录页面
            LoginViewController *login = [[LoginViewController alloc] init];
            //隐藏tabbar
            login.hidesBottomBarWhenPushed = YES;
            login.fromShoppingType = @"200";
            [((UINavigationController *)tabBarController.selectedViewController) pushViewController:login animated:YES];
            
            
            return NO;
        }
    }
    else
        return YES;
    
}





@end

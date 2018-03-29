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

//高德地图key
static NSString * const amapServiceKey = @"e18a4fcdbab49ef870d1d5700a033163";

@interface AppDelegate ()<UITabBarControllerDelegate>
@property (strong, nonatomic) UITabBarController *tabBars;

@end

@implementation AppDelegate




- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    self.window.rootViewController = [self setTabBar];
    
    //配置高德地图
    [AMapServices sharedServices].apiKey = amapServiceKey;
    //键盘遮挡
    IQKeyboardManager * manager = [IQKeyboardManager sharedManager];
    manager.enable = YES;
    manager.shouldResignOnTouchOutside = YES;
    manager.shouldToolbarUsesTextFieldTintColor = YES;
    manager.enableAutoToolbar = YES;
    
    if (@available(iOS 11.0, *)) {
        UITableView.appearance.estimatedRowHeight = 0;
        UITableView.appearance.estimatedSectionFooterHeight = 0;
        UITableView.appearance.estimatedSectionHeaderHeight = 0;
    }
    
    ///开启网络监测
    [GLobalRealReachability startNotifier];
    //微信注册//
    [WXApi registerApp:@"wx3202ad817c81cb99"];
    return YES;
}


//9.0前的方法，为了适配低版本 保留
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url{
    return [WXApi handleOpenURL:url delegate:self];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation{
    
    if ([url.host isEqualToString:@"safepay"]) {//支付宝支付
        // 支付跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"result = %@",resultDic);
        }];
        
        // 授权跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processAuth_V2Result:url standbyCallback:^(NSDictionary *resultDic) {
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
    
    if ([url.host isEqualToString:@"safepay"]) {
        // 支付跳转支付宝钱包进行支付，处理支付结果
        // 支付跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"result = %@",resultDic);
        }];
        
        // 授权跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processAuth_V2Result:url standbyCallback:^(NSDictionary *resultDic) {
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
        
    }else if ([url.host isEqualToString:@"pay"]){
        
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
        switch (response.errCode) {
            case WXSuccess:
                //服务器端查询支付通知或查询API返回的结果再提示成功
                NSLog(@"支付成功");
                //通过通知告诉支付界面该做哪些操作
                [[NSNotificationCenter defaultCenter] postNotificationName:@"WEIXINPAYS" object:nil];
                break;
            case WXErrCodeCommon:
                NSLog(@"支付失败");
                [[NSNotificationCenter defaultCenter] postNotificationName:@"WEIXINPAYF" object:nil];
                break;
            case WXErrCodeUserCancel:
                NSLog(@"用户取消");
                [[NSNotificationCenter defaultCenter] postNotificationName:@"WEIXINPAYC" object:nil];
                break;
            default:
                NSLog(@"支付结果：失败！retcode = %d, retstr = %@", resp.errCode,resp.errStr);
                break;
        }
    }
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

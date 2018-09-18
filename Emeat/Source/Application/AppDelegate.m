//
//  AppDelegate.m
//  Emeat
//
//  Created by liuheshun on 2017/11/3.
//  Copyright © 2017年 liuheshun. All rights reserved.
//

#import "AppDelegate.h"
#import "HomePageViewController.h"
#import "PersonalPageViewController.h"

#import "HomePageDetailsViewController.h"
#import "HomePageOtherDetailsViewController.h"
#import "PhoneNumberCertificationViewController.h"
#import "ShopCertificationViewController.h"
#import "ShoppingCartViewController.h"
#import "MyViewController.h"
#import "IQKeyboardManager.h"
#import <AMapFoundationKit/AMapFoundationKit.h>
#import "RealReachability.h"
#import "WXApi.h"
#import "LaunchIntroductionView.h"
#import <AudioToolbox/AudioToolbox.h>
#import <CommonCrypto/CommonDigest.h>

////
#import "MerchantViewController.h"


//高德地图key
static NSString * const amapServiceKey = @"e18a4fcdbab49ef870d1d5700a033163";

@interface AppDelegate ()<UITabBarControllerDelegate,WXApiDelegate>
@property (strong, nonatomic) UITabBarController *tabBars;
// 用来判断是否是通过点击通知栏开启（唤醒）APP
@property (nonatomic) BOOL isLaunchedByNotification;

@property (nonatomic) BOOL offLine;

@property (nonatomic,strong) NSMutableDictionary *payloadMsgDic;


@end

@implementation AppDelegate




- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
   
    
    
#ifdef DEBUG
    //do sth.

    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    if ([user valueForKey:@"server"]) {
        
    }else{
        [user setValue:@"http://beta.cyberfresh.cn" forKey:@"server"];
    }
    
#else
    //do sth.

#endif

    
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
    //个推
    // 通过个推平台分配的appId、 appKey 、appSecret 启动SDK，注：该方法需要在主线程中调用
    [GeTuiSdk startSdkWithAppId:kGtAppId appKey:kGtAppKey appSecret:kGtAppSecret delegate:self];
    // 注册 APNs
    [self registerRemoteNotification];
//是否允许SDK 后台运行（这个一定要设置，否则后台apns不会执行）
    [GeTuiSdk runBackgroundEnable:true];
   
    //程序处于未启动状态时推送
    if (launchOptions) {
        NSDictionary *userInfo = [launchOptions       objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
        if (userInfo) {
           // DLog(@"-------%@" ,[NSString stringWithFormat:@"%@" ,userInfo]);
            self.isLaunchedByNotification = YES;
            
        }
    }
  
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
    //由于iPhone X高度发生变化,图片铺满整个屏幕时候造成图片拉伸,现在需要UI切一个1125*2436的3x图片和以前做iPhone X机型判断1124*2001图片,并且对图片contentMode属性进行设置
    NSArray *coverImageNames;
    CGFloat Y ;
    if (LL_iPhoneX) {
        coverImageNames = @[@"X0",@"X1",@"X2",@"X3"];
        Y = (505+145-10)*kScale;
    }else{
        
        coverImageNames = @[@"launch0",@"launch1",@"launch2",@"launch3"];
        Y = 505*kScale;
    }
    LaunchIntroductionView *launch = [LaunchIntroductionView sharedWithImages:coverImageNames buttonImage:@"login" buttonFrame:CGRectMake((kWidth-137*kScale)/2,Y, 137*kScale, 38*kScale)];
    launch.currentColor = RGB(137, 137, 137, 1);
    launch.nomalColor = RGB(221, 221, 221, 1);
//    imageView.clipsToBounds = YES;//超出区域裁剪
//    imageView.contentMode = UIViewContentModeScaleAspectFill;//图片等比例拉伸，会填充整个区域，但是会有一部分过大而超出整个区域
//
    
    return YES;
}



/** 注册 APNs */
- (void)registerRemoteNotification {
    /*
     警告：Xcode8 需要手动开启"TARGETS -> Capabilities -> Push Notifications"
     */
    
    /*
     警告：该方法需要开发者自定义，以下代码根据 APP 支持的 iOS 系统不同，代码可以对应修改。
     以下为演示代码，注意根据实际需要修改，注意测试支持的 iOS 系统都能获取到 DeviceToken
     */
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 10.0) {
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0 // Xcode 8编译会调用
        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
        center.delegate = self;
        [center requestAuthorizationWithOptions:(UNAuthorizationOptionBadge | UNAuthorizationOptionSound | UNAuthorizationOptionAlert | UNAuthorizationOptionCarPlay) completionHandler:^(BOOL granted, NSError *_Nullable error) {
            if (!error) {
                //NSLog(@"request authorization succeeded!");
            }
        }];
        
        [[UIApplication sharedApplication] registerForRemoteNotifications];
#else // Xcode 7编译会调用
        UIUserNotificationType types = (UIUserNotificationTypeAlert | UIUserNotificationTypeSound | UIUserNotificationTypeBadge);
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:types categories:nil];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
#endif
    } else if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
        UIUserNotificationType types = (UIUserNotificationTypeAlert | UIUserNotificationTypeSound | UIUserNotificationTypeBadge);
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:types categories:nil];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
    } else {
        UIRemoteNotificationType apn_type = (UIRemoteNotificationType)(UIRemoteNotificationTypeAlert |
                                                                       UIRemoteNotificationTypeSound |
                                                                       UIRemoteNotificationTypeBadge);
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:apn_type];
    }
}


#pragma mark - 远程通知(推送)回调

/** 远程通知注册成功委托 *///向个推服务器注册DeviceToken
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    NSString *token = [[deviceToken description] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
    token = [token stringByReplacingOccurrencesOfString:@" " withString:@""];
   // DLog(@"\n>>>[DeviceToken Success]:%@\n\n", token);
    
    // 向个推服务器注册deviceToken
    [GeTuiSdk registerDeviceToken:token];
}
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    //NSLog(@"---个推注册失败---");
    
    //注册失败通知个推服务器
    [GeTuiSdk registerDeviceToken:@""];
    
}

#pragma mark - APP运行中接收到通知(推送)处理 - iOS 10以下版本收到推送

/** APP已经接收到“远程”通知(推送) - (App运行在后台/App运行在前台)  */
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    
    //此时 App 在后台点击通知栏进去前台 这里可做进入前台操作
    //app 进去前台 icon角标显示数为0 并且发送个推服务器
    //[[UIApplication sharedApplication] cancelAllLocalNotifications];
//    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    [GeTuiSdk setBadge:0];
    
    // [ GTSdk ]：将收到的APNs信息传给个推统计
    [GeTuiSdk handleRemoteNotification:userInfo];
    // [4-EXT]:处理APN
    NSString *record = [NSString stringWithFormat:@"App运行在后台/App运行在前台[APN]%@, %@", [NSDate date], userInfo];
    //NSLog(@"%@", record);
    
    if (self.offLine == NO) {///收到消息时候 APP在前台
       // DLog(@"收到消息时候 APP在前台");
        [self pushMessage:self.payloadMsgDic];
        
        
    }else{///后台
        
        [self pushMessage:self.payloadMsgDic];
        
    }
   
    
    completionHandler(UIBackgroundFetchResultNewData);
    self.isLaunchedByNotification = YES;
}

#pragma mark - iOS 10中收到推送消息()

#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0
//  iOS 10: App在前台获取到通知
- (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler  API_AVAILABLE(ios(10.0)){
    
//NSLog(@"willPresentNotification：%@", notification.request.content.userInfo);
    
    // 根据APP需要，判断是否要提示用户Badge、Sound、Alert
    completionHandler(UNNotificationPresentationOptionBadge | UNNotificationPresentationOptionSound | UNNotificationPresentationOptionAlert);
}

//  iOS 10之后: 点击通知进入App时触发
- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)(void))completionHandler  API_AVAILABLE(ios(10.0)){
    
   
    if (self.offLine == NO) {///收到消息时候 APP在前台
//        [self pushMessage:self.payloadMsgDic];

 
    }else{///后台
        
        [self pushMessage:self.payloadMsgDic];
        
    }
    self.isLaunchedByNotification = YES;
    
    //设置角标为0 相当于复位
    [GeTuiSdk setBadge:0];
   // [[UIApplication sharedApplication]setApplicationIconBadgeNumber:0];//进入前台取消应用消息图标搜索
   // [[UIApplication sharedApplication] cancelAllLocalNotifications];
    

    
    // [ GTSdk ]：将收到的APNs信息传给个推统计
    [GeTuiSdk handleRemoteNotification:response.notification.request.content.userInfo];
    
    completionHandler();
}
#endif





-(void)pushMessage:(NSDictionary*)dic{
    if ([dic[@"messageTypes"] isEqualToString:@"0"]) {//商品
        
        HomePageDetailsViewController *OtherVC = [HomePageDetailsViewController new];
        OtherVC.hidesBottomBarWhenPushed = YES;
        
        OtherVC.detailsId = self.payloadMsgDic[@"detailsId"];
        
        
        //获得当前控制器
        UITabBarController *tabBarController = ( UITabBarController*)self.window.rootViewController;
        UINavigationController * nav = (UINavigationController *)tabBarController.selectedViewController;
        UIViewController *currentVC = nav.visibleViewController;
        NSString *currentVCString = NSStringFromClass([currentVC class]);
        NSString *OtherVCString = NSStringFromClass([OtherVC class]);
       // DLog(@"-----控制器名字---------%@ %@" ,currentVCString ,OtherVCString );
        
        if ([currentVCString isEqualToString:OtherVCString]) {
            ///通知刷新页面
            [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshHomePageDetailsControllerWithNotification" object:nil userInfo:[NSMutableDictionary dictionaryWithObjectsAndKeys:self.payloadMsgDic[@"detailsId"],@"detailsId", nil]];
        }else{
            if (currentVC.presentedViewController) {
                currentVC = currentVC.presentedViewController;
            }
            [currentVC.navigationController pushViewController:OtherVC animated:YES];
            
        }
        
    }else if ([dic[@"messageTypes"] isEqualToString:@"1"]){//活动海报
        
        HomePageOtherDetailsViewController *OtherVC = [HomePageOtherDetailsViewController new];
        OtherVC.hidesBottomBarWhenPushed = YES;
        OtherVC.detailsURL = self.payloadMsgDic[@"actUrl"];
       
        //获得当前控制器
        UITabBarController *tabBarController = ( UITabBarController*)self.window.rootViewController;
        UINavigationController * nav = (UINavigationController *)tabBarController.selectedViewController;
        UIViewController *currentVC = nav.visibleViewController;
        NSString *currentVCString = NSStringFromClass([currentVC class]);
        NSString *OtherVCString = NSStringFromClass([OtherVC class]);
        //DLog(@"-----控制器名字---------%@ %@" ,currentVCString ,OtherVCString );

        if ([currentVCString isEqualToString:OtherVCString]) {
            ///通知刷新页面
            [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshControllerWithNotification" object:nil userInfo:[NSMutableDictionary dictionaryWithObjectsAndKeys:self.payloadMsgDic[@"actUrl"],@"detailsURL", nil]];
        }else{
            if (currentVC.presentedViewController) {
                currentVC = currentVC.presentedViewController;
            }
            [currentVC.navigationController pushViewController:OtherVC animated:YES];
        
        }
    }
    
    
}



/** SDK启动成功返回cid */
- (void)GeTuiSdkDidRegisterClient:(NSString *)clientId {
    //个推SDK已注册，返回clientId
   // DLog(@"\n>>>[GeTuiSdk RegisterClient]:%@\n\n", clientId);
}


/** SDK遇到错误回调 */
- (void)GeTuiSdkDidOccurError:(NSError *)error
{
    // [EXT]:个推错误报告，集成步骤发生的任何错误都在这里通知，如果集成后，无法正常收到消息，查看这里的通知。
   // NSLog(@"\n>>[GTSdk error]:%@\n\n", [error localizedDescription]);
}

/** SDK收到透传消息回调 */
- (void)GeTuiSdkDidReceivePayloadData:(NSData *)payloadData andTaskId:(NSString *)taskId andMsgId:(NSString *)msgId andOffLine:(BOOL)offLine fromGtAppId:(NSString *)appId
{
    // 汇报个推自定义事件
    [GeTuiSdk sendFeedbackMessage:90001 andTaskId:taskId andMsgId:msgId];
    
    // [4]: 收到个推消息
    //这里收到透传消息,根据自己服务器返回的格式处理
    NSDictionary * jsonDict = [NSJSONSerialization JSONObjectWithData:payloadData options:NSJSONReadingMutableLeaves error:nil];
    self.payloadMsgDic = [NSMutableDictionary dictionaryWithDictionary:jsonDict];
    //DLog(@"payloadMsgDic========%@" ,self.payloadMsgDic);
    // 当app不在前台时，接收到的推送消息offLine值均为YES
    // 判断app是否是点击通知栏消息进行唤醒或开启
    // 如果是点击icon图标使得app进入前台，则不做操作，并且同一条推送通知，此方法只执行一次
    self.offLine = offLine;
    if (offLine) {
        // 离线消息，说明app接收推送时不在前台
       // [SVProgressHUD showWithStatus:[NSString stringWithFormat:@"%@" ,self.payloadMsgDic]];
        
        if (self.isLaunchedByNotification == YES) {
            self.isLaunchedByNotification = NO;
            // app是通过点击通知栏进入前台
//            [SVProgressHUD showSuccessWithStatus:@"app是通过点击通知栏进入前台"];
            [self pushMessage:jsonDict];

        } else {
            
            // app是通过点击icon进入前台，在这里不做操作
//            [SVProgressHUD showSuccessWithStatus:@"appicon,不chao'zuo"];

        }
        
        
    } else  {

        // 使用 UNUserNotificationCenter 来管理通知
        if (@available(iOS 10.0, *)) {
            UNUserNotificationCenter* center = [UNUserNotificationCenter currentNotificationCenter];
            //需创建一个包含待通知内容的 UNMutableNotificationContent 对象，注意不是 UNNotificationContent ,此对象为不可变对象。
            UNMutableNotificationContent* content = [[UNMutableNotificationContent alloc] init];
            content.title = [NSString localizedUserNotificationStringForKey:jsonDict[@"title"] arguments:nil];
            content.body = [NSString localizedUserNotificationStringForKey:jsonDict[@"body"]
                                                                 arguments:nil];
            content.sound = [UNNotificationSound defaultSound];
            
            
            
            UNNotificationRequest* request = [UNNotificationRequest requestWithIdentifier:@"FiveSecond"
                                                                                  content:content trigger:nil];
            
            //添加推送成功后的处理！
            [center addNotificationRequest:request withCompletionHandler:^(NSError * _Nullable error) {
            }];
        } else {
            // Fallback on earlier versions
            UILocalNotification *notification = [[UILocalNotification alloc] init];
            // 通知内容
            notification.alertBody =  jsonDict[@"body"];
            notification.alertTitle = jsonDict[@"title"];
            notification.applicationIconBadgeNumber = 1;
            // 通知被触发时播放的声音
            notification.soundName = UILocalNotificationDefaultSoundName;
            // 通知参数
            NSDictionary *userDict = [NSDictionary dictionaryWithObject:@"1" forKey:@"types"];
            notification.userInfo = userDict;
            
            // ios8后，需要添加这个注册，才能得到授权
            if ([[UIApplication sharedApplication] respondsToSelector:@selector(registerUserNotificationSettings:)]) {
                UIUserNotificationType type =  UIUserNotificationTypeAlert | UIUserNotificationTypeBadge | UIUserNotificationTypeSound;
                UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:type
                                                                                         categories:nil];
                [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
                // 通知重复提示的单位，可以是天、周、月
//                notification.repeatInterval = NSCalendarUnitDay;
            } else {
                // 通知重复提示的单位，可以是天、周、月
//                notification.repeatInterval = NSDayCalendarUnit;
            }
            
            // 执行通知注册
            [[UIApplication sharedApplication] scheduleLocalNotification:notification];
          
        }
 
        
    }
    // 控制台打印日志
    NSString *msg = [NSString stringWithFormat:@"SDK收到透传消息回调taskId====%@,messageId=======:%@,payloadMsg=======:%@ =======%@", taskId, msgId, jsonDict, offLine ? @"<离线消息>" : @""];
   // NSLog(@"\n>>[GTSdk ReceivePayload]:%@\n\n", msg);
#pragma mark--- 接收到推送后，进行提示或怎样
    
}



/** SDK收到sendMessage消息回调 */
- (void)GeTuiSdkDidSendMessage:(NSString *)messageId result:(int)result
{
    // 发送上行消息结果反馈
    NSString *msg = [NSString stringWithFormat:@"sendmessage=%@,result=%d", messageId, result];
    //NSLog(@"\n>>[GTSdk DidSendMessage]:SDK收到sendMessage消息回调--------------%@\n\n", msg);
}


/** SDK运行状态通知 */
- (void)GeTuiSDkDidNotifySdkState:(SdkStatus)aStatus
{
    // 通知SDK运行状态
   //NSLog(@"通知SDK运行状态======:%u\n\n", aStatus);
}


////#pragma mark ---application
//- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings {
//    NSLog(@"推送的内容：%@",notificationSettings);
//
//    [application registerForRemoteNotifications];
//}















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
            //NSLog(@"result = %@",resultDic);
            [[NSNotificationCenter defaultCenter] postNotificationName:@"Alipay_Result" object:resultDic];

        }];
        
        // 授权跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processAuth_V2Result:url standbyCallback:^(NSDictionary *resultDic) {
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"Alipay_Result" object:resultDic];

          //  NSLog(@"result = %@",resultDic);
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
           // NSLog(@"授权结果 authCode = %@", authCode?:@"");
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
    //DLog(@"hhhhhhhh==== %@  == %@" ,url , options);
    if ([url.host isEqualToString:@"oauth"]) {//微信登陆
        
        [WXApi handleOpenURL:url delegate:self];

    }else if ([url.host isEqualToString:@"safepay"]) {
        // 支付跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
           // NSLog(@"appppppdpppresult = %@",resultDic);
            
            
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
//        DLog(@"resp=======%@" ,resp);
//
//        DLog(@"response=======%@" ,response);
//        DLog(@"response.errCode========%d" ,response.errCode);
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
                NSDictionary *dicData = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                if ([dicData objectForKey:@"errcode"]){
                    
                    //AccessToken失效,重新获取accessToken
                    [self getAccessTokenWithRefreshToken:[[NSUserDefaults standardUserDefaults]objectForKey:@"refresh_token"]];
                    
                    
                }else{
                   // DLog(@"微信登陆成功=====%@" ,dicData);
                    [self requestTicketReturnWeChatReturnDic:[NSMutableDictionary dictionaryWithDictionary:dicData]];
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


-(void)requestTicketReturnWeChatReturnDic:(NSMutableDictionary *)WeChatReturnDic{
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *secret = @"UHnyKzP5sNmh2EV0Dflgl4VfzbaWc4crQ7JElfw1cuNCbcJUau";
    NSString *nonce = [self ret32bitString];//随机数
    NSString *curTime = [self dateTransformToTimeSp];
    NSString *checkSum = [self sha1:[NSString stringWithFormat:@"%@%@%@" ,secret ,  nonce ,curTime]];
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:secret forKey:@"secret"];
    [dic setObject:nonce forKey:@"nonce"];
    [dic setObject:curTime forKey:@"curTime"];
    [dic setObject:checkSum forKey:@"checkSum"];
    [dic setValue:mTypeIOS forKey:@"mtype"];
    [dic setValue:[user valueForKey:@"appVersionNumber"] forKey:@"appVersionNumber"];
    [dic setValue:[user valueForKey:@"user"] forKey:@"user"];
    //DLog(@"获取ticket== %@" ,dic);
    
    [MHNetworkManager postReqeustWithURL:[NSString stringWithFormat:@"%@/cas/mobile/getticket.html" ,baseUrl] params:dic successBlock:^(NSDictionary *returnData) {
        //DLog(@"ticker=== %@" ,returnData);
        if ([returnData[@"code"] isEqualToString:@"00"]) {
            NSString *ticket = returnData[@"ticket"];
            ///保存ticket
            NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
            [user setObject:ticket forKey:@"ticket"];

            [self rquestWechatUserInfoDataWithTicket:ticket WeChatReturnDic:WeChatReturnDic];
        }
        
    } failureBlock:^(NSError *error) {
        
    } showHUD:NO];
    
}

-(void)rquestWechatUserInfoDataWithTicket:(NSString*)ticket WeChatReturnDic:(NSMutableDictionary*)dicData{
    [SVProgressHUD show];

    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    NSString *secret = @"UHnyKzP5sNmh2EV0Dflgl4VfzbaWc4crQ7JElfw1cuNCbcJUau";
    NSString *nonce = [self ret32bitString];//随机数
    NSString *curTime = [self dateTransformToTimeSp];
    NSString *checkSum = [self sha1:[NSString stringWithFormat:@"%@%@%@" ,secret ,  nonce ,curTime]];
    [dic setValue:secret forKey:@"secret"];
    [dic setValue:nonce forKey:@"nonce"];
    [dic setValue:curTime forKey:@"curTime"];
    [dic setValue:checkSum forKey:@"checkSum"];
    [dic setValue:ticket forKey:@"ticket"];
    [dic setValue:dicData[@"openid"] forKey:@"openId"];
    [dic setValue:mTypeIOS forKey:@"mtype"];
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];

    [dic setValue:[user valueForKey:@"appVersionNumber"] forKey:@"appVersionNumber"];
    [dic setValue:[user valueForKey:@"user"] forKey:@"user"];
    //DLog(@"微信名字==%@",dic);
    
    [MHNetworkManager postReqeustWithURL:[NSString stringWithFormat:@"%@/cas/mobile/checkOpenId" ,baseUrl] params:dic successBlock:^(NSDictionary *returnData) {
        
        //DLog(@"微信登陆=======  %@",returnData);
        [GlobalHelper shareInstance].merchantsIsLoginStated = @"2";

        //获得当前控制器
        UITabBarController *tabBarController = ( UITabBarController*)self.window.rootViewController;
        UINavigationController * nav = (UINavigationController *)tabBarController.selectedViewController;
        UIViewController *currentVC = nav.visibleViewController;
        
        NSUserDefaults *user = [NSUserDefaults standardUserDefaults];

        [user setValue:returnData[@"data"][@"headPic"] forKey:@"headPic"];
        [user setValue:returnData[@"data"][@"nickname"] forKey:@"nickname"];

        
        if ([returnData[@"code"]integerValue] == 04) {///未认证手机号
            PhoneNumberCertificationViewController *VC  = [PhoneNumberCertificationViewController new];
            VC.openid = dicData[@"openid"];
            VC.headPic = dicData[@"headimgurl"];
            VC.nickname = dicData[@"nickname"];
            
            [currentVC.navigationController pushViewController:VC animated:YES];
            
        }else if ([returnData[@"code"]integerValue] == 00){//已认证
            [user setValue:returnData[@"data"][@"id"]  forKey:@"userId"];
            [user setValue:@"1" forKey:@"isLoginState"];
            
            NSDictionary *data = returnData[@"data"];
            if ([data isKindOfClass:[NSDictionary class]] && [data objectForKey:@"store"]) {
                
                //记录店铺认证
                [user setValue:[NSString stringWithFormat:@"%@" ,returnData[@"data"][@"store"][@"isApprove"]] forKey:@"approve"];

                [currentVC.navigationController popViewControllerAnimated:YES];
                
            }else{//店铺未认证
                
                [user setValue:@"0" forKey:@"approve"];
                [currentVC.navigationController pushViewController:[ShopCertificationViewController new] animated:YES];
            }
            
        }
        [SVProgressHUD dismiss];
        
    } failureBlock:^(NSError *error) {
       // DLog(@"微信登陆失败方法=%@" ,error);
        [SVProgressHUD dismiss];
        [SVProgressHUD showErrorWithStatus:error];
        
    } showHUD:NO];

}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    
    ///切后台关闭SDK，让SDK第一时间断线，让个推先用APN推送
    [GeTuiSdk destroy];
    
    
    
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
    
    //设置角标为0 相当于复位
    //[GeTuiSdk setBadge:0];
    UILocalNotification *localNote = [[UILocalNotification alloc] init];
    localNote.applicationIconBadgeNumber = -1;
    [[UIApplication sharedApplication] scheduleLocalNotification:localNote];
    [[UIApplication sharedApplication] cancelLocalNotification:localNote];
   
//    [[UIApplication sharedApplication]setApplicationIconBadgeNumber:0];//进入前台取消应用消息图标搜索
//   [[UIApplication sharedApplication] cancelAllLocalNotifications];
//

}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    [[NSNotificationCenter defaultCenter] postNotificationName:@"versionUpdate" object:nil];
    
    
    
//    [DeviceDelegateHelper sharedInstance].preDate = [NSDate date];
    /// 个推重新上线
    [GeTuiSdk startSdkWithAppId:kGtAppId appKey:kGtAppKey appSecret:kGtAppSecret delegate:self];

}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


#pragma mark = 创建tabBar控制器

-(UITabBarController*)setTabBar{
//
//    PersonalPageViewController *PersonalPageVC = [[PersonalPageViewController alloc] init];
//    UINavigationController *navPersonalPageVC = [[UINavigationController alloc] initWithRootViewController:PersonalPageVC];
//    PersonalPageVC.tabBarItem.title = @"个人专区";
//    PersonalPageVC.tabBarItem.image = [[UIImage imageNamed:@"个人专区"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] ;
//    PersonalPageVC.tabBarItem.selectedImage = [[UIImage imageNamed:@"个人专区选中"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];

    
    
    
    PersonalPageViewController *PersonalPageVC = [[PersonalPageViewController alloc] init];
    UINavigationController *navPersonalPageVC = [[UINavigationController alloc] initWithRootViewController:PersonalPageVC];
    PersonalPageVC.tabBarItem.title = @"个人专区";
    PersonalPageVC.tabBarItem.image = [[UIImage imageNamed:@"个人专区"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] ;
    PersonalPageVC.tabBarItem.selectedImage = [[UIImage imageNamed:@"个人专区选中"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];

    
    
    
    HomePageViewController *homePageVC = [[HomePageViewController alloc] init];
    UINavigationController *navHomePageVC = [[UINavigationController alloc] initWithRootViewController:homePageVC];
    homePageVC.tabBarItem.title = @"商户专区";
    homePageVC.tabBarItem.image = [[UIImage imageNamed:@"商户专区"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] ;
    homePageVC.tabBarItem.selectedImage = [[UIImage imageNamed:@"商户专区选中"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];

    
    
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
    self.tabBars.viewControllers = @[navPersonalPageVC,navHomePageVC  , navCartVC , navMyVC];
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    if ([[user valueForKey:@"approve"] isEqualToString:@"1"]) {
        self.tabBars.selectedIndex = 1;
    }else{
        self.tabBars.selectedIndex = 0;
    }
    
    //self.tabBars.viewControllers = @[navHomePageVC  , navCartVC , navMyVC];


    
    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:RGB(236, 31, 35, 1), NSForegroundColorAttributeName, nil] forState:UIControlStateSelected];
    return  self.tabBars;

    
}


-(BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController{
    
    
    //这里我判断的是当前点击的tabBarItem的标题
    if ([viewController.tabBarItem.title isEqualToString:@"购物车"]) {
        //如果用户ID存在的话，说明已登陆
        NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
        
        if ([[user valueForKey:@"isLoginState"] isEqualToString:@"1"]){
            return YES;
        }else{
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


///sha1加密方式

- (NSString *) sha1:(NSString *)input
{
    //const char *cstr = [input cStringUsingEncoding:NSUTF8StringEncoding];
    //NSData *data = [NSData dataWithBytes:cstr length:input.length];
    
    NSData *data = [input dataUsingEncoding:NSUTF8StringEncoding];
    
    uint8_t digest[CC_SHA1_DIGEST_LENGTH];
    
    CC_SHA1(data.bytes, (unsigned int)data.length, digest);
    
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];
    
    for(int i=0; i<CC_SHA1_DIGEST_LENGTH; i++) {
        [output appendFormat:@"%02x", digest[i]];
    }
    
    return output;
}

//1970获取当前时间转为时间戳
- (NSString *)dateTransformToTimeSp{
    UInt64 recordTime = [[NSDate date] timeIntervalSince1970];
    NSString *timeSp = [NSString stringWithFormat:@"%llu",recordTime];
    return timeSp;
}

///随机数

-(NSString *)ret32bitString

{
    
    char data[32];
    
    for (int x=0;x<32;data[x++] = (char)('A' + (arc4random_uniform(26))));
    
    return [[NSString alloc] initWithBytes:data length:32 encoding:NSUTF8StringEncoding];
    
}



@end

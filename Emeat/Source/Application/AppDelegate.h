//
//  AppDelegate.h
//  Emeat
//
//  Created by liuheshun on 2017/11/3.
//  Copyright © 2017年 liuheshun. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <GTSDK/GeTuiSdk.h>     // GetuiSdk头文件应用

// iOS10 及以上需导入 UserNotifications.framework
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0
#import <UserNotifications/UserNotifications.h>
#endif

/// 使用个推回调时，需要添加"GeTuiSdkDelegate"
/// iOS 10 及以上环境，需要添加 UNUserNotificationCenterDelegate 协议，才能使用 UserNotifications.framework 的回调

#define KWeixinAPP_ID  @"wxbd69c8d0e62710fa"
#define KWeixinAPP_SECRET      @"c0944b09fce0fffcf3d19e5acc6dfca0" //微信appsecret
///个推
#define kGtAppId           @"yAuXzIJepr9iUdH2rYSed3"
#define kGtAppKey          @"cIG5VsoMUZ62DTrecFeKO3"
#define kGtAppSecret       @"XGjxk9iRl29rgrcuBbLB"


@interface AppDelegate : UIResponder <UIApplicationDelegate ,  GeTuiSdkDelegate, UNUserNotificationCenterDelegate>

@property (strong, nonatomic) UIWindow *window;


@end


//
//  LHSPayManger.h
//  Emeat
//
//  Created by liuheshun on 2018/1/12.
//  Copyright © 2018年 liuheshun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WXApi.h"
#import <UIKit/UIKit.h>
@interface LHSPayManger : NSObject


+ (LHSPayManger*)sharedManager ;

#pragma mark = wechatPay

-(void)sendWXPay:(NSDictionary*)dic;

#pragma mark = Alipay

-(void)sendAliPay:(NSDictionary*)dic;

#pragma mark =  UPPay
-(void)sendUPPay:(NSDictionary*)dic UiviewController:(UIViewController*)VC;





@end

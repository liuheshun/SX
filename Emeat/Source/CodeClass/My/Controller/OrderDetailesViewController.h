//
//  OrderDetailesViewController.h
//  Emeat
//
//  Created by liuheshun on 2017/12/8.
//  Copyright © 2017年 liuheshun. All rights reserved.
//订单详情

#import <UIKit/UIKit.h>

@interface OrderDetailesViewController : SHLBaseViewController
///订单号
@property (nonatomic,strong) NSString *orderNo;
/// 1 的时候表示跳转来自支付页面 ,
@property (nonatomic,strong) NSString *fromPayVC;

///1 的时候表示跳转来自待评价页面 ,
@property (nonatomic,strong) NSString *fromWaitCommentsVC;


@end

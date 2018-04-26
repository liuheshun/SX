//
//  SelectPayTypeViewController.h
//  Emeat
//
//  Created by liuheshun on 2017/12/8.
//  Copyright © 2017年 liuheshun. All rights reserved.
//选择支付方式

#import <UIKit/UIKit.h>

@interface SelectPayTypeViewController : SHLBaseViewController
///订单号
@property (nonatomic,strong) NSString *orderNo;
///是否是周期性付款用户
@property (nonatomic,assign) NSInteger periodic;

///来自确认订单页面 = 1 或者 我的订单页面

@property (nonatomic,strong) NSString *fromVC;


@end

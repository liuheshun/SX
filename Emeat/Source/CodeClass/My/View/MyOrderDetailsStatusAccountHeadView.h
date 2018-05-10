//
//  MyOrderDetailsStatusAccountHeadView.h
//  Emeat
//
//  Created by liuheshun on 2018/4/17.
//  Copyright © 2018年 liuheshun. All rights reserved.
//

#import <UIKit/UIKit.h>
///周期性打款view
@interface MyOrderDetailsStatusAccountHeadView : UIView
///周期性付款信息
//
@property (nonatomic,strong) UIImageView *accountBgView;
///打款账户
@property (nonatomic,strong) UILabel *accountLable;
///打款账户信息
@property (nonatomic,strong) UILabel *accountInfoLable;

///开户行
@property (nonatomic,strong) UILabel *accountWhere;
///开户名
@property (nonatomic,strong) UILabel *accountName;

@end

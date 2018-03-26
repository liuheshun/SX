//
//  MyHeadView.h
//  Emeat
//
//  Created by liuheshun on 2017/11/14.
//  Copyright © 2017年 liuheshun. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^returnUserNameBlock)(NSString *userName);

@interface MyHeadView : UIView<UITextFieldDelegate>

@property (nonatomic,copy) returnUserNameBlock userNameBlock;

///背景图
@property (nonatomic,strong) UIImageView *bgImv;
///
@property (nonatomic,strong) UIView *topBgView;

///用户头像
@property (nonatomic,strong) UIButton *userImv;
///用户名
@property (nonatomic,strong) UITextField *userName;
///编辑按钮
@property (nonatomic,strong) UIButton *editBtn;

///用户手机号
@property (nonatomic,strong) UILabel *phoneLab;

///我的订单
@property (nonatomic,strong) UIButton *myOrderBtn;
///查看全部订单
@property (nonatomic,strong) UIButton *checkAllOrderBtn;
///待付款
@property (nonatomic,strong) UIButton *waitPayBtn;
///待发货
@property (nonatomic,strong) UIButton *waitSendGoodsBtn;
///待收货
@property (nonatomic,strong) UIButton *waitReceiveBtn;
///待评价
@property (nonatomic,strong) UIButton *waitCommentBtn;

///退货/售后
@property (nonatomic,strong) UIButton *returnGoodsBtn;

///登录/注册
@property (nonatomic,strong) UIButton *loginBtn;

///是否登录 加载不同UI控件
-(void)addTopHeadView:(NSString *)isLogin  configHeadViewMyModel:(MyModel*)model;







@end

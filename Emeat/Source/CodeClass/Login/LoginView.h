//
//  LoginView.h
//  Emeat
//
//  Created by liuheshun on 2017/12/27.
//  Copyright © 2017年 liuheshun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginView : UIView
@property (nonatomic,strong) UIView *bgView;

@property (nonatomic,strong) UITextField *phoneNumTextField;
@property (nonatomic,strong) UITextField *codeTextField;
@property (nonatomic,strong) UIButton *codeBtn;

@property (nonatomic,strong) UIView *lineView1;
@property (nonatomic,strong) UIView *lineView2;

@property (nonatomic,strong) UIButton *loginBtn;

@property (nonatomic,strong) UIButton *wechatBtn;

@property (nonatomic,strong) UIView *leftLineView;
@property (nonatomic,strong) UIView *rightLineView;
@property (nonatomic,strong) UILabel *oauthLable;

@property (nonatomic,strong) UILabel *agreementLab;
@property (nonatomic,strong) UIButton *agreementBtn;

@property (nonatomic,strong) UILabel *kfPhoneNumLab;








@end

//
//  LoginView.m
//  Emeat
//
//  Created by liuheshun on 2017/12/27.
//  Copyright © 2017年 liuheshun. All rights reserved.
//

#import "LoginView.h"

@implementation LoginView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.bgView];
        [self.bgView addSubview:self.lineView1];
        [self.bgView addSubview:self.phoneNumTextField];
        [self.bgView addSubview:self.lineView2];
        [self.bgView addSubview:self.codeBtn];
        [self.bgView addSubview:self.codeTextField];
        [self addSubview:self.loginBtn];
        
        [self addSubview:self.oauthLable];
        [self addSubview:self.leftLineView];
        [self addSubview:self.rightLineView];
        [self addSubview:self.wechatBtn];
        [self addSubview:self.agreementLab];
        [self addSubview:self.agreementBtn];
        
        
        [self addSubview:self.kfPhoneNumLab];
        
        [self setMainViewFrame];
    }
    return self;
}

-(UIView *)bgView{
    if (!_bgView) {
        _bgView = [[UIView alloc] init];
        _bgView.backgroundColor = [UIColor whiteColor];
    }
    return _bgView;
}

-(UITextField *)phoneNumTextField{
    if (!_phoneNumTextField) {
        _phoneNumTextField = [[UITextField alloc] init];
        _phoneNumTextField.placeholder = @"请输入手机号";
        
        [_phoneNumTextField setValue:[UIFont systemFontOfSize:15.0f*kScale] forKeyPath:@"_placeholderLabel.font"];
        [_phoneNumTextField setValue:RGB(185, 185, 185, 1) forKeyPath:@"_placeholderLabel.textColor"];
        _phoneNumTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _phoneNumTextField.keyboardType = UIKeyboardTypeNumberPad;
        _phoneNumTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;

    }
    return _phoneNumTextField;
}



-(UITextField *)codeTextField{
    if (!_codeTextField) {
        _codeTextField = [[UITextField alloc] init];
        _codeTextField.placeholder = @"请输入验证码";
        
        [_codeTextField setValue:[UIFont systemFontOfSize:15.0f*kScale] forKeyPath:@"_placeholderLabel.font"];
        [_codeTextField setValue:RGB(185, 185, 185, 1) forKeyPath:@"_placeholderLabel.textColor"];
        _codeTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _codeTextField.keyboardType = UIKeyboardTypeNumberPad;
        _codeTextField.secureTextEntry = YES;
        _codeTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    }
    return _codeTextField;
}


-(UIView *)lineView1{
    if (!_lineView1) {
        _lineView1 = [[UIView alloc] init];
        _lineView1.backgroundColor = RGB(220, 220, 220, 1);
        
    }
    return _lineView1;
}

-(UIView *)lineView2{
    if (!_lineView2) {
        _lineView2 = [[UIView alloc] init];
        _lineView2.backgroundColor = RGB(220, 220, 220, 1);

    }
    return _lineView2;
}

-(UIButton *)codeBtn{
    if (!_codeBtn) {
        _codeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _codeBtn.titleLabel.font = [UIFont systemFontOfSize:12.0f];
        _codeBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        _codeBtn.backgroundColor = RGB(136, 136, 136, 1);
        [_codeBtn setTitle:@"获取验证码" forState:0];
        _codeBtn.titleLabel.font = [UIFont systemFontOfSize:12.0f];
        _codeBtn.layer.cornerRadius = 4;
        _codeBtn.layer.masksToBounds = YES;
        _codeBtn.userInteractionEnabled = NO;
    }
    return _codeBtn;
}

-(UIButton *)loginBtn{
    if (!_loginBtn) {
        _loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _loginBtn.titleLabel.font = [UIFont systemFontOfSize:12.0f];
        _loginBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        _loginBtn.backgroundColor = RGB(136, 136, 136, 1);
        [_loginBtn setTitle:@"确认" forState:0];
        _loginBtn.titleLabel.font = [UIFont systemFontOfSize:15.0f];
        _loginBtn.layer.cornerRadius = 4;
        _loginBtn.layer.masksToBounds = YES;
        _loginBtn.userInteractionEnabled = NO;

    }
    return _loginBtn;
}


-(UILabel *)oauthLable{
    if (!_oauthLable) {
        _oauthLable = [[UILabel alloc] init];
        _oauthLable.font = [UIFont systemFontOfSize:12*kScale];
        _oauthLable.textColor = RGB(136, 136, 136, 1);
        _oauthLable.text = @"一键登录";
        _oauthLable.textAlignment = NSTextAlignmentCenter;
        
    }
    return _oauthLable;
}

-(UIView *)leftLineView{
    if (!_leftLineView) {
        _leftLineView = [[UIView alloc] init];
        _leftLineView.backgroundColor = RGB(136, 136, 136, 1);
    }
    return _leftLineView;
}

-(UIView *)rightLineView{
    if (!_rightLineView) {
        _rightLineView = [[UIView alloc] init];
        _rightLineView.backgroundColor = RGB(136, 136, 136, 1);
    }
    return _rightLineView;
}

-(UIButton *)wechatBtn{
    if (!_wechatBtn) {
        _wechatBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_wechatBtn setImage:[UIImage imageNamed:@"loginWeixin"] forState:0];
        [_wechatBtn setTitle:@"微信" forState:0];
        _wechatBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        _wechatBtn.titleLabel.font = [UIFont systemFontOfSize:12*kScale];
        [_wechatBtn setTitleColor:RGB(136, 136, 136, 1) forState:0];
    }
    return _wechatBtn;
}


-(UILabel *)agreementLab{
    if (!_agreementLab) {
        _agreementLab = [[UILabel alloc] init];
        _agreementLab.font = [UIFont systemFontOfSize:12.0f*kScale];
        _agreementLab.textColor = RGB(136, 136, 136, 1);
        _agreementLab.text = @"登录/注册代表您已同意";
        _agreementLab.textAlignment = NSTextAlignmentRight;
    }
    return _agreementLab;
}

-(UIButton *)agreementBtn{
    if (!_agreementBtn) {
        _agreementBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _agreementBtn.titleLabel.font = [UIFont systemFontOfSize:12.0f*kScale];
        [_agreementBtn setTitle:@"《赛鲜服务协议》" forState:0];
        [_agreementBtn setTitleColor:RGB(231, 35, 36, 1) forState:0];
        ;
        
        _agreementBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    }
    return _agreementBtn;
}


-(UILabel *)kfPhoneNumLab{
    if (!_kfPhoneNumLab) {
        _kfPhoneNumLab = [[UILabel alloc] init];
        _kfPhoneNumLab.textColor = RGB(136, 136, 136, 1);
        _kfPhoneNumLab.font = [UIFont systemFontOfSize:12.0f*kScale];
        _kfPhoneNumLab.textAlignment = NSTextAlignmentCenter;
        _kfPhoneNumLab.text = @"客服热线 : 400110611";
    }
    return _kfPhoneNumLab;
}


-(void)setMainViewFrame{
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(self);
        make.top.equalTo(self);
        make.height.equalTo(@90);
    }];
    
    [self.lineView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).with.offset(15);
        
        make.right.equalTo(self.mas_right).with.offset(-15);        make.top.equalTo(self);
        make.height.equalTo(@1);
    }];
    [self.phoneNumTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).with.offset(30);

        make.right.equalTo(self.mas_right).with.offset(-15);
        make.top.equalTo(self.lineView1.mas_bottom).with.offset(0);
        make.height.equalTo(@44);
    }];
    
    [self.lineView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).with.offset(15);
        make.right.equalTo(self.mas_right).with.offset(-15);        make.top.equalTo(self.phoneNumTextField.mas_bottom);
        make.height.equalTo(@1);
    }];
    
    [self.codeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).with.offset(-15);
        make.top.equalTo(self.lineView2.mas_bottom).with.offset(7);
        make.height.equalTo(@30);
        make.width.equalTo(@75);
    }];

    
    [self.codeTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).with.offset(30);
        make.right.equalTo(self.codeBtn.mas_left).with.offset(-15);
        make.top.equalTo(self.lineView2.mas_bottom);
        make.height.equalTo(@44);
    }];
    
    [self.loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).with.offset(15);
        make.right.equalTo(self.mas_right).with.offset(-15);
        make.top.equalTo(self.codeTextField.mas_bottom).with.offset(32);
        make.height.equalTo(@40);
    }];
    
    
    
    [self.oauthLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.loginBtn.mas_bottom).with.offset(65*kScale);
        make.width.equalTo(@(60*kScale));
        make.centerX.equalTo(self);
        make.height.equalTo(@(10*kScale));
    }];
    
    
    [self.leftLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(110*kScale));
        make.height.equalTo(@(1*kScale));
        make.right.equalTo(self.oauthLable.mas_left).with.offset(-10*kScale);
        make.centerY.equalTo(self.oauthLable);
        
    }];
    
    
    
    [self.rightLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(110*kScale));
        make.height.equalTo(@(1*kScale));
        make.left.equalTo(self.oauthLable.mas_right).with.offset(10*kScale);
        make.centerY.equalTo(self.oauthLable);
        
    }];
    
    
    [self.wechatBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.oauthLable.mas_bottom).with.offset(38*kScale);
        make.width.height.equalTo(@(80*kScale));
        make.centerX.equalTo(self);
    }];
    
    [_wechatBtn layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleTop imageTitleSpace:10*kScale];

    
    [self.agreementLab mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.mas_left).with.offset((kWidth-235*kScale)/2);
        make.height.equalTo(@(12*kScale));
        make.width.equalTo(@(135*kScale));
        make.bottom.equalTo(self.mas_bottom).with.offset(-47*kScale);
        
        
    }];
    
    [self.agreementBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.agreementLab.mas_right).with.offset(0);
        make.height.equalTo(@(12*kScale));
        make.width.equalTo(@(100*kScale));
        make.bottom.equalTo(self.mas_bottom).with.offset(-47*kScale);
        
        
    }];
    
    [self.kfPhoneNumLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.height.equalTo(@(12*kScale));
        make.bottom.equalTo(self.mas_bottom).with.offset(-25*kScale);
        
    }];
    
}




/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

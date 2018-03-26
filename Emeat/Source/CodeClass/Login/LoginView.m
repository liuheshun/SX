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
    
    
}




/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

//
//  MyHeadView.m
//  Emeat
//
//  Created by liuheshun on 2017/11/14.
//  Copyright © 2017年 liuheshun. All rights reserved.
//

#import "MyHeadView.h"
#import <SDWebImage/UIButton+WebCache.h>


@implementation MyHeadView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.bgImv];
        [self addSubview:self.myOrderBtn];
        [self addSubview:self.checkAllOrderBtn];
        [self addSubview:self.waitPayBtn];
        [self addSubview:self.waitSendGoodsBtn];
        [self addSubview:self.waitReceiveBtn];
        [self addSubview:self.returnGoodsBtn];
        [self addSubview:self.waitCommentBtn];
        [self setMainViewFrame];
        self.bgImv.image = [UIImage imageNamed:@"组8"];
     
        
        
    }
    return self;
}

-(void)editBtnAction{
//    self.userName.enabled = YES;
    [self.userName becomeFirstResponder];
    
}

-(void)textFieldDidEndEditing:(UITextField *)textField{
    if (textField.text.length>10) {
        textField.text = [textField.text substringToIndex:10];
    }
    if ([self respondsToSelector:@selector(userNameBlock)]) {
        self.userNameBlock(textField.text);
        CGFloat userNameW = [GetWidthAndHeightOfString getWidthForText:self.userName height:15*kScale];
//        if (userNameW >150) {
//            userNameW = 150;
//        }
        [self.userName mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@(userNameW));
        }];
    }
}

-(void)textFieldDidChange:(UITextField*)textField{
    if (textField.text.length>10) {
        textField.text = [textField.text substringToIndex:10];
    }
    CGFloat userNameW = [GetWidthAndHeightOfString getWidthForText:self.userName height:15*kScale];
//    if (userNameW >150) {
//        userNameW = 150;
//    }
    [self.userName mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.userImv.mas_right).with.offset(10*kScale);
        make.width.equalTo(@(userNameW));
    }];
}


-(void)addTopHeadView:(NSString *)isLogin  configHeadViewMyModel:(MyModel*)model{

    if ([isLogin  isEqualToString:@"1"]) {//登陆状态显示用户相关信息
        [self.bgImv addSubview:self.userImv];
        [self.bgImv addSubview:self.userName];
        [self.bgImv addSubview:self.editBtn];
        [self.bgImv addSubview:self.phoneLab];
        [self.bgImv addSubview:self.shopNameBtn];
        [self.bgImv addSubview:self.shopCertifiImv];
        [self.loginBtn removeFromSuperview];
        [self setUserImvFrame];
        [self.editBtn addTarget:self action:@selector(editBtnAction) forControlEvents:1];
        
        [self.userImv sd_setBackgroundImageWithURL:[NSURL URLWithString:model.headPic] forState:0 placeholderImage:[UIImage imageNamed:@"user_imv"]];

        self.userName.text = model.nickname;
        self.phoneLab.text = model.customerAccount ;
        if (model.storeName) {
            [self.shopNameBtn setTitle:model.storeName forState:0];
        }else{
            [self.shopNameBtn setTitle:@"认证店铺" forState:0];

        }
        
        if (model.isApprove == 1) {
            self.shopCertifiImv.image = [UIImage imageNamed:@"已认证"];
        }else{
            self.shopCertifiImv.image = [UIImage imageNamed:@"dairenzheng"];

        }

        [self setButtonBadgeValue:self.waitPayBtn badgeValue:[NSString stringWithFormat:@"%ld",(long)model.waitBuy] badgeOriginX:MaxX(self.waitPayBtn.imageView)-5 badgeOriginY:-5];
        [self setButtonBadgeValue:self.waitSendGoodsBtn badgeValue:[NSString stringWithFormat:@"%ld",(long)model.waitTransport] badgeOriginX:MaxX(self.waitSendGoodsBtn.imageView)-5 badgeOriginY:-5];
        
        [self setButtonBadgeValue:self.waitReceiveBtn badgeValue:[NSString stringWithFormat:@"%ld",(long)model.waitRecive] badgeOriginX:MaxX(self.waitReceiveBtn.imageView)-5 badgeOriginY:-5];
        
        [self setButtonBadgeValue:self.returnGoodsBtn badgeValue:[NSString stringWithFormat:@"%ld",(long)model.salesReturn] badgeOriginX:MaxX(self.returnGoodsBtn.imageView)-5 badgeOriginY:-5];
        
        CGFloat userNameW = [GetWidthAndHeightOfString getWidthForText:self.userName height:15*kScale];
      
        [self.userName mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@(userNameW));
        }];
        
        
        CGFloat shopNameBtn = [GetWidthAndHeightOfString getWidthForText:self.shopNameBtn height:25*kScale]+25*kScale;
        
        [self.shopNameBtn mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@(shopNameBtn));
        }];
        
        
    }else{//未登录
        
        [self.bgImv addSubview:self.loginBtn];
        [self.userImv removeFromSuperview];
        [self.userName removeFromSuperview];
        [self.editBtn removeFromSuperview];
        [self.phoneLab removeFromSuperview];
        [self setLoginViewFrame];
    }
}


/**
 * 设置button角标
 */
-(void)setButtonBadgeValue:(UIButton*)btn badgeValue:(NSString *)badgeValue badgeOriginX:(CGFloat)X  badgeOriginY:(CGFloat)Y{
    
        btn.badgeValue = badgeValue;
        btn.badgeBGColor = [UIColor redColor];
        btn.badgeTextColor = [UIColor whiteColor];
        btn.badgeOriginX = X;
        btn.badgeOriginY = Y;
       // btn.shouldHideBadgeAtZero = YES;///此属性不起作用.....
}






-(void)setLoginViewFrame{
    [self.loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgImv.mas_left).with.offset((kWidth-100*kScale)/2);
        make.top.equalTo(self.bgImv.mas_top).with.offset(57*kScale);
        make.width.equalTo(@(100*kScale));
        make.height.equalTo(@(28*kScale));
    }];
}
-(void)setUserImvFrame{
    [self.userImv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgImv.mas_left).with.offset(15*kScale);
        make.top.equalTo(self.bgImv.mas_top).with.offset(41*kScale);
        make.width.equalTo(@(60*kScale));
        make.height.equalTo(@(60*kScale));
    }];
    
    [self.userName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.userImv.mas_right).with.offset(10*kScale);
        make.top.equalTo(self.bgImv.mas_top).with.offset(36*kScale);
        make.width.equalTo(@(80*kScale));
        make.height.equalTo(@(15*kScale));
    }];
    
    [self.editBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.userName.mas_right).with.offset(10*kScale);
        make.top.equalTo(self.bgImv.mas_top).with.offset(34*kScale);
        make.width.equalTo(@(20*kScale));
        make.height.equalTo(@(20*kScale));
    }];
    
    [self.phoneLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.userImv.mas_right).with.offset(10*kScale);
        make.top.equalTo(self.userName.mas_bottom).with.offset(5*kScale);
        make.width.equalTo(@(200*kScale));
        make.height.equalTo(@(15*kScale));
    }];
    
    
    [self.shopNameBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.userImv.mas_right).with.offset(10*kScale);
        make.top.equalTo(self.phoneLab.mas_bottom).with.offset(5*kScale);
        make.width.equalTo(@(220*kScale));
        make.height.equalTo(@(25*kScale));
    }];
    
    
    
    [self.shopCertifiImv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.bgImv.mas_right).with.offset(-17*kScale);
        make.bottom.equalTo(self.shopNameBtn.mas_top).with.offset(7*kScale);
        make.width.equalTo(@(57*kScale));
        make.height.equalTo(@(48*kScale));
    }];
    
}



-(void)setMainViewFrame{
    [self.bgImv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self);
        make.top.equalTo(self);
        make.width.equalTo(@(kWidth));
        make.height.equalTo(@(125*kScale));
    }];
    
    [self.myOrderBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).with.offset(15*kScale);
        make.top.equalTo(self.mas_top).with.offset(134*kScale);
        make.width.equalTo(@(150*kScale));
        make.height.equalTo(@(15*kScale));
    }];
    
    [self.checkAllOrderBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).with.offset(-15*kScale);
        make.top.equalTo(self.myOrderBtn);
        make.width.equalTo(@(150*kScale));
        make.height.equalTo(@(15*kScale));
    }];
    
    [self.waitPayBtn mas_makeConstraints:^(MASConstraintMaker *make) {
       // make.left.equalTo(self.mas_left).with.offset((kWidth-260*kScale)/5);

        make.left.equalTo(self.mas_left).with.offset((kWidth-320*kScale)/6);
        make.top.equalTo(self.myOrderBtn.mas_bottom).with.offset(30*kScale);
        make.width.equalTo(@(60*kScale));
        make.height.equalTo(@(50*kScale));
    }];
    
    [self.waitSendGoodsBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.waitPayBtn.mas_right).with.offset((kWidth-320*kScale)/6);
        make.top.equalTo(self.myOrderBtn.mas_bottom).with.offset(30*kScale);
        make.width.equalTo(@(60*kScale));
        make.height.equalTo(@(50*kScale));
    }];
    [self.waitReceiveBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.waitSendGoodsBtn.mas_right).with.offset((kWidth-320*kScale)/6);
        make.top.equalTo(self.myOrderBtn.mas_bottom).with.offset(30*kScale);
        make.width.equalTo(@(60*kScale));
        make.height.equalTo(@(50*kScale));
    }];
    
    
    [self.waitCommentBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.waitReceiveBtn.mas_right).with.offset((kWidth-320*kScale)/6);
        make.top.equalTo(self.myOrderBtn.mas_bottom).with.offset(30);
        make.width.equalTo(@(60*kScale));
        make.height.equalTo(@(50*kScale));
    }];
    
    [self.returnGoodsBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.waitCommentBtn.mas_right).with.offset((kWidth-320*kScale)/6);
        make.top.equalTo(self.myOrderBtn.mas_bottom).with.offset(30*kScale);
        make.width.equalTo(@(80*kScale));
        make.height.equalTo(@(50*kScale));
    }];
    
    _checkAllOrderBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    
    [_checkAllOrderBtn layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleRight imageTitleSpace:5];

    [_waitPayBtn layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleTop imageTitleSpace:10];
    [_returnGoodsBtn layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleTop imageTitleSpace:10];
    [_waitCommentBtn layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleTop imageTitleSpace:10];
    [_waitReceiveBtn layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleTop imageTitleSpace:10];
    [_waitSendGoodsBtn layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleTop imageTitleSpace:10];
}


-(UIImageView*)bgImv{
    if (!_bgImv) {
        _bgImv = [[UIImageView alloc] init];
        _bgImv.userInteractionEnabled = YES;
    }
    return _bgImv;
}

-(UIButton *)loginBtn{
    if (!_loginBtn) {
        _loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_loginBtn setTitle:@"登录/注册" forState:0];
        [_loginBtn setTitleColor:[UIColor whiteColor] forState:0];
        _loginBtn.titleLabel.font = [UIFont systemFontOfSize:15.0f*kScale];
        _loginBtn.layer.cornerRadius = 4;
        _loginBtn.layer.borderColor = [UIColor whiteColor].CGColor;
        _loginBtn.layer.borderWidth = 1;
        
    }
    return _loginBtn;
}


///用户相关信息
-(UIButton*)userImv{
    if (!_userImv) {
        _userImv = [UIButton  buttonWithType:UIButtonTypeCustom];
        _userImv.layer.cornerRadius = 30*kScale;
        _userImv.layer.masksToBounds = YES;
//        _userImv.backgroundColor = [UIColor cyanColor];
    }
    return _userImv;
}


-(UITextField*)userName{
    if (!_userName) {
        _userName = [[UITextField alloc] init];
        _userName.font = [UIFont systemFontOfSize:15.0f*kScale];
        _userName.textColor = [UIColor whiteColor];
        _userName.delegate = self;
        [_userName addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    }
    return _userName;
}




-(UIButton*)editBtn{
    if (!_editBtn) {
        _editBtn = [UIButton  buttonWithType:UIButtonTypeCustom];
        [_editBtn setImage:[UIImage imageNamed:@"edit"] forState:0];
    }
    return _editBtn;
}

-(UILabel*)phoneLab{
    if (!_phoneLab) {
        _phoneLab = [[UILabel alloc] init];
        _phoneLab.font = [UIFont systemFontOfSize:15.0f*kScale];
        _phoneLab.textColor = RGB(221, 221, 221, 1);
    }
    return _phoneLab;
}
-(UIButton*)shopNameBtn{
    if (!_shopNameBtn) {
        _shopNameBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _shopNameBtn.titleLabel.font = [UIFont systemFontOfSize:15.0f*kScale];
        [_shopNameBtn setTitleColor:[UIColor whiteColor] forState:0];
        [_shopNameBtn setImage:[UIImage imageNamed:@"shangdian"] forState:0];
        _shopNameBtn.layer.borderWidth = 1;
        _shopNameBtn.layer.borderColor = [UIColor whiteColor].CGColor;
        _shopNameBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        _shopNameBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 10*kScale, 0, 0);
        _shopNameBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 15*kScale, 0, 0);

        
    }
    return _shopNameBtn;
}


-(UIImageView *)shopCertifiImv{
    if (!_shopCertifiImv) {
        _shopCertifiImv = [[UIImageView alloc] init];
    }
    return _shopCertifiImv;
}


///订单部分
-(UIButton*)myOrderBtn{
    if (!_myOrderBtn) {
        _myOrderBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _myOrderBtn.titleLabel.font = [UIFont systemFontOfSize:15.0f*kScale];
        [_myOrderBtn setTitleColor:RGB(51, 51, 51, 1) forState:0];
        [_myOrderBtn setImage:[UIImage imageNamed:@"dingdan"] forState:0];
        [_myOrderBtn setTitle:@"我的订单" forState:0];
        _myOrderBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        _myOrderBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
        _myOrderBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 5*kScale, 0, 0);

        
    }
    return _myOrderBtn;
}

-(UIButton*)checkAllOrderBtn{
    if (!_checkAllOrderBtn) {
        _checkAllOrderBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _checkAllOrderBtn.titleLabel.font = [UIFont systemFontOfSize:15.0f*kScale];
        [_checkAllOrderBtn setTitle:@"查看全部订单" forState:0];
        [_checkAllOrderBtn setTitleColor:RGB(185, 185, 185, 1) forState:0];

        [_checkAllOrderBtn setImage:[UIImage imageNamed:@"进入"] forState:0];
        
     
    }
    return _checkAllOrderBtn;
}

-(UIButton*)waitPayBtn{
    if (!_waitPayBtn) {
        _waitPayBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _waitPayBtn.titleLabel.font = [UIFont systemFontOfSize:15.0f*kScale];
        [_waitPayBtn setTitleColor:RGB(136, 136, 136, 1) forState:0];

        [_waitPayBtn setTitle:@"待付款" forState:0];
        [_waitPayBtn setImage:[UIImage imageNamed:@"daifukuan"] forState:0];

    }
    return _waitPayBtn;
}



-(UIButton*)waitSendGoodsBtn{
    if (!_waitSendGoodsBtn) {
        _waitSendGoodsBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _waitSendGoodsBtn.titleLabel.font = [UIFont systemFontOfSize:15.0f*kScale];
        [_waitSendGoodsBtn setTitleColor:RGB(136, 136, 136, 1) forState:0];

        [_waitSendGoodsBtn setImage:[UIImage imageNamed:@"daifahuo"] forState:0];
        [_waitSendGoodsBtn setTitle:@"待确认" forState:0];
    }
    return _waitSendGoodsBtn;
}


-(UIButton*)waitReceiveBtn{
    if (!_waitReceiveBtn) {
        _waitReceiveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _waitReceiveBtn.titleLabel.font = [UIFont systemFontOfSize:15.0f*kScale];
        [_waitReceiveBtn setTitleColor:RGB(136, 136, 136, 1) forState:0];

        [_waitReceiveBtn setImage:[UIImage imageNamed:@"daishouhuo"] forState:0];
        [_waitReceiveBtn setTitle:@"待收货" forState:0];
       

    }
    return _waitReceiveBtn;
}
-(UIButton*)waitCommentBtn{
    if (!_waitCommentBtn) {
        _waitCommentBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _waitCommentBtn.titleLabel.font = [UIFont systemFontOfSize:15.0f*kScale];
        [_waitCommentBtn setTitleColor:RGB(136, 136, 136, 1) forState:0];
        
        [_waitCommentBtn setImage:[UIImage imageNamed:@"daipingjia"] forState:0];
        [_waitCommentBtn setTitle:@"待评价" forState:0];
       
    }
    return _waitCommentBtn;
}

-(UIButton*)returnGoodsBtn{
    if (!_returnGoodsBtn) {
        _returnGoodsBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _returnGoodsBtn.titleLabel.font = [UIFont systemFontOfSize:15.0f*kScale];
        [_returnGoodsBtn setTitleColor:RGB(136, 136, 136, 1) forState:0];

        [_returnGoodsBtn setImage:[UIImage imageNamed:@"shouhou"] forState:0];
        [_returnGoodsBtn setTitle:@"退货/售后" forState:0];
       
    }
    return _returnGoodsBtn;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

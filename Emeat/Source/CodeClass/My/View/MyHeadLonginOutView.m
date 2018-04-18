//
//  MyHeadLonginOutView.m
//  Emeat
//
//  Created by liuheshun on 2018/4/12.
//  Copyright © 2018年 liuheshun. All rights reserved.
//

#import "MyHeadLonginOutView.h"

@implementation MyHeadLonginOutView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.bgImv];
        [self.bgImv addSubview:self.loginBtn];
        self.bgImv.image = [UIImage imageNamed:@"组8"];
        
        
        
    }
    return self;
}

-(void)setLoginViewFrame{
    
    [self.bgImv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self);
        make.top.equalTo(self);
        make.width.equalTo(@(kWidth));
        make.height.equalTo(@(125*kScale));
    }];
    
    
    [self.loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgImv.mas_left).with.offset((kWidth-100*kScale)/2);
        make.top.equalTo(self.bgImv.mas_top).with.offset(57*kScale);
        make.width.equalTo(@(100*kScale));
        make.height.equalTo(@(28*kScale));
    }];
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
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

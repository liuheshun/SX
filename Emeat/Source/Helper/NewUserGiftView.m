//
//  NewUserGiftView.m
//  Emeat
//
//  Created by liuheshun on 2018/9/18.
//  Copyright © 2018年 liuheshun. All rights reserved.
//

#import "NewUserGiftView.h"

@implementation NewUserGiftView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.giftImageView];
        [self addSubview:self.giftBtn];
        [self setUI];
        
    }
    return self;
}


-(UIImageView *)giftImageView{
    if (_giftImageView == nil) {
        _giftImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"弹窗"]];
    }
    return _giftImageView;
}

-(UIButton *)giftBtn{
    if (_giftBtn == nil) {
        _giftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _giftBtn.backgroundColor = RGB(231, 35, 36, 1);
        _giftBtn.layer.cornerRadius = 5*kScale;
        [_giftBtn setTitle:@"拆礼包" forState:0];
        _giftBtn.titleLabel.font = [UIFont systemFontOfSize:17*kScale weight:0.5];
        
    }
    return _giftBtn;
}

-(void)setUI{
    
    [self.giftImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).with.offset(0*kScale);
        make.right.equalTo(self.mas_right).with.offset(-10*kScale);
        make.width.equalTo(@(311*kScale));
        make.height.equalTo(@(241*kScale));
        
    }];
    
    [self.giftBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.giftImageView.mas_bottom).with.offset(22*kScale);
        make.centerX.equalTo(self);
        make.width.equalTo(@(150*kScale));
        make.height.equalTo(@(35*kScale));
        
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

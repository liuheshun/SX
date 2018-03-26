//
//  HomePageAddressNoticeView.m
//  Emeat
//
//  Created by liuheshun on 2018/1/31.
//  Copyright © 2018年 liuheshun. All rights reserved.
//

#import "HomePageAddressNoticeView.h"

@implementation HomePageAddressNoticeView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.bgView];
        [self.bgView addSubview:self.noticeBtn];
        [self.bgView addSubview:self.enterBtn];
        [self setMainFrame];
    }
    return self;
}

-(void)setMainFrame{
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self);
        make.left.right.equalTo(self);
        make.height.equalTo(@29);
    }];
    
    [self.noticeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgView.mas_left).with.offset(15);
        make.top.bottom.equalTo(self.bgView);
        make.right.equalTo(self.bgView.mas_right).with.offset(-40);
    }];
    
    [self.enterBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self.bgView);
        make.right.equalTo(self.bgView.mas_right).with.offset(-5);
        make.width.equalTo(@35);
    }];
    
}


-(UIView *)bgView{
    if (!_bgView) {
        _bgView = [[UIView alloc] init];
        _bgView.backgroundColor = RGB(255,233, 233, 1);
        
    }
    return _bgView;
}


-(UIButton *)noticeBtn{
    if (!_noticeBtn) {
        _noticeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_noticeBtn setImage:[UIImage imageNamed:@"地址警告"] forState:0];
        [_noticeBtn setTitle:@" 当前位置不在配送范围内,搜搜其它地址" forState:0];
        _noticeBtn.titleLabel.font = [UIFont systemFontOfSize:12.0f];
        [_noticeBtn setTitleColor:RGB(236, 31, 35, 1) forState:0];
        _noticeBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        
    }
    return _noticeBtn;
}

-(UIButton *)enterBtn{
    if (!_enterBtn) {
        _enterBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_enterBtn setImage:[UIImage imageNamed:@"地址进入"] forState:0];
      
    }
    return _enterBtn;
}














/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

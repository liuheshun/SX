//
//  HomePageBottomView.m
//  Emeat
//
//  Created by liuheshun on 2017/11/22.
//  Copyright © 2017年 liuheshun. All rights reserved.
//

#import "HomePageDetailsBottomView.h"

@implementation HomePageDetailsBottomView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.cartBtn];
        [self addSubview:self.addCartBtn];
        [self addSubview:self.lineView];
        [self setMainViewFrame];
    }
    return self;
}

-(UIButton*)cartBtn{
    if (!_cartBtn) {
        _cartBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_cartBtn setImage:[UIImage imageNamed:@"jiarugouwuche"] forState:0];
        [_cartBtn setTitleColor:RGB(236, 31, 35, 1) forState:0];
    }
    return _cartBtn;
}


-(UIButton*)addCartBtn{
    if (!_addCartBtn) {
        _addCartBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_addCartBtn setBackgroundColor:RGB(236, 31, 35, 1)];
        _addCartBtn.titleLabel.font = [UIFont systemFontOfSize:15.0f];
        [_addCartBtn setTitle:@"加入购物车" forState:0];
        [_addCartBtn setTitleColor:[UIColor whiteColor] forState:0];
    }
    return _addCartBtn;
}

-(UIView*)lineView{
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor =RGB(238, 238, 238, 1);
    }
    return _lineView;
}


-(void)setMainViewFrame{
    
    [self.cartBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).with.offset(0);
        make.bottom.equalTo(self.mas_bottom).with.offset(0);
        make.width.equalTo(@(100*kScale));
        make.height.equalTo(self);
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.cartBtn.mas_left).with.offset(0);
        make.top.equalTo(self.cartBtn.mas_top).with.offset(0);
        make.height.equalTo(@1);
        make.width.equalTo(self.cartBtn);
    }];
    
    [self.addCartBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.cartBtn.mas_right).with.offset(0);
        make.right.equalTo(self.mas_right).with.offset(0);
        make.bottom.equalTo(self.mas_bottom).with.offset(0);
        make.height.equalTo(self);
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

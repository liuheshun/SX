//
//  ShoppingCartBottomView.m
//  Emeat
//
//  Created by liuheshun on 2017/11/8.
//  Copyright © 2017年 liuheshun. All rights reserved.
//

#import "ShoppingCartBottomView.h"

@implementation ShoppingCartBottomView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self setupBottomView];
    }
    return self;
}


#pragma mark - 设置底部视图
-(void)setupBottomView
{
//    //底部视图的 背景
//    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, kHeight - 50-kBottomBarHeight, kWidth, 50)];
//    [self.view addSubview:bgView];
//
    UILabel *line = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, kWidth, 0.5)];
    line.backgroundColor = RGB(220, 220, 220, 1);
    [self addSubview:line];
    
//    //全选按钮
//    self.selectAll = [UIButton buttonWithType:UIButtonTypeCustom];
//    self.selectAll.titleLabel.font = [UIFont systemFontOfSize:12.0f*kScale];
//    [self.selectAll setTitle:@" 全选" forState:UIControlStateNormal];
//    [self.selectAll setImage:[UIImage imageNamed:@"no_selected"] forState:UIControlStateNormal];
//    [self.selectAll setImage:[UIImage imageNamed:@"selected"] forState:UIControlStateSelected];
//    [self.selectAll setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//    [self addSubview:self.selectAll];
    
    //合计
    UILabel *label = [[UILabel alloc]init];
    label.text = @"合计: ";
    label.font = [UIFont systemFontOfSize:12.0f*kScale];
    label.textAlignment = NSTextAlignmentRight;
    [self addSubview:label];
    
    //价格
    self.priceLabel = [[UILabel alloc]init];
    self.priceLabel.text = @"￥0";
    self.priceLabel.font = [UIFont boldSystemFontOfSize:16.0f*kScale];
    self.priceLabel.textColor = [UIColor redColor];
    [self addSubview:self.priceLabel];
    
    ///配送
    self.sendPricesDesc = [[UILabel alloc] init];
    self.sendPricesDesc.text = @"配送费";
    self.sendPricesDesc.font = [UIFont systemFontOfSize:12.0f*kScale];
    self.sendPricesDesc.textColor = RGB(136, 136, 136, 1);
    self.sendPricesDesc.textAlignment = NSTextAlignmentLeft;
    [self addSubview:self.sendPricesDesc];
    
    ///配送费
    self.sendPrices = [[UILabel alloc] init];
    self.sendPrices.text = @"0";
    self.sendPrices.font = [UIFont systemFontOfSize:12.0f*kScale];
    self.sendPrices.textColor = RGB(136, 136, 136, 1);
    self.sendPrices.textAlignment = NSTextAlignmentLeft;

    [self addSubview:self.sendPrices];
    

    
    //结算按钮
    
    self.PayBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.PayBtn.backgroundColor = [UIColor redColor];
    [self.PayBtn setTitle:@"去结算" forState:UIControlStateNormal];
    self.PayBtn.titleLabel.font = [UIFont systemFontOfSize:15.0f*kScale];
    //[btn addTarget:self action:@selector(goPayBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.PayBtn];
    
#pragma mark -- 底部视图添加约束
//    //全选按钮
//    [self.selectAll mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self).offset(10*kScale);
//        make.top.equalTo(@(10*kScale));
//        make.bottom.equalTo(self).offset(-10*kScale);
//        make.width.equalTo(@(80*kScale));
//
//    }];
    
    //结算按钮
    [self.PayBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self);
        make.right.equalTo(self);
        make.bottom.equalTo(self);
        make.width.equalTo(@(100*kScale));
        
    }];
  
    //合计
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self).offset(-8*kScale);
//        make.left.equalTo(self.selectAll.mas_right);
        make.left.equalTo(self.mas_left).with.offset(15*kScale);
        make.width.equalTo(@(30*kScale));
        make.height.equalTo(@(12*kScale));
    }];
   
    //价格显示
    [self.priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(label.mas_right).offset(5*kScale);
        make.bottom.equalTo(self).offset(-8*kScale);
        make.height.equalTo(@(12*kScale));
        make.right.equalTo(self.PayBtn.mas_left).with.offset(-5*kScale);
    }];
    
    
    [self.sendPricesDesc mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(8*kScale);
        make.left.equalTo(label.mas_left).with.offset(2*kScale);
        make.width.equalTo(@(40*kScale));
        make.height.equalTo(@(12*kScale));
    }];
    
    [self.sendPrices mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(8*kScale);
        make.left.equalTo(self.sendPricesDesc.mas_right).with.offset(5*kScale);
        make.width.equalTo(@(200*kScale));
        make.height.equalTo(@(12*kScale));
        
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

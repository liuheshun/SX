//
//  InvoiceListBottomView.m
//  Emeat
//
//  Created by liuheshun on 2018/6/21.
//  Copyright © 2018年 liuheshun. All rights reserved.
//

#import "InvoiceListBottomView.h"

@implementation InvoiceListBottomView

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
    
    //全选按钮
    self.selectAll = [UIButton buttonWithType:UIButtonTypeCustom];
    self.selectAll.titleLabel.font = [UIFont systemFontOfSize:12.0f*kScale];
    [self.selectAll setImage:[UIImage imageNamed:@"no_selected"] forState:UIControlStateNormal];
    [self.selectAll setImage:[UIImage imageNamed:@"selected"] forState:UIControlStateSelected];
    [self addSubview:self.selectAll];
    UILabel *label = [[UILabel alloc] init];
    label.text = @"全选";
    label.font = [UIFont systemFontOfSize:12.0f*kScale];
    [self addSubview:label];
    
    //价格
    self.priceLabel = [[UILabel alloc]init];
    self.priceLabel.text = @"￥0.00";
    self.priceLabel.font = [UIFont boldSystemFontOfSize:12.0f*kScale];
    self.priceLabel.textColor = RGB(51, 51, 51, 1);
    self.priceLabel.textAlignment = NSTextAlignmentLeft;
    [self addSubview:self.priceLabel];
    
    
    
    //结算按钮
    
    self.PayBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.PayBtn.backgroundColor = [UIColor redColor];
    [self.PayBtn setTitle:@"下一步" forState:UIControlStateNormal];
    self.PayBtn.titleLabel.font = [UIFont systemFontOfSize:15.0f*kScale];
    //[btn addTarget:self action:@selector(goPayBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.PayBtn];
    
#pragma mark -- 底部视图添加约束
  
    
  
    //价格显示
    [self.priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(15*kScale);
        make.top.equalTo(self).offset(8*kScale);
        make.height.equalTo(@(12*kScale));
        make.right.equalTo(self.PayBtn.mas_left).with.offset(-5*kScale);
    }];
    
    //全选按钮
    [self.selectAll mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).with.offset(10*kScale);
        make.top.equalTo(self.priceLabel.mas_bottom).with.offset(0*kScale);
        make.height.equalTo(@(30*kScale));
        make.width.equalTo(@(30*kScale));
        
    }];
    
    //全选label
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.selectAll.mas_right).with.offset(5*kScale);
        make.top.equalTo(self.priceLabel.mas_bottom).with.offset(0*kScale);
        make.height.equalTo(@(30*kScale));
        make.width.equalTo(@(30*kScale));
        
    }];
    
    
    //结算按钮
    [self.PayBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self);
        make.right.equalTo(self);
        make.bottom.equalTo(self);
        make.width.equalTo(@(100*kScale));
        
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

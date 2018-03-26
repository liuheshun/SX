//
//  AddOrCutShoppingCartView.m
//  Emeat
//
//  Created by liuheshun on 2017/11/27.
//  Copyright © 2017年 liuheshun. All rights reserved.
//

#import "AddOrCutShoppingCartView.h"

@implementation AddOrCutShoppingCartView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setMainView];
    }
    return self;
}



// 数量加按钮
-(void)addBtnClickAction
{
    if (self.numAddBlock) {
        self.numAddBlock();
    }
}

//数量减按钮
-(void)cutBtnClickAction
{
    if (self.numCutBlock) {
        self.numCutBlock();
    }
}







-(void)setMainView{
    
    //数量加按钮
    UIButton *addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [addBtn setImage:[UIImage imageNamed:@"add"] forState:UIControlStateNormal];
    [addBtn setImage:[UIImage imageNamed:@"cart_addBtn_highlight"] forState:UIControlStateHighlighted];
    [addBtn addTarget:self action:@selector(addBtnClickAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:addBtn];
    self.addBtn = addBtn;
    
    //数量减按钮
    UIButton *cutBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [cutBtn setImage:[UIImage imageNamed:@"cut"] forState:UIControlStateNormal];
    [cutBtn setImage:[UIImage imageNamed:@"cart_cutBtn_highlight"] forState:UIControlStateHighlighted];
    [cutBtn addTarget:self action:@selector(cutBtnClickAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:cutBtn];
    
    //数量显示
    self.numberLabel = [[UILabel alloc]init];
    self.numberLabel.textAlignment = NSTextAlignmentCenter;
    self.numberLabel.text = @"1";
    self.numberLabel.font = [UIFont systemFontOfSize:15];
    [self addSubview:self.numberLabel];
    
    
    
    //数量加按钮
    [addBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(0);
        make.bottom.equalTo(self).offset(0);
        make.height.equalTo(@25);
        make.width.equalTo(@25);
    }];
    
    //数量显示
    [self.numberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(addBtn.mas_left);
        make.bottom.equalTo(addBtn);
        make.width.equalTo(@30);
        make.height.equalTo(addBtn);
    }];
    
    //数量减按钮
    [cutBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.numberLabel.mas_left);
        make.height.equalTo(addBtn);
        make.width.equalTo(addBtn);
        make.bottom.equalTo(addBtn);
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

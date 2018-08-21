//
//  ConfirmOrderInfoFootView.m
//  Emeat
//
//  Created by liuheshun on 2017/11/10.
//  Copyright © 2017年 liuheshun. All rights reserved.
//

#import "ConfirmOrderInfoFootView.h"

@implementation ConfirmOrderInfoFootView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.cardUseBtn];
        [self.cardUseBtn addSubview:self.cardPricesLab];
        [self addSubview:self.labelOrder];
        [self addSubview:self.labelOrderTotalPrice];
        [self addSubview:self.labelShipping];
        [self addSubview:self.labelShippingFee];
        [self addSubview:self.sliceLabPlaceholderLab];
        [self addSubview:self.sliceLab];
        [self addSubview:self.cardAddPricesPlaceholderLab];
        [self addSubview:self.cardAddPricesLab];
        [self setMainFrame];
    }
    return self;
}

-(void)configFootViewWithShoppingModel:(ShoppingCartModel*)model{
    
    if (model.ticketName) {
        [self.cardUseBtn setTitle:model.ticketName forState:0];

    }else{
        [self.cardUseBtn setTitle:@"优惠券" forState:0];

    }
    if (model.amount) {
         self.cardPricesLab.text = [NSString stringWithFormat:@"- %.2f" ,(CGFloat)model.amount/100];
    }else{
         self.cardPricesLab.text = @" ";
    }
   

    self.labelOrder.text = @"商品总价";
    self.labelShipping.text = @"配送费";
    self.sliceLabPlaceholderLab.text = @"加工耗材费";
    self.cardAddPricesPlaceholderLab.text = @"卡券抵扣";
    
    self.labelOrderTotalPrice.text = [NSString stringWithFormat:@"¥ %@" ,model.productTotalPrice];
    self.labelShippingFee.text = [NSString stringWithFormat:@"¥ %ld" ,model.postage];
    if (model.servicePrice) {
        self.sliceLab.text = [NSString stringWithFormat:@"¥ %@" ,model.servicePrice];
    }else{
        self.sliceLab.text = @"¥ 0";
    }
    
    ///卡券折扣
    if (model.amount) {
         self.cardAddPricesLab.text = [NSString stringWithFormat:@"¥ %.2f" ,(CGFloat)model.amount/100];
    }else{
        self.cardAddPricesLab.text = @"¥ 0";
    }
   
}

-(void)setMainFrame{
    
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 20*kScale, kWidth, 10*kScale)];
    topView.backgroundColor = RGB(238, 238, 238, 1);
    [self addSubview:topView];
    [self.cardUseBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).with.offset(15*kScale);
        make.top.equalTo(topView.mas_bottom).with.offset(0*kScale);
        make.width.equalTo(@(kWidth-15*kScale));
        make.height.equalTo(@(40*kScale));
    }];
    
    
    UIButton *enterBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [enterBtn setImage:[UIImage imageNamed:@"进入"] forState:0];
    enterBtn.frame = CGRectMake(kWidth-45*kScale, 0, 20*kScale, 40*kScale);
    [self.cardUseBtn addSubview:enterBtn];
    [self.cardPricesLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.cardUseBtn.mas_right).with.offset(-30*kScale);
        make.top.equalTo(self.cardUseBtn.mas_top).with.offset(0*kScale);
        make.width.equalTo(@(100*kScale));
        make.height.equalTo(@(40*kScale));
    }];
    
    
    UIView *bView = [[UIView alloc] initWithFrame:CGRectMake(0, 70*kScale, kWidth, 10*kScale)];
    bView.backgroundColor = RGB(238, 238, 238, 1);
    [self addSubview:bView];
    
    [self.labelOrder mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).with.offset(15*kScale);
        make.top.equalTo(bView.mas_bottom).with.offset(10*kScale);
        make.width.equalTo(@(100*kScale));
        make.height.equalTo(@(15*kScale));
    }];
    
    
    [self.labelOrderTotalPrice mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.labelOrder.mas_right).with.offset(10*kScale);
        make.top.equalTo(self.labelOrder);
        make.right.equalTo(self.mas_right).with.offset(-15*kScale);
        make.height.equalTo(@(15*kScale));
    }];
    
    [self.labelShipping mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.labelOrder);
        make.top.equalTo(self.labelOrder.mas_bottom).with.offset(15*kScale);
        make.width.equalTo(self.labelOrder);
        make.height.equalTo(self.labelOrder);
        
    }];
    
    [self.labelShippingFee mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.labelOrderTotalPrice);
        make.top.equalTo(self.labelOrder.mas_bottom).with.offset(15*kScale);
        make.right.equalTo(self.mas_right).with.offset(-15*kScale);
        make.height.equalTo(@(15*kScale));
    }];
    
    
    [self.sliceLabPlaceholderLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.labelOrder);
        make.top.equalTo(self.labelShippingFee.mas_bottom).with.offset(15*kScale);
        make.width.equalTo(self.labelOrder);
        make.height.equalTo(self.labelOrder);
        
    }];
    
    [self.sliceLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.labelOrderTotalPrice);
        make.top.equalTo(self.labelShippingFee.mas_bottom).with.offset(15*kScale);
        make.right.equalTo(self.mas_right).with.offset(-15*kScale);
        make.height.equalTo(@(15*kScale));
    }];
    
    
    
    
    [self.cardAddPricesPlaceholderLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.labelOrder);
        make.top.equalTo(self.sliceLab.mas_bottom).with.offset(15*kScale);
        make.width.equalTo(self.labelOrder);
        make.height.equalTo(self.labelOrder);
        
    }];
    
    [self.cardAddPricesLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.labelOrderTotalPrice);
        make.top.equalTo(self.sliceLab.mas_bottom).with.offset(15*kScale);
        make.right.equalTo(self.mas_right).with.offset(-15*kScale);
        make.height.equalTo(@(15*kScale));
    }];
    
}

-(UIButton *)cardUseBtn{
    if (_cardUseBtn == nil) {
        _cardUseBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _cardUseBtn.titleLabel.font = [UIFont systemFontOfSize:15.0f*kScale];
        _cardUseBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [_cardUseBtn setTitleColor:RGB(51, 51, 51, 1) forState:0];
        
    
        
    }
    return _cardUseBtn;
}

-(UILabel*)cardPricesLab{
    if (!_cardPricesLab) {
        _cardPricesLab = [[UILabel alloc] init];
        _cardPricesLab.textAlignment = NSTextAlignmentRight;
        _cardPricesLab.font = [UIFont systemFontOfSize:15.0f*kScale];
        _cardPricesLab.textColor = RGB(236, 31, 35, 1);
        
    }
    return _cardPricesLab;
}


-(UILabel*)labelOrder{
    if (!_labelOrder) {
        _labelOrder = [[UILabel alloc] init];
        _labelOrder.font = [UIFont systemFontOfSize:15.0f*kScale];
        _labelOrder.textColor = RGB(136, 136, 136, 1);

    }
    return _labelOrder;
}

-(UILabel*)labelOrderTotalPrice{
    if (!_labelOrderTotalPrice) {
        _labelOrderTotalPrice = [[UILabel alloc] init];
        _labelOrderTotalPrice.font = [UIFont systemFontOfSize:15.0f*kScale];
        _labelOrderTotalPrice.textAlignment = NSTextAlignmentRight;
        _labelOrderTotalPrice.textColor = RGB(136, 136, 136, 1);

    }
    return _labelOrderTotalPrice;
}


-(UILabel*)labelShipping{
    if (!_labelShipping) {
        _labelShipping = [[UILabel alloc] init];
        _labelShipping.font = [UIFont systemFontOfSize:15.0f*kScale];
        _labelShipping.textColor = RGB(136, 136, 136, 1);

    }
    return _labelShipping;
}


-(UILabel*)labelShippingFee{
    if (!_labelShippingFee) {
        _labelShippingFee = [[UILabel alloc] init];
        _labelShippingFee.font = [UIFont systemFontOfSize:15.0f*kScale];
        _labelShippingFee.textAlignment = NSTextAlignmentRight;
        _labelShippingFee.textColor = RGB(136, 136, 136, 1);
    }
    return _labelShippingFee;
}
///
-(UILabel*)sliceLabPlaceholderLab{
    if (!_sliceLabPlaceholderLab) {
        _sliceLabPlaceholderLab = [[UILabel alloc] init];
        _sliceLabPlaceholderLab.font = [UIFont systemFontOfSize:15.0f*kScale];
        _sliceLabPlaceholderLab.textColor = RGB(136, 136, 136, 1);
        
    }
    return _sliceLabPlaceholderLab;
}


-(UILabel*)sliceLab{
    if (!_sliceLab) {
        _sliceLab = [[UILabel alloc] init];
        _sliceLab.font = [UIFont systemFontOfSize:15.0f*kScale];
        _sliceLab.textAlignment = NSTextAlignmentRight;
        _sliceLab.textColor = RGB(136, 136, 136, 1);
    }
    return _sliceLab;
}
//卡券抵扣
-(UILabel*)cardAddPricesPlaceholderLab{
    if (!_cardAddPricesPlaceholderLab) {
        _cardAddPricesPlaceholderLab = [[UILabel alloc] init];
        _cardAddPricesPlaceholderLab.font = [UIFont systemFontOfSize:15.0f*kScale];
        _cardAddPricesPlaceholderLab.textColor = RGB(136, 136, 136, 1);
        
    }
    return _cardAddPricesPlaceholderLab;
}


-(UILabel*)cardAddPricesLab{
    if (!_cardAddPricesLab) {
        _cardAddPricesLab = [[UILabel alloc] init];
        _cardAddPricesLab.font = [UIFont systemFontOfSize:15.0f*kScale];
        _cardAddPricesLab.textAlignment = NSTextAlignmentRight;
        _cardAddPricesLab.textColor = RGB(136, 136, 136, 1);
    }
    return _cardAddPricesLab;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

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
        [self addSubview:self.labelOrder];
        [self addSubview:self.labelOrderTotalPrice];
        [self addSubview:self.labelShipping];
        [self addSubview:self.labelShippingFee];
        [self setMainFrame];
    }
    return self;
}

-(void)configFootViewWithShoppingModel:(ShoppingCartModel*)model{
    
    self.labelOrder.text = @"商品总价";
    self.labelShipping.text = @"配送费";
    self.labelOrderTotalPrice.text = [NSString stringWithFormat:@"¥ %@" ,model.productTotalPrice];
    self.labelShippingFee.text = [NSString stringWithFormat:@"¥ %ld" ,model.postage];
}

-(void)setMainFrame{
    
    [self.labelOrder mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).with.offset(15*kScale);
        make.top.equalTo(self.mas_top).with.offset(30*kScale);
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


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

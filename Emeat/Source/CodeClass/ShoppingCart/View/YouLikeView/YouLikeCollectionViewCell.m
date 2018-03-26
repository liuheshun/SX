//
//  YouLikeCollectionViewCell.m
//  Emeat
//
//  Created by liuheshun on 2017/11/17.
//  Copyright © 2017年 liuheshun. All rights reserved.
//

#import "YouLikeCollectionViewCell.h"

@implementation YouLikeCollectionViewCell

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUI];
    }
    return self;
}


-(void)SetCollCellData:(HomePageModel*)model{
    
    [self.imv sd_setImageWithURL:[NSURL URLWithString:model.mainImage]];
    self.nameLable.text = model.commodityName;
    self.priceLable.text = [NSString stringWithFormat:@"¥%.2f元/kg" , (float)model.unitPrice/100];
    
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:self.priceLable.text];
    [string addAttribute:NSForegroundColorAttributeName value:RGB(236, 31, 35, 1) range:NSMakeRange(0, string.length-4)];
    [string addAttribute:NSForegroundColorAttributeName value:RGB(136, 136, 136, 1) range:NSMakeRange(string.length-4, string.length - (string.length-4))];
    self.priceLable.attributedText = string;
    
    self.weightLable.text = model.size;
    
    CGFloat priceW = [GetWidthAndHeightOfString getWidthForText:self.priceLable height:15*kScale];
    CGFloat weightW = [GetWidthAndHeightOfString getWidthForText:self.weightLable height:15*kScale];
    [self.priceLable mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(10*kScale);
        make.top.equalTo(self.weightLable.mas_bottom).with.offset(5*kScale);
        make.height.equalTo(@(15*kScale));
        make.width.equalTo(@(priceW));
    }];
    
    [self.weightLable mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).with.offset(10*kScale);
        make.top.equalTo(self.nameLable.mas_bottom).with.offset(10*kScale);
        make.height.equalTo(@(15*kScale));
        make.width.equalTo(@(weightW));
    } ];
    
}




-(void)setUI{
    
        [self addSubview:self.imv];
        [self addSubview:self.nameLable];
        [self addSubview:self.priceLable];
        [self addSubview:self.weightLable];
        [self addSubview:self.joinCartBtn];
        [self setMainViewFrame];

}

-(UIImageView*)imv{
    if (!_imv) {
        _imv = [[UIImageView alloc] init];
        _imv.backgroundColor = [UIColor whiteColor];
    }
    return _imv;
}

-(UILabel*)nameLable{
    if (!_nameLable) {
        _nameLable = [[UILabel alloc] init];
        _nameLable.font = [UIFont systemFontOfSize:15.0f*kScale];
        _nameLable.textAlignment = NSTextAlignmentLeft;
        _nameLable.textColor = RGB(51, 51, 51, 1);


    }
    return _nameLable;
}

-(UILabel*)priceLable{
    if (!_priceLable) {
        _priceLable = [[UILabel alloc] init];
        _priceLable.font = [UIFont systemFontOfSize:15.0f*kScale];
        _priceLable.textColor = RGB(235, 31, 36, 1);
        _priceLable.textAlignment = NSTextAlignmentLeft;
    }
    return _priceLable;
}

-(UILabel*)weightLable{
    if (!_weightLable) {
        _weightLable = [[UILabel alloc] init];
        _weightLable.font = [UIFont systemFontOfSize:12.0f*kScale];
        _weightLable.textColor = RGB(138, 138, 138, 1);
        _weightLable.textAlignment = NSTextAlignmentLeft;

    }
    return _weightLable;
}

-(UIButton*)joinCartBtn{
    if (!_joinCartBtn) {
        _joinCartBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_joinCartBtn setImage:[UIImage imageNamed:@"join_cart_small"] forState:0];
    }
    return _joinCartBtn;
}

-(void)setMainViewFrame{
    
    [self.imv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(10*kScale);
        make.top.equalTo(self).offset(10*kScale);
        make.height.equalTo(@(100*kScale));
        make.right.equalTo(self).offset(-10*kScale);
    }];
    
    [self.nameLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(10*kScale);
        make.top.equalTo(self.imv.mas_bottom).offset(10*kScale);
        make.height.equalTo(@(15*kScale));
        make.right.equalTo(self).offset(0);
    }];
    
//    [self.priceLable mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self).offset(10);
//        make.top.equalTo(self.nameLable.mas_bottom).offset(10);
//        make.height.equalTo(@15);
//        make.width.equalTo(@60);
//    }];
//
//
//    [self.weightLable mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.priceLable.mas_right).offset(0);
//        make.top.equalTo(self.nameLable.mas_bottom).offset(10);
//        make.height.equalTo(@15);
//        make.width.equalTo(@40);
//    }];
//
//
//    [self.joinCartBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.right.equalTo(self).offset(-10);
//        make.bottom.equalTo(self.mas_bottom).offset(0);
//        make.height.equalTo(@20);
//        make.width.equalTo(@20);
//    }];
    
   
    
    
    [self.weightLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(10*kScale);
        make.top.equalTo(self.nameLable.mas_bottom).with.offset(10*kScale);
        make.height.equalTo(@(15*kScale));
        make.width.equalTo(@(70*kScale));
    }];
    
    [self.priceLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(10*kScale);
        make.top.equalTo(self.weightLable.mas_bottom).with.offset(5*kScale);
        make.height.equalTo(@(15*kScale));
        make.width.equalTo(@(80*kScale));
    }];
    
    [self.joinCartBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).with.offset(-10*kScale);
        make.bottom.equalTo(self.mas_bottom).offset(-10*kScale);
        make.height.equalTo(@(40*kScale));
        make.width.equalTo(@(40*kScale));
    }];
    
    
    
    
    
}






@end

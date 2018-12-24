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
    
    [self.imv sd_setImageWithURL:[NSURL URLWithString:model.mainImage] placeholderImage:[UIImage imageNamed:@"列表图加载"]];
    self.nameLable.text = model.commodityName;
    
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    
    if ([[user valueForKey:@"approve"] isEqualToString:@"1"]) {//商户已认证
        if ([model.priceTypes isEqualToString:@"WEIGHT"]) {
            if (model.discountPrice == -1) {///只显示原价
                
                [self.newsPriceBtn setTitle:[NSString stringWithFormat:@"%.2f元/kg",(float)model.costPrice/100] forState:0];
                [self.oldPriceBtn setTitle:@"" forState:0];

            }else{
                [self.newsPriceBtn setTitle:[NSString stringWithFormat:@"%.2f元/kg",(float)model.unitPrice/100] forState:0];
                [self.oldPriceBtn setTitle:[NSString stringWithFormat:@"%.2f元/kg",(float)model.costPrice/100] forState:0];
            }
            
        }else{
            
            
            if (model.discountPrice == -1) {///只显示原价
                
                [self.newsPriceBtn setTitle:[NSString stringWithFormat:@"%.2f元/件",(float)model.costPrice/100] forState:0];
                [self.oldPriceBtn setTitle:@"" forState:0];

            }else{
                [self.newsPriceBtn setTitle:[NSString stringWithFormat:@"%.2f元/件",(float)model.unitPrice/100] forState:0];
                [self.oldPriceBtn setTitle:[NSString stringWithFormat:@"%.2f元/件",(float)model.costPrice/100] forState:0];
            }
            
            
            
        }
        
        
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:self.newsPriceBtn.titleLabel.text];
        NSRange range1 = [[str string] rangeOfString:[NSString stringWithFormat:@"%.2f" ,(float)model.unitPrice/100]];
        [str addAttribute:NSForegroundColorAttributeName value:RGB(236, 31, 35, 1) range:range1];
        
        [self.newsPriceBtn setAttributedTitle:str forState:UIControlStateNormal];
        
        
        
        
        
        
        
    }else{//商户未认证
        
        
        if (model.discountPrice == -1) {///只显示原价
            
            [self.newsPriceBtn setTitle:@"查看价格" forState:0];
            [self.oldPriceBtn setTitle:@"" forState:0];

        }else{
            
            [self.newsPriceBtn setTitle:@"查看价格" forState:0];
            [self.oldPriceBtn setTitle:@"原价" forState:0];
            
        }
        
        
        
        
        
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:self.newsPriceBtn.titleLabel.text];
        NSRange range1 = [[str string] rangeOfString:self.newsPriceBtn.titleLabel.text];
        [str addAttribute:NSForegroundColorAttributeName value:RGB(236, 31, 35, 1) range:range1];
        
        
        [self.newsPriceBtn setAttributedTitle:str forState:UIControlStateNormal];
        
    }
    
    
    
    
    self.weightLable.text = model.size;
    
    CGFloat priceW = [GetWidthAndHeightOfString getWidthForText:self.newsPriceBtn height:15*kScale];
    CGFloat oldpriceW = [GetWidthAndHeightOfString getWidthForText:self.oldPriceBtn height:15*kScale];
    
    CGFloat weightW = [GetWidthAndHeightOfString getWidthForText:self.weightLable height:15*kScale];
    
    
    [self.newsPriceBtn mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(10*kScale);
        make.top.equalTo(self.weightLable.mas_bottom).with.offset(5*kScale);
        make.height.equalTo(@(15*kScale));
        make.width.equalTo(@(priceW));
    }];
    [self.oldPriceBtn mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(10*kScale);
        
        make.bottom.equalTo(self.mas_bottom).with.offset(-2*kScale);
        //        make.top.equalTo(self.newsPriceBtn.mas_bottom).with.offset(5*kScale);
        make.height.equalTo(@(15*kScale));
        make.width.equalTo(@(oldpriceW));
    }];
    
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 7*kScale, oldpriceW, 1)];
    lineView.backgroundColor = RGB(136, 136, 136, 1);
    
    if (model.discountPrice == -1) {///只显示原价
        [lineView removeFromSuperview];
        
        [self.joinCartBtn mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.mas_bottom).offset(-8*kScale);
        
        }];
        
        
    }else{
        [self.oldPriceBtn addSubview:lineView];
        
        [self.joinCartBtn mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.mas_bottom).offset(-5*kScale);
        }];
    }
    
    [self.weightLable mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).with.offset(10*kScale);
        make.top.equalTo(self.nameLable.mas_bottom).with.offset(10*kScale);
        make.height.equalTo(@(15*kScale));
        make.width.equalTo(@(weightW));
    } ];
    
}


-(void)setUI{
    
    [self addSubview:self.imv];
    [self addSubview:self.nameLable];
    [self addSubview:self.newsPriceBtn];
    [self addSubview:self.oldPriceBtn];
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

-(UIButton*)newsPriceBtn{
    if (!_newsPriceBtn) {
        _newsPriceBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _newsPriceBtn.titleLabel.font = [UIFont systemFontOfSize:15.0f*kScale];
        [_newsPriceBtn setTitleColor:RGB(136, 136, 136, 1) forState:0];
        _newsPriceBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    }
    return _newsPriceBtn;
}


-(UIButton*)oldPriceBtn{
    if (!_oldPriceBtn) {
        _oldPriceBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _oldPriceBtn.titleLabel.font = [UIFont systemFontOfSize:15.0f*kScale];
        [_oldPriceBtn setTitleColor:RGB(136, 136, 136, 1) forState:0];
        _oldPriceBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    }
    return _oldPriceBtn;
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
    
    [self.newsPriceBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(10*kScale);
        make.top.equalTo(self.weightLable.mas_bottom).with.offset(5*kScale);
        make.height.equalTo(@(15*kScale));
        make.width.equalTo(@(80*kScale));
    }];
    
    
    [self.oldPriceBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(10*kScale);
        make.top.equalTo(self.newsPriceBtn.mas_bottom).with.offset(5*kScale);
        make.height.equalTo(@(15*kScale));
        make.width.equalTo(@(135*kScale));
    }];
    
    
    
    
    
    
    
    [self.joinCartBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).with.offset(0*kScale);
        make.bottom.equalTo(self.mas_bottom).offset(-8*kScale);
        make.height.equalTo(@(40*kScale));
        make.width.equalTo(@(40*kScale));
    }];
    
    
    
    
    
}






@end

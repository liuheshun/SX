//
//  HomePageTableViewCell.m
//  Emeat
//
//  Created by liuheshun on 2017/11/20.
//  Copyright © 2017年 liuheshun. All rights reserved.
//

#import "HomePageTableViewCell.h"

@implementation HomePageTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self addSubview:self.mainImv];
        [self addSubview:self.lableBtn];
        [self addSubview:self.nameLab];
        [self addSubview:self.descLab];
        [self addSubview:self.weightLab];
        [self addSubview:self.pricelab];
        [self addSubview:self.cartBtn];
        [self setMainViewFrame];
    
        
    }
    return self;
}

-(void)configHomePageCellWithModel:(HomePageModel *)model{
    
    [self.mainImv sd_setImageWithURL:[NSURL URLWithString:model.mainImage]];
    [self.mainImv sd_setImageWithURL:[NSURL URLWithString:model.mainImage] placeholderImage:[UIImage imageNamed:@"列表图加载"]];
    
    self.nameLab.text = model.commodityName;
    self.descLab.text = model.commodityDesc;
  
    CGFloat hDesc =   [GetWidthAndHeightOfString getHeightForText:self.descLab width:kWidth -(115+21+21+15)*kScale];
    
    [self.descLab mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(hDesc));
    }];
    
    
    self.weightLab.text = model.size;
    self.pricelab.text =[NSString stringWithFormat:@"%.2f元/kg",(float)model.unitPrice/100];
    
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:self.pricelab.text];
    
    [string addAttribute:NSForegroundColorAttributeName value:RGB(236, 31, 35, 1) range:NSMakeRange(0, string.length-4)];
    
    [string addAttribute:NSForegroundColorAttributeName value:RGB(136, 136, 136, 1) range:NSMakeRange(string.length-4, string.length - (string.length-4))];
    
    self.pricelab.attributedText = string;
        
    if ([model.commodityMark isEqualToString:@"热销"]) {
        [self.lableBtn setImage:[UIImage imageNamed:@"rexiao"] forState:0];

    }else if ([model.commodityMark isEqualToString:@"新品"]){
        [self.lableBtn setImage:[UIImage imageNamed:@"NEW"] forState:0];

    }else if ([model.commodityMark isEqualToString:@"特惠"]){
        [self.lableBtn setImage:[UIImage imageNamed:@"tehui"] forState:0];

    }else if ([model.commodityMark isEqualToString:@"试样"]){
        [self.lableBtn setImage:[UIImage imageNamed:@"试样"] forState:0];

    }
    else {
        [self.lableBtn setImage:[UIImage imageNamed:@"wu"] forState:0];

    }
    self.cartView.numberLabel.text =[NSString stringWithFormat:@"%ld" ,model.number];
    
    [self.cartBtn setImage:[UIImage imageNamed:@"join_cart"] forState:0];

//    后期可能会有此需求(商品首页回显加入购物车数量)
//    if (model.number == 0) {
//        [self.cartView removeFromSuperview];
//        [self addSubview:self.cartBtn];
//        [self.cartBtn setImage:[UIImage imageNamed:@"join_cart"] forState:0];
//
//        [self.cartBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.bottom.equalTo(self.mainImv.mas_bottom).with.offset(0);
//            make.right.equalTo(self.mas_right).with.offset(-15);
//            make.height.width.equalTo(@40);
//        }];
//    }else{
//        [self.cartBtn removeFromSuperview];
//        [self addSubview:self.cartView];
//        [self setCartViewFrame];
//    }
   
}

-(AddOrCutShoppingCartView *)cartView{
    if (!_cartView) {
        _cartView = [[AddOrCutShoppingCartView alloc] init];
        
    }
    return _cartView;
}

-(void)setCartViewFrames{
   
    [self.cartView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).with.offset(-15*kScale);
        make.bottom.equalTo(self.mainImv).with.offset(0);
        make.width.equalTo(@(100*kScale));
        make.height.equalTo(@(30*kScale));
    }];
}



-(UIButton*)lableBtn{
    if (!_lableBtn) {
        _lableBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    }
    return _lableBtn;
}

-(UIImageView*)mainImv{
    if (!_mainImv) {
        _mainImv = [[UIImageView alloc] init];
    }
    return _mainImv;
}


-(UILabel*)nameLab{
    if (!_nameLab) {
        _nameLab = [[UILabel alloc] init];
        _nameLab.font = [UIFont systemFontOfSize:15.0f*kScale];
        _nameLab.textColor = RGB(51, 51, 51, 1);
        
    }
    return _nameLab;
}

-(UILabel*)descLab{
    if (!_descLab) {
        _descLab = [[UILabel alloc] init];
        _descLab.font = [UIFont systemFontOfSize:12.0f*kScale];
        _descLab.numberOfLines = 2;
        _descLab.textColor = RGB(136, 136, 136, 1);
    }
    return _descLab;
}

-(UILabel*)weightLab{
    if (!_weightLab) {
        _weightLab = [[UILabel alloc] init];
        _weightLab.font = [UIFont systemFontOfSize:12.0f*kScale];
        _weightLab.textColor = RGB(136, 136, 136, 1);
    }
    return _weightLab;
}


-(UILabel*)pricelab{
    if (!_pricelab) {
        _pricelab = [[UILabel alloc] init];
        _pricelab.font = [UIFont systemFontOfSize:12.0f*kScale];
        _pricelab.textColor = RGB(236, 31, 35, 1);
    }
    return _pricelab;
}


-(UIButton*)cartBtn{
    if (!_cartBtn) {
        _cartBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    }
    return _cartBtn;
}







-(void)setMainViewFrame{
   
    [self.mainImv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).with.offset(21*kScale);
        make.top.equalTo(self.mas_top).with.offset(12*kScale);
        make.width.equalTo(@(115*kScale));
        make.height.equalTo(@(100*kScale));
    }];
    
    [self.lableBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mainImv.mas_left).with.offset(-6*kScale);
        make.top.equalTo(self.mainImv.mas_top).with.offset(-10*kScale);
        make.height.equalTo(@(46*kScale));
        make.width.equalTo(@(31*kScale));

    }];
    
    
    
    [self.nameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mainImv.mas_right).with.offset(21*kScale);
        make.top.equalTo(self.mainImv.mas_top).with.offset(0);
        make.right.equalTo(self.mas_right).with.offset(-15*kScale);
        make.height.equalTo(@(16*kScale));
    }];
    
    [self.descLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mainImv.mas_right).with.offset(21*kScale);
        make.top.equalTo(self.nameLab.mas_bottom).with.offset(8*kScale);
        make.right.equalTo(self.mas_right).with.offset(-15*kScale);
        make.height.equalTo(@(13*kScale));
    }];
    
    [self.weightLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mainImv.mas_right).with.offset(21*kScale);
        make.top.equalTo(self.descLab.mas_bottom).with.offset(13*kScale);
        make.right.equalTo(self.mas_right).with.offset(-15*kScale);
        make.height.equalTo(@(13*kScale));
    }];
    
    [self.pricelab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mainImv.mas_right).with.offset(21*kScale);
        make.bottom.equalTo(self.mainImv.mas_bottom).with.offset(0);
        make.right.equalTo(self.mas_right).with.offset(-15*kScale);
        make.height.equalTo(@(16*kScale));
    }];
    [self.cartBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.mainImv.mas_bottom).with.offset(0);
        make.right.equalTo(self.mas_right).with.offset(-15*kScale);
        make.height.width.equalTo(@(40*kScale));
    }];
}






@end

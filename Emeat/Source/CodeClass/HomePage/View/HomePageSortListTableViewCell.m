//
//  HomePageSortListTableViewCell.m
//  Emeat
//
//  Created by liuheshun on 2018/8/3.
//  Copyright © 2018年 liuheshun. All rights reserved.
//

#import "HomePageSortListTableViewCell.h"

@implementation HomePageSortListTableViewCell

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

-(void)configCellWithModel:(HomePageModel *)model{
    
    //[self.mainImv sd_setImageWithURL:[NSURL URLWithString:model.mainImage]];
    [self.mainImv sd_setImageWithURL:[NSURL URLWithString:model.mainImage] placeholderImage:[UIImage imageNamed:@"列表图加载"]];
    
    self.nameLab.text = model.commodityName;
    self.descLab.text = model.commodityDesc;
    
//    CGFloat hDesc =   [GetWidthAndHeightOfString getHeightForText:self.descLab width:kWidth -(115+21+21+15)*kScale];
//
//    [self.descLab mas_updateConstraints:^(MASConstraintMaker *make) {
//        make.height.equalTo(@(hDesc));
//    }];
    
    
    self.weightLab.text = model.size;
    
    if ([model.priceTypes isEqualToString:@"WEIGHT"]) {
        self.pricelab.text =[NSString stringWithFormat:@"%.2f元/kg",(float)model.unitPrice/100];
    }else{
        self.pricelab.text =[NSString stringWithFormat:@"%.2f元/件",(float)model.unitPrice/100];
    }
    
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:self.pricelab.text];
    NSRange range1 = [[str string] rangeOfString:[NSString stringWithFormat:@"%.2f" ,(float)model.unitPrice/100]];
    [str addAttribute:NSForegroundColorAttributeName value:RGB(236, 31, 35, 1) range:range1];
    
    self.pricelab.attributedText = str;
    
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
    if (model.number) {
        self.cartView.numberLabel.text =[NSString stringWithFormat:@"%ld" ,model.number];
        
    }
    
    [self.cartBtn setImage:[UIImage imageNamed:@"join_cart"] forState:0];
    
  
    
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
        _descLab.numberOfLines = 1;
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
        _pricelab.textColor = RGB(136, 136, 136, 1);
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
        make.left.equalTo(self.mas_left).with.offset(10*kScale);
        make.top.equalTo(self.mas_top).with.offset(15*kScale);
        make.width.equalTo(@(80*kScale));
        make.height.equalTo(@(70*kScale));
    }];
    
    [self.lableBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mainImv.mas_left).with.offset(-6*kScale);
        make.top.equalTo(self.mainImv.mas_top).with.offset(-10*kScale);
        make.height.equalTo(@(46*kScale));
        make.width.equalTo(@(31*kScale));
        
    }];
    
    
    
    [self.nameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mainImv.mas_right).with.offset(10*kScale);
        make.top.equalTo(self.mainImv.mas_top).with.offset(0);
        make.right.equalTo(self.mas_right).with.offset(-15*kScale);
        make.height.equalTo(@(16*kScale));
    }];
    
    [self.descLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mainImv.mas_right).with.offset(10*kScale);
        make.top.equalTo(self.nameLab.mas_bottom).with.offset(5*kScale);
        make.right.equalTo(self.mas_right).with.offset(-15*kScale);
        make.height.equalTo(@(13*kScale));
    }];
    
    [self.weightLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mainImv.mas_right).with.offset(10*kScale);
        make.top.equalTo(self.descLab.mas_bottom).with.offset(5*kScale);
        make.right.equalTo(self.mas_right).with.offset(-15*kScale);
        make.height.equalTo(@(13*kScale));
    }];
    
    [self.pricelab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mainImv.mas_right).with.offset(10*kScale);
        make.bottom.equalTo(self.mainImv.mas_bottom).with.offset(0);
        make.right.equalTo(self.mas_right).with.offset(-15*kScale);
        make.height.equalTo(@(16*kScale));
    }];
    [self.cartBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.mainImv.mas_bottom).with.offset(10);
        make.right.equalTo(self.mas_right).with.offset(-15*kScale);
        make.height.width.equalTo(@(40*kScale));
    }];
}





- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

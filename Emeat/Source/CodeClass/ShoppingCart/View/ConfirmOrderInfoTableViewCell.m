//
//  ConfirmOrderInfoTableViewCell.m
//  Emeat
//
//  Created by liuheshun on 2017/11/10.
//  Copyright © 2017年 liuheshun. All rights reserved.
//

#import "ConfirmOrderInfoTableViewCell.h"

@implementation ConfirmOrderInfoTableViewCell
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self addSubview:self.mainImageView];
        [self addSubview:self.nameLab];
        [self addSubview:self.weightSizeLab];
        [self addSubview:self.countLab];
        [self addSubview:self.newspriceLab];
        [self addSubview:self.oldPricesLab];
        [self addSubview:self.allPricesLab];
        [self setMainViewFrame];

    }
    return self;
}


-(void)configWithShoppingModel:(ShoppingCartModel*)model{

    [self.mainImageView sd_setImageWithURL:[NSURL URLWithString:model.mainImage] placeholderImage:[UIImage imageNamed:@"small_placeholder"] options:SDWebImageDelayPlaceholder];
    
    self.nameLab.text = model.productName;
     if ([model.businessType isEqualToString:@"C"] ){///个人专区
        self.weightSizeLab.text = model.standardSize;

     }else{///商户
         self.weightSizeLab.text = model.productSize;
         
     }
    
    self.countLab.text = [NSString stringWithFormat:@"x %ld" ,(long)model.quantity];
    
    
    if (model.discountPrice == -1) {///只显示原价
        
        self.newspriceLab.text = [NSString stringWithFormat:@"¥ %@元" ,model.costPrice];
        self.oldPricesLab.text = @"";
        
    }else{
        
        self.newspriceLab.text = [NSString stringWithFormat:@" %@元" ,model.currentUnitPrice];
        self.oldPricesLab.text = [NSString stringWithFormat:@"¥ %@元" ,model.costPrice];
    }
    
    
  
    self.allPricesLab.text = [NSString stringWithFormat:@"%@元" ,model.totalPrice];
    

    [self.newspriceLab mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@([GetWidthAndHeightOfString getWidthForText:self.newspriceLab height:12.0f*kScale]));
    }];
    
    [self.oldPricesLab mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@([GetWidthAndHeightOfString getWidthForText:self.oldPricesLab height:12.0f*kScale]));
        make.left.equalTo(self.newspriceLab.mas_right).with.offset(10*kScale);

    }];
    
    if (model.discountPrice == -1) {///只显示原价
        
    }else{
        UIView*lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 5.5*kScale, [GetWidthAndHeightOfString getWidthForText:self.oldPricesLab height:12.0f*kScale], 1)];
        lineView.backgroundColor = RGB(136, 136, 136, 1);
        [self.oldPricesLab addSubview:lineView];
        
    }
   
    [self.allPricesLab mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@([GetWidthAndHeightOfString getWidthForText:self.allPricesLab height:12.0f*kScale]));
        
    }];
    
}



-(void)setMainViewFrame{
    
    [self.mainImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).with.offset(15*kScale);
        make.top.equalTo(self.mas_top).with.offset(0);
        make.width.equalTo(@(70*kScale));
        make.height.equalTo(@(55*kScale));

    }];
    
    
    [self.nameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mainImageView.mas_right).with.offset(5*kScale);
        make.top.equalTo(self.mainImageView);
        make.right.equalTo(self.mas_right).with.offset(-15*kScale);
        make.height.equalTo(@(12*kScale));
    }];
    
    [self.weightSizeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mainImageView.mas_right).with.offset(5*kScale);
        make.top.equalTo(self.nameLab.mas_bottom).with.offset(5*kScale);
        make.right.equalTo(self.mas_right).with.offset(-15*kScale);
        make.height.equalTo(@(12*kScale));
        
    }];
    
    [self.newspriceLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mainImageView.mas_right).with.offset(5*kScale);
        make.width.equalTo(@(100*kScale));
        make.height.equalTo(@(12*kScale));
        make.bottom.equalTo(self.mainImageView.mas_bottom).with.offset(0);
    }];
    
    [self.oldPricesLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.newspriceLab.mas_right).with.offset(5*kScale);
        make.width.equalTo(@(100*kScale));
        make.height.equalTo(@(12*kScale));
        make.bottom.equalTo(self.mainImageView.mas_bottom).with.offset(0*kScale);
    }];
    
    
    [self.countLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).with.offset(240*kScale);
        make.width.equalTo(@(45*kScale));
        make.height.equalTo(@(12*kScale));
        make.bottom.equalTo(self.mainImageView.mas_bottom).with.offset(0*kScale);
    }];
    
    [self.allPricesLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).with.offset(-15*kScale);
        make.width.equalTo(@(100*kScale));
        make.height.equalTo(@(12*kScale));
        make.bottom.equalTo(self.mainImageView.mas_bottom).with.offset(0*kScale);
    }];
    
}


-(UIImageView *)mainImageView{
    if (_mainImageView == nil) {
        _mainImageView = [[UIImageView alloc] init];
    }
    return _mainImageView;
}

-(UILabel *)weightSizeLab{
    if (_weightSizeLab == nil) {
        _weightSizeLab = [UILabel new];
        _weightSizeLab.textAlignment = NSTextAlignmentLeft;
        _weightSizeLab.font = [UIFont systemFontOfSize:11.0f*kScale];
        _weightSizeLab.textColor = RGB(136, 136, 136, 136);

    }
    return _weightSizeLab;
}

-(UILabel *)oldPricesLab{
    if (_oldPricesLab == nil) {
        _oldPricesLab = [UILabel new];
        _oldPricesLab.textAlignment = NSTextAlignmentCenter;
        _oldPricesLab.font = [UIFont systemFontOfSize:11.0f*kScale];
        _oldPricesLab.textColor = RGB(136, 136, 136, 136);
    }
    return _oldPricesLab;
}


-(UILabel*)nameLab{
    if (!_nameLab) {
        _nameLab = [[UILabel alloc] init];
        _nameLab.font = [UIFont systemFontOfSize:11.0f*kScale];
        _nameLab.textColor = RGB(51, 51, 51, 1);
        _nameLab.textAlignment = NSTextAlignmentLeft;

    }
    return _nameLab;
}

-(UILabel*)countLab{
    if (!_countLab) {
        _countLab = [[UILabel alloc] init];
        _countLab.font = [UIFont systemFontOfSize:11.0f*kScale];
        _countLab.textColor = RGB(51, 51, 51, 1);
        _countLab.textAlignment = NSTextAlignmentLeft;


        
    }
    return _countLab;
}

-(UILabel*)newspriceLab{
    if (!_newspriceLab) {
        _newspriceLab = [[UILabel alloc] init];
        _newspriceLab.font = [UIFont systemFontOfSize:11.0f*kScale];
        _newspriceLab.textAlignment = NSTextAlignmentLeft;
        _newspriceLab.textColor = RGB(231, 35, 36, 1);

    }
    return _newspriceLab;
}

-(UILabel*)allPricesLab{
    if (!_allPricesLab) {
        _allPricesLab = [[UILabel alloc] init];
        _allPricesLab.font = [UIFont systemFontOfSize:11.0f*kScale];
        _allPricesLab.textAlignment = NSTextAlignmentRight;
        _allPricesLab.textColor = RGB(231, 35, 36, 1);
        
    }
    return _allPricesLab;
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

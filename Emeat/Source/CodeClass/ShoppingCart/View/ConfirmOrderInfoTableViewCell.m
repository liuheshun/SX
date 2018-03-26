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
        [self addSubview:self.nameLab];
        [self addSubview:self.countLab];
        [self addSubview:self.priceLab];
        [self setMainViewFrame];

    }
    return self;
}


-(void)configWithShoppingModel:(ShoppingCartModel*)model{
    
    self.nameLab.text = model.productName;
    self.countLab.text = [NSString stringWithFormat:@"x %ld" ,model.quantity];
    self.priceLab.text = [NSString stringWithFormat:@"¥ %@" ,model.totalPrice];
    
}



-(void)setMainViewFrame{
    [self.nameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).with.offset(15*kScale);
        make.top.equalTo(self.mas_top).with.offset(0);
        make.width.equalTo(@(200*kScale));
        make.height.equalTo(self);
    }];
    
    [self.countLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameLab.mas_right).with.offset(5*kScale);
        make.top.equalTo(self.mas_top).with.offset(0);
        make.width.equalTo(@(50*kScale));
        make.height.equalTo(self);
    }];
    
    [self.priceLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).with.offset(-15*kScale);
        make.top.equalTo(self);
        make.width.equalTo(@(90*kScale));
        make.height.equalTo(self);
    }];
}
-(UILabel*)nameLab{
    if (!_nameLab) {
        _nameLab = [[UILabel alloc] init];
        _nameLab.font = [UIFont systemFontOfSize:15.0f*kScale];
        _nameLab.textColor = RGB(51, 51, 51, 1);
    }
    return _nameLab;
}

-(UILabel*)countLab{
    if (!_countLab) {
        _countLab = [[UILabel alloc] init];
        _countLab.font = [UIFont systemFontOfSize:15.0f*kScale];
        _countLab.textColor = RGB(51, 51, 51, 1);

        
    }
    return _countLab;
}

-(UILabel*)priceLab{
    if (!_priceLab) {
        _priceLab = [[UILabel alloc] init];
        _priceLab.font = [UIFont systemFontOfSize:15.0f*kScale];
        _priceLab.textAlignment = NSTextAlignmentRight;
        _priceLab.textColor = RGB(51, 51, 51, 1);

    }
    return _priceLab;
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

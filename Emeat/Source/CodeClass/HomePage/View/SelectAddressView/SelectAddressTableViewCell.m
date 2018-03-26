//
//  SelectAddressTableViewCell.m
//  Emeat
//
//  Created by liuheshun on 2017/12/11.
//  Copyright © 2017年 liuheshun. All rights reserved.
//

#import "SelectAddressTableViewCell.h"

@implementation SelectAddressTableViewCell

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.nameLab];
        [self addSubview:self.phoneNumLab];
        [self addSubview:self.addressType];
        [self addSubview:self.addressLab];
    }
    return self;
}

-(UILabel *)nameLab{
    if (!_nameLab) {
        _nameLab = [[UILabel alloc] initWithFrame:CGRectMake(15*kScale, 15*kScale, 80*kScale, 15*kScale)];
        _nameLab.font = [UIFont systemFontOfSize:12.0f];
    }
    return _nameLab;
}


-(UILabel *)phoneNumLab{
    if (!_phoneNumLab) {
        _phoneNumLab = [[UILabel alloc] initWithFrame:CGRectMake(MaxX(self.nameLab)+35*kScale, 15*kScale, 90*kScale, 15*kScale)];
        _phoneNumLab.font = [UIFont systemFontOfSize:12.0f];
    }
    return _phoneNumLab;
}


-(UILabel *)addressType{
    if (!_addressType) {
        _addressType = [[UILabel alloc] initWithFrame:CGRectMake(X(self.nameLab), MaxY(self.nameLab)+13*kScale, 35*kScale, 19*kScale)];
        _addressType.font = [UIFont systemFontOfSize:12.0f];
        _addressType.backgroundColor = RGB(231, 35, 36, 1);
        _addressType.layer.cornerRadius = 4;
        _addressType.layer.masksToBounds = YES;
    }
    return _addressType;
}


-(UILabel *)addressLab{
    if (!_addressLab) {
        _addressLab = [[UILabel alloc] initWithFrame:CGRectMake(MaxX(self.addressType), MaxY(self.nameLab)+15*kScale, 35*kScale, 300*kScale)];
        _addressLab.font = [UIFont systemFontOfSize:12.0f];
    }
    return _addressLab;
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

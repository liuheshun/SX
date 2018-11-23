//
//  SearchLocationAddressTableViewCell.m
//  Emeat
//
//  Created by liuheshun on 2018/11/16.
//  Copyright © 2018年 liuheshun. All rights reserved.
//

#import "SearchLocationAddressTableViewCell.h"

@implementation SearchLocationAddressTableViewCell



-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self addSubview:self.addressDetailLab];
        [self addSubview:self.addressLab];
    }
    return self;
}

-(UILabel *)addressDetailLab{
    if (_addressDetailLab == nil) {
        _addressDetailLab = [[UILabel alloc] initWithFrame:CGRectMake(15*kScale, 10*kScale, kWidth-30*kScale, 20*kScale)];
        _addressDetailLab.textColor = RGB(51, 51, 51, 1);
        _addressDetailLab.textAlignment = NSTextAlignmentLeft;
        _addressDetailLab.font = [UIFont systemFontOfSize:15.0f*kScale];
    }
    return _addressDetailLab;
}


-(UILabel *)addressLab{
    if (_addressLab == nil) {
        _addressLab = [[UILabel alloc] initWithFrame:CGRectMake(15*kScale, MaxY(self.addressDetailLab)+5*kScale, kWidth-30*kScale, 20*kScale)];
        _addressLab.textColor = RGB(136, 136, 136, 1);
        _addressLab.textAlignment = NSTextAlignmentLeft;
        _addressLab.font = [UIFont systemFontOfSize:12.0f*kScale];
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

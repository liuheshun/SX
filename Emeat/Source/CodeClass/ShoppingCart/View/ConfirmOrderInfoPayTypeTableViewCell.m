//
//  ConfirmCartInfoPayTypeTableViewCell.m
//  Emeat
//
//  Created by liuheshun on 2017/11/9.
//  Copyright © 2017年 liuheshun. All rights reserved.
//

#import "ConfirmOrderInfoPayTypeTableViewCell.h"

@implementation ConfirmOrderInfoPayTypeTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self addSubview:self.payTypeBtn];
        [self addSubview:self.roundPayBtn];
    }
    return self;
}

-(UIButton*)payTypeBtn{
    if (!_payTypeBtn) {
        _payTypeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _payTypeBtn.frame  = CGRectMake(0, 0, kWidth, 50*kScale);
        _payTypeBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        _payTypeBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 15*kScale, 0, 0);
        _payTypeBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 25, 0, 0);
        [_payTypeBtn setTitleColor:[UIColor blackColor] forState:0];
    }
    return _payTypeBtn;
}

-(UIButton*)roundPayBtn{
    if (!_roundPayBtn) {
        _roundPayBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _roundPayBtn.frame  = CGRectMake(kWidth-35*kScale, 16*kScale, 20*kScale, 20*kScale);
    }
    return _roundPayBtn;
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

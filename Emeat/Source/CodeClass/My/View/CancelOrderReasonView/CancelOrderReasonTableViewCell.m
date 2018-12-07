//
//  CancelOrderReasonTableViewCell.m
//  Emeat
//
//  Created by liuheshun on 2018/11/14.
//  Copyright © 2018年 liuheshun. All rights reserved.
//

#import "CancelOrderReasonTableViewCell.h"

@implementation CancelOrderReasonTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self addSubview:self.payTypeBtn];
        [self addSubview:self.roundPayBtn];
    }
    return self;
}



-(void)configSelectStated:(ShoppingCartModel *)model{
    
    if (model.productChecked == 0){
        
        [self.roundPayBtn setImage:[UIImage imageNamed:@"no_selected"] forState:UIControlStateNormal];
    }else if (model.productChecked == 1){
        [self.roundPayBtn setImage:[UIImage imageNamed:@"selected"] forState:UIControlStateNormal];
    }

    
}

-(UIButton*)payTypeBtn{
    if (!_payTypeBtn) {
        _payTypeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _payTypeBtn.frame  = CGRectMake(15*kScale, 0, kWidth-60*kScale, 30*kScale);
        [_payTypeBtn setTitleColor:RGB(51, 51, 51, 1) forState:0];
        _payTypeBtn.titleLabel.font = [UIFont systemFontOfSize:13.0f*kScale];
        _payTypeBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        
    }
    return _payTypeBtn;
}

-(UIButton*)roundPayBtn{
    if (!_roundPayBtn) {
        _roundPayBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _roundPayBtn.frame  = CGRectMake(kWidth-75*kScale, 0*kScale, 30*kScale, 30*kScale);
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

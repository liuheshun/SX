//
//  SaleMoneyTableViewCell.m
//  Emeat
//
//  Created by liuheshun on 2018/8/28.
//  Copyright © 2018年 liuheshun. All rights reserved.
//

#import "SaleMoneyTableViewCell.h"

@implementation SaleMoneyTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setFrames];
    }
    return self;
}



-(void)setFrames{
    
    self.topImv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"推手"]];
    [self addSubview:self.topImv];
    [self.topImv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.top.equalTo(self);
        make.height.equalTo(@(430*kScale));
        
    }];
    
    self.enterSaleWeb = [UIButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:self.enterSaleWeb];
    self.enterSaleWeb.titleLabel.font = [UIFont systemFontOfSize:15.0f*kScale];
    self.enterSaleWeb.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [self.enterSaleWeb setTitle:@"点击进入我的赛鲜推手平台" forState:0];
    self.enterSaleWeb.layer.cornerRadius = 5*kScale;
    self.enterSaleWeb.layer.masksToBounds = YES;
    self.enterSaleWeb.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
//    [self.enterSaleWeb setTitleColor:RGB(236, 31, 35, 1) forState:0];
   // [self.enterSaleWeb setBackgroundImage:[UIImage imageNamed:@"推手图片"] forState:0];
    self.enterSaleWeb.backgroundColor = [UIColor orangeColor];
    [self.enterSaleWeb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.topImv.mas_bottom).with.offset(25*kScale);
        make.right.equalTo(self.mas_right).with.offset(-(kWidth-220*kScale)/2);
        make.height.equalTo(@(25*kScale));
        make.width.equalTo(@(220*kScale));
        
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

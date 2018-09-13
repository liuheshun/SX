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
    [self.enterSaleWeb setTitle:@"点击进入我的分销平台" forState:0];
    [self.enterSaleWeb setTitleColor:RGB(236, 31, 35, 1) forState:0];
    
    [self.enterSaleWeb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.topImv.mas_bottom).with.offset(15*kScale);
        make.right.equalTo(self.mas_right).with.offset(-30*kScale);
        make.height.equalTo(@(30*kScale));
        make.width.equalTo(@(200*kScale));
        
    }];
    
    
    // underline Terms and condidtions
    NSMutableAttributedString* tncString = [[NSMutableAttributedString alloc] initWithString:self.enterSaleWeb.titleLabel.text];
    
    //设置下划线...
    /*
     NSUnderlineStyleNone                                    = 0x00, 无下划线
     NSUnderlineStyleSingle                                  = 0x01, 单行下划线
     NSUnderlineStyleThick NS_ENUM_AVAILABLE(10_0, 7_0)      = 0x02, 粗的下划线
     NSUnderlineStyleDouble NS_ENUM_AVAILABLE(10_0, 7_0)     = 0x09, 双下划线
     */
    [tncString addAttribute:NSUnderlineStyleAttributeName
                      value:@(NSUnderlineStyleSingle)
                      range:(NSRange){0,[tncString length]}];
    //此时如果设置字体颜色要这样
//    [tncString addAttribute:NSForegroundColorAttributeName value:[UIColor blueColor]  range:NSMakeRange(0,[tncString length])];
    
    //设置下划线颜色...
    [tncString addAttribute:NSUnderlineColorAttributeName value:[UIColor redColor] range:(NSRange){0,[tncString length]}];
    [self.enterSaleWeb setAttributedTitle:tncString forState:UIControlStateNormal];

    
    
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

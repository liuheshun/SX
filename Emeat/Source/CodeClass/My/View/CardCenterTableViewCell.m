//
//  CardCenterTableViewCell.m
//  Emeat
//
//  Created by liuheshun on 2018/8/15.
//  Copyright © 2018年 liuheshun. All rights reserved.
//

#import "CardCenterTableViewCell.h"

@implementation CardCenterTableViewCell


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self addSubview:self.bgImage];
        [self.bgImage addSubview:self.priceLab];
        [self.bgImage addSubview:self.timeLab];
        [self.bgImage addSubview:self.descLab];
        [self.bgImage addSubview:self.statusBtn];
        [self setUI];
    }
    return self;
}


-(void)configWithModel:(CardModel*)model{
    
    
    if ([model.ticketType isEqualToString:@"CASH_COUPON"]) {
        ///代金券
        if ([model.status isEqualToString:@"未使用"]) {
            self.bgImage.image = [UIImage imageNamed:@"代金券"];
            
            self.priceLab.textColor = RGB(250, 135, 68, 1);
            self.timeLab.textColor = RGB(136, 136, 136, 1);
            self.descLab.textColor = RGB(136, 136, 136, 1);


        }else{
            self.bgImage.image = [UIImage imageNamed:@"已失效代金券"];
            self.priceLab.textColor = RGB(220, 220, 220, 1);
            self.timeLab.textColor = RGB(220, 220, 220, 1);
            self.descLab.textColor = RGB(220, 220, 220, 1);
        }
        
        
        self.priceLab.text = [NSString stringWithFormat:@"¥ %@" ,@((CGFloat)model.amount/100)];
        self.priceLab.font = [UIFont systemFontOfSize:35.0f*kScale weight:0.4];

    }else{
        ///满减券
        self.priceLab.text = [NSString stringWithFormat:@"满%@减%@" ,@((CGFloat)model.satisfyAmount/100) ,@((CGFloat)model.amount/100)];

        if ([model.status isEqualToString:@"未使用"]) {
            
            self.bgImage.image = [UIImage imageNamed:@"满减券"];
            
            self.priceLab.textColor = RGB(250, 135, 68, 1);
            self.timeLab.textColor = RGB(136, 136, 136, 1);
            self.descLab.textColor = RGB(136, 136, 136, 1);
            
            NSArray *tempArray = [self.priceLab.text componentsSeparatedByString:@"减"];
            
            NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:self.priceLab.text];
            NSRange range1 = [[str string] rangeOfString:[NSString stringWithFormat:@"%@减" ,[tempArray firstObject]]];
            [str addAttribute:NSForegroundColorAttributeName value:RGB(248,181,81, 1) range:range1];
            
            self.priceLab.attributedText = str;
        }else{
            self.bgImage.image = [UIImage imageNamed:@"已失效满减券"];
            self.priceLab.textColor = RGB(220, 220, 220, 1);
            self.timeLab.textColor = RGB(220, 220, 220, 1);
            self.descLab.textColor = RGB(220, 220, 220, 1);
            
        }
        
        self.priceLab.font = [UIFont systemFontOfSize:25.0f*kScale weight:0.4];
        
    }
  
    self.timeLab.text = [NSString stringWithFormat:@"有效期至: %@" ,model.distributeEndTime];
    self.descLab.text = model.desc;
    if ([model.status isEqualToString:@"未使用"]) {
        [self.statusBtn setImage:[UIImage imageNamed:@"立即使用"] forState:0];
    }else if ([model.status isEqualToString:@"已使用"]){
        [self.statusBtn setImage:[UIImage imageNamed:@"已使用"] forState:0];
       
    }else if ([model.status isEqualToString:@"已失效"]){
        [self.statusBtn setImage:[UIImage imageNamed:@"已失效"] forState:0];

    }

}

-(NSString*)removeFloatAllZero:(NSString*)string
{
    NSString * testNumber = string;
    NSString * outNumber = [NSString stringWithFormat:@"%@",@(testNumber.floatValue)];
    return outNumber;
}


-(void)setUI{
    [self.bgImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).with.offset(15*kScale);
        make.top.equalTo(self.mas_top).with.offset(15*kScale);
        make.right.equalTo(self.mas_right).with.offset(-15*kScale);
        make.height.equalTo(@(125*kScale));
    }];
    
    [self.priceLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgImage.mas_left).with.offset(56*kScale);
        make.top.equalTo(self.bgImage.mas_top).with.offset(30*kScale);
        make.right.equalTo(self.bgImage.mas_right).with.offset(-15*kScale);
//        make.width.equalTo(@(150*kScale));
        make.height.equalTo(@(35*kScale));
        
    }];
    
    [self.timeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.priceLab);
        make.top.equalTo(self.priceLab.mas_bottom).with.offset(15*kScale);
        make.right.equalTo(self.bgImage.mas_right).with.offset(-15*kScale);
        make.height.equalTo(@(11*kScale));
    }];
    
    [self.descLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.priceLab);
        make.top.equalTo(self.timeLab.mas_bottom).with.offset(15*kScale);
        make.right.equalTo(self.bgImage.mas_right).with.offset(-15*kScale);
        make.height.equalTo(@(11*kScale));
    }];
    
    
    
    [self.statusBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bgImage.mas_top).with.offset(10*kScale);
        make.right.equalTo(self.bgImage);
        make.width.equalTo(@(140*kScale));
        make.height.equalTo(@(80*kScale));
    }];
    

    
}

-(UIImageView *)bgImage{
    if (_bgImage == nil) {
        _bgImage = [[UIImageView alloc] init];
        
    }
    return _bgImage;
}

- (UILabel *)priceLab{
    if (_priceLab == nil) {
        _priceLab = [UILabel new];
        _priceLab.font = [UIFont systemFontOfSize:35.0f*kScale weight:0.4];
        _priceLab.textColor = RGB(250, 135, 68, 1);
    }
    return _priceLab;
}

- (UILabel *)timeLab{
    if (_timeLab == nil) {
        _timeLab = [UILabel new];
        _timeLab.font = [UIFont systemFontOfSize:11.0f*kScale];
        _timeLab.textColor = RGB(136, 136, 136, 1);
    }
    return _timeLab;
}

- (UILabel *)descLab{
    if (_descLab == nil) {
        _descLab = [UILabel new];
        _descLab.font = [UIFont systemFontOfSize:11.0f*kScale];
        _descLab.textColor = RGB(136, 136, 136, 1);
    }
    return _descLab;
}


- (UIButton *)statusBtn{
    if (_statusBtn == nil) {
        _statusBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        
    }
    return _statusBtn;
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

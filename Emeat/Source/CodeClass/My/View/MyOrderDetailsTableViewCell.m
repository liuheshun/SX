//
//  MyOrderDetailsTableViewCell.m
//  Emeat
//
//  Created by liuheshun on 2017/12/14.
//  Copyright © 2017年 liuheshun. All rights reserved.
//

#import "MyOrderDetailsTableViewCell.h"

@implementation MyOrderDetailsTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self addSubview:self.orderImv];
        [self addSubview:self.orderName];
        [self addSubview:self.orderWeight];
        [self addSubview:self.orderPrices];
        [self addSubview:self.orderCount];
        
        [self setMainViewFrame];
       
    }
    
    return self;
}


-(void)configCellWithModel:(OrderModel*)orderModel{
    
    [self.orderImv sd_setImageWithURL:[NSURL URLWithString:orderModel.productImage] placeholderImage:[UIImage imageNamed:@"small_placeholder"]];
    self.orderName.text = orderModel.productName;
//    self.orderPrices.text = [NSString stringWithFormat:@"¥ %@元/kg" ,orderModel.currentUnitPrice];
    self.orderCount.text = [NSString stringWithFormat:@"x %@" ,orderModel.quantity];
    
    
    
    if ([orderModel.typeOfBusiness isEqualToString:@"C"]) {
        self.orderPrices.text =[NSString stringWithFormat:@"%@元",orderModel.currentUnitPrice];
        self.orderWeight.text = orderModel.standardSize;

    }else{
        self.orderPrices.text =[NSString stringWithFormat:@"%@元/kg",orderModel.currentUnitPrice];
        self.orderWeight.text = orderModel.productSize;

    }
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:self.orderPrices.text];
    NSRange range1 = [[str string] rangeOfString:[NSString stringWithFormat:@"%@元" ,orderModel.currentUnitPrice]];
    [str addAttribute:NSForegroundColorAttributeName value:RGB(236, 31, 35, 1) range:range1];
    self.orderPrices.attributedText = str;
    
    
}





-(void)setMainViewFrame{
    [self.orderImv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).with.offset(15*kScale);
        make.top.equalTo(self.mas_top).with.offset(10*kScale);
        make.width.equalTo(@(70*kScale));
        make.height.equalTo(@(55*kScale));
    }];
    
    [self.orderName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.orderImv.mas_right).with.offset(10*kScale);
        make.right.equalTo(self.mas_right).with.offset(-15*kScale);
        make.top.equalTo(self.orderImv);
        make.height.equalTo(@(13*kScale));
    }];
    
    
    [self.orderWeight mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.orderName);
        make.top.equalTo(self.orderName.mas_bottom).with.offset(10*kScale);
        make.right.equalTo(self.orderCount.mas_left).with.offset(-10*kScale);
        make.height.equalTo(@(13*kScale));
    }];
    

    [self.orderPrices mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.orderName);
        make.top.equalTo(self.orderWeight.mas_bottom).with.offset(10*kScale);
        make.right.equalTo(self.orderCount.mas_left).with.offset(-10*kScale);
        make.height.equalTo(@(13*kScale));
    }];
   
    [self.orderCount mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).with.offset(-15*kScale);
        make.top.equalTo(self.orderPrices);
        make.width.equalTo(@(100*kScale));
        make.height.equalTo(@(13*kScale));
    }];

    
    
}



-(UIImageView *)orderImv{
    if (!_orderImv) {
        _orderImv = [[UIImageView alloc] init];
        
    }
    return _orderImv;
}

-(UILabel *)orderName{
    if (!_orderName) {
        _orderName = [[UILabel alloc] init];
        _orderName.textAlignment = NSTextAlignmentLeft;
        _orderName.font = [UIFont systemFontOfSize:12.0f];
        
    }
    return _orderName;
}


-(UILabel *)orderPrices{
    if (!_orderPrices) {
        _orderPrices = [[UILabel alloc] init];
        _orderPrices.textAlignment = NSTextAlignmentLeft;
        _orderPrices.font = [UIFont systemFontOfSize:12.0f];
        _orderPrices.textColor = RGB(136, 136, 136, 1);
        
    }
    return _orderPrices;
}

-(UILabel *)orderWeight{
    if (!_orderWeight) {
        _orderWeight = [[UILabel alloc] init];
        _orderWeight.textAlignment = NSTextAlignmentLeft;
        _orderWeight.font = [UIFont systemFontOfSize:12.0f];
        _orderWeight.textColor = RGB(136, 136, 136, 1);
        
    }
    return _orderWeight;
}

-(UILabel *)orderCount{
    if (!_orderCount) {
        _orderCount = [[UILabel alloc] init];
        _orderCount.textAlignment = NSTextAlignmentRight;
        _orderCount.font = [UIFont systemFontOfSize:12.0f];
        
    }
    return _orderCount;
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

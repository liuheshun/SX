//
//  MyOrderTableViewCell.m
//  Emeat
//
//  Created by liuheshun on 2017/12/14.
//  Copyright © 2017年 liuheshun. All rights reserved.
//

#import "MyOrderTableViewCell.h"

@implementation MyOrderTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
       
    }
    return self;
}



//接收数据
-(void)getHomeArray:(NSArray *)homeArray
{
    self.HomeArray = homeArray;
    [self addSubview:self.orderTimeLab];
    [self addSubview:self.orderStated];
    [self addSubview:self.lineView];
    [self addSubview:self.orderDetailsLab];

    [self   setMainFrame];

    [self setOrderImvFrame];
   
    
}


-(void)configWithOrderModel:(OrderModel*)model{
    
//    // timeStampString 是服务器返回的13位时间戳
//    NSString *timeStampString  = model.createOrderTime;
//    DLog(@"%@" ,model.createOrderTime);
//    // iOS 生成的时间戳是10位
//    NSTimeInterval interval    = [timeStampString doubleValue] / 1000.0;
//    NSDate *date               = [NSDate dateWithTimeIntervalSince1970:interval];
//    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
//    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
//    NSString *dateString       = [formatter stringFromDate: date];

    self.orderTimeLab.text = model.createOrderTime;
    self.orderStated.text = model.statusDesc;
    self.orderDetailsLab.text =[NSString stringWithFormat:@"共%@件商品,总计¥%@" ,model.productAmount,model.payment];
    
}






-(UILabel *)orderTimeLab{
    if (!_orderTimeLab) {
        _orderTimeLab = [[UILabel alloc] init];
        _orderTimeLab.font = [UIFont systemFontOfSize:12.0f*kScale];
        _orderTimeLab.textAlignment = NSTextAlignmentLeft;
    }
    return _orderTimeLab;
}


-(UILabel *)orderStated{
    if (!_orderStated) {
        _orderStated = [[UILabel alloc] init];
        _orderStated.font = [UIFont systemFontOfSize:12.0f*kScale];
        _orderStated.textAlignment = NSTextAlignmentRight;
    }
    return _orderStated;
}


-(UIView *)lineView{
    if (!_lineView) {
        _lineView = [[UIView alloc]init];
        _lineView.backgroundColor = RGB(238, 238, 238, 1);
    }
    return _lineView;
}

-(void)setOrderImvFrame{
    NSInteger arrayCount = 0;
    if (self.HomeArray.count >3) {
        arrayCount = 4;
    }else{
        arrayCount = self.HomeArray.count;
    }
      __block UIView *lastView = nil;
    for (int i = 0; i < arrayCount; i++) {
        UIImageView *imv = [[UIImageView alloc] init];
        [self addSubview:imv];
        self.orderImv = imv;
        [imv mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@(55*kScale));
            make.width.equalTo(@(70*kScale));
            make.top.equalTo(self.lineView.mas_bottom).with.offset(15*kScale);
            if (i == 0) {
                make.left.equalTo(self.mas_left).with.offset(15*kScale);
            }else{
                make.left.equalTo(lastView.mas_right).with.offset(15*kScale);
            }
        }];
   
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        
        if (i == 3)
        {
            [imv addSubview:btn];
            [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.equalTo(imv);
                make.top.bottom.equalTo(imv);
            }];
            [btn setImage:[UIImage imageNamed:@"order_placeHolder"] forState:0];
        }
        else
        {
            [imv sd_setImageWithURL:[NSURL URLWithString:self.HomeArray[i]] placeholderImage:[UIImage imageNamed:@"small_placeholder"]];

            [btn removeFromSuperview];
        }
        self.orderImv = imv;
        lastView = imv;

    }
    
    
}
-(void)setMainFrame{
    [self.orderTimeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).with.offset(15*kScale);
        make.top.equalTo(self.mas_top).with.offset(10*kScale);
        make.width.equalTo(@(200*kScale));
        make.height.equalTo(@(20*kScale));
    }];
    
    [self.orderStated mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).with.offset(-15*kScale);
        make.top.equalTo(self.mas_top).with.offset(10*kScale);
        make.width.equalTo(@(45*kScale));
        make.height.equalTo(@(20*kScale));
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).with.offset(15*kScale);
        make.top.equalTo(self.orderTimeLab.mas_bottom).with.offset(15*kScale);
        make.width.equalTo(@(kWidth-30*kScale));
        make.height.equalTo(@1);
    }];
    
    [self.orderDetailsLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).with.offset(15*kScale);
        make.bottom.equalTo(self.mas_bottom).with.offset(-13*kScale);
        make.width.equalTo(@(kWidth-30*kScale));
        make.height.equalTo(@(13*kScale));
    }];
    
    
    
    
}

-(UILabel *)orderDetailsLab{
    if (!_orderDetailsLab) {
        _orderDetailsLab = [[UILabel alloc] init];
        _orderDetailsLab.font = [UIFont systemFontOfSize:12.0f*kScale];
        _orderDetailsLab.textAlignment = NSTextAlignmentRight;
    }
    return _orderDetailsLab;
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

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
        [self addSubview:self.orderTimeLab];
        [self addSubview:self.orderStated];
        [self addSubview:self.lineView];
        [self addSubview:self.orderDetailsLab];
        
        [self   setMainFrame];
        
        [self setOrderImvFrame];
    }
    return self;
}



-(void)configWithOrderModel:(OrderModel*)model{

    self.orderTimeLab.text = model.createOrderTime;
//    self.orderStated.text = model.statusDesc;
    self.orderDetailsLab.text =[NSString stringWithFormat:@"共%@件商品,总计¥%@" ,model.productAmount,model.payment];
    
    
    
    if (model.status == 10){
        self.orderStated.text = @"待支付";
        
        
    }else  if (model.status == 50 || model.status == 40 || model.status == 46){
        self.orderStated.text = @"待确认";
        
    }else if (model.status == 60){
        self.orderStated.text = @"配送中";
        
    }else if (model.status == 70){
        self.orderStated.text = @"待收货";
       
    }else if (model.status == 120){
        self.orderStated.text = @"待核验";
    
    }else if (model.status == 140){
        self.orderStated.text = @"已退货";
        
    }else if (model.status == 20){
        self.orderStated.text = @"取消退货";
       
    }else if (model.status == 80){
        self.orderStated.text = @"已完成";
        
        
    }else if (model.status == 0 || model.status == 51 || model.status == 52){
        self.orderStated.text = @"已取消";
      
    }

    
    
    
    
    
    
    
    
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
    MyOrderTableCellConfig *orderConfig = [MyOrderTableCellConfig myOrderTableCellConfig];
    DLog(@"ccccccccc=========== %ld" , orderConfig.orderImvArray.count);
    if (orderConfig.orderImvArray.count >3) {
        arrayCount = 4;
    }else{
        arrayCount = orderConfig.orderImvArray.count;
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
            [imv sd_setImageWithURL:[NSURL URLWithString:orderConfig.orderImvArray[i]] placeholderImage:[UIImage imageNamed:@"small_placeholder"]];

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
        make.width.equalTo(@(70*kScale));
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



@implementation MyOrderTableCellConfig

+ (MyOrderTableCellConfig *)myOrderTableCellConfig
{
    static MyOrderTableCellConfig *config1;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        
        config1 = [MyOrderTableCellConfig new];
        
    });
    
    return config1;
}

- (instancetype)init
{
    self = [super init];
    
    if ( self )
    {
        
    }
    
    return self;
}

@end









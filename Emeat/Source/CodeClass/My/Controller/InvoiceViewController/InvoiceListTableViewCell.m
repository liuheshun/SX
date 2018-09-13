//
//  InvoiceListTableViewCell.m
//  Emeat
//
//  Created by liuheshun on 2018/6/21.
//  Copyright © 2018年 liuheshun. All rights reserved.
//

#import "InvoiceListTableViewCell.h"

@implementation InvoiceListTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self setupMainView];
    }
    return self;
}
//选中按钮点击事件
-(void)selectBtnClick:(UIButton*)button
{
    button.selected = !button.selected;
    if (self.cartBlock) {
        self.cartBlock(button.selected);
    }
}



-(void)setupMainView
{
    
    //选中按钮
    self.selectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.selectBtn.selected = self.isSelected;
    [self.selectBtn setImage:[UIImage imageNamed:@"no_selected"] forState:UIControlStateNormal];
    [self.selectBtn setImage:[UIImage imageNamed:@"selected"] forState:UIControlStateSelected];
    [self.selectBtn addTarget:self action:@selector(selectBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self  addSubview:self.selectBtn];
    //选中按钮
    [self.selectBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left ).offset(10*kScale);
        make.top.equalTo(self.mas_top).with.offset(60*kScale);
        make.width.equalTo(@(30*kScale));
        make.height.equalTo(@(30*kScale));
    }];
    
    [self addSubview:self.orderTimeLab];
    [self addSubview:self.orderStated];
    [self addSubview:self.lineView];
    [self addSubview:self.orderDetailsLab];
    [self addSubview:self.enterBtn];
    
    [self   setMainFrame];
    
    [self setOrderImvFrame];
 
   
    
   
   
}



-(void)configWithOrderModel:(InvoiceListModel*)model{
    
//    self.orderTimeLab.text = model.createOrderTime;
//    self.orderStated.text = model.statusDesc;
//    self.orderDetailsLab.text =[NSString stringWithFormat:@"共%@件商品,总计¥%@" ,model.productAmount,model.payment];
    
//    
//    // timeStampString 是服务器返回的13位时间戳
//    NSString *timeStampString  = model.createTime;
//    // iOS 生成的时间戳是10位
//    NSTimeInterval interval    =[timeStampString doubleValue] / 1000.0;
//    NSDate *date               = [NSDate dateWithTimeIntervalSince1970:interval];
//    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
//    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
//    NSString *dateString       = [formatter stringFromDate: date];
//    NSLog(@"服务器返回的时间戳对应的时间是:%@",dateString);
    
    self.orderTimeLab.text = model.createTime;
    self.orderStated.text = @"已完成";
    self.orderDetailsLab.text = [NSString stringWithFormat:@"共%ld件商品, 可开票金额:¥ %.2f" ,model.quantity , (CGFloat)model.netPrice/100];
    
    if (model.checkStated == 0)
    {
        self.isSelected = NO;
    }else if (model.checkStated == 1)
    {
        self.isSelected = YES;
    }
    
    self.selectBtn.selected = self.isSelected;
    
    
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

-(UIButton *)enterBtn{
    if (!_enterBtn) {
        _enterBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_enterBtn setImage:[UIImage imageNamed:@"进入"] forState:0];
    }
    return _enterBtn;
}


-(void)setOrderImvFrame{
    NSInteger arrayCount = 0;
    InvoiceTableCellConfig *orderConfig = [InvoiceTableCellConfig myOrderTableCellConfig];
//    orderConfig.orderImvArray = @[@"1" , @"12" ,@"3" ,@"4"];
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
                make.left.equalTo(self.mas_left).with.offset(55*kScale);
            }else if (i== 3){
                make.left.equalTo(lastView.mas_right).with.offset(-5*kScale);

            }
            else{
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
        make.top.equalTo(self.mas_top).with.offset(0*kScale);
        make.width.equalTo(@(200*kScale));
        make.height.equalTo(@(30*kScale));
    }];
    
    [self.orderStated mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).with.offset(-15*kScale);
        make.top.equalTo(self.mas_top).with.offset(0*kScale);
        make.width.equalTo(@(45*kScale));
        make.height.equalTo(@(30*kScale));
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).with.offset(15*kScale);
        make.top.equalTo(self.orderTimeLab.mas_bottom).with.offset(0*kScale);
        make.width.equalTo(@(kWidth-30*kScale));
        make.height.equalTo(@(1*kScale));
    }];
    
    [self.orderDetailsLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).with.offset(15*kScale);
        make.bottom.equalTo(self.mas_bottom).with.offset(-15*kScale);
        make.width.equalTo(@(kWidth-30*kScale));
        make.height.equalTo(@(13*kScale));
    }];
    
    [self.enterBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).with.offset(-15*kScale);
        make.top.equalTo(self.selectBtn.mas_top).with.offset(-1*kScale);
        make.width.equalTo(@(6*kScale));
        make.height.equalTo(@(30*kScale));
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


@end


@implementation InvoiceTableCellConfig

+ (InvoiceTableCellConfig *)myOrderTableCellConfig
{
    static InvoiceTableCellConfig *config1;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        
        config1 = [InvoiceTableCellConfig new];
        
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






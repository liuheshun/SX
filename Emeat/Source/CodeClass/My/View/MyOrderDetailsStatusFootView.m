//
//  MyOrderDetailsStatusFootView.m
//  Emeat
//
//  Created by liuheshun on 2017/12/18.
//  Copyright © 2017年 liuheshun. All rights reserved.
//

#import "MyOrderDetailsStatusFootView.h"

@implementation MyOrderDetailsStatusFootView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.footTopBgView];
        [self.footTopBgView addSubview:self.orderAllPricesLab];
        [self.footTopBgView addSubview:self.orderAllPricesCount];
        [self.footTopBgView addSubview:self.sendPricesLab];
        [self.footTopBgView addSubview:self.sendPricesCount];
        [self.footTopBgView addSubview:self.orderPayStatus];
        [self.footTopBgView addSubview:self.orderPayPrices];
        
        
        [self addSubview:self.footBottomView];
        [self.footBottomView addSubview:self.orderInfoLab];
        [self.footBottomView addSubview:self.orderNumber];
        [self.footBottomView addSubview:self.orderTime];
        [self.footBottomView addSubview:self.payTime];
        [self.footBottomView addSubview:self.sendTime];
        [self.footBottomView addSubview:self.arriveTime];
        [self.footBottomView addSubview:self.cancelTime];
        
        [self setFootViewFrame];
        
    }
    return self;
}


-(void)configOrderDetailsFootViewWithModel:(OrderModel*)model{
    
    if (model.status == 10)////待支付
    {
        self.orderPayStatus.text = @"需支付";
        
        
    }
    else  if (model.status == 50 || model.status == 40)///待发货
    {
        self.orderPayStatus.text = @"已支付";
        if (model.paymentType == 11) {
            
        }
        else
        {
        self.payTime.text = [NSString stringWithFormat:@"付款时间 : %@" , model.paymentTime];
        }
        
    }
    else if (model.status == 60)///配送中
    {
        self.orderPayStatus.text = @"已支付";
        self.payTime.text = [NSString stringWithFormat:@"付款时间 : %@" , model.paymentTime];
        self.sendTime.text = [NSString stringWithFormat:@"发货时间 : %@" , model.sendTime];
        
    }
    else if (model.status == 120)///待核验 (退货中)
    {
        self.orderPayStatus.text = @"已支付";
        self.payTime.text = [NSString stringWithFormat:@"付款时间 : %@" , model.paymentTime];
        self.sendTime.text = [NSString stringWithFormat:@"发货时间 : %@" , model.sendTime];
        self.arriveTime.text =  [NSString stringWithFormat:@"申请退款 : %@" , model.endTime];
    }
    else if (model.status == 140)///已退货
    {
        self.orderPayStatus.text = @"已支付";
        self.payTime.text = [NSString stringWithFormat:@"付款时间 : %@" , model.paymentTime];
        self.sendTime.text = [NSString stringWithFormat:@"发货时间 : %@" , model.sendTime];
        self.arriveTime.text =  [NSString stringWithFormat:@"申请退款 : %@" , model.endTime];
        self.cancelTime.text = [NSString stringWithFormat:@"退款时间 : %@" , model.endTime];
    }
    else if (model.status == 20)///取消退货
    {
        self.orderPayStatus.text = @"已支付";
        self.payTime.text = [NSString stringWithFormat:@"付款时间 : %@" , model.paymentTime];
        self.sendTime.text = [NSString stringWithFormat:@"发货时间 : %@" , model.sendTime];
        self.arriveTime.text =  [NSString stringWithFormat:@"申请退款 : %@" , model.endTime];
        self.cancelTime.text = [NSString stringWithFormat:@"取消时间 : %@" , model.endTime];
        
    }else if (model.status == 80)///已完成
    {
        self.orderPayStatus.text = @"已支付";
        self.payTime.text = [NSString stringWithFormat:@"付款时间 : %@" , model.paymentTime];
        self.sendTime.text = [NSString stringWithFormat:@"发货时间 : %@" , model.sendTime];
        self.arriveTime.text =  [NSString stringWithFormat:@"送达时间 : %@" , model.receiveTime];
        

    }
    else if (model.status == 0)///已取消
    {
        if (model.paymentType == 0) {///未支付状态下
            self.orderPayStatus.text = @"需支付";

        }
        else
        {
            self.orderPayStatus.text = @"已支付";

        }

    }
    
    
    
    
    
    
    
    self.orderAllPricesLab.text = @"商品总价";
    self.orderAllPricesCount.text = [NSString stringWithFormat:@"¥ %@" , model.orderTotalPrice];
    self.sendPricesLab.text = @"配送费";
    self.sendPricesCount.text = @"¥ 0.00";
    self.orderPayPrices.text =[NSString stringWithFormat:@"¥ %@" , model.orderTotalPrice];
    
    self.orderInfoLab.text = @"订单信息";
    self.orderNumber.text = [NSString stringWithFormat:@"下单时间 : %@" , model.createOrderTime];
    self.orderTime.text = [NSString stringWithFormat:@"订单号 : %@" , model.orderNo];
    
    
    CGFloat orderPayPricesWidth =  [GetWidthAndHeightOfString getWidthForText:self.orderPayPrices height:15];
    
    [self.orderPayPrices mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(orderPayPricesWidth));
    }];
    
    
    [self.orderPayStatus mas_updateConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.orderPayPrices.mas_left).with.offset(-5);
    }];
    
    
}

-(UIView *)footTopBgView{
    if (!_footTopBgView) {
        _footTopBgView = [[UIView alloc] init];
        _footTopBgView.backgroundColor = [UIColor whiteColor];
    }
    return _footTopBgView;
}


-(UILabel *)orderAllPricesLab{
    if (!_orderAllPricesLab) {
        _orderAllPricesLab = [[UILabel alloc] init];
        _orderAllPricesLab.font = [UIFont systemFontOfSize:15.0f];
        _orderAllPricesLab.textAlignment = NSTextAlignmentLeft;
        _orderAllPricesLab.textColor = RGB(138, 138, 138, 1);
    }
    return _orderAllPricesLab;
}



-(UILabel *)orderAllPricesCount{
    if (!_orderAllPricesCount) {
        _orderAllPricesCount = [[UILabel alloc] init];
        _orderAllPricesCount.font = [UIFont systemFontOfSize:15.0f];
        _orderAllPricesCount.textAlignment = NSTextAlignmentRight;
        _orderAllPricesCount.textColor = RGB(138, 138, 138, 1);
    }
    return _orderAllPricesCount;
}


-(UILabel *)sendPricesLab{
    if (!_sendPricesLab) {
        _sendPricesLab = [[UILabel alloc] init];
        _sendPricesLab.font = [UIFont systemFontOfSize:15.0f];
        _sendPricesLab.textAlignment = NSTextAlignmentLeft;
        _sendPricesLab.textColor = RGB(138, 138, 138, 1);
    }
    return _sendPricesLab;
}




-(UILabel *)sendPricesCount{
    if (!_sendPricesCount) {
        _sendPricesCount = [[UILabel alloc] init];
        _sendPricesCount.font = [UIFont systemFontOfSize:15.0f];
        _sendPricesCount.textAlignment = NSTextAlignmentRight;
        _sendPricesCount.textColor = RGB(138, 138, 138, 1);
    }
    return _sendPricesCount;
}

-(UILabel *)orderPayStatus{
    if (!_orderPayStatus) {
        _orderPayStatus = [[UILabel alloc] init];
        _orderPayStatus.font = [UIFont systemFontOfSize:15.0f];
        _orderPayStatus.textAlignment = NSTextAlignmentRight;
        _orderPayStatus.textColor = RGB(138, 138, 138, 1);
    }
    return _orderPayStatus;
}

-(UILabel *)orderPayPrices{
    if (!_orderPayPrices) {
        _orderPayPrices = [[UILabel alloc] init];
        _orderPayPrices.font = [UIFont systemFontOfSize:15.0f];
        _orderPayPrices.textAlignment = NSTextAlignmentRight;
        _orderPayPrices.textColor = RGB(231, 35, 36, 1);
    }
    return _orderPayPrices;
}


-(UIView *)footBottomView{
    if (!_footBottomView) {
        _footBottomView = [[UIView alloc] init];
        _footBottomView.backgroundColor = [UIColor whiteColor];
        
    }
    return _footBottomView;
}

-(UILabel *)orderInfoLab{
    if (!_orderInfoLab) {
        _orderInfoLab = [[UILabel alloc] init];
        _orderInfoLab.font = [UIFont systemFontOfSize:15.0f];
        _orderInfoLab.textAlignment = NSTextAlignmentLeft;
    }
    return _orderInfoLab;
}


-(UILabel *)orderNumber{
    if (!_orderNumber) {
        _orderNumber = [[UILabel alloc] init];
        _orderNumber.font = [UIFont systemFontOfSize:12.0f];
        _orderNumber.textAlignment = NSTextAlignmentLeft;
    }
    return _orderNumber;
}



-(UILabel *)orderTime{
    if (!_orderTime) {
        _orderTime = [[UILabel alloc] init];
        _orderTime.font = [UIFont systemFontOfSize:12.0f];
        _orderTime.textAlignment = NSTextAlignmentLeft;
    }
    return _orderTime;
}



-(UILabel *)payTime{
    if (!_payTime) {
        _payTime = [[UILabel alloc] init];
        _payTime.font = [UIFont systemFontOfSize:12.0f];
        _payTime.textAlignment = NSTextAlignmentLeft;
    }
    return _payTime;
}

-(UILabel *)sendTime{
    if (!_sendTime) {
        _sendTime = [[UILabel alloc] init];
        _sendTime.font = [UIFont systemFontOfSize:12.0f];
        _sendTime.textAlignment = NSTextAlignmentLeft;
    }
    return _sendTime;
}

-(UILabel *)arriveTime{
    if (!_arriveTime) {
        _arriveTime = [[UILabel alloc] init];
        _arriveTime.font = [UIFont systemFontOfSize:12.0f];
        _arriveTime.textAlignment = NSTextAlignmentLeft;
    }
    return _arriveTime;
}
-(UILabel *)cancelTime{
    if (!_cancelTime) {
        _cancelTime = [[UILabel alloc] init];
        _cancelTime.font = [UIFont systemFontOfSize:12.0f];
        _cancelTime.textAlignment = NSTextAlignmentLeft;
    }
    return _cancelTime;
}

-(void)setFootViewFrame{
    
    [self.footTopBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).with.offset(0);
        make.left.equalTo(self.mas_left).with.offset(0);
        make.width.equalTo(self);
        make.height.equalTo(@93);
    }];
    
    [self.orderAllPricesLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.footTopBgView.mas_top).with.offset(10);
        make.left.equalTo(self.footTopBgView.mas_left).with.offset(15);
        make.width.equalTo(@65);
        make.height.equalTo(@15);
    }];
    
    
    [self.orderAllPricesCount mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.footTopBgView.mas_top).with.offset(10);
        make.right.equalTo(self.footTopBgView.mas_right).with.offset(-15);
        make.width.equalTo(@120);
        make.height.equalTo(@15);
    }];
    
    [self.sendPricesLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.orderAllPricesLab.mas_bottom).with.offset(15);
        make.left.equalTo(self.footTopBgView.mas_left).with.offset(15);
        make.width.equalTo(@65);
        make.height.equalTo(@15);
    }];
    
    
    [self.sendPricesCount mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.orderAllPricesCount.mas_bottom).with.offset(15);
        make.right.equalTo(self.footTopBgView.mas_right).with.offset(-15);
        make.width.equalTo(@120);
        make.height.equalTo(@15);
    }];
    
    
    [self.orderPayPrices mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.sendPricesCount.mas_bottom).with.offset(15);
        make.right.equalTo(self.footTopBgView.mas_right).with.offset(-15);
        make.width.equalTo(@60);
        make.height.equalTo(@15);
    }];
    
    
    [self.orderPayStatus mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.sendPricesCount.mas_bottom).with.offset(15);
        make.right.equalTo(self.orderPayPrices.mas_left).with.offset(-5);
        make.width.equalTo(@120);
        make.height.equalTo(@15);
    }];
    
   //
    [self.footBottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.footTopBgView.mas_bottom).with.offset(10);
        make.left.equalTo(self.mas_left).with.offset(0);
        make.width.equalTo(self);
        make.height.equalTo(@177);
    }];
    
    [self.orderInfoLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.footBottomView.mas_top).with.offset(15);
        make.left.equalTo(self.footBottomView.mas_left).with.offset(15);
        make.width.equalTo(@(kWidth-30));
        make.height.equalTo(@15);
    }];
    
    
    [self.orderNumber mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.orderInfoLab.mas_bottom).with.offset(20);
        make.left.equalTo(self.footBottomView.mas_left).with.offset(15);
        make.width.equalTo(@(kWidth-30));
        make.height.equalTo(@15);
    }];
    
    
    
    [self.orderTime mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.orderNumber.mas_bottom).with.offset(10);
        make.left.equalTo(self.footBottomView.mas_left).with.offset(15);
        make.width.equalTo(@(kWidth-30));
        make.height.equalTo(@15);
    }];
    
    
    [self.payTime mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.orderTime.mas_bottom).with.offset(10);
        make.left.equalTo(self.footBottomView.mas_left).with.offset(15);
        make.width.equalTo(@(kWidth-30));
        make.height.equalTo(@15);
    }];
    
    [self.sendTime mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.payTime.mas_bottom).with.offset(10);
        make.left.equalTo(self.footBottomView.mas_left).with.offset(15);
        make.width.equalTo(@(kWidth-30));
        make.height.equalTo(@15);
    }];
    
    [self.arriveTime mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.sendTime.mas_bottom).with.offset(10);
        make.left.equalTo(self.footBottomView.mas_left).with.offset(15);
        make.width.equalTo(@(kWidth-30));
        make.height.equalTo(@15);
    }];
    
    
    [self.cancelTime mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.arriveTime.mas_bottom).with.offset(10);
        make.left.equalTo(self.footBottomView.mas_left).with.offset(15);
        make.width.equalTo(@(kWidth-30));
        make.height.equalTo(@15);
    }];
    
}







@end

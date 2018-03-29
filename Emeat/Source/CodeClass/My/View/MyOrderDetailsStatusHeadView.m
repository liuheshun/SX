//
//  MyOrderDetailsStatusHeadView.m
//  Emeat
//
//  Created by liuheshun on 2017/12/14.
//  Copyright © 2017年 liuheshun. All rights reserved.
//

#import "MyOrderDetailsStatusHeadView.h"

@implementation MyOrderDetailsStatusHeadView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.statusBgImv];
        [self.statusBgImv addSubview:self.orderStatusLab];
        [self.statusBgImv addSubview:self.orderStatusDetailsLab];
        [self.statusBgImv addSubview:self.statusImv];
        
        
        
        [self addSubview:self.sendBgView];
        [self.sendBgView addSubview:self.sendInfoLab];
        [self.sendBgView addSubview:self.sendAddressLab];
        [self.sendBgView addSubview:self.orderNameLab];
        [self.sendBgView addSubview:self.orderPhoneNumerLab];
        [self.sendBgView addSubview:self.orderAddressLab];
        
        [self addSubview:self.orderCommentBgView];
        [self.orderCommentBgView addSubview:self.orderCommentLab];
        [self.orderCommentBgView addSubview:self.orderCommentDetailsLab];
        
        [self addSubview:self.goodsBgView];
        [self.goodsBgView addSubview:self.goodsLab];
        [self setMainViewFrame];
      
    }
    return self;
}

-(void)configAddressWithModel:(MyAddressModel*)addressModel orderModel:(OrderModel*)orderModel
{
    DLog(@"sssssssssssssssss=========== = %ld" ,orderModel.status);
    if (orderModel.status == 10)
    {
        self.orderStatusLab.text = @"待支付";
        self.orderStatusDetailsLab.text = @"订单提交成功,等待用户支付";
        [self.statusImv setImage:[UIImage imageNamed:@"daizhifu"] forState:0];

    }
    
    else  if (orderModel.status == 50 || orderModel.status == 40)
    {
        self.orderStatusLab.text = @"待确认";
        self.orderStatusDetailsLab.text = @"用户已支付,等待商家发货";
        [self.statusImv setImage:[UIImage imageNamed:@"daifahuo1"] forState:0];

    }
    else if (orderModel.status == 60)
    {
          self.orderStatusLab.text = @"配送中";
        self.orderStatusDetailsLab.text = @"商家已发货,正在配送中";
        [self.statusImv setImage:[UIImage imageNamed:@"peisongzhong"] forState:0];

    }else if (orderModel.status == 70)
    {
        self.orderStatusLab.text = @"待收货";
        self.orderStatusDetailsLab.text = @"商家已送达,等待签收";
        [self.statusImv setImage:[UIImage imageNamed:@"daiheyan"] forState:0];
        
    }
    
    
    
    
    else if (orderModel.status == 120)
    {
        self.orderStatusLab.text = @"待核验";
        self.orderStatusDetailsLab.text = @"用户正在退回相应商品,等待商家核验";
        [self.statusImv setImage:[UIImage imageNamed:@"daiheyan"] forState:0];

    }
    else if (orderModel.status == 140)
    {
        self.orderStatusLab.text = @"已退货";
        self.orderStatusDetailsLab.text = @"用户已退回相应商品,货款已退回";
        [self.statusImv setImage:[UIImage imageNamed:@"yituihuo"] forState:0];

    }
    else if (orderModel.status == 20)
    {
        self.orderStatusLab.text = @"取消退货";
        self.orderStatusDetailsLab.text = @"商家经过核验,退货申请已取消";
        [self.statusImv setImage:[UIImage imageNamed:@"quxiaotuihuo"] forState:0];

    }else if (orderModel.status == 80)
    {
        self.orderStatusLab.text = @"已完成";
        self.orderStatusDetailsLab.text = @"用户确认收货 ,订单完成";
        [self.statusImv setImage:[UIImage imageNamed:@"yiwancheng"] forState:0];

        
    }
    else if (orderModel.status == 0)
    {
        self.orderStatusLab.text = @"已取消";
        self.orderStatusDetailsLab.text = @"用户已取消订单";
        
        [self.statusImv setImage:[UIImage imageNamed:@"quxiaotuihuo"] forState:0];
    }
   
    
    self.orderNameLab.text = addressModel.receiverName;
    self.orderPhoneNumerLab.text =[NSString stringWithFormat:@"%ld",addressModel.receiverPhone] ;
    self.orderAddressLab.text = [NSString stringWithFormat:@"%@%@" ,addressModel.receiverProvince , addressModel.receiverAddress];
    
    self.orderCommentDetailsLab.text = orderModel.orderComment;

  CGFloat orderCommentDetailsLabHeight = [GetWidthAndHeightOfString getHeightForText:self.orderCommentDetailsLab width:kWidth-30*kScale];
    
    
    [self.orderCommentBgView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(40*kScale + orderCommentDetailsLabHeight));
    }];
    
    
    [self.orderCommentDetailsLab mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(orderCommentDetailsLabHeight));
    }];
   
    
    
    [self.goodsBgView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self);
        make.top.equalTo(self.orderCommentBgView.mas_bottom).with.offset(10*kScale);
        make.width.equalTo(@(kWidth));
        make.height.equalTo(@(40*kScale));
    }];
    
    
    orderModel.orderDeatailsCommentHeight = orderCommentDetailsLabHeight;
}



-(UIImageView *)statusBgImv{
    if (!_statusBgImv) {
        _statusBgImv = [[UIImageView alloc] init];
        _statusBgImv.image = [UIImage imageNamed:@"orderDetails_bgView"];
    }
    return _statusBgImv;
}

-(UILabel *)orderStatusLab{
    if (!_orderStatusLab) {
        _orderStatusLab = [[UILabel alloc] init];
        _orderStatusLab.font = [UIFont systemFontOfSize:15.0f*kScale];
        _orderStatusLab.textAlignment = NSTextAlignmentLeft;
        _orderStatusLab.textColor = [UIColor whiteColor];
    }
    return _orderStatusLab;
}


-(UILabel *)orderStatusDetailsLab{
    if (!_orderStatusDetailsLab) {
        _orderStatusDetailsLab = [[UILabel alloc] init];
        _orderStatusDetailsLab.font = [UIFont systemFontOfSize:15.0f*kScale];
        _orderStatusDetailsLab.textAlignment = NSTextAlignmentLeft;
        _orderStatusDetailsLab.textColor = [UIColor whiteColor];

    }
    return _orderStatusDetailsLab;
}

-(UIButton *)statusImv{
    if (!_statusImv) {
        _statusImv = [UIButton buttonWithType:UIButtonTypeCustom];
    }
    return _statusImv;
}



-(UIView *)sendBgView{
    if (!_sendBgView) {
        _sendBgView = [[UIView alloc] init];
        _sendBgView.backgroundColor = [UIColor whiteColor];
    }
    return _sendBgView;
}



-(UILabel *)sendInfoLab{
    if (!_sendInfoLab) {
        _sendInfoLab = [[UILabel alloc] init];
        _sendInfoLab.textAlignment = NSTextAlignmentLeft;
        _sendInfoLab.font = [UIFont systemFontOfSize:15.0f*kScale];
        _sendInfoLab.text  = @"配送信息";
        _sendInfoLab.textColor = RGB(51, 51, 51, 1);

    }
    return _sendInfoLab;
}

-(UILabel *)sendAddressLab{
    if (!_sendAddressLab) {
        _sendAddressLab = [[UILabel alloc] init];
        _sendAddressLab.textAlignment = NSTextAlignmentLeft;
        _sendAddressLab.font = [UIFont systemFontOfSize:12.0f*kScale];
        _sendAddressLab.text  = @"配送地址";
        _sendAddressLab.textColor = RGB(51, 51, 51, 1);

    }
    return _sendAddressLab;
}



-(UILabel *)orderNameLab{
    if (!_orderNameLab) {
        _orderNameLab = [[UILabel alloc] init];
        _orderNameLab.font = [UIFont systemFontOfSize:12.0f*kScale];
        _orderNameLab.textAlignment = NSTextAlignmentLeft;
    }
    return _orderNameLab;
}



-(UILabel *)orderPhoneNumerLab{
    if (!_orderPhoneNumerLab) {
        _orderPhoneNumerLab = [[UILabel alloc] init];
        _orderPhoneNumerLab.font = [UIFont systemFontOfSize:12.0f*kScale];
        _orderPhoneNumerLab.textAlignment = NSTextAlignmentLeft;
    }
    return _orderPhoneNumerLab;
}



-(UILabel *)orderAddressLab{
    if (!_orderAddressLab) {
        _orderAddressLab = [[UILabel alloc] init];
        _orderAddressLab.font = [UIFont systemFontOfSize:12.0f*kScale];
        _orderAddressLab.textAlignment = NSTextAlignmentLeft;
    }
    return _orderAddressLab;
}
///
-(UIView *)orderCommentBgView{
    if (!_orderCommentBgView) {
        _orderCommentBgView = [[UIView alloc] init];
        _orderCommentBgView.backgroundColor = [UIColor whiteColor];
    }
    return _orderCommentBgView;
}


-(UILabel *)orderCommentLab{
    if (!_orderCommentLab) {
        _orderCommentLab = [[UILabel alloc] init];
        _orderCommentLab.font = [UIFont systemFontOfSize:15.0f*kScale];
        _orderCommentLab.textAlignment = NSTextAlignmentLeft;
        _orderCommentLab.text = @"备注信息";
    }
    return _orderCommentLab;
}
-(UILabel *)orderCommentDetailsLab{
    if (!_orderCommentDetailsLab) {
        _orderCommentDetailsLab = [[UILabel alloc] init];
        _orderCommentDetailsLab.font = [UIFont systemFontOfSize:12.0f*kScale];
        _orderCommentDetailsLab.textAlignment = NSTextAlignmentLeft;
        _orderCommentDetailsLab.numberOfLines = 0;
    }
    return _orderCommentDetailsLab;
}





/////

-(UIView *)goodsBgView{
    if (!_goodsBgView) {
        _goodsBgView = [[UIView alloc] init];
        _goodsBgView.backgroundColor = [UIColor whiteColor];
    }
    return _goodsBgView;
}


-(UILabel *)goodsLab{
    if (!_goodsLab) {
        _goodsLab = [[UILabel alloc] init];
        _goodsLab.font = [UIFont systemFontOfSize:15.0f];
        _goodsLab.textAlignment = NSTextAlignmentLeft;
        _goodsLab.text = @"商品信息";
    }
    return _goodsLab;
}

-(void)setMainViewFrame{
    [self.statusBgImv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(self);
        make.top.equalTo(self);
        make.height.equalTo(@(85*kScale));
    }];
    
    [self.orderStatusLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.statusBgImv.mas_left).with.offset(30*kScale);
        make.top.equalTo(self.statusBgImv.mas_top).with.offset(25*kScale);
        make.width.equalTo(@(60*kScale));
        make.height.equalTo(@(15*kScale));
        
    }];
    
    [self.orderStatusDetailsLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.statusBgImv.mas_left).with.offset(30*kScale);
        make.top.equalTo(self.orderStatusLab.mas_bottom).with.offset(10*kScale);
        make.width.equalTo(@(260*kScale));
        make.height.equalTo(@(15*kScale));
    }];
    
    [self.statusImv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.statusBgImv.mas_right).with.offset(-20*kScale);
        make.top.equalTo(self.statusBgImv.mas_top).with.offset(24*kScale);
        make.width.equalTo(@(55*kScale));
        make.height.equalTo(@(41*kScale));
    }];
    //配送信息frame
    
    [self.sendBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self);
        make.top.equalTo(self.statusBgImv.mas_bottom).with.offset(10*kScale);
        make.right.equalTo(self);
        make.height.equalTo(@(96*kScale));
    }];
    
    [self.sendInfoLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.sendBgView.mas_left).with.offset(15*kScale);
        make.top.equalTo(self.sendBgView.mas_top).with.offset(22*kScale);
        make.width.equalTo(@(75*kScale));
        make.height.equalTo(@ (15*kScale));
    }];
    [self.sendAddressLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.sendBgView.mas_left).with.offset(15*kScale);
        make.top.equalTo(self.sendInfoLab.mas_bottom).with.offset(20*kScale);
        make.width.equalTo(@(75*kScale));
        make.height.equalTo(@(15*kScale));
    }];
    [self.orderNameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.sendInfoLab.mas_right).with.offset(15*kScale);
        make.top.equalTo(self.sendInfoLab);
        make.width.equalTo(@(80*kScale));
        make.height.equalTo(@(12*kScale));
    }];
    
    [self.orderPhoneNumerLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.orderNameLab.mas_right).with.offset(15*kScale);
        make.top.equalTo(self.sendInfoLab);
        make.right.equalTo(self.mas_right).with.offset(-15*kScale);
        make.height.equalTo(@(12*kScale));
    }];
    
    [self.orderAddressLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.orderNameLab);
        make.top.equalTo(self.sendAddressLab);
        make.width.equalTo(@(270*kScale));
        make.height.equalTo(@(12*kScale));
    }];
    
    
    
    [self.orderCommentBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self);
        make.top.equalTo(self.sendBgView.mas_bottom).with.offset(10*kScale);
        make.width.equalTo(@(kWidth));
        make.height.equalTo(@(40*kScale));
    }];
    
    [self.orderCommentLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.orderCommentBgView.mas_left).with.offset(15*kScale);
        make.top.equalTo(self.orderCommentBgView.mas_top).with.offset(15*kScale);
        make.width.equalTo(@(90*kScale));
        make.height.equalTo(@(15*kScale));
        
    }];
    
    [self.orderCommentDetailsLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.orderCommentBgView.mas_left).with.offset(15*kScale);
        make.top.equalTo(self.orderCommentLab.mas_bottom).with.offset(5*kScale);
        make.width.equalTo(@(kWidth-30*kScale));
        make.height.equalTo(@(15*kScale));
        
    }];
    
    
    
    
    
    [self.goodsBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self);
        make.top.equalTo(self.orderCommentBgView.mas_bottom).with.offset(10*kScale);
        make.width.equalTo(@(kWidth));
        make.height.equalTo(@(40*kScale));
    }];
    
    [self.goodsLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.goodsBgView.mas_left).with.offset(15*kScale);
        make.top.equalTo(self.goodsBgView.mas_top).with.offset(15*kScale);
        make.width.equalTo(@(90*kScale));
        make.height.equalTo(@(15*kScale));
        
    }];
    
}




/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

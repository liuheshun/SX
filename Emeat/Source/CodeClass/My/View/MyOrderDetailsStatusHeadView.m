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
        [self.sendBgView addSubview:self.sendAddressBtn];
        [self.sendBgView addSubview:self.orderNameLab];
        [self.sendBgView addSubview:self.orderPhoneNumerLab];
        [self.sendBgView addSubview:self.orderAddressLab];
        
        
        [self addSubview:self.seliceBgView];
        [self.seliceBgView addSubview:self.seliceLab];
        [self.seliceBgView addSubview:self.seliceDetailsLab];
        [self.seliceBgView addSubview:self.seliceBtn];
        
        
        [self addSubview:self.orderCommentBgView];
        [self.orderCommentBgView addSubview:self.orderCommentLab];
        [self.orderCommentBgView addSubview:self.orderCommentDetailsLab];
        [self.orderCommentBgView addSubview:self.orderCommentBtn];

        [self addSubview:self.goodsBgView];
        [self.goodsBgView addSubview:self.goodsLab];
        [self setMainViewFrame];
      
    }
    return self;
}

-(void)configAddressWithModel:(MyAddressModel*)addressModel orderModel:(OrderModel*)orderModel OutBoundProductNameMarray:(NSMutableArray *)nameMarray OutBoundProductSizeMarray:(NSMutableArray *)sizeMarray OutBoundProductCountMarray:(NSMutableArray *)countMarray{
    DLog(@"sssssssssssssssss=========== 状态码= %ld  周期性用户码 = %ld" ,orderModel.status , orderModel.periodic);
    
    if (orderModel.status == 10){
        self.orderStatusLab.text = @"待支付";
        self.orderStatusDetailsLab.text = @"订单提交成功,等待用户支付";
        [self.statusImv setImage:[UIImage imageNamed:@"daizhifu"] forState:0];

        if (orderModel.paymentType == 12) {
            
            
            [self addSubview:self.myOrderDetailsStatusAccountHeadView];
            [self.sendBgView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.mas_left).with.offset(0);
                make.top.equalTo(self.myOrderDetailsStatusAccountHeadView.mas_bottom).with.offset(20*kScale);
                make.right.equalTo(self.mas_right).with.offset(0);
                make.height.equalTo(@(96*kScale));
            }];
            
        }else {
            
            [self.sendBgView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.mas_left).with.offset(0);
                make.top.equalTo(self.statusBgImv.mas_bottom).with.offset(10*kScale);
                make.right.equalTo(self.mas_right).with.offset(0);
                make.height.equalTo(@(96*kScale));
            }];
            
        }
        
        
    }else  if (orderModel.status == 50 || orderModel.status == 40 || orderModel.status == 46){
        self.orderStatusLab.text = @"待确认";
        self.orderStatusDetailsLab.text = @"用户已支付,等待商家发货";
        [self.statusImv setImage:[UIImage imageNamed:@"daifahuo1"] forState:0];
        
        
        
#pragma mark ============================12为 ,线下打款
        if (orderModel.paymentType == 12) {
            
            
            [self addSubview:self.myOrderDetailsStatusAccountHeadView];
            [self.sendBgView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.mas_left).with.offset(0);
                make.top.equalTo(self.myOrderDetailsStatusAccountHeadView.mas_bottom).with.offset(20*kScale);
                make.right.equalTo(self.mas_right).with.offset(0);
                make.height.equalTo(@(96*kScale));
            }];
            
        }else {
            
            [self.sendBgView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.mas_left).with.offset(0);
                make.top.equalTo(self.statusBgImv.mas_bottom).with.offset(10*kScale);
                make.right.equalTo(self.mas_right).with.offset(0);
                make.height.equalTo(@(96*kScale));
            }];
            
        }
        
        

    }else if (orderModel.status == 60 || orderModel.status == 55){
          self.orderStatusLab.text = @"配送中";
        self.orderStatusDetailsLab.text = @"商家已发货,正在配送中";
        [self.statusImv setImage:[UIImage imageNamed:@"peisongzhong"] forState:0];

    }else if (orderModel.status == 70){
        self.orderStatusLab.text = @"待收货";
        self.orderStatusDetailsLab.text = @"商家已送达,等待签收";
        [self.statusImv setImage:[UIImage imageNamed:@"daiheyan"] forState:0];
        
    }else if (orderModel.status == 120)
    {
        self.orderStatusLab.text = @"待核验";
        self.orderStatusDetailsLab.text = @"用户正在退回相应商品,等待商家核验";
        [self.statusImv setImage:[UIImage imageNamed:@"daiheyan"] forState:0];

    }else if (orderModel.status == 140){
        self.orderStatusLab.text = @"已退货";
        self.orderStatusDetailsLab.text = @"用户已退回相应商品,货款已退回";
        [self.statusImv setImage:[UIImage imageNamed:@"yituihuo"] forState:0];

    }else if (orderModel.status == 20){
        self.orderStatusLab.text = @"取消退货";
        self.orderStatusDetailsLab.text = @"商家经过核验,退货申请已取消";
        [self.statusImv setImage:[UIImage imageNamed:@"quxiaotuihuo"] forState:0];

    }else if (orderModel.status == 80){
        self.orderStatusLab.text = @"已完成";
        self.orderStatusDetailsLab.text = @"用户确认收货 ,订单完成";
        [self.statusImv setImage:[UIImage imageNamed:@"yiwancheng"] forState:0];

        
    }else if (orderModel.status == 0 || orderModel.status == 51 || orderModel.status == 52){
        self.orderStatusLab.text = @"已取消";
        self.orderStatusDetailsLab.text = @"用户已取消订单";
        
        [self.statusImv setImage:[UIImage imageNamed:@"quxiaotuihuo"] forState:0];
    }
    
    
    
    ///配送地址
    self.orderNameLab.text = addressModel.receiverName;
    self.orderPhoneNumerLab.text =[NSString stringWithFormat:@"%ld",addressModel.receiverPhone] ;
    self.orderAddressLab.text = [NSString stringWithFormat:@"%@%@" ,addressModel.receiverProvince , addressModel.receiverAddress];
    
    ///加工服务
  
    self.seliceDetailsLab.text = orderModel.serviceType;
    
    CGFloat seliceDetailsLabHeight = [GetWidthAndHeightOfString getHeightForText:self.seliceDetailsLab width:kWidth-52*kScale];
    
    
    [self.seliceDetailsLab mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(ceil (seliceDetailsLabHeight)+1));
    }];
    [self.seliceBgView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(85*kScale +ceil (seliceDetailsLabHeight)+1));
    }];
    
    
    
    ///备注信息
    self.orderCommentDetailsLab.text = orderModel.orderComment;
    CGFloat orderCommentDetailsLabHeight = [GetWidthAndHeightOfString getHeightForText:self.orderCommentDetailsLab width:kWidth-52*kScale];
    
   
    [self.orderCommentDetailsLab mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(ceil (orderCommentDetailsLabHeight)+1));
    }];
    [self.orderCommentBgView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(85*kScale +ceil (orderCommentDetailsLabHeight)+1));
    }];
    
//    self.orderCommentBgView.backgroundColor = [UIColor cyanColor];
    
    ////
    [self.goodsBgView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self);
        make.bottom.equalTo(self.mas_bottom).with.offset(0*kScale);
        make.width.equalTo(@(kWidth));
        make.height.equalTo(@(40*kScale));
    }];
    
    
    orderModel.orderDeatailsCommentHeight = ceil (orderCommentDetailsLabHeight)+1;
    
    DLog(@"gggggggggggggggggggggggg=========%f" ,ceil (orderCommentDetailsLabHeight)+1);
    
    
    
    
    
    if (orderModel.status == 60 || orderModel.status == 70 || orderModel.status == 80) {

        [self addSubview:self.sendDetailsBgView];
        [self.sendDetailsBgView addSubview:self.sendDetailsLab];
        
        
        [self.sendDetailsBgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left).with.offset(0*kScale);
            make.top.equalTo(self.orderCommentBgView.mas_bottom).with.offset(10*kScale);
            make.right.equalTo(self.mas_right).with.offset(0*kScale);
            make.height.equalTo(@(70*kScale +(nameMarray.count +1) *44*kScale + (nameMarray.count +1)*1*kScale));
        }];
        
        [self.sendDetailsLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left).with.offset(15*kScale);
            make.top.equalTo(self.sendDetailsBgView.mas_top).with.offset(15*kScale);
            make.right.equalTo(self.mas_right).with.offset(-15*kScale);
            make.height.equalTo(@(15*kScale));
        }];
        
        JHGridView *gridView = [[JHGridView alloc] initWithFrame:CGRectMake(15*kScale, 44*kScale, kWidth-30*kScale, ( nameMarray.count +1) *43*kScale + ( nameMarray.count +1)*1*kScale)];
        
        gridView.delegate = self;
        
        NSMutableArray *array = [NSMutableArray array];
        for (int i = 0; i<nameMarray.count; i++) {
        [array addObject:[[TestObject alloc] initWithName:nameMarray[i] Sex:sizeMarray[i] Number:countMarray[i] Address:@"sdfabfsakjbakf" Birthday:@"1996-06-14"]];
        }
        
 
        [gridView setTitles:@[@"品名",
                              @"实际重量",
                              @"配送数量",
                             ]
                 andObjects:array withTags:@[@"name",@"sex",@"number"]];
        [self.sendDetailsBgView addSubview:gridView];
        
        
        [self.goodsBgView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self);
            make.top.equalTo(self.sendDetailsBgView.mas_bottom).with.offset(10*kScale);
            make.width.equalTo(@(kWidth));
            make.height.equalTo(@(40*kScale));
        }];
        
        
        
    }

}




#pragma mark == 周期性用户view

-(MyOrderDetailsStatusAccountHeadView *)myOrderDetailsStatusAccountHeadView{
    if (!_myOrderDetailsStatusAccountHeadView) {
        _myOrderDetailsStatusAccountHeadView = [[MyOrderDetailsStatusAccountHeadView  alloc] initWithFrame:CGRectMake(0, 95*kScale, kWidth, 94*kScale)];
        _myOrderDetailsStatusAccountHeadView.backgroundColor = [UIColor whiteColor];
    }
    return _myOrderDetailsStatusAccountHeadView;
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

-(UIButton *)sendAddressBtn{
    if (!_sendAddressBtn) {
        _sendAddressBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_sendAddressBtn setImage:[UIImage imageNamed:@"配送信息"] forState:0];
    }
    return _sendAddressBtn;
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

////加工服务
-(UIView *)seliceBgView{
    if (!_seliceBgView) {
        _seliceBgView = [[UIView alloc] init];
        _seliceBgView.backgroundColor = [UIColor whiteColor];
    }
    return _seliceBgView;
}


-(UILabel *)seliceLab{
    if (!_seliceLab) {
        _seliceLab = [[UILabel alloc] init];
        _seliceLab.font = [UIFont systemFontOfSize:15.0f*kScale];
        _seliceLab.textAlignment = NSTextAlignmentLeft;
        _seliceLab.text = @"加工服务";
    }
    return _seliceLab;
}
-(UILabel *)seliceDetailsLab{
    if (!_seliceDetailsLab) {
        _seliceDetailsLab = [[UILabel alloc] init];
        _seliceDetailsLab.font = [UIFont systemFontOfSize:12.0f*kScale];
        _seliceDetailsLab.textAlignment = NSTextAlignmentLeft;
        _seliceDetailsLab.numberOfLines = 0;
    }
    return _seliceDetailsLab;
}

-(UIButton *)seliceBtn{
    if (!_seliceBtn) {
        _seliceBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_seliceBtn setImage:[UIImage imageNamed:@"加工服务"] forState:0];
    }
    return _seliceBtn;
}






///备注信息
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

-(UIButton *)orderCommentBtn{
    if (!_orderCommentBtn) {
        _orderCommentBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_orderCommentBtn setImage:[UIImage imageNamed:@"备注信息"] forState:0];
    }
    return _orderCommentBtn;
}

////配送明细



-(UIView *)sendDetailsBgView{
    if (!_sendDetailsBgView) {
        _sendDetailsBgView = [[UIView alloc] init];
        _sendDetailsBgView.backgroundColor = [UIColor whiteColor];
    }
    return _sendDetailsBgView;
}


-(UILabel *)sendDetailsLab{
    if (!_sendDetailsLab) {
        _sendDetailsLab = [[UILabel alloc] init];
        _sendDetailsLab.textAlignment = NSTextAlignmentLeft;
        _sendDetailsLab.font = [UIFont systemFontOfSize:15.0f*kScale];
        _sendDetailsLab.text  = @"配送明细";
        _sendDetailsLab.textColor = RGB(51, 51, 51, 1);
        
    }
    return _sendDetailsLab;
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
        make.top.equalTo(self.sendBgView.mas_top).with.offset(18*kScale);
        make.width.equalTo(@(75*kScale));
        make.height.equalTo(@ (15*kScale));
    }];
    [self.sendAddressBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.sendBgView.mas_left).with.offset(15*kScale);
        make.top.equalTo(self.sendInfoLab.mas_bottom).with.offset(22*kScale);
        make.width.equalTo(@(22*kScale));
        make.height.equalTo(@(22*kScale));
    }];
    [self.orderNameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.sendAddressBtn.mas_right).with.offset(15*kScale);
        make.top.equalTo(self.sendInfoLab.mas_bottom).with.offset(15*kScale);
        make.width.equalTo(@(80*kScale));
        make.height.equalTo(@(12*kScale));
    }];
    
    [self.orderPhoneNumerLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.orderNameLab.mas_right).with.offset(15*kScale);
        make.top.equalTo(self.orderNameLab);
        make.right.equalTo(self.mas_right).with.offset(-15*kScale);
        make.height.equalTo(@(12*kScale));
    }];
    
    [self.orderAddressLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.orderNameLab);
        make.bottom.equalTo(self.sendAddressBtn);
        make.width.equalTo(@(270*kScale));
        make.height.equalTo(@(12*kScale));
    }];
    
    ///加工服务frame
    
    [self.seliceBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self);
        make.top.equalTo(self.sendBgView.mas_bottom).with.offset(10*kScale);
        make.width.equalTo(@(kWidth));
        make.height.equalTo(@(85*kScale));
    }];
    
    [self.seliceLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.seliceBgView.mas_left).with.offset(15*kScale);
        make.top.equalTo(self.seliceBgView.mas_top).with.offset(15*kScale);
        make.width.equalTo(@(90*kScale));
        make.height.equalTo(@(15*kScale));
        
    }];
    
    [self.seliceBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.seliceBgView.mas_left).with.offset(15*kScale);
        make.top.equalTo(self.seliceLab.mas_bottom).with.offset(20*kScale);
        make.width.equalTo(@(22*kScale));
        make.height.equalTo(@(22*kScale));
        
    }];
    
    
    
    [self.seliceDetailsLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.seliceBtn.mas_right).with.offset(15*kScale);
        make.top.equalTo(self.seliceLab.mas_bottom).with.offset(21*kScale);
        make.right.equalTo(self.seliceBgView.mas_right).with.offset(-15*kScale);
        make.height.equalTo(@(15*kScale));
        
    }];
    
    
    
    
    
    ///备注frame
    
    [self.orderCommentBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self);
        make.top.equalTo(self.seliceBgView.mas_bottom).with.offset(10*kScale);
        make.width.equalTo(@(kWidth));
        make.height.equalTo(@(85*kScale));
    }];
    
    [self.orderCommentLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.orderCommentBgView.mas_left).with.offset(15*kScale);
        make.top.equalTo(self.orderCommentBgView.mas_top).with.offset(15*kScale);
        make.width.equalTo(@(90*kScale));
        make.height.equalTo(@(15*kScale));
        
    }];
    
    [self.orderCommentBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.orderCommentBgView.mas_left).with.offset(15*kScale);
        make.top.equalTo(self.orderCommentLab.mas_bottom).with.offset(20*kScale);
        make.width.equalTo(@(22*kScale));
        make.height.equalTo(@(22*kScale));
        
    }];
    
    
    
    [self.orderCommentDetailsLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.orderCommentBtn.mas_right).with.offset(15*kScale);
        make.top.equalTo(self.orderCommentLab.mas_bottom).with.offset(22*kScale);
        make.right.equalTo(self.orderCommentBgView.mas_right).with.offset(-15*kScale);
        make.height.equalTo(@(15*kScale));
        
    }];
    
    
   
    
    
    
    
    
    [self.goodsBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self);
        make.bottom.equalTo(self.mas_bottom).with.offset(0*kScale);
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

- (void)didSelectRowAtGridIndex:(GridIndex)gridIndex{
    NSLog(@"selected at\ncol:%ld -- row:%ld", gridIndex.col, gridIndex.row);
}

- (BOOL)isTitleFixed{
    return YES;
}

- (CGFloat)widthForColAtIndex:(long)index{
    if (index == 0) {
        return 145*kScale;
    }
    return 100*kScale;
}

//- (CGFloat)heightForRowAtIndex:(long)index{
//    return 100*kScale;
//}


- (UIColor *)backgroundColorForTitleAtIndex:(long)index{
    return [UIColor whiteColor];
}

- (UIColor *)backgroundColorForGridAtGridIndex:(GridIndex)gridIndex{
    
        return [UIColor whiteColor];

}

- (UIColor *)textColorForTitleAtIndex:(long)index{
   
        return RGB(51, 51, 51, 1);

}

- (UIColor *)textColorForGridAtGridIndex:(GridIndex)gridIndex{
    return RGB(136, 136, 136, 1);
}

- (UIFont *)fontForTitleAtIndex:(long)index{
    return [UIFont systemFontOfSize:13*kScale];
}

- (UIFont *)fontForGridAtGridIndex:(GridIndex)gridIndex{
    return [UIFont systemFontOfSize:11*kScale];
}

- (JHGridAlignmentType)gridViewAlignmentType{
    return JHGridAlignmentTypeLeft;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

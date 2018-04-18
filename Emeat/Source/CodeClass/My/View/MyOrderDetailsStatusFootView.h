//
//  MyOrderDetailsStatusFootView.h
//  Emeat
//
//  Created by liuheshun on 2017/12/18.
//  Copyright © 2017年 liuheshun. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface MyOrderDetailsStatusFootView : UIView

typedef void(^ReturnDeleteClickBlcok)(NSInteger clickIndex);


@property (nonatomic,strong) UIView *footTopBgView;
//商品总价
@property (nonatomic,strong) UILabel *orderAllPricesLab;
@property (nonatomic,strong) UILabel *orderAllPricesCount;
//配送费

@property (nonatomic,strong) UILabel *sendPricesLab;
@property (nonatomic,strong) UILabel *sendPricesCount;


@property (nonatomic,strong) UILabel *orderPayStatus;
@property (nonatomic,strong) UILabel *orderPayPrices;

@property (nonatomic,strong) UIView *footBottomView;
@property (nonatomic,strong) UILabel *orderInfoLab;
///订单号
@property (nonatomic,strong) UILabel *orderNumber;
///下单时间
@property (nonatomic,strong) UILabel *orderTime;
///支付时间
@property (nonatomic,strong) UILabel *payTime;
///发货时间
@property (nonatomic,strong) UILabel *sendTime;
///送达时间
@property (nonatomic,strong) UILabel *arriveTime;

///取消时间
@property (nonatomic,strong) UILabel *cancelTime;
 //// ///赋值 以及   上传打款凭证
-(void)configOrderDetailsFootViewWithModel:(OrderModel*)model configMoneyProve:(NSMutableArray*)imageArray isShow:(BOOL)isShow;

@property (nonatomic,strong) UIImageView *proveImage;
@property (nonatomic,strong) UIButton *deleteImvBtn;

@property (nonatomic,copy) ReturnDeleteClickBlcok returnDeleteClickBlcok;





@end

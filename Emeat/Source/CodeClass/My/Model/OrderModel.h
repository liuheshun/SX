//
//  OrderModel.h
//  Emeat
//
//  Created by liuheshun on 2018/1/29.
//  Copyright © 2018年 liuheshun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OrderModel : NSObject


///默认商品分页总数
@property (nonatomic,assign) NSInteger pages;
///每页展示的商品数量
@property (nonatomic,assign) NSInteger pageSize;
///数据总条数
@property (nonatomic,assign) NSInteger total;//(total/pageSize = pages)

////////
@property (nonatomic,strong) NSString *sectionStr;


///"orderNo": 1517484534250197011,        订单号
@property (nonatomic,strong) NSString *orderNo;
///"productId": 12,                        商品id
@property (nonatomic,strong) NSString *productId;
///"productName": "1",                    商品名称
@property (nonatomic,strong) NSString *productName;
///"productImage": "1",                    商品图片
@property (nonatomic,strong) NSString *productImage;
///"currentUnitPrice": null,            当前单价
@property (nonatomic,strong) NSString *currentUnitPrice;
///"quantity": 0,                        数量
@property (nonatomic,strong) NSString *quantity;
///单个商品总价
@property (nonatomic,strong) NSString *totalPrice;
/// 下单时间
@property (nonatomic,strong) NSString *createOrderTime;


@property (nonatomic,strong) MyAddressModel *myAddressModel;

///"payment": 44400,                    一个订单付款总数
@property (nonatomic,strong) NSString *payment;
///"status": 10,                        订单状态
@property (nonatomic,assign) NSUInteger status;
///"statusDesc": "未支付",                订单状态描述
@property (nonatomic,strong) NSString *statusDesc;
///"productAmount": 2,                        商品总数
@property (nonatomic,strong) NSString *productAmount;
///"orderComment": "",                        订单备注
@property (nonatomic,strong) NSString *orderComment;


///
@property (nonatomic,strong) NSString *createTime;

///订单详情总价
@property (nonatomic,strong) NSString *orderTotalPrice;


@property (nonatomic,strong) NSString *paymentTypeDesc;

///上传打款凭证图片string
@property (nonatomic,strong) NSString *voucherImg;


///订单详情页备注信息高度
@property (nonatomic,assign) CGFloat orderDeatailsCommentHeight;

///财务是否确认
@property (nonatomic,assign) NSInteger financeConfirm;
///是否为周期性用户
@property (nonatomic,assign) NSInteger periodic;
///支付方式 999= 支付宝 888=微信 11=线下打款
@property (nonatomic,assign) NSInteger paymentType;

/////订单编号
//@property (nonatomic,assign) NSInteger orderNo;
/////用户姓名
//@property (nonatomic,strong) NSString *userName;
//
//@property (nonatomic,assign) NSInteger userId;
/////商品名称
//@property (nonatomic,strong) NSString * productName;
/////商品规格
//@property (nonatomic,strong) NSString * productSize;
/////商品价格
//@property (nonatomic,assign) NSInteger productPrice;
/////商品质量
//@property (nonatomic,assign) NSInteger quantity;
/////总价
//@property (nonatomic,assign) NSInteger totalPrice;
/////邮费
//@property (nonatomic,assign) NSInteger postage;
/////最终总价
//@property (nonatomic,assign) NSInteger finalTotalPrice;
/////备注
//@property (nonatomic,strong) NSString * comment;
/////配送地址id
//@property (nonatomic,assign) NSInteger shippingId;
/////付款金额
//@property (nonatomic,assign) NSInteger payment;

/////支付状态
//@property (nonatomic,assign) NSInteger paymentStatus;
/////订单状态
//@property (nonatomic,assign) NSInteger status;
//
//@property (nonatomic,strong) NSString * statusDesc;
//
///支付时间
@property (nonatomic,strong) NSString * paymentTime;
///发货时间
@property (nonatomic,strong) NSString * sendTime;
///送达时间
@property (nonatomic,strong) NSString *receiveTime;


///订单完成时间
@property (nonatomic,strong) NSString * endTime;
///订单关闭时间
@property (nonatomic,strong) NSString * closeTime;

////
@property (nonatomic,strong) NSString *priceTypes;


///退货原因
//@property (nonatomic,strong) NSString * refundReason;
//@property (nonatomic,strong) NSString * createOrderTime;
//@property (nonatomic,strong) NSString * updateTime;
@end

//
//  ShoppingCartModel.h
//  Emeat
//
//  Created by liuheshun on 2017/11/7.
//  Copyright © 2017年 liuheshun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ShoppingCartModel : NSObject
//
//@property (nonatomic,strong) NSString *sizeStr;
//@property (nonatomic,strong) NSString *nameStr;
//@property (nonatomic,strong) NSString *dateStr;
////@property (nonatomic,assign) NSInteger number;
////@property (nonatomic,strong) NSString *price;
//@property (nonatomic,strong) NSString *image;


// Long productId;                    商品id
//    Integer quatity;                     购物车中此商品的数量
//    String productName;            商品名称
//    String mainImage;                 主图
//    Integer productPrice;            产品价格
//    Integer productStatus;          产品状态（上架，下架）
//    Integer productTotalPrice;     商品总价
//    Integer productStock;           库存
//   Integer productChecked;       此商品是否勾选
//   String limitQuantity;// 限制数量的一个返回结果
/// 商品id
@property (nonatomic,assign) NSInteger commodityId;

/// 购物车中此商品的数量
@property (nonatomic,assign) NSInteger quatity;

///
@property (nonatomic,assign) NSInteger quantity;

///商品名称
@property (nonatomic,strong) NSString *productName;
///商品主图
@property (nonatomic,strong) NSString *mainImage;

/// 商品价格
@property (nonatomic,strong) NSString *productPrice;
///商品原价
@property (nonatomic,strong) NSString *costPrice;


///商品重量规格
@property (nonatomic,strong) NSString *productSize;
////标准规格
@property (nonatomic,strong) NSString *standardSize;


///商品状态（上架，下架）
@property (nonatomic,assign) NSInteger productStatus;

///商品总价 确认订单
@property (nonatomic,strong) NSString *productTotalPrice;
///需支付 确认订单
@property (nonatomic,strong) NSString *payment;


///商品库存
@property (nonatomic,assign) NSInteger productStock;

///此商品是否勾选
@property (nonatomic,assign) NSInteger productChecked;

///限制数量的一个返回结果
@property (nonatomic,strong) NSString *limitQuantity;

@property (nonatomic,assign) BOOL isSelect;

///购物车购买全部商品总价
@property (nonatomic,strong) NSString *cartTotalPrice;


/// 一种商品的总价(购买数量一个 多个)
@property (nonatomic,strong) NSString *totalPrice;
///邮费
@property (nonatomic,strong) NSString * postMoney;
///加工耗材费
@property (nonatomic,strong) NSString *slicePrices;

///
@property (nonatomic,strong) NSString *servicePrice;

///
@property (nonatomic,strong) NSString *currentUnitPrice;

///区分B端 C端 订单
@property (nonatomic,strong) NSString *businessType;


///商品对象新加字段discountPrice 促销价(分)用于判断是否需要划掉原价 , -1为没促销价
@property (nonatomic,assign) NSInteger discountPrice;


///商品状态
@property (nonatomic,strong) NSString *priceTypes;

//代金券价格
@property (nonatomic,strong) NSString *ticketMoneySum;
@property (nonatomic,assign) NSInteger amount;
///代金券名称
@property (nonatomic,strong) NSString *ticketName;
///代金券id
@property (nonatomic,assign) NSInteger cardId;



@end

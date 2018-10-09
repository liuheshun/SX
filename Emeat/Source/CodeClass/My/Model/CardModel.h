//
//  CardModel.h
//  Emeat
//
//  Created by liuheshun on 2018/8/16.
//  Copyright © 2018年 liuheshun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CardModel : NSObject
///代金券id
@property (nonatomic,assign) NSInteger cardId;

///代金券名字
@property (nonatomic,strong) NSString *ticketName;
///代金券金额
@property (nonatomic,assign) NSInteger amount;
@property (nonatomic,strong) NSString *discountAmount;
@property (nonatomic,assign) NSInteger satisfyAmount;
///代金券描述
@property (nonatomic,strong) NSString *desc;

///代金券使用时间
@property (nonatomic,strong) NSString *distributeEndTime;
///代金券状态
@property (nonatomic,strong) NSString *status;

///减去代金券订单总价
@property (nonatomic,strong) NSString *productTotalPrice;
///配送费
@property (nonatomic,strong) NSString *postMoney;

///券类型 VOUCHER= 满减券  CASH_COUPON= 代金券
@property (nonatomic,strong) NSString *ticketType;




@end

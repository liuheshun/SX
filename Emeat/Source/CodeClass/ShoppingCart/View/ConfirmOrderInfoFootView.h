//
//  ConfirmOrderInfoFootView.h
//  Emeat
//
//  Created by liuheshun on 2017/11/10.
//  Copyright © 2017年 liuheshun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ConfirmOrderInfoFootView : UIView

///优惠券
@property (nonatomic,strong) UIButton *cardUseBtn;
@property (nonatomic,strong) UILabel *cardPricesLab;




//商品总价
@property (nonatomic,strong) UILabel *labelOrder;
@property (nonatomic,strong) UILabel *labelOrderTotalPrice;

//配送费
@property (nonatomic,strong) UILabel *labelShipping;
@property (nonatomic,strong) UILabel *labelShippingFee;

//切片 加工耗材费
@property (nonatomic,strong) UILabel *sliceLabPlaceholderLab;
@property (nonatomic,strong) UILabel *sliceLab;

//卡券抵扣
@property (nonatomic,strong) UILabel *cardAddPricesPlaceholderLab;
@property (nonatomic,strong) UILabel *cardAddPricesLab;



-(void)configFootViewWithShoppingModel:(ShoppingCartModel*)model;

@end

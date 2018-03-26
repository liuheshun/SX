//
//  ConfirmOrderInfoFootView.h
//  Emeat
//
//  Created by liuheshun on 2017/11/10.
//  Copyright © 2017年 liuheshun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ConfirmOrderInfoFootView : UIView
//商品总价
@property (nonatomic,strong) UILabel *labelOrder;
@property (nonatomic,strong) UILabel *labelOrderTotalPrice;

//配送费
@property (nonatomic,strong) UILabel *labelShipping;
@property (nonatomic,strong) UILabel *labelShippingFee;

-(void)configFootViewWithShoppingModel:(ShoppingCartModel*)model;

@end

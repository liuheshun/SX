//
//  ShoppingCartBottomView.h
//  Emeat
//
//  Created by liuheshun on 2017/11/8.
//  Copyright © 2017年 liuheshun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShoppingCartBottomView : UIView
@property (nonatomic,strong) UIButton *selectAll;//全选按钮
@property (nonatomic,strong) UILabel *priceLabel;//价格
@property (nonatomic,strong) UIButton *PayBtn;//结算按钮
@property (nonatomic,strong) UILabel *sendPricesDesc;//配送

@property (nonatomic,strong) UILabel *sendPrices;///配送费


@end

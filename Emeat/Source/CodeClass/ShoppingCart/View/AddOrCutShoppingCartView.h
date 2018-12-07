//
//  AddOrCutShoppingCartView.h
//  Emeat
//
//  Created by liuheshun on 2017/11/27.
//  Copyright © 2017年 liuheshun. All rights reserved.
//购物车 +- 按钮

#import <UIKit/UIKit.h>
typedef void(^cartNumChange)(void);

@interface AddOrCutShoppingCartView : UIView

@property (nonatomic,strong) UILabel *numberLabel;
@property (nonatomic,copy) cartNumChange numAddBlock;
@property (nonatomic,copy) cartNumChange numCutBlock;
@property (nonatomic,strong) UIButton *addBtn;


@end

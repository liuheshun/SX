//
//  CardView.h
//  仿陌陌点点切换
//
//  Created by zjwang on 16/3/28.
//  Copyright © 2016年 Xsummerybc. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface CardView : UIView

///图片
@property (nonatomic, strong) UIImageView *imageView;
///标题
@property (nonatomic, strong) UILabel *labelTitle;
///价格
@property (nonatomic, strong) UILabel *labelNewPrices;
///原价
@property (nonatomic, strong) UILabel *labelOldPrices;
///加入购物车按钮
@property (nonatomic, strong) UIButton *addShoppingCardBtn;


//-(void)configDataWithModel:(ZhiKuListModel*)model;



@end

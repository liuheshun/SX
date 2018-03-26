//
//  YouLikeCollectionViewCell.h
//  Emeat
//
//  Created by liuheshun on 2017/11/17.
//  Copyright © 2017年 liuheshun. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface YouLikeCollectionViewCell : UICollectionViewCell
///商品图片
@property (nonatomic,strong) UIImageView *imv;
///商品名称
@property (nonatomic,strong) UILabel *nameLable;
///商品价格
@property (nonatomic,strong) UILabel *priceLable;
///规格
@property (nonatomic,strong) UILabel *weightLable;
///加入购物车按钮
@property (nonatomic,strong) UIButton *joinCartBtn;

//-(void)setUI;

-(void)SetCollCellData:(HomePageModel*)model;


@end

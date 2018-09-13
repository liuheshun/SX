//
//  SearchCollectionViewCell.h
//  Emeat
//
//  Created by liuheshun on 2018/8/7.
//  Copyright © 2018年 liuheshun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchCollectionViewCell : UICollectionViewCell

//标签
@property (nonatomic,strong) UIButton *lableBtn;
//商品图片
@property (nonatomic,strong) UIImageView *mainImv;
//商品名字
@property (nonatomic,strong) UILabel *nameLab;
//商品描述
@property (nonatomic,strong) UILabel *descLab;
//商品重量规格
@property (nonatomic,strong) UILabel *weightLab;
///商品促销价格
@property (nonatomic,strong) UIButton *newsPriceBtn;
///商品原价
@property (nonatomic,strong) UIButton *oldPriceBtn;


//购物车按钮
@property (nonatomic,strong) UIButton *cartBtn;

//
@property (nonatomic,strong) AddOrCutShoppingCartView *cartView;


-(void)configHomePageCellWithModel:(HomePageModel*)model;





@end

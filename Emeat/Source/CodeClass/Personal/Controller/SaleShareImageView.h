//
//  SaleShareImageView.h
//  Emeat
//
//  Created by liuheshun on 2018/8/30.
//  Copyright © 2018年 liuheshun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SaleShareImageView : UIView
///logo
@property (nonatomic,strong) UIImageView *logoImageView;
///分享商品主图
@property (nonatomic,strong) UIImageView *mainImageView;
///分享标题
@property (nonatomic,strong) UILabel *titleLab;
///分享描述
@property (nonatomic,strong) UILabel *descLab;
///价格
@property (nonatomic,strong) UILabel *pricesLab;
///横线
@property (nonatomic,strong) UIImageView *lingView;
///二维码
@property (nonatomic,strong) UIImageView *codeImageView;
///二维码描述
@property (nonatomic,strong) UILabel *codeDescLab1;
@property (nonatomic,strong) UILabel *codeDescLab2;
@property (nonatomic,strong) UILabel *codeDescLab3;

///中间三角图片
@property (nonatomic,strong)  UIButton *imageBtn;

///
@property (nonatomic,strong) UIImageView *userImageBtn;
@property (nonatomic,strong) UILabel *userNameLab;
@property (nonatomic,strong) UILabel *saleNameLab;






-(void)configShareViewMainimage:(NSString*)mainImage Title:(NSString*)title Desc:(NSString*)desc Prices:(NSString*)prices codeURL:(NSString*)codeUrl PriceTypes:(NSString*)priceTypes;

@end

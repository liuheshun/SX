//
//  ShareImageView.h
//  Emeat
//
//  Created by liuheshun on 2018/7/16.
//  Copyright © 2018年 liuheshun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShareImageView : UIView
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
@property (nonatomic,strong) UIView *lingView;
///二维码
@property (nonatomic,strong) UIImageView *codeImageView;
///二维码描述
@property (nonatomic,strong) UILabel *codeDescLab1;
@property (nonatomic,strong) UILabel *codeDescLab2;


-(void)configShareViewMainimage:(NSString*)mainImage Title:(NSString*)title Desc:(NSString*)desc Prices:(NSString*)prices codeURL:(NSString*)codeUrl PriceTypes:(NSString*)priceTypes;


@end

//
//  HomePageDetailsHeadView.h
//  Emeat
//
//  Created by liuheshun on 2017/11/20.
//  Copyright © 2017年 liuheshun. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^changeSelectStyleBlock)(void);

@interface HomePageDetailsHeadView : UIView<SDCycleScrollViewDelegate>
//轮播图
@property (nonatomic,strong) SDCycleScrollView *cycleScrollView;


-(void)setSDCycleScrollView:(NSArray*)imvURLArray;
//商品图片
@property (nonatomic,strong) UIImageView *mainImv;
//商品名字
@property (nonatomic,strong) UILabel *nameLab;
//商品描述
@property (nonatomic,strong) UILabel *descLab;
//商品重量规格
@property (nonatomic,strong) UILabel *weightLab;
//商品价格
@property (nonatomic,strong) UILabel *pricelab;
//提示说明
@property (nonatomic,strong) UIButton *noticeBtn;


//商品详情按钮
@property (nonatomic,strong) UIButton *goodsDetailsBtn;
//评价详情
@property (nonatomic,strong) UIButton *pingjiaDetailsBtn;

@property (nonatomic,strong) UIView *lineView;

@property (nonatomic,strong) UIView *lineleftView;
@property (nonatomic,strong) UIView *lineRightView;

@property (nonatomic,copy) changeSelectStyleBlock changeGoodsDetailsBlock;

@property (nonatomic,copy) changeSelectStyleBlock changeCommentDetailsBlock;


///详情描述字段：
//@property (nonatomic,strong) UILabel *speDescLab;

///原产地
@property (nonatomic,strong) UILabel *countryLab;
///部位
@property (nonatomic,strong) UILabel *partLab;
///规格
@property (nonatomic,strong) UILabel *standardsLab;
///品种
@property (nonatomic,strong) UILabel *breedLab;
///存储条件环境
@property (nonatomic,strong) UILabel *environmentLab;
///品牌
@property (nonatomic,strong) UILabel *brandLab;

-(void)configHeadViewWithModel:(HomePageModel*)model;



@end

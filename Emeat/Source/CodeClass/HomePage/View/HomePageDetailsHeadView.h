//
//  HomePageDetailsHeadView.h
//  Emeat
//
//  Created by liuheshun on 2017/11/20.
//  Copyright © 2017年 liuheshun. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^changeSelectStyleBlock)(void);

typedef void(^ReturnSelectIndex)(NSInteger selectIndex);

@interface HomePageDetailsHeadView : UIView

//商品名字
@property (nonatomic,strong) UILabel *nameLab;
//商品描述
@property (nonatomic,strong) UILabel *descLab;
//商品重量规格
@property (nonatomic,strong) UILabel *weightLab;
//商品促销价价格
@property (nonatomic,strong) UIButton *newspriceBtnLab;

//商品原价格
@property (nonatomic,strong) UIButton *oldspriceBtnLab;





//提示说明
@property (nonatomic,strong) UIButton *noticeBtn;
///多规格重量
@property (nonatomic,strong) UIButton *moreSpecificationsBtn;
@property (nonatomic,strong) UIView *moreSpecificationsBgView;
///规格重量
@property (nonatomic,strong) UILabel *moreSpecificationslabel1;
///规格重量单位
@property (nonatomic,strong) UILabel *moreSpecificationslabel2;

@property (nonatomic,copy) ReturnSelectIndex returnSelectIndex;


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

//
//  HomePageModel.h
//  Emeat
//
//  Created by liuheshun on 2017/11/27.
//  Copyright © 2017年 liuheshun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YYModel.h"


@interface HomePageModel : NSObject<YYModel>
///默认商品分页数
@property (nonatomic,assign) NSInteger pages;
///每页展示的商品数量
@property (nonatomic,assign) NSInteger pageSize;
///商品总数量
@property (nonatomic,assign) NSInteger total;//(total/pageSize = pages)

///多规格商品ID
@property (nonatomic,assign) NSInteger  commodityId;
///规格详情
@property (nonatomic,strong) NSString *specs;

///商品id
@property (nonatomic,assign) NSInteger id;
///轮播图banner
@property (nonatomic,strong) NSString *bannerImage;
///轮播图详情页链接
@property (nonatomic,strong) NSString *bannerUrl;
///商品图片
@property (nonatomic,strong) NSString *mainImage;
///商品名称
@property (nonatomic,strong) NSString *commodityName;
///商品角标
@property (nonatomic,strong) NSString *commodityMark;
///商品简述
@property (nonatomic,strong) NSString *commodityDesc;
///销量
@property (nonatomic,assign) NSInteger commoditySellNum;
///标准规格
@property (nonatomic,strong) NSString *size;
///最大规格
@property (nonatomic,strong) NSString *size2;
///售价
@property (nonatomic,assign) NSInteger unitPrice;

///商品轮播图(字符串数组)
@property (nonatomic,strong) NSString *commodityBanner;
///商品上架数量
@property (nonatomic,assign) NSInteger commodityUpNum;
///商品详情(字符串数组)
@property (nonatomic,strong) NSString *commodityDetail;


///原产地
@property (nonatomic,strong) NSString * origin;
///部位
@property (nonatomic,strong) NSString * position;
//@property (nonatomic,strong) NSString * size;//规格
///品种
@property (nonatomic,strong) NSString * varieties;
///储存条件
@property (nonatomic,strong) NSString * storageConditions;
///品牌
@property (nonatomic,strong) NSString *brand;






///加入购物车数量
@property (nonatomic,assign) NSInteger number;

///详情页面图片高度
@property (nonatomic,assign) CGFloat cellHeight;


@property (nonatomic,assign) CGFloat headViewHeight;




@end

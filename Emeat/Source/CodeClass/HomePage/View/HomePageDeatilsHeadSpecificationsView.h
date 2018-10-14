//
//  HomePageDeatilsHeadSpecificationsView.h
//  Emeat
//
//  Created by liuheshun on 2018/10/12.
//  Copyright © 2018年 liuheshun. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HomePageDeatilsHeadSpecificationsView : UIView
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

-(void)configSpecialHeadViewWithModel:(HomePageModel*)model;


@end

NS_ASSUME_NONNULL_END

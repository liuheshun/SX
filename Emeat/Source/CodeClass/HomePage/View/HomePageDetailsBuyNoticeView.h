//
//  HomePageDetailsBuyNoticeView.h
//  Emeat
//
//  Created by liuheshun on 2018/1/17.
//  Copyright © 2018年 liuheshun. All rights reserved.
//商品详情页购买说明

#import <UIKit/UIKit.h>

@interface HomePageDetailsBuyNoticeView : UIView
@property (nonatomic,strong) UIView *bgView;

@property (nonatomic,strong) UILabel *buyNoticeTieleLab;
@property (nonatomic,strong) UILabel *descLab1;
@property (nonatomic,strong) UILabel *descLab2;
@property (nonatomic,strong) UIButton *cancleBtn;
@property (nonatomic, strong) UITapGestureRecognizer *recognizerTap;

- (void)showBuyNotice;

@end

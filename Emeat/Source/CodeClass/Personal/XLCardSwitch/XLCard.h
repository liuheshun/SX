//
//  Card.h
//  CardSwitchDemo
//
//  Created by Apple on 2016/11/9.
//  Copyright © 2016年 Apple. All rights reserved.
//  被切换的卡片

#import <UIKit/UIKit.h>
#import "XLCardItem.h"

@interface XLCard : UICollectionViewCell

@property (nonatomic, strong) HomePageModel *item;
@property (nonatomic,strong) UIImageView *imageView;
@property (nonatomic,strong) UILabel *textLabel;

@property (nonatomic,strong) UILabel *newsPricesLabel;

@property (nonatomic,strong) UILabel *oldsPricesLabel;

@property (nonatomic,strong) UIButton *addShoppingCardBtn;

@property (nonatomic,strong) UIView *lineView;


@end

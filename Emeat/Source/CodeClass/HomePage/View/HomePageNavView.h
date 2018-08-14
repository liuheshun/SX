//
//  HomePageNavView.h
//  Emeat
//
//  Created by liuheshun on 2017/11/23.
//  Copyright © 2017年 liuheshun. All rights reserved.
//

#import <UIKit/UIKit.h>

//消息按钮点击事件block
typedef void(^sortBtnActionBlock)(void);



@interface HomePageNavView : UIView
///扫一扫
@property (nonatomic,strong) UIButton *scanBtn;


//选择地址
@property (nonatomic,strong) UIButton *selectAddressBtn;
//消息
@property (nonatomic,strong) UIButton *messageBtn;
//搜索按钮
@property (nonatomic,strong) UIButton *searchBtn;

//消息block
@property (nonatomic,copy) sortBtnActionBlock sortBlock;
//搜索block
@property (nonatomic,copy) sortBtnActionBlock searchBtnBlock;
//选择地址block
@property (nonatomic,copy) sortBtnActionBlock selectAddressBtnBlock;



@end

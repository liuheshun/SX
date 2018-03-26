//
//  HomePageNavView.h
//  Emeat
//
//  Created by liuheshun on 2017/11/23.
//  Copyright © 2017年 liuheshun. All rights reserved.
//

#import <UIKit/UIKit.h>

//cell 点击事件block
typedef void(^selectSortListIndexBlock)(NSInteger selectIndex);

//分类按钮点击事件block
typedef void(^sortBtnActionBlock)(void);



@interface HomePageNavView : UIView<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UITableView *tableView;
//阴影遮罩
@property (nonatomic,strong) UIButton *shadeBtn;
//接收数据源数据
@property (strong, nonatomic) NSArray *HomeArray;

//选择收货地址
@property (nonatomic,strong) UIButton *selectAddressBtn;
//分类
@property (nonatomic,strong) UIButton *sortBtn;

@property (nonatomic,copy) selectSortListIndexBlock selectSortIndexBlock;
//分类block
@property (nonatomic,copy) sortBtnActionBlock sortBlock;
//搜索block
@property (nonatomic,copy) sortBtnActionBlock searchBtnBlock;
//选择地址block
@property (nonatomic,copy) sortBtnActionBlock selectAddressBtnBlock;


//搜索按钮
@property (nonatomic,strong) UIButton *searchBtn;




@end

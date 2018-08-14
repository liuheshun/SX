//
//  HomePageSortListViewController.h
//  Emeat
//
//  Created by liuheshun on 2017/11/24.
//  Copyright © 2017年 liuheshun. All rights reserved.
//分类列表页

#import <UIKit/UIKit.h>
#import "Location.h"
@interface HomePageSortListViewController : SHLBaseViewController
///分类标签数据源
@property (nonatomic,strong) NSMutableArray *sortListMarray;


///选择分类标签
@property (nonatomic,strong) NSString *selelctSortLable;
///选择分类标签id
@property (nonatomic,strong) NSString *ID;
///传值  记录当前位置信息
@property (nonatomic,strong) Location *currentLocation;
@property (nonatomic,strong) NSMutableArray *otherAddressArray;
///


@property (nonatomic,assign) NSInteger selectIndex;

///首页分类id传值
@property (nonatomic,assign) NSInteger sortId;
///分类类型 STAIR(0,"一级",""),VFP(1,"二级","");
@property (nonatomic,strong) NSString *sortType;

///所以一级分类(model)
@property (nonatomic,strong) NSMutableArray *segmentTitleMarray;




@end

//
//  HomePageAllSortListViewController.h
//  Emeat
//
//  Created by liuheshun on 2018/8/2.
//  Copyright © 2018年 liuheshun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZJScrollPageView.h"
@interface HomePageAllSortListViewController : SHLBaseViewController

///是否第一次进入分类页面
@property (nonatomic,assign) NSInteger isFirsrEnter;


@property (nonatomic,strong) NSMutableArray *segmentTitleMarray;

///首页分类id传值
@property (nonatomic,assign) NSInteger sortId;
///分类类型 STAIR(0,"一级",""),VFP(1,"二级","");
@property (nonatomic,strong) NSString *sortType;

@end

//
//  SeacherViewController.h
//  Emeat
//
//  Created by liuheshun on 2017/11/30.
//  Copyright © 2017年 liuheshun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SeacherViewController : UIViewController
@property (nonatomic,strong) NSString *searchText;
///判断是否来自分来页面 1表示来自分来搜索
@property (nonatomic,strong) NSString *fromSortString;
///部位ID
@property (nonatomic,strong) NSString *position;

@end

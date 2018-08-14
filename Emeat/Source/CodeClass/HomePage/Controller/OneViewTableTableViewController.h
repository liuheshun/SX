//
//  OneViewTableTableViewController.h
//  HeaderViewAndPageView
//
//  Created by su on 16/8/8.
//  Copyright © 2016年 susu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ParentClassScrollViewController.h"

@interface OneViewTableTableViewController : ParentClassScrollViewController
@property (nonatomic,strong) NSMutableArray *titleModelMarray;

///是否第一次进入分类页面
@property (nonatomic,assign) NSInteger isFirsrEnter;

///
@property (nonatomic,assign) NSInteger isLoading;


@end

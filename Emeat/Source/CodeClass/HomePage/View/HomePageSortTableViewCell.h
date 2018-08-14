//
//  HomePageSortTableViewCell.h
//  Emeat
//
//  Created by liuheshun on 2018/8/2.
//  Copyright © 2018年 liuheshun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomePageSortTableViewCell : UITableViewCell<UITableViewDataSource ,UITableViewDelegate>

@property (nonatomic,strong) UITableView *leftTableView;
@property (nonatomic,strong) UITableView *rightTableView;

@property (nonatomic,strong) NSMutableArray *leftTileMarray;



@end

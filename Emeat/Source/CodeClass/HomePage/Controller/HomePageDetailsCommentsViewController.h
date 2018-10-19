//
//  HomePageDetailsCommentsViewController.h
//  Emeat
//
//  Created by liuheshun on 2018/10/11.
//  Copyright © 2018年 liuheshun. All rights reserved.
//商品评价

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HomePageDetailsCommentsViewController : SHLBaseViewController
@property (nonatomic,strong) UITableView *tableView;

@property (nonatomic,strong) NSString *fromBaner;
@property (nonatomic,strong) NSString *detailsId;
@end

NS_ASSUME_NONNULL_END

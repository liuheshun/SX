//
//  MerchantOneViewController.h
//  Emeat
//
//  Created by liuheshun on 2018/8/12.
//  Copyright © 2018年 liuheshun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MerchantOneViewController : UIViewController
@property (nonatomic, copy) NSString *cellTitle;

@property (nonatomic, strong) UITableView *tableView;



- (void)addTableViewRefresh;
@end

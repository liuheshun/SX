//
//  HomePageShoppingDetailsTableViewCell.h
//  Emeat
//
//  Created by liuheshun on 2018/1/24.
//  Copyright © 2018年 liuheshun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomePageModel.h"

@interface HomePageShoppingDetailsTableViewCell : UITableViewCell
@property (nonatomic,strong) UIImageView *detailsImv;

-(void)configCell:(HomePageModel*)model forIndexPath:(NSIndexPath *)indexPath tableView:(UITableView*)tableView;

-(CGFloat)returnCellHeight;
@end

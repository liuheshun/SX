//
//  HomePageNavSortTableViewCell.h
//  Emeat
//
//  Created by liuheshun on 2017/11/24.
//  Copyright © 2017年 liuheshun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomePageNavSortTableViewCell : UITableViewCell
@property (nonatomic,strong) UIImageView *imv;
@property (nonatomic,strong) UILabel *titleLab;
-(void)configCell:(NSMutableDictionary*)dic;


@end

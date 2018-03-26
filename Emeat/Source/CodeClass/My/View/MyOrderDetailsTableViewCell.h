//
//  MyOrderDetailsTableViewCell.h
//  Emeat
//
//  Created by liuheshun on 2017/12/14.
//  Copyright © 2017年 liuheshun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyOrderDetailsTableViewCell : UITableViewCell
@property (nonatomic,strong) UIImageView *orderImv;
@property (nonatomic,strong) UILabel *orderName;
@property (nonatomic,strong) UILabel *orderPrices;
@property (nonatomic,strong) UILabel *orderCount;

-(void)configCellWithModel:(OrderModel*)orderModel;



@end

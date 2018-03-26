//
//  ConfirmOrderInfoTableViewCell.h
//  Emeat
//
//  Created by liuheshun on 2017/11/10.
//  Copyright © 2017年 liuheshun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ConfirmOrderInfoTableViewCell : UITableViewCell
@property (nonatomic,strong) UILabel *nameLab;
@property (nonatomic,strong) UILabel *countLab;
@property (nonatomic,strong) UILabel *priceLab;

-(void)configWithShoppingModel:(ShoppingCartModel*)model;


@end

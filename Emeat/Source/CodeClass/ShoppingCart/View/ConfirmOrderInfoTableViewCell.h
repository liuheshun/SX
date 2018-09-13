//
//  ConfirmOrderInfoTableViewCell.h
//  Emeat
//
//  Created by liuheshun on 2017/11/10.
//  Copyright © 2017年 liuheshun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ConfirmOrderInfoTableViewCell : UITableViewCell
@property (nonatomic,strong) UIImageView *mainImageView;
@property (nonatomic,strong) UILabel *weightSizeLab;
@property (nonatomic,strong) UILabel *oldPricesLab;
@property (nonatomic,strong) UILabel *newspriceLab;
@property (nonatomic,strong) UILabel *allPricesLab;



@property (nonatomic,strong) UILabel *nameLab;
@property (nonatomic,strong) UILabel *countLab;

-(void)configWithShoppingModel:(ShoppingCartModel*)model;


@end

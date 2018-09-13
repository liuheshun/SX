//
//  SaleMoneyTableViewCell.h
//  Emeat
//
//  Created by liuheshun on 2018/8/28.
//  Copyright © 2018年 liuheshun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SaleMoneyTableViewCell : UITableViewCell

///推手说明图片
@property (nonatomic,strong) UIImageView *topImv;
///进入赛鲜推手平台
@property (nonatomic,strong) UIButton *enterSaleWeb;

@property (nonatomic,strong) UILabel *descSaleLab;
///推手链接
@property (nonatomic,strong) UIButton *saleURLBtn;
///推手图片
@property (nonatomic,strong) UIButton *saleImageBtn;




@end

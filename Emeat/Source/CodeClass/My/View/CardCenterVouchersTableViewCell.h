//
//  CardCenterVouchersTableViewCell.h
//  Emeat
//
//  Created by liuheshun on 2018/9/20.
//  Copyright © 2018年 liuheshun. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CardCenterVouchersTableViewCell : UITableViewCell

@property (nonatomic,strong) UIImageView *bgImage;
@property (nonatomic,strong) UILabel *priceLab;
@property (nonatomic,strong) UILabel *timeLab;
@property (nonatomic,strong) UILabel *descLab;
@property (nonatomic,strong) UIButton *statusBtn;

-(void)configWithModel:(CardModel*)model;

@end

NS_ASSUME_NONNULL_END

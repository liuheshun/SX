//
//  CardCenterTableViewCell.h
//  Emeat
//
//  Created by liuheshun on 2018/8/15.
//  Copyright © 2018年 liuheshun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CardCenterTableViewCell : UITableViewCell

@property (nonatomic,strong) UIImageView *bgImage;
@property (nonatomic,strong) UILabel *priceLab;
@property (nonatomic,strong) UILabel *timeLab;
@property (nonatomic,strong) UILabel *descLab;
@property (nonatomic,strong) UIButton *statusBtn;

-(void)configWithModel:(CardModel*)model;














@end

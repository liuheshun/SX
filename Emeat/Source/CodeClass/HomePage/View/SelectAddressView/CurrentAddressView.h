//
//  CurrentAddressView.h
//  Emeat
//
//  Created by liuheshun on 2017/12/4.
//  Copyright © 2017年 liuheshun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CurrentAddressView : UIView
//当前定位
//小图标
@property (nonatomic,strong) UIImageView *currentImv;
//当前地址
@property (nonatomic,strong) UILabel *currentAddressLab;

@property (nonatomic,strong) UILabel *placeholderLab;
//选择定位
@property (nonatomic,strong) UIButton *locationBtn;

-(void)setCurrentLabelTitle:(NSString*)text;


@end

//
//  ConfirmOrderInfoHeadView.h
//  Emeat
//
//  Created by liuheshun on 2017/11/13.
//  Copyright © 2017年 liuheshun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ConfirmOrderInfoAddressHeadView : UIView

@property (nonatomic,strong) UIImageView *addressImv;
@property (nonatomic,strong) UILabel *nameLab;

@property (nonatomic,strong)  UILabel *phoneLab;

@property (nonatomic,strong) UILabel *addressLab;

//-(void)setHeadView:(NSInteger )integer;

-(void)configMyShippingAddressWithMyAddressModel:(MyAddressModel*)mdoel;

@end

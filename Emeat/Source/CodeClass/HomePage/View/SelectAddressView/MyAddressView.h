//
//  MyAddressView.h
//  Emeat
//
//  Created by liuheshun on 2017/12/11.
//  Copyright © 2017年 liuheshun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyAddressView : UIView
@property (nonatomic,strong) UILabel *nameLab;
@property (nonatomic,strong) UILabel *phoneNumLab;
@property (nonatomic,strong) UILabel *addressType;
@property (nonatomic,strong) UILabel *addressLab;
//编辑按钮
@property (nonatomic,strong) UIButton *editBtn;


-(void)setConfigAddressInfo:(MyAddressModel*)addressModel isEdit:(BOOL)isEdit fromConfirmVC:(NSString*)fromConfirmVC;


@end

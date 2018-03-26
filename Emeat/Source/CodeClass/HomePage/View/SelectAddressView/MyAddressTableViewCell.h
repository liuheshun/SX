//
//  MyAddressTableViewCell.h
//  Emeat
//
//  Created by liuheshun on 2018/3/5.
//  Copyright © 2018年 liuheshun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyAddressTableViewCell : UITableViewCell
@property (nonatomic,strong) UILabel *nameLab;
@property (nonatomic,strong) UILabel *phoneNumLab;
@property (nonatomic,strong) UILabel *addressType;
@property (nonatomic,strong) UILabel *addressLab;
//编辑按钮
@property (nonatomic,strong) UIButton *editBtn;


-(void)setConfigAddressInfo:(MyAddressModel*)addressModel isEdit:(BOOL)isEdit fromConfirmVC:(NSString*)fromConfirmVC;

@end

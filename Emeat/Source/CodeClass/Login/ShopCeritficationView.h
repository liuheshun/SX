//
//  ShopCeritficationView.h
//  Emeat
//
//  Created by liuheshun on 2018/4/18.
//  Copyright © 2018年 liuheshun. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef void(^textFieldChangeTitleBlock)(NSMutableDictionary *dic);


@interface ShopCeritficationView : UIView <UITextFieldDelegate>
///背景
@property (nonatomic,strong) UIView *bgView;

///店铺名称
@property (nonatomic,strong) UITextField *textFieldShopName;
///店长姓名
@property (nonatomic,strong) UITextField *textFieldShopManagerName;
///手机号
@property (nonatomic,strong) UITextField *textFieldPhoneNumer;
///地址
@property (nonatomic,strong) UIButton *btnAddress;
@property (nonatomic,strong) UITextField *textFieldCity;
///详细地址
@property (nonatomic,strong) UITextField *textFieldDetailsAddress;
///邀请码
@property (nonatomic,strong) UITextField *textFieldInviteCode;


@property (nonatomic,copy) textFieldChangeTitleBlock textFieldTitleBlock;


//选择地址block
@property (nonatomic,copy) textFieldChangeTitleBlock addressTitleBlockClickAction;

@property (assign, nonatomic) NSInteger selIndex;//单选，当前选中的行

@property (nonatomic,strong) NSMutableDictionary *selectedMdic;

///认证按钮
@property (nonatomic,strong) UIButton *submitBtn;

///赋值\

-(void)configShopCertifiViewWithModel:(MyModel*)model;


@end

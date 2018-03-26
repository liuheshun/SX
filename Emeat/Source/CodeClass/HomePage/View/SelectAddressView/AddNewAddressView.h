//
//  AddNewAddressView.h
//  Emeat
//
//  Created by liuheshun on 2017/12/7.
//  Copyright © 2017年 liuheshun. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^textFieldChangeTitleBlock)(NSMutableDictionary *dic);

typedef void(^returnLabelBlcok)(NSInteger labelInter);

@interface AddNewAddressView : UIView <UITextFieldDelegate>

//姓名
@property (nonatomic,strong) UITextField *textFieldName;
//手机号
@property (nonatomic,strong) UITextField *textFieldPhoneNumer;
//地址
@property (nonatomic,strong) UIButton *btnAddress;
@property (nonatomic,strong) UITextField *textFieldCity;
@property (nonatomic,strong) UITextField *textFieldSubstreet;
//详细地址
@property (nonatomic,strong) UITextField *textFieldDetailsAddress;
//地址类型
@property (nonatomic,strong) UIButton *btnAddressType;


@property (nonatomic,copy) textFieldChangeTitleBlock textFieldTitleBlock;

//标签block
@property (nonatomic,copy) returnLabelBlcok lableTitleBlock;

//选择地址block
@property (nonatomic,copy) textFieldChangeTitleBlock addressTitleBlockClickAction;

@property (assign, nonatomic) NSInteger selIndex;//单选，当前选中的行

@property (nonatomic,strong) NSMutableDictionary *selectedMdic;

-(void)configAddressView:(MyAddressModel*)model;



@end

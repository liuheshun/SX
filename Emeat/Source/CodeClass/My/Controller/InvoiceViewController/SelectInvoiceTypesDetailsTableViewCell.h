//
//  SelectInvoiceTypesDetailsTableViewCell.h
//  Emeat
//
//  Created by liuheshun on 2018/6/22.
//  Copyright © 2018年 liuheshun. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "InvoiceDetailsModel.h"

///是否展示更多信息
typedef void(^IsShowMoreInfoBlock)(NSInteger isShow);

///选择普通发票的种类 , 企业发票为20, 个人发票为21
typedef void(^IsSwitchOrdinaryTypesBlock)(NSInteger types);


@interface SelectInvoiceTypesDetailsTableViewCell : UITableViewCell

///抬头类型
@property (nonatomic,strong) UILabel *lookUpType;
///企业
@property (nonatomic,strong) UIButton *lookUpTypeBtn1;
///个人/非企业单位
@property (nonatomic,strong) UIButton *lookUpTypeBtn2;
///发票抬头
@property (nonatomic,strong) UILabel *invoiceLookUpLabel;
@property (nonatomic,strong) UITextField *invoiceLookUpTextField;
///税号
@property (nonatomic,strong) UILabel *enioLabel;
@property (nonatomic,strong) UITextField *enioTextField;
///发票内容
@property (nonatomic,strong) UILabel *invoiceContentLabel;
@property (nonatomic,strong) UITextField *invoiceContentTextField;
///发票金额
@property (nonatomic,strong) UILabel *invoiceMoneyLabel;
@property (nonatomic,strong) UITextField *invoiceMoneyTextField;

///更多信息
@property (nonatomic,strong) UILabel *moreInfoLabel;
@property (nonatomic,strong) UIButton *showMoreInfoBtn;


///公司电话
@property (nonatomic,strong) UILabel *companyPhoneNumLabel;
@property (nonatomic,strong) UITextField *companyPhoneNumTextField;
///公司地址
@property (nonatomic,strong) UILabel *companyAddressLabel;
@property (nonatomic,strong) UITextField *companyAddressTextField;
///开户银行
@property (nonatomic,strong) UILabel *bankLabel;
@property (nonatomic,strong) UITextField *bankTextField;
///开户银行账号
@property (nonatomic,strong) UILabel *bankAccountLabel;
@property (nonatomic,strong) UITextField *bankAccountTextField;


///备注
@property (nonatomic,strong) UILabel *noteLabel;
@property (nonatomic,strong) UITextField *noteTextField;

@property (nonatomic,strong) UIView *lineView;

///是否展示更多信息
@property (nonatomic,assign) NSInteger isShowMoreInfo;



@property (nonatomic,copy) IsShowMoreInfoBlock isShowMoreInfoBlock;

@property (nonatomic,copy) IsSwitchOrdinaryTypesBlock isSwitchOrdinaryTypesBlock;



-(void)configWithModel:(InvoiceDetailsModel*)model;






















@end

//
//  InvoicePreviewView.h
//  Emeat
//
//  Created by liuheshun on 2018/6/26.
//  Copyright © 2018年 liuheshun. All rights reserved.
//发票预览

#import <UIKit/UIKit.h>

@interface InvoicePreviewView : UIView
///抬头类型
@property (nonatomic,strong) UILabel *lookUpType;
///发票抬头
@property (nonatomic,strong) UILabel *invoiceLookUpLabel;
///税号
@property (nonatomic,strong) UILabel *enioLabel;
///公司电话
@property (nonatomic,strong) UILabel *companyPhoneNumLabel;
///公司地址
@property (nonatomic,strong) UILabel *companyAddressLabel;
///开户银行
@property (nonatomic,strong) UILabel *bankLabel;
///开户银行账号
@property (nonatomic,strong) UILabel *bankAccountLabel;
///发票内容
@property (nonatomic,strong) UILabel *invoiceContentLabel;
///发票金额
@property (nonatomic,strong) UILabel *invoiceMoneyLabel;
///收件人
@property (nonatomic,strong) UILabel *receiverLab;
///联系电话
@property (nonatomic,strong) UILabel *receiverPhoneNumLabel;
///收货地址
@property (nonatomic,strong) UILabel *receiverAddressLabel;
///门牌号
@property (nonatomic,strong) UILabel *receiverDetailsAddressLab;
///横线
@property (nonatomic,strong) UIView *lineView;
///关闭按钮
@property (nonatomic,strong) UIButton *closeBtn;
///提交按钮
@property (nonatomic,strong) UIButton *submitBtn;



///抬头类型
@property (nonatomic,strong) UILabel *lookUpTypeTemp;
///发票抬头
@property (nonatomic,strong) UILabel *invoiceLookUpLabelTemp;
///税号
@property (nonatomic,strong) UILabel *enioLabelTemp;
///公司电话
@property (nonatomic,strong) UILabel *companyPhoneNumLabelTemp;
///公司地址
@property (nonatomic,strong) UILabel *companyAddressLabelTemp;
///开户银行
@property (nonatomic,strong) UILabel *bankLabelTemp;
///开户银行账号
@property (nonatomic,strong) UILabel *bankAccountLabelTemp;
///发票内容
@property (nonatomic,strong) UILabel *invoiceContentLabelTemp;
///发票金额
@property (nonatomic,strong) UILabel *invoiceMoneyLabelTemp;
///收件人
@property (nonatomic,strong) UILabel *receiverLabTemp;
///联系电话
@property (nonatomic,strong) UILabel *receiverPhoneNumLabelTemp;
///收货地址
@property (nonatomic,strong) UILabel *receiverAddressLabelTemp;
///门牌号
@property (nonatomic,strong) UILabel *receiverDetailsAddressLabTemp;


@end

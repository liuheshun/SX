//
//  InvoiceDetailsModel.h
//  Emeat
//
//  Created by liuheshun on 2018/6/27.
//  Copyright © 2018年 liuheshun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface InvoiceDetailsModel : NSObject
//
@property (nonatomic,strong) NSString *id;
@property (nonatomic,strong) NSString *createDate;


@property (nonatomic,strong) NSString * invoiceMaterial; //默认10 纸质发票
@property (nonatomic,strong) NSString * invoiceType; //默认0专票 1普票
@property (nonatomic,strong) NSString * invoiceNature;//默认20 企业 21 个人
@property (nonatomic,strong) NSString * invoiceCompany; //发票抬头
@property (nonatomic,strong) NSString * invoiceTaxNum; //税号
@property (nonatomic,strong) NSString * invoiceCompanyPhone; //公司电话
@property (nonatomic,strong) NSString * invoiceCompanyAddress; //公司地址
@property (nonatomic,strong) NSString * invoiceCompanyBank; //开户行
@property (nonatomic,strong) NSString * invoiceCompanyBankAccount; //开户行账号
@property (nonatomic,strong) NSString * invoiceAmount; //发票金额
@property (nonatomic,strong) NSString * invoiceReceiver; //收件人
@property (nonatomic,strong) NSString * invoiceReceiverPhone; //联系电话
@property (nonatomic,strong) NSString * invoiceReceiverAddress; //收货地址
@property (nonatomic,strong) NSString *invoiceEmail;


@property (nonatomic,strong) NSString * invoiceReceiverDetailsAddress; //收货地址


///开票状态
@property (nonatomic,assign) NSInteger invoiceStatus;
///发票订单数量
@property (nonatomic,assign) NSInteger orderNum;
///发票拒绝原因
@property (nonatomic,strong) NSString *invoiceRefuseReason;

///默认商品分页数
@property (nonatomic,assign) NSInteger pages;
///每页展示的商品数量
@property (nonatomic,assign) NSInteger pageSize;
///商品总数量
@property (nonatomic,assign) NSInteger total;//(total/pageSize = pages)



@end

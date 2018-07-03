//
//  SelectInvoiceTypesHeadView.h
//  Emeat
//
//  Created by liuheshun on 2018/6/22.
//  Copyright © 2018年 liuheshun. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^SelectInvoiceKindsBlock)(NSInteger kindStated);

@interface SelectInvoiceTypesHeadView : UIView
///请选择发票类型
@property (nonatomic,strong) UILabel *selectInvoceTypesLabel;
///发票类型白色背景
@property (nonatomic,strong) UIView *invoiceTypesBgView;


///发票类型(暂时纸质发票)
@property (nonatomic,strong) UIButton *invoiceTypesBtn;
///请选择发票种类
@property (nonatomic,strong) UILabel *selectInvoceKindLabel;
///发票种类白色背景
@property (nonatomic,strong) UIView *invoiceKindBgView;

///发票普票
@property (nonatomic,strong) UIButton *ordinaryInvoiceKindBtn;
///专用发票
@property (nonatomic,strong) UIButton *specialInvoiceKindBtn;

///发票详情
@property (nonatomic,strong) UILabel *invoiceDetailsLabel;

@property (nonatomic,copy) SelectInvoiceKindsBlock selectInvoiceKindsBlock;


@end

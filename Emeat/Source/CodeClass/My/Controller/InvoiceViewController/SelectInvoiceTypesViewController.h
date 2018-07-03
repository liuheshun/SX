//
//  SelectInvoiceTypesViewController.h
//  Emeat
//
//  Created by liuheshun on 2018/6/22.
//  Copyright © 2018年 liuheshun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SelectInvoiceTypesViewController : SHLBaseViewController
///接收发票回显信息
@property (nonatomic,strong) NSMutableArray *invoiceShowMarray;
///开发票金额
@property (nonatomic,strong) NSString *invoiceTotalPrices;

///选择的发票ID字符串
@property (nonatomic,strong) NSString *invoiceIdString;

@end

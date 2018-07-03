//
//  InvoiceHistoryTableViewCell.h
//  Emeat
//
//  Created by liuheshun on 2018/6/26.
//  Copyright © 2018年 liuheshun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InvoiceDetailsModel.h"
@interface InvoiceHistoryTableViewCell : UITableViewCell
///时间
@property (nonatomic,strong) UILabel *timeLab;
///横线
@property (nonatomic,strong) UIView *lineView;
///发票状态
@property (nonatomic,strong) UILabel *invoiceStatedLab;

///开票订单描述
@property (nonatomic,strong) UILabel *orderDescLab;
///发票类型
@property (nonatomic,strong) UILabel *invoiceTypes;

-(void)configCell:(InvoiceDetailsModel*)model;



@end

//
//  SelectInvoiceTypesReceiveAddressTableViewCell.h
//  Emeat
//
//  Created by liuheshun on 2018/6/25.
//  Copyright © 2018年 liuheshun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InvoiceDetailsModel.h"
#import "SHLBaseViewController.h"

typedef void(^SaveReceiverInfoBlock)(NSMutableDictionary *receiverDic);

@interface SelectInvoiceTypesReceiveAddressTableViewCell : UITableViewCell<UITextFieldDelegate>

///收件人
@property (nonatomic,strong) UILabel *receiverLab;
@property (nonatomic,strong) UITextField *receiverTextField;
///联系电话
@property (nonatomic,strong) UILabel *receiverPhoneNumLabel;
@property (nonatomic,strong) UITextField *receiverPhoneNumTextField;
///收货地址
@property (nonatomic,strong) UILabel *receiverAddressLabel;
@property (nonatomic,strong) UITextField *receiverAddressTextField;

@property (nonatomic,strong) UIButton *receiverAddressBtn;


///门牌号
@property (nonatomic,strong) UILabel *receiverDetailsAddressLab;
@property (nonatomic,strong) UITextField *receiverDetailsAddressTextField;


///电子邮箱
@property (nonatomic,strong) UILabel *recerEmailLabel;
@property (nonatomic,strong) UITextField *receiverEmailTextField;

///邮费
@property (nonatomic,strong) UILabel *sendFreeLabel;
@property (nonatomic,strong) UITextField *sendFreeTextField;



@property (nonatomic,strong) UIView *lineView;

@property (nonatomic,copy) SaveReceiverInfoBlock saveReceiverInfoBlocks;


-(void)configAddressCellWithModel:(InvoiceDetailsModel*)model;



@end

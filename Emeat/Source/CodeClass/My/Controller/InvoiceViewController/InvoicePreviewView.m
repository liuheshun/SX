//
//  InvoicePreviewView.m
//  Emeat
//
//  Created by liuheshun on 2018/6/26.
//  Copyright © 2018年 liuheshun. All rights reserved.
//

#import "InvoicePreviewView.h"

@implementation InvoicePreviewView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.lookUpType];
        [self addSubview:self.closeBtn];
        [self addSubview:self.invoiceLookUpLabel];
        [self addSubview:self.enioLabel];
        [self addSubview:self.companyPhoneNumLabel];
        [self addSubview:self.companyAddressLabel];
        [self addSubview:self.bankLabel];
        [self addSubview:self.bankAccountLabel];
        [self addSubview:self.invoiceContentLabel];
        [self addSubview:self.invoiceMoneyLabel];
        [self addSubview:self.receiverLab];
        [self addSubview:self.receiverPhoneNumLabel];

        [self addSubview:self.receiverAddressLabel];
        [self addSubview:self.receiverDetailsAddressLab];
        
        [self addSubview:self.lookUpTypeTemp];
        [self addSubview:self.invoiceLookUpLabelTemp];
        [self addSubview:self.enioLabelTemp];
        [self addSubview:self.companyPhoneNumLabelTemp];
        [self addSubview:self.companyAddressLabelTemp];
        [self addSubview:self.bankLabelTemp];
        [self addSubview:self.bankAccountLabelTemp];
        [self addSubview:self.invoiceContentLabelTemp];
        [self addSubview:self.invoiceMoneyLabelTemp];
        [self addSubview:self.receiverLabTemp];
        [self addSubview:self.receiverPhoneNumLabelTemp];
        
        [self addSubview:self.receiverAddressLabelTemp];
        [self addSubview:self.receiverDetailsAddressLabTemp];
        
     
        [self addSubview:self.submitBtn];
        [self setPreviewFrame];
        [self setLineViewUI];
    }
    return self;
}






-(void)setLineViewUI{
    
    NSArray *labelArray =  @[@"备注:" ,@"公司电话:" ,@"公司地址" ,@"开户银行:" ,@"开户行账号" ,@"备注:" ,@"公司电话:" ,@"公司地址" ,@"开户银行:" ,@"备注:" ,@"公司电话:" ,@"公司地址" ,@"开户银行:"];
    for (int i = 0; i < labelArray.count; i++) {
        
        self.lineView = [[UIView alloc] init];
        self.lineView.backgroundColor = RGB(238, 238, 238, 1);
        [self addSubview:self.lineView];
        
        [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left).offset(15*kScale);
            make.right.equalTo(self.mas_right).with.offset(-15*kScale);
            make.height.equalTo(@(1*kScale));
            make.top.equalTo(self.lookUpType.mas_bottom).with.offset(41*i );
            
        }];
        
        
    }
    
    
    
    
}


-(void)setPreviewFrame{
    
    [self.lookUpTypeTemp mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(15*kScale);
        make.top.equalTo(self);
        make.width.equalTo(@(90*kScale));
        make.height.equalTo(@(40*kScale));
    }];
    [self.lookUpType mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.lookUpTypeTemp.mas_right).offset(20*kScale);
        make.top.equalTo(self);
        make.right.equalTo(self.mas_right).with.offset(-15*kScale);
        make.height.equalTo(@(40*kScale));
    }];
  
    [self.closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(0*kScale);
        make.top.equalTo(self);
        make.width.equalTo(@(40*kScale));
        make.height.equalTo(@(40*kScale));
    }];
    
    
    [self.invoiceLookUpLabelTemp mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(15*kScale);
        make.top.equalTo(self.lookUpType.mas_bottom).with.offset(1*kScale);
        make.width.equalTo(@(90*kScale));
        make.height.equalTo(@(40*kScale));
    }];
    
    [self.invoiceLookUpLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.invoiceLookUpLabelTemp.mas_right).offset(20*kScale);
        make.top.equalTo(self.lookUpType.mas_bottom).with.offset(1*kScale);
        make.right.equalTo(self.mas_right).with.offset(-15*kScale);
        make.height.equalTo(@(40*kScale));
    }];
    
    
    
    [self.enioLabelTemp mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(15*kScale);
        make.top.equalTo(self.invoiceLookUpLabel.mas_bottom).with.offset(1*kScale);
        make.width.equalTo(@(90*kScale));
        make.height.equalTo(@(40*kScale));
    }];
    
    
    [self.enioLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.enioLabelTemp.mas_right).offset(20*kScale);
        make.top.equalTo(self.invoiceLookUpLabel.mas_bottom).with.offset(1*kScale);
        make.right.equalTo(self.mas_right).with.offset(-15*kScale);
        make.height.equalTo(@(40*kScale));
    }];
    
    
    
    [self.companyPhoneNumLabelTemp mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(15*kScale);
        make.top.equalTo(self.enioLabel.mas_bottom).with.offset(1*kScale);
        make.width.equalTo(@(90*kScale));
        make.height.equalTo(@(40*kScale));
    }];
    
    [self.companyPhoneNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.companyPhoneNumLabelTemp.mas_right).offset(20*kScale);
        make.top.equalTo(self.enioLabel.mas_bottom).with.offset(1*kScale);
        make.right.equalTo(self.mas_right).with.offset(-15*kScale);
        make.height.equalTo(@(40*kScale));
    }];
    
    
    
    [self.companyAddressLabelTemp mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(15*kScale);
        make.top.equalTo(self.companyPhoneNumLabel.mas_bottom).with.offset(1*kScale);
        make.width.equalTo(@(90*kScale));
        make.height.equalTo(@(40*kScale));
    }];
    
    
    [self.companyAddressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.companyAddressLabelTemp.mas_right).offset(20*kScale);
        make.top.equalTo(self.companyPhoneNumLabel.mas_bottom).with.offset(1*kScale);
        make.right.equalTo(self.mas_right).with.offset(-15*kScale);
        make.height.equalTo(@(40*kScale));
    }];
    
    
    [self.bankLabelTemp mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(15*kScale);
        make.top.equalTo(self.companyAddressLabel.mas_bottom).with.offset(1*kScale);
        make.width.equalTo(@(90*kScale));
        make.height.equalTo(@(40*kScale));
    }];
    
    [self.bankLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bankLabelTemp.mas_right).offset(20*kScale);
        make.top.equalTo(self.companyAddressLabel.mas_bottom).with.offset(1*kScale);
        make.right.equalTo(self.mas_right).with.offset(-15*kScale);
        make.height.equalTo(@(40*kScale));
    }];
    
    
    
    
    [self.bankAccountLabelTemp mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(15*kScale);
        make.top.equalTo(self.bankLabel.mas_bottom).with.offset(1*kScale);
        make.width.equalTo(@(90*kScale));
        make.height.equalTo(@(40*kScale));
    }];
    
    [self.bankAccountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bankAccountLabelTemp.mas_right).offset(20*kScale);
        make.top.equalTo(self.bankLabel.mas_bottom).with.offset(1*kScale);
        make.right.equalTo(self.mas_right).with.offset(-15*kScale);
        make.height.equalTo(@(40*kScale));
    }];
    
    
    
    
    [self.invoiceContentLabelTemp mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(15*kScale);
        make.top.equalTo(self.bankAccountLabel.mas_bottom).with.offset(1*kScale);
        make.width.equalTo(@(90*kScale));
        make.height.equalTo(@(40*kScale));
    }];
    
    [self.invoiceContentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.invoiceContentLabelTemp.mas_right).offset(20*kScale);
        make.top.equalTo(self.bankAccountLabel.mas_bottom).with.offset(1*kScale);
        make.right.equalTo(self.mas_right).with.offset(-15*kScale);
        make.height.equalTo(@(40*kScale));
    }];
    
    
    
    [self.invoiceMoneyLabelTemp mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(15*kScale);
        make.top.equalTo(self.invoiceContentLabel.mas_bottom).with.offset(1*kScale);
        make.width.equalTo(@(90*kScale));
        make.height.equalTo(@(40*kScale));
    }];
    
    [self.invoiceMoneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.invoiceMoneyLabelTemp.mas_right).offset(20*kScale);
        make.top.equalTo(self.invoiceContentLabel.mas_bottom).with.offset(1*kScale);
        make.right.equalTo(self.mas_right).with.offset(-15*kScale);
        make.height.equalTo(@(40*kScale));
    }];
    
    
    
    
    [self.receiverLabTemp mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(15*kScale);
        make.top.equalTo(self.invoiceMoneyLabel.mas_bottom).with.offset(1*kScale);
        make.width.equalTo(@(90*kScale));
        make.height.equalTo(@(40*kScale));
    }];
    
    
    [self.receiverLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.receiverLabTemp.mas_right).offset(20*kScale);
        make.top.equalTo(self.invoiceMoneyLabel.mas_bottom).with.offset(1*kScale);
        make.right.equalTo(self.mas_right).with.offset(-15*kScale);
        make.height.equalTo(@(40*kScale));
    }];
    
    
    
    [self.receiverPhoneNumLabelTemp mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(15*kScale);
        make.top.equalTo(self.receiverLab.mas_bottom).with.offset(1*kScale);
        make.width.equalTo(@(90*kScale));
        make.height.equalTo(@(40*kScale));
    }];
    
    [self.receiverPhoneNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.receiverPhoneNumLabelTemp.mas_right).offset(20*kScale);
        make.top.equalTo(self.receiverLab.mas_bottom).with.offset(1*kScale);
        make.right.equalTo(self.mas_right).with.offset(-15*kScale);
        make.height.equalTo(@(40*kScale));
    }];
    
    
    
    [self.receiverAddressLabelTemp mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(15*kScale);
        make.top.equalTo(self.receiverPhoneNumLabel.mas_bottom).with.offset(1*kScale);
        make.width.equalTo(@(90*kScale));
        make.height.equalTo(@(40*kScale));
    }];
    
    [self.receiverAddressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.receiverAddressLabelTemp.mas_right).offset(20*kScale);
        make.top.equalTo(self.receiverPhoneNumLabel.mas_bottom).with.offset(1*kScale);
        make.right.equalTo(self.mas_right).with.offset(-15*kScale);
        make.height.equalTo(@(40*kScale));
    }];
    
    
    
    
    [self.receiverDetailsAddressLabTemp mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(15*kScale);
        make.top.equalTo(self.receiverAddressLabel.mas_bottom).with.offset(1*kScale);
        make.width.equalTo(@(90*kScale));
        make.height.equalTo(@(40*kScale));
    }];
    
    
    [self.receiverDetailsAddressLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.receiverDetailsAddressLabTemp.mas_right).offset(20*kScale);
        make.top.equalTo(self.receiverAddressLabel.mas_bottom).with.offset(1*kScale);
        make.right.equalTo(self.mas_right).with.offset(-15*kScale);
        make.height.equalTo(@(40*kScale));
    }];
    
   
    
    [self.submitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(15*kScale);
        make.top.equalTo(self.receiverDetailsAddressLab.mas_bottom).with.offset(24*kScale);
        make.width.equalTo(@(kWidth -30*kScale));
        make.height.equalTo(@(40*kScale));
    }];
    
    
    
}


-(UILabel *)lookUpType{
    if (!_lookUpType) {
        _lookUpType = [[UILabel alloc] init];
        _lookUpType.font = [UIFont systemFontOfSize:12.0f*kScale];
        _lookUpType.textColor = RGB(51, 51, 51, 1);
        _lookUpType.textAlignment = NSTextAlignmentLeft;
    }
    return _lookUpType;
}

-(UIButton *)closeBtn{
    if (!_closeBtn) {
        _closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_closeBtn setImage:[UIImage imageNamed:@"close"] forState:0];
    }
    return _closeBtn;
}


-(UILabel *)invoiceLookUpLabel{
    if (!_invoiceLookUpLabel) {
        _invoiceLookUpLabel = [[UILabel alloc] init];
        _invoiceLookUpLabel.font = [UIFont systemFontOfSize:12.0f*kScale];
        _invoiceLookUpLabel.textColor = RGB(51, 51, 51, 1);
        _invoiceLookUpLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _invoiceLookUpLabel;
}


-(UILabel *)enioLabel{
    if (!_enioLabel) {
        _enioLabel = [[UILabel alloc] init];
        _enioLabel.font = [UIFont systemFontOfSize:12.0f*kScale];
        _enioLabel.textColor = RGB(51, 51, 51, 1);
        _enioLabel.textAlignment = NSTextAlignmentLeft;
        
    }
    return _enioLabel;
}


-(UILabel *)companyPhoneNumLabel{
    if (!_companyPhoneNumLabel) {
        _companyPhoneNumLabel = [[UILabel alloc] init];
        _companyPhoneNumLabel.font = [UIFont systemFontOfSize:12.0f*kScale];
        _companyPhoneNumLabel.textColor = RGB(51, 51, 51, 1);
        _companyPhoneNumLabel.textAlignment = NSTextAlignmentLeft;
        
    }
    return _companyPhoneNumLabel;
}


-(UILabel *)companyAddressLabel{
    if (!_companyAddressLabel) {
        _companyAddressLabel = [[UILabel alloc] init];
        _companyAddressLabel.font = [UIFont systemFontOfSize:12.0f*kScale];
        _companyAddressLabel.textColor = RGB(51, 51, 51, 1);
        _companyAddressLabel.textAlignment = NSTextAlignmentLeft;
        
    }
    return _companyAddressLabel;
}




-(UILabel *)bankLabel{
    if (!_bankLabel) {
        _bankLabel = [[UILabel alloc] init];
        _bankLabel.font = [UIFont systemFontOfSize:12.0f*kScale];
        _bankLabel.textColor = RGB(51, 51, 51, 1);
        _bankLabel.textAlignment = NSTextAlignmentLeft;
        
    }
    return _bankLabel;
}





-(UILabel *)bankAccountLabel{
    if (!_bankAccountLabel) {
        _bankAccountLabel = [[UILabel alloc] init];
        _bankAccountLabel.font = [UIFont systemFontOfSize:12.0f*kScale];
        _bankAccountLabel.textColor = RGB(51, 51, 51, 1);
        _bankAccountLabel.textAlignment = NSTextAlignmentLeft;
        
    }
    return _bankAccountLabel;
}




-(UILabel *)invoiceContentLabel{
    if (!_invoiceContentLabel) {
        _invoiceContentLabel = [[UILabel alloc] init];
        _invoiceContentLabel.font = [UIFont systemFontOfSize:12.0f*kScale];
        _invoiceContentLabel.textColor = RGB(51, 51, 51, 1);
        _invoiceContentLabel.textAlignment = NSTextAlignmentLeft;
        
    }
    return _invoiceContentLabel;
}



-(UILabel *)invoiceMoneyLabel{
    if (!_invoiceMoneyLabel) {
        _invoiceMoneyLabel = [[UILabel alloc] init];
        _invoiceMoneyLabel.font = [UIFont systemFontOfSize:12.0f*kScale];
        _invoiceMoneyLabel.textColor = RGB(51, 51, 51, 1);
        _invoiceMoneyLabel.textAlignment = NSTextAlignmentLeft;
        
    }
    return _invoiceMoneyLabel;
}





-(UILabel *)receiverLab{
    if (!_receiverLab) {
        _receiverLab = [[UILabel alloc] init];
        _receiverLab.font = [UIFont systemFontOfSize:12.0f*kScale];
        _receiverLab.textColor = RGB(51, 51, 51, 1);
        _receiverLab.textAlignment = NSTextAlignmentLeft;
        
    }
    return _receiverLab;
}


-(UILabel *)receiverPhoneNumLabel{
    if (!_receiverPhoneNumLabel) {
        _receiverPhoneNumLabel = [[UILabel alloc] init];
        _receiverPhoneNumLabel.font = [UIFont systemFontOfSize:12.0f*kScale];
        _receiverPhoneNumLabel.textColor = RGB(51, 51, 51, 1);
        _receiverPhoneNumLabel.textAlignment = NSTextAlignmentLeft;
        
    }
    return _receiverPhoneNumLabel;
}



-(UILabel *)receiverAddressLabel{
    if (!_receiverAddressLabel) {
        _receiverAddressLabel = [[UILabel alloc] init];
        _receiverAddressLabel.font = [UIFont systemFontOfSize:12.0f*kScale];
        _receiverAddressLabel.textColor = RGB(51, 51, 51, 1);
        _receiverAddressLabel.textAlignment = NSTextAlignmentLeft;
        
    }
    return _receiverAddressLabel;
}






-(UILabel *)receiverDetailsAddressLab{
    if (!_receiverDetailsAddressLab) {
        _receiverDetailsAddressLab = [[UILabel alloc] init];
        _receiverDetailsAddressLab.font = [UIFont systemFontOfSize:12.0f*kScale];
        _receiverDetailsAddressLab.textColor = RGB(51, 51, 51, 1);
        _receiverDetailsAddressLab.textAlignment = NSTextAlignmentLeft;
        
    }
    return _receiverDetailsAddressLab;
}


-(UIButton *)submitBtn{
    if (!_submitBtn) {
        _submitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        
        _submitBtn.backgroundColor = RGB(236, 31, 35, 1);
        [_submitBtn setTitle:@"提交" forState:0];
        [_submitBtn setTitleColor:[UIColor whiteColor] forState:0];
        _submitBtn.layer.cornerRadius = 5;
        _submitBtn.layer.masksToBounds = YES;
        
    }
    return _submitBtn;
}

//////////////////////////////////



-(UILabel *)lookUpTypeTemp{
    if (!_lookUpTypeTemp) {
        _lookUpTypeTemp = [[UILabel alloc] init];
        _lookUpTypeTemp.font = [UIFont systemFontOfSize:12.0f*kScale];
        _lookUpTypeTemp.textColor = RGB(51, 51, 51, 1);
        _lookUpTypeTemp.textAlignment = NSTextAlignmentLeft;
        _lookUpTypeTemp.text = @"抬头类型:";
    }
    return _lookUpTypeTemp;
}




-(UILabel *)invoiceLookUpLabelTemp{
    if (!_invoiceLookUpLabelTemp) {
        _invoiceLookUpLabelTemp = [[UILabel alloc] init];
        _invoiceLookUpLabelTemp.font = [UIFont systemFontOfSize:12.0f*kScale];
        _invoiceLookUpLabelTemp.textColor = RGB(51, 51, 51, 1);
        _invoiceLookUpLabelTemp.textAlignment = NSTextAlignmentLeft;
        _invoiceLookUpLabelTemp.text = @"发票抬头:";
    }
    return _invoiceLookUpLabelTemp;
}


-(UILabel *)enioLabelTemp{
    if (!_enioLabelTemp) {
        _enioLabelTemp = [[UILabel alloc] init];
        _enioLabelTemp.font = [UIFont systemFontOfSize:12.0f*kScale];
        _enioLabelTemp.textColor = RGB(51, 51, 51, 1);
        _enioLabelTemp.textAlignment = NSTextAlignmentLeft;
        _enioLabelTemp.text = @"税号:";
        
    }
    return _enioLabelTemp;
}


-(UILabel *)companyPhoneNumLabelTemp{
    if (!_companyPhoneNumLabelTemp) {
        _companyPhoneNumLabelTemp = [[UILabel alloc] init];
        _companyPhoneNumLabelTemp.font = [UIFont systemFontOfSize:12.0f*kScale];
        _companyPhoneNumLabelTemp.textColor = RGB(51, 51, 51, 1);
        _companyPhoneNumLabelTemp.textAlignment = NSTextAlignmentLeft;
        _companyPhoneNumLabelTemp.text = @"公司电话:";
        
    }
    return _companyPhoneNumLabelTemp;
}


-(UILabel *)companyAddressLabelTemp{
    if (!_companyAddressLabelTemp) {
        _companyAddressLabelTemp = [[UILabel alloc] init];
        _companyAddressLabelTemp.font = [UIFont systemFontOfSize:12.0f*kScale];
        _companyAddressLabelTemp.textColor = RGB(51, 51, 51, 1);
        _companyAddressLabelTemp.textAlignment = NSTextAlignmentLeft;
        _companyAddressLabelTemp.text = @"公司地址:";
        
    }
    return _companyAddressLabelTemp;
}




-(UILabel *)bankLabelTemp{
    if (!_bankLabelTemp) {
        _bankLabelTemp = [[UILabel alloc] init];
        _bankLabelTemp.font = [UIFont systemFontOfSize:12.0f*kScale];
        _bankLabelTemp.textColor = RGB(51, 51, 51, 1);
        _bankLabelTemp.textAlignment = NSTextAlignmentLeft;
        _bankLabelTemp.text = @"开户银行:";
        
    }
    return _bankLabelTemp;
}





-(UILabel *)bankAccountLabelTemp{
    if (!_bankAccountLabelTemp) {
        _bankAccountLabelTemp = [[UILabel alloc] init];
        _bankAccountLabelTemp.font = [UIFont systemFontOfSize:12.0f*kScale];
        _bankAccountLabelTemp.textColor = RGB(51, 51, 51, 1);
        _bankAccountLabelTemp.textAlignment = NSTextAlignmentLeft;
        _bankAccountLabelTemp.text = @"开户行账号:";
        
    }
    return _bankAccountLabelTemp;
}




-(UILabel *)invoiceContentLabelTemp{
    if (!_invoiceContentLabelTemp) {
        _invoiceContentLabelTemp = [[UILabel alloc] init];
        _invoiceContentLabelTemp.font = [UIFont systemFontOfSize:12.0f*kScale];
        _invoiceContentLabelTemp.textColor = RGB(51, 51, 51, 1);
        _invoiceContentLabelTemp.textAlignment = NSTextAlignmentLeft;
        _invoiceContentLabelTemp.text = @"发票内容:";
        
    }
    return _invoiceContentLabelTemp;
}



-(UILabel *)invoiceMoneyLabelTemp{
    if (!_invoiceMoneyLabelTemp) {
        _invoiceMoneyLabelTemp = [[UILabel alloc] init];
        _invoiceMoneyLabelTemp.font = [UIFont systemFontOfSize:12.0f*kScale];
        _invoiceMoneyLabelTemp.textColor = RGB(51, 51, 51, 1);
        _invoiceMoneyLabelTemp.textAlignment = NSTextAlignmentLeft;
        _invoiceMoneyLabelTemp.text = @"发票金额:";
        
    }
    return _invoiceMoneyLabelTemp;
}





-(UILabel *)receiverLabTemp{
    if (!_receiverLabTemp) {
        _receiverLabTemp = [[UILabel alloc] init];
        _receiverLabTemp.font = [UIFont systemFontOfSize:12.0f*kScale];
        _receiverLabTemp.textColor = RGB(51, 51, 51, 1);
        _receiverLabTemp.textAlignment = NSTextAlignmentLeft;
        _receiverLabTemp.text = @"收件人:";
        
    }
    return _receiverLabTemp;
}


-(UILabel *)receiverPhoneNumLabelTemp{
    if (!_receiverPhoneNumLabelTemp) {
        _receiverPhoneNumLabelTemp = [[UILabel alloc] init];
        _receiverPhoneNumLabelTemp.font = [UIFont systemFontOfSize:12.0f*kScale];
        _receiverPhoneNumLabelTemp.textColor = RGB(51, 51, 51, 1);
        _receiverPhoneNumLabelTemp.textAlignment = NSTextAlignmentLeft;
        _receiverPhoneNumLabelTemp.text = @"联系电话:";
        
    }
    return _receiverPhoneNumLabelTemp;
}



-(UILabel *)receiverAddressLabelTemp{
    if (!_receiverAddressLabelTemp) {
        _receiverAddressLabelTemp = [[UILabel alloc] init];
        _receiverAddressLabelTemp.font = [UIFont systemFontOfSize:12.0f*kScale];
        _receiverAddressLabelTemp.textColor = RGB(51, 51, 51, 1);
        _receiverAddressLabelTemp.textAlignment = NSTextAlignmentLeft;
        _receiverAddressLabelTemp.text = @"收货地址:";
        
    }
    return _receiverAddressLabelTemp;
}






-(UILabel *)receiverDetailsAddressLabTemp{
    if (!_receiverDetailsAddressLabTemp) {
        _receiverDetailsAddressLabTemp = [[UILabel alloc] init];
        _receiverDetailsAddressLabTemp.font = [UIFont systemFontOfSize:12.0f*kScale];
        _receiverDetailsAddressLabTemp.textColor = RGB(51, 51, 51, 1);
        _receiverDetailsAddressLabTemp.textAlignment = NSTextAlignmentLeft;
        _receiverDetailsAddressLabTemp.text = @"门牌号:";
        
    }
    return _receiverDetailsAddressLabTemp;
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

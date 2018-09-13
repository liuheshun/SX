//
//  SelectInvoiceTypesDetailsTableViewCell.m
//  Emeat
//
//  Created by liuheshun on 2018/6/22.
//  Copyright © 2018年 liuheshun. All rights reserved.
//

#import "SelectInvoiceTypesDetailsTableViewCell.h"

@implementation SelectInvoiceTypesDetailsTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self addSubview:self.lookUpType];
        [self addSubview:self.lookUpTypeBtn1];
        [self addSubview:self.lookUpTypeBtn2];
        [self addSubview:self.invoiceLookUpLabel];
        [self addSubview:self.invoiceLookUpTextField];
        [self addSubview:self.enioLabel];
        [self addSubview:self.enioTextField];
        [self addSubview:self.invoiceContentLabel];
        [self addSubview:self.invoiceContentTextField];
        [self addSubview:self.invoiceMoneyLabel];
        [self addSubview:self.invoiceMoneyTextField];
        [self addSubview:self.moreInfoLabel];
        [self addSubview:self.showMoreInfoBtn];
        
        [self setMainFrame];
        [self setLineViewUI];

    }
    return self;
}


-(void)configWithModel:(InvoiceDetailsModel*)model{
   
    self.invoiceLookUpTextField.text = model.invoiceCompany;
    self.enioTextField.text = model.invoiceTaxNum;
    self.companyPhoneNumTextField.text = model.invoiceCompanyPhone;
    self.companyAddressTextField.text = model.invoiceCompanyAddress;
    
    self.bankTextField.text = model.invoiceCompanyBank;
    self.bankAccountTextField.text = model.invoiceCompanyBankAccount;
    
    self.invoiceMoneyTextField.enabled = NO;
    
    
    
}






-(void)lookUpTypeBtn1Action{
    [_lookUpTypeBtn1 setImage:[UIImage imageNamed:@"selected"] forState:0];
    [_lookUpTypeBtn2 setImage:[UIImage imageNamed:@"no_selected"] forState:0];
    self.enioTextField.hidden = NO;
    self.enioLabel.hidden = NO;
    
    [self.enioLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(15*kScale);
        make.top.equalTo(self.invoiceLookUpLabel.mas_bottom).with.offset(1*kScale);
        make.width.equalTo(@(90*kScale));
        make.height.equalTo(@(40*kScale));
    }];
    
    [self.enioTextField mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.enioLabel.mas_right).offset(0);
        make.top.equalTo(self.invoiceLookUpLabel.mas_bottom).with.offset(1*kScale);
        make.right.equalTo(self.mas_right).with.offset(-15*kScale);
        make.height.equalTo(@(40*kScale));
    }];
    
    
    [self.invoiceContentLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(15*kScale);
        make.top.equalTo(self.enioLabel.mas_bottom).with.offset(1*kScale);
        make.width.equalTo(@(90*kScale));
        make.height.equalTo(@(40*kScale));
    }];
    
    [self.invoiceContentTextField mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.invoiceContentLabel.mas_right).offset(0);
        make.top.equalTo(self.enioLabel.mas_bottom).with.offset(1*kScale);
        make.right.equalTo(self.mas_right).with.offset(-15*kScale);
        make.height.equalTo(@(40*kScale));
    }];

    [self layoutIfNeeded];
    
    
    self.isSwitchOrdinaryTypesBlock(20);
}


-(void)lookUpTypeBtn2Action{
    [_lookUpTypeBtn1 setImage:[UIImage imageNamed:@"no_selected"] forState:0];

    [_lookUpTypeBtn2 setImage:[UIImage imageNamed:@"selected"] forState:0];

//    [self.enioLabel removeFromSuperview];
//    [self.enioTextField removeFromSuperview];
    
    self.enioTextField.hidden = YES;
    self.enioLabel.hidden = YES;
    [self.invoiceContentLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(15*kScale);
        make.top.equalTo(self.invoiceLookUpLabel.mas_bottom).with.offset(1*kScale);
        make.width.equalTo(@(90*kScale));
        make.height.equalTo(@(40*kScale));
    }];
    
    [self.invoiceContentTextField mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.invoiceContentLabel.mas_right).offset(0);
        make.top.equalTo(self.invoiceLookUpLabel.mas_bottom).with.offset(1*kScale);
        make.right.equalTo(self.mas_right).with.offset(-15*kScale);
        make.height.equalTo(@(40*kScale));
    }];
    
    
    self.isSwitchOrdinaryTypesBlock(21);

    
    
}



#pragma mark ====更多信息
-(void)showMoreInfoBtnAction{
    if ([self respondsToSelector:@selector(isShowMoreInfoBlock)]) {
        if (_isShowMoreInfo == 0) {
            _isShowMoreInfo = 1;
            //更多信息
            [self addSubview:self.companyPhoneNumLabel];
            [self addSubview:self.companyPhoneNumTextField];
            [self addSubview:self.companyAddressLabel];
            [self addSubview:self.companyAddressTextField];
            [self addSubview:self.bankLabel];
            [self addSubview:self.bankTextField];
            [self addSubview:self.bankAccountLabel];
            [self addSubview:self.bankAccountTextField];
            [self addSubview:self.noteLabel];
            [self addSubview:self.noteTextField];
            [self setMoreInfoMainFrame];
            [self setMoreLineView];
            
            [_showMoreInfoBtn setImage:[UIImage imageNamed:@"展开"] forState:0];

            
        }else if (_isShowMoreInfo == 1){
            _isShowMoreInfo = 0;
            [self.companyPhoneNumLabel removeFromSuperview];
            [self.companyPhoneNumTextField removeFromSuperview];
            [self.companyAddressLabel removeFromSuperview];
            [self.companyAddressTextField removeFromSuperview];
            [self.bankLabel removeFromSuperview];
            [self.bankTextField removeFromSuperview];
            [self.bankAccountLabel removeFromSuperview];
            [self.bankAccountTextField removeFromSuperview];
            [self.noteLabel removeFromSuperview];
            [self.noteTextField removeFromSuperview];
            [self.lineView removeFromSuperview];
            [_showMoreInfoBtn setImage:[UIImage imageNamed:@"收起"] forState:0];

        }
        
        self.isShowMoreInfoBlock(_isShowMoreInfo);
        
    }

    
}

-(void)setMoreLineView{
    NSArray *labelArray =  @[@"备注:" ,@"公司电话:" ,@"公司地址" ,@"开户银行:" ,@"开户行账号"];

    for (int i = 0; i < labelArray.count; i++) {
        
        self.lineView = [[UIView alloc] init];
        self.lineView.backgroundColor = RGB(238, 238, 238, 1);
        [self addSubview:self.lineView];
        
        [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left).offset(15*kScale);
            make.right.equalTo(self.mas_right).with.offset(-15*kScale);
            make.height.equalTo(@(1*kScale));
            make.top.equalTo(self.companyPhoneNumLabel.mas_bottom).with.offset(41*kScale*i+1*kScale );
            
        }];
        
        
    }
    
}


-(void)setLineViewUI{
    
    UIView *lastLineView = nil;
    NSArray *labelArray =  @[@"发票抬头:" ,@"税号:" ,@"发票内容:" ,@"发票金额:" ,@"更多信息"];
    for (int i = 0; i < labelArray.count; i++) {
           
            self.lineView = [[UIView alloc] init];
            self.lineView.backgroundColor = RGB(238, 238, 238, 1);
            [self addSubview:self.lineView];

            [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.mas_left).offset(15*kScale);
                make.right.equalTo(self.mas_right).with.offset(-15*kScale);
                make.height.equalTo(@(1*kScale));
               make.top.equalTo(self.lookUpType.mas_bottom).with.offset(41*kScale*i+1*kScale);
 
            }];

            lastLineView = self.lineView;

        }

   

    
}



-(void)setMainFrame{
    [self.lookUpType mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(15*kScale);
        make.top.equalTo(self);
        make.width.equalTo(@(90*kScale));
        make.height.equalTo(@(40*kScale));
    }];
    
    [self.lookUpTypeBtn1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.lookUpType.mas_right).offset(0*kScale);
        make.top.equalTo(self);
        make.width.equalTo(@(100*kScale));
        make.height.equalTo(@(40*kScale));
    }];
    
    [self.lookUpTypeBtn2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.lookUpTypeBtn1.mas_right).offset(0*kScale);
        make.right.equalTo(self.mas_right).offset(-15*kScale);
        make.top.equalTo(self);
        make.height.equalTo(@(40*kScale));
    }];
    
    
    [self.invoiceLookUpLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(15*kScale);
        make.top.equalTo(self.lookUpType.mas_bottom).with.offset(1*kScale);
        make.width.equalTo(@(90*kScale));
        make.height.equalTo(@(40*kScale));
    }];
    
    [self.invoiceLookUpTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.invoiceLookUpLabel.mas_right).offset(0);
        make.top.equalTo(self.lookUpType.mas_bottom).with.offset(1*kScale);
        make.right.equalTo(self.mas_right).with.offset(-15*kScale);
        make.height.equalTo(@(40*kScale));
    }];
    
    [self.enioLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(15*kScale);
        make.top.equalTo(self.invoiceLookUpLabel.mas_bottom).with.offset(1*kScale);
        make.width.equalTo(@(90*kScale));
        make.height.equalTo(@(40*kScale));
    }];
    
    [self.enioTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.enioLabel.mas_right).offset(0);
        make.top.equalTo(self.invoiceLookUpLabel.mas_bottom).with.offset(1*kScale);
        make.right.equalTo(self.mas_right).with.offset(-15*kScale);
        make.height.equalTo(@(40*kScale));
    }];
    
    
    [self.invoiceContentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(15*kScale);
        make.top.equalTo(self.enioLabel.mas_bottom).with.offset(1*kScale);
        make.width.equalTo(@(90*kScale));
        make.height.equalTo(@(40*kScale));
    }];
    
    [self.invoiceContentTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.invoiceContentLabel.mas_right).offset(0);
        make.top.equalTo(self.enioLabel.mas_bottom).with.offset(1*kScale);
        make.right.equalTo(self.mas_right).with.offset(-15*kScale);
        make.height.equalTo(@(40*kScale));
    }];
    
    
    
    
    [self.invoiceMoneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(15*kScale);
        make.top.equalTo(self.invoiceContentLabel.mas_bottom).with.offset(1*kScale);
        make.width.equalTo(@(90*kScale));
        make.height.equalTo(@(40*kScale));
    }];
    
    [self.invoiceMoneyTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.invoiceMoneyLabel.mas_right).offset(0);
        make.top.equalTo(self.invoiceContentLabel.mas_bottom).with.offset(1*kScale);
        make.right.equalTo(self.mas_right).with.offset(-15*kScale);
        make.height.equalTo(@(40*kScale));
    }];
    
    [self.moreInfoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(15*kScale);
        make.top.equalTo(self.invoiceMoneyLabel.mas_bottom).with.offset(1*kScale);
        make.width.equalTo(@(90*kScale));
        make.height.equalTo(@(40*kScale));
    }];
    
    [self.showMoreInfoBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-15*kScale);
        make.top.equalTo(self.invoiceMoneyLabel.mas_bottom).with.offset(1*kScale);
        make.width.equalTo(@(45*kScale));
        make.height.equalTo(@(40*kScale));
    }];
    
  
}


-(void)setMoreInfoMainFrame{
    ///更多选填信息
    [self.companyPhoneNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(15*kScale);
        make.top.equalTo(self.moreInfoLabel.mas_bottom).with.offset(1*kScale);
        make.width.equalTo(@(90*kScale));
        make.height.equalTo(@(40*kScale));
    }];
    
    [self.companyPhoneNumTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.companyPhoneNumLabel.mas_right).offset(0);
        make.top.equalTo(self.moreInfoLabel.mas_bottom).with.offset(1*kScale);
        make.right.equalTo(self.mas_right).with.offset(-15*kScale);
        make.height.equalTo(@(40*kScale));
    }];
    
    
    
    [self.companyAddressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(15*kScale);
        make.top.equalTo(self.companyPhoneNumLabel.mas_bottom).with.offset(1*kScale);
        make.width.equalTo(@(90*kScale));
        make.height.equalTo(@(40*kScale));
    }];
    
    [self.companyAddressTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.companyPhoneNumLabel.mas_right).offset(0);
        make.top.equalTo(self.companyPhoneNumLabel.mas_bottom).with.offset(1*kScale);
        make.right.equalTo(self.mas_right).with.offset(-15*kScale);
        make.height.equalTo(@(40*kScale));
    }];
    
    
    [self.bankLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(15*kScale);
        make.top.equalTo(self.companyAddressLabel.mas_bottom).with.offset(1*kScale);
        make.width.equalTo(@(90*kScale));
        make.height.equalTo(@(40*kScale));
    }];
    
    [self.bankTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bankLabel.mas_right).offset(0);
        make.top.equalTo(self.companyAddressLabel.mas_bottom).with.offset(1*kScale);
        make.right.equalTo(self.mas_right).with.offset(-15*kScale);
        make.height.equalTo(@(40*kScale));
    }];
    
    
    
    
    [self.bankAccountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(15*kScale);
        make.top.equalTo(self.bankLabel.mas_bottom).with.offset(1*kScale);
        make.width.equalTo(@(90*kScale));
        make.height.equalTo(@(40*kScale));
    }];
    
    [self.bankAccountTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bankAccountLabel.mas_right).offset(0);
        make.top.equalTo(self.bankLabel.mas_bottom).with.offset(1*kScale);
        make.right.equalTo(self.mas_right).with.offset(-15*kScale);
        make.height.equalTo(@(40*kScale));
    }];
    
    
    
    [self.noteLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(15*kScale);
        make.top.equalTo(self.bankAccountLabel.mas_bottom).with.offset(1*kScale);
        make.width.equalTo(@(90*kScale));
        make.height.equalTo(@(40*kScale));
    }];
    
    [self.noteTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.noteLabel.mas_right).offset(0);
        make.top.equalTo(self.bankAccountLabel.mas_bottom).with.offset(1*kScale);
        make.right.equalTo(self.mas_right).with.offset(-15*kScale);
        make.height.equalTo(@(40*kScale));
    }];
    
}




-(UILabel *)lookUpType{
    if (!_lookUpType) {
        _lookUpType = [[UILabel alloc] init];
        _lookUpType.font = [UIFont systemFontOfSize:15.0f*kScale];
        _lookUpType.textColor = RGB(51, 51, 51, 1);
        _lookUpType.textAlignment = NSTextAlignmentLeft;
        _lookUpType.text = @"抬头类型:";
    }
    return _lookUpType;
}



-(UIButton *)lookUpTypeBtn1{
    if (!_lookUpTypeBtn1) {
        _lookUpTypeBtn1 = [UIButton buttonWithType:UIButtonTypeCustom];
        _lookUpTypeBtn1.titleLabel.font  = [UIFont systemFontOfSize:12.0f*kScale];
        [_lookUpTypeBtn1 setTitleColor:RGB(51, 51, 51, 1) forState:0];
        [_lookUpTypeBtn1 setTitle:@"企业单位" forState:0];
        [_lookUpTypeBtn1 setImage:[UIImage imageNamed:@"selected"] forState:0];
        _lookUpTypeBtn1.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
        _lookUpTypeBtn1.imageEdgeInsets = UIEdgeInsetsMake(0, -5*kScale, 0, 0);
        _lookUpTypeBtn1.contentHorizontalAlignment =  UIControlContentHorizontalAlignmentLeft;
        [_lookUpTypeBtn1 addTarget:self action:@selector(lookUpTypeBtn1Action) forControlEvents:1];
    }
    return _lookUpTypeBtn1;
}

-(UIButton *)lookUpTypeBtn2{
    if (!_lookUpTypeBtn2) {
        _lookUpTypeBtn2 = [UIButton buttonWithType:UIButtonTypeCustom];
        _lookUpTypeBtn2.titleLabel.font  = [UIFont systemFontOfSize:12.0f*kScale];
        [_lookUpTypeBtn2 setTitleColor:RGB(51, 51, 51, 1) forState:0];
        [_lookUpTypeBtn2 setTitle:@"个人/非企业单位" forState:0];
        [_lookUpTypeBtn2 setImage:[UIImage imageNamed:@"no_selected"] forState:0];
        _lookUpTypeBtn2.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
        _lookUpTypeBtn2.imageEdgeInsets = UIEdgeInsetsMake(0, -5*kScale, 0, 0);
        _lookUpTypeBtn2.contentHorizontalAlignment =  UIControlContentHorizontalAlignmentLeft;
        [_lookUpTypeBtn2 addTarget:self action:@selector(lookUpTypeBtn2Action) forControlEvents:1];

    }
    return _lookUpTypeBtn2;
}



-(UILabel *)invoiceLookUpLabel{
    if (!_invoiceLookUpLabel) {
        _invoiceLookUpLabel = [[UILabel alloc] init];
        _invoiceLookUpLabel.font = [UIFont systemFontOfSize:12.0f*kScale];
        _invoiceLookUpLabel.textColor = RGB(51, 51, 51, 1);
        _invoiceLookUpLabel.textAlignment = NSTextAlignmentLeft;
        _invoiceLookUpLabel.text = @"发票抬头:";
    }
    return _invoiceLookUpLabel;
}

-(UITextField *)invoiceLookUpTextField{
    if (!_invoiceLookUpTextField) {
        _invoiceLookUpTextField = [[UITextField alloc] init];
        _invoiceLookUpTextField.font = [UIFont systemFontOfSize:12.0f*kScale];
        _invoiceLookUpTextField.textAlignment = NSTextAlignmentLeft;
        _invoiceLookUpTextField.textColor =  RGB(51, 51, 51, 1);
        _invoiceLookUpTextField.placeholder = @"请填写发票抬头";
    }
    return _invoiceLookUpTextField;
}


-(UILabel *)enioLabel{
    if (!_enioLabel) {
        _enioLabel = [[UILabel alloc] init];
        _enioLabel.font = [UIFont systemFontOfSize:12.0f*kScale];
        _enioLabel.textColor = RGB(51, 51, 51, 1);
        _enioLabel.textAlignment = NSTextAlignmentLeft;
        _enioLabel.text = @"税号:";
        
    }
    return _enioLabel;
}

-(UITextField *)enioTextField{
    if (!_enioTextField) {
        _enioTextField = [[UITextField alloc] init];
        _enioTextField.font = [UIFont systemFontOfSize:12.0f*kScale];
        _enioTextField.textAlignment = NSTextAlignmentLeft;
        _enioTextField.textColor =  RGB(51, 51, 51, 1);
        _enioTextField.placeholder = @"请填写纳税人识别号";
        
    }
    return _enioTextField;
}




-(UILabel *)invoiceContentLabel{
    if (!_invoiceContentLabel) {
        _invoiceContentLabel = [[UILabel alloc] init];
        _invoiceContentLabel.font = [UIFont systemFontOfSize:12.0f*kScale];
        _invoiceContentLabel.textColor = RGB(51, 51, 51, 1);
        _invoiceContentLabel.textAlignment = NSTextAlignmentLeft;
        _invoiceContentLabel.text = @"发票内容:";
        
    }
    return _invoiceContentLabel;
}

-(UITextField *)invoiceContentTextField{
    if (!_invoiceContentTextField) {
        _invoiceContentTextField = [[UITextField alloc] init];
        _invoiceContentTextField.font = [UIFont systemFontOfSize:12.0f*kScale];
        _invoiceContentTextField.textAlignment = NSTextAlignmentLeft;
        _invoiceContentTextField.textColor =  RGB(51, 51, 51, 1);
        _invoiceContentTextField.placeholder = @"*根据相应订单商品明细生成";
        _invoiceContentTextField.enabled = NO;
        
    }
    return _invoiceContentTextField;
}


-(UILabel *)invoiceMoneyLabel{
    if (!_invoiceMoneyLabel) {
        _invoiceMoneyLabel = [[UILabel alloc] init];
        _invoiceMoneyLabel.font = [UIFont systemFontOfSize:12.0f*kScale];
        _invoiceMoneyLabel.textColor = RGB(51, 51, 51, 1);
        _invoiceMoneyLabel.textAlignment = NSTextAlignmentLeft;
        _invoiceMoneyLabel.text = @"发票金额:";
        
    }
    return _invoiceMoneyLabel;
}

-(UITextField *)invoiceMoneyTextField{
    if (!_invoiceMoneyTextField) {
        _invoiceMoneyTextField = [[UITextField alloc] init];
        _invoiceMoneyTextField.font = [UIFont systemFontOfSize:12.0f*kScale];
        _invoiceMoneyTextField.textAlignment = NSTextAlignmentLeft;
        _invoiceMoneyTextField.textColor =  RGB(51, 51, 51, 1);
        
        
    }
    return _invoiceMoneyTextField;
}



-(UILabel *)moreInfoLabel{
    if (!_moreInfoLabel) {
        _moreInfoLabel = [[UILabel alloc] init];
        _moreInfoLabel.font = [UIFont systemFontOfSize:12.0f*kScale];
        _moreInfoLabel.textColor = RGB(51, 51, 51, 1);
        _moreInfoLabel.textAlignment = NSTextAlignmentLeft;
        _moreInfoLabel.text = @"更多信息";
    }
    return _moreInfoLabel;
}


-(UIButton *)showMoreInfoBtn{
    if (!_showMoreInfoBtn) {
        _showMoreInfoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_showMoreInfoBtn setImage:[UIImage imageNamed:@"收起"] forState:0];
        _showMoreInfoBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        _isShowMoreInfo = 0;
        [_showMoreInfoBtn addTarget:self action:@selector(showMoreInfoBtnAction) forControlEvents:1];
    }
    return _showMoreInfoBtn;
}

///选填 更多信息


-(UILabel *)companyPhoneNumLabel{
    if (!_companyPhoneNumLabel) {
        _companyPhoneNumLabel = [[UILabel alloc] init];
        _companyPhoneNumLabel.font = [UIFont systemFontOfSize:12.0f*kScale];
        _companyPhoneNumLabel.textColor = RGB(51, 51, 51, 1);
        _companyPhoneNumLabel.textAlignment = NSTextAlignmentLeft;
        _companyPhoneNumLabel.text = @"公司电话:";
        
    }
    return _companyPhoneNumLabel;
}

-(UITextField *)companyPhoneNumTextField{
    if (!_companyPhoneNumTextField) {
        _companyPhoneNumTextField = [[UITextField alloc] init];
        _companyPhoneNumTextField.font = [UIFont systemFontOfSize:12.0f*kScale];
        _companyPhoneNumTextField.textAlignment = NSTextAlignmentLeft;
        _companyPhoneNumTextField.textColor =  RGB(51, 51, 51, 1);
        _companyPhoneNumTextField.placeholder = @"请填写公司电话 (选填)";

        
    }
    return _companyPhoneNumTextField;
}



-(UILabel *)companyAddressLabel{
    if (!_companyAddressLabel) {
        _companyAddressLabel = [[UILabel alloc] init];
        _companyAddressLabel.font = [UIFont systemFontOfSize:12.0f*kScale];
        _companyAddressLabel.textColor = RGB(51, 51, 51, 1);
        _companyAddressLabel.textAlignment = NSTextAlignmentLeft;
        _companyAddressLabel.text = @"公司地址:";
        
    }
    return _companyAddressLabel;
}

-(UITextField *)companyAddressTextField{
    if (!_companyAddressTextField) {
        _companyAddressTextField = [[UITextField alloc] init];
        _companyAddressTextField.font = [UIFont systemFontOfSize:12.0f*kScale];
        _companyAddressTextField.textAlignment = NSTextAlignmentLeft;
        _companyAddressTextField.textColor =  RGB(51, 51, 51, 1);
        _companyAddressTextField.placeholder = @"请填写公司地址 (选填)";
        
        
    }
    return _companyAddressTextField;
}



-(UILabel *)bankLabel{
    if (!_bankLabel) {
        _bankLabel = [[UILabel alloc] init];
        _bankLabel.font = [UIFont systemFontOfSize:12.0f*kScale];
        _bankLabel.textColor = RGB(51, 51, 51, 1);
        _bankLabel.textAlignment = NSTextAlignmentLeft;
        _bankLabel.text = @"开户银行:";
        
    }
    return _bankLabel;
}

-(UITextField *)bankTextField{
    if (!_bankTextField) {
        _bankTextField = [[UITextField alloc] init];
        _bankTextField.font = [UIFont systemFontOfSize:12.0f*kScale];
        _bankTextField.textAlignment = NSTextAlignmentLeft;
        _bankTextField.textColor =  RGB(51, 51, 51, 1);
        _bankTextField.placeholder = @"请填写开户银行 (选填)";
        
        
    }
    return _bankTextField;
}





-(UILabel *)bankAccountLabel{
    if (!_bankAccountLabel) {
        _bankAccountLabel = [[UILabel alloc] init];
        _bankAccountLabel.font = [UIFont systemFontOfSize:12.0f*kScale];
        _bankAccountLabel.textColor = RGB(51, 51, 51, 1);
        _bankAccountLabel.textAlignment = NSTextAlignmentLeft;
        _bankAccountLabel.text = @"开户行账号:";
        
    }
    return _bankAccountLabel;
}

-(UITextField *)bankAccountTextField{
    if (!_bankAccountTextField) {
        _bankAccountTextField = [[UITextField alloc] init];
        _bankAccountTextField.font = [UIFont systemFontOfSize:12.0f*kScale];
        _bankAccountTextField.textAlignment = NSTextAlignmentLeft;
        _bankAccountTextField.textColor =  RGB(51, 51, 51, 1);
        _bankAccountTextField.placeholder = @"请填写开户行账号 (选填)";
        
        
    }
    return _bankAccountTextField;
}




-(UILabel *)noteLabel{
    if (!_noteLabel) {
        _noteLabel = [[UILabel alloc] init];
        _noteLabel.font = [UIFont systemFontOfSize:12.0f*kScale];
        _noteLabel.textColor = RGB(51, 51, 51, 1);
        _noteLabel.textAlignment = NSTextAlignmentLeft;
        _noteLabel.text = @"备注:";
        
    }
    return _noteLabel;
}

-(UITextField *)noteTextField{
    if (!_noteTextField) {
        _noteTextField = [[UITextField alloc] init];
        _noteTextField.font = [UIFont systemFontOfSize:12.0f*kScale];
        _noteTextField.textAlignment = NSTextAlignmentLeft;
        _noteTextField.textColor =  RGB(51, 51, 51, 1);
        _noteTextField.placeholder = @"请填写备注 (选填)";
        
        
    }
    return _noteTextField;
}




- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

//
//  SelectInvoiceTypesReceiveAddressTableViewCell.m
//  Emeat
//
//  Created by liuheshun on 2018/6/25.
//  Copyright © 2018年 liuheshun. All rights reserved.
//

#import "SelectInvoiceTypesReceiveAddressTableViewCell.h"

@implementation SelectInvoiceTypesReceiveAddressTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        //更多信息
        [self addSubview:self.receiverLab];
        [self addSubview:self.receiverTextField];
        [self addSubview:self.receiverPhoneNumLabel];
        [self addSubview:self.receiverPhoneNumTextField];
        [self addSubview:self.receiverAddressLabel];
        [self addSubview:self.receiverAddressTextField];
        [self.receiverAddressTextField addSubview:self.receiverAddressBtn];

        
        
        [self addSubview:self.receiverDetailsAddressLab];
        [self addSubview:self.receiverDetailsAddressTextField];
        [self addSubview:self.recerEmailLabel];
        [self addSubview:self.receiverEmailTextField];
        [self addSubview:self.sendFreeLabel];
        [self addSubview:self.sendFreeTextField];
        
        [self setMoreInfoMainFrame];
        [self setMoreLineView];
        
    }
    return self;
}

-(void)configAddressCellWithModel:(InvoiceDetailsModel*)model{
    
    self.receiverTextField.text = model.invoiceReceiver;
    self.receiverPhoneNumTextField.text = model.invoiceReceiverPhone;
    self.receiverAddressTextField.text =  model.invoiceReceiverAddress;
    self.receiverDetailsAddressTextField.text =  model.invoiceReceiverDetailsAddress;   
    self.sendFreeTextField.enabled = NO;
    
    
}

////设置地址不可编辑
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    
    return NO;
    
}


-(void)setMoreLineView{
    NSArray *labelArray =  @[@"收件人:" ,@"联系电话:" ,@"收货地址" ,@"门牌号:" ,@"电子邮箱" ];
    
    for (int i = 0; i < labelArray.count; i++) {
        
        self.lineView = [[UIView alloc] init];
        self.lineView.backgroundColor = RGB(238, 238, 238, 1);
        [self addSubview:self.lineView];
        self.lineView.tag = i;
        [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left).offset(15*kScale);
            make.right.equalTo(self.mas_right).with.offset(-15*kScale);
            make.height.equalTo(@(1*kScale));
            make.top.equalTo(self.receiverLab.mas_bottom).with.offset(41*kScale*i+1*kScale );
            
        }];
        
        
    }
    
}

-(void)setMoreInfoMainFrame{
    ///更多选填信息
    [self.receiverLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(15*kScale);
        make.top.equalTo(self.mas_top).with.offset(0*kScale);
        make.width.equalTo(@(90*kScale));
        make.height.equalTo(@(40*kScale));
    }];
    
    [self.receiverTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.receiverLab.mas_right).offset(0);
        make.top.equalTo(self.mas_top).with.offset(0*kScale);
        make.right.equalTo(self.mas_right).with.offset(-15*kScale);
        make.height.equalTo(@(40*kScale));
    }];
    
    
    
    [self.receiverPhoneNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(15*kScale);
        make.top.equalTo(self.receiverLab.mas_bottom).with.offset(1*kScale);
        make.width.equalTo(@(90*kScale));
        make.height.equalTo(@(40*kScale));
    }];
    
    [self.receiverPhoneNumTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.receiverLab.mas_right).offset(0);
        make.top.equalTo(self.receiverLab.mas_bottom).with.offset(1*kScale);
        make.right.equalTo(self.mas_right).with.offset(-15*kScale);
        make.height.equalTo(@(40*kScale));
    }];
    
    
    [self.receiverAddressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(15*kScale);
        make.top.equalTo(self.receiverPhoneNumLabel.mas_bottom).with.offset(1*kScale);
        make.width.equalTo(@(90*kScale));
        make.height.equalTo(@(40*kScale));
    }];
    
    [self.receiverAddressTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.receiverAddressLabel.mas_right).offset(0);
        make.top.equalTo(self.receiverPhoneNumLabel.mas_bottom).with.offset(1*kScale);
        make.right.equalTo(self.mas_right).with.offset(-15*kScale);
        make.height.equalTo(@(40*kScale));
    }];
    
    
    
    [self.receiverAddressBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.right.equalTo(self.receiverAddressTextField);
        make.top.equalTo(self.receiverAddressTextField.mas_top).with.offset(0*kScale);
        make.height.equalTo(self.receiverAddressTextField);
    }];
    
    
    
    [self.receiverDetailsAddressLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(15*kScale);
        make.top.equalTo(self.receiverAddressLabel.mas_bottom).with.offset(1*kScale);
        make.width.equalTo(@(90*kScale));
        make.height.equalTo(@(40*kScale));
    }];
    
    [self.receiverDetailsAddressTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.receiverDetailsAddressLab.mas_right).offset(0);
        make.top.equalTo(self.receiverAddressLabel.mas_bottom).with.offset(1*kScale);
        make.right.equalTo(self.mas_right).with.offset(-15*kScale);
        make.height.equalTo(@(40*kScale));
    }];
    
    
    
    [self.recerEmailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(15*kScale);
        make.top.equalTo(self.receiverDetailsAddressLab.mas_bottom).with.offset(1*kScale);
        make.width.equalTo(@(90*kScale));
        make.height.equalTo(@(40*kScale));
    }];
    
    [self.receiverEmailTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.recerEmailLabel.mas_right).offset(0);
        make.top.equalTo(self.receiverDetailsAddressLab.mas_bottom).with.offset(1*kScale);
        make.right.equalTo(self.mas_right).with.offset(-15*kScale);
        make.height.equalTo(@(40*kScale));
    }];
    
    
    
    [self.sendFreeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(15*kScale);
        make.top.equalTo(self.recerEmailLabel.mas_bottom).with.offset(1*kScale);
        make.width.equalTo(@(90*kScale));
        make.height.equalTo(@(40*kScale));
    }];
    
    [self.sendFreeTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.sendFreeLabel.mas_right).offset(0);
        make.top.equalTo(self.recerEmailLabel.mas_bottom).with.offset(1*kScale);
        make.right.equalTo(self.mas_right).with.offset(-15*kScale);
        make.height.equalTo(@(40*kScale));
    }];
    
    
}





///选填 更多信息


-(UILabel *)receiverLab{
    if (!_receiverLab) {
        _receiverLab = [[UILabel alloc] init];
        _receiverLab.font = [UIFont systemFontOfSize:12.0f*kScale];
        _receiverLab.textColor = RGB(51, 51, 51, 1);
        _receiverLab.textAlignment = NSTextAlignmentLeft;
        _receiverLab.text = @"收件人:";

    }
    return _receiverLab;
}

-(UITextField *)receiverTextField{
    if (!_receiverTextField) {
        _receiverTextField = [[UITextField alloc] init];
        _receiverTextField.font = [UIFont systemFontOfSize:12.0f*kScale];
        _receiverTextField.textAlignment = NSTextAlignmentLeft;
        _receiverTextField.textColor =  RGB(51, 51, 51, 1);
        _receiverTextField.placeholder = @"请填写收件人姓名";

        
    }
    return _receiverTextField;
}



-(UILabel *)receiverPhoneNumLabel{
    if (!_receiverPhoneNumLabel) {
        _receiverPhoneNumLabel = [[UILabel alloc] init];
        _receiverPhoneNumLabel.font = [UIFont systemFontOfSize:12.0f*kScale];
        _receiverPhoneNumLabel.textColor = RGB(51, 51, 51, 1);
        _receiverPhoneNumLabel.textAlignment = NSTextAlignmentLeft;
        _receiverPhoneNumLabel.text = @"联系电话:";
        
    }
    return _receiverPhoneNumLabel;
}

-(UITextField *)receiverPhoneNumTextField{
    if (!_receiverPhoneNumTextField) {
        _receiverPhoneNumTextField = [[UITextField alloc] init];
        _receiverPhoneNumTextField.font = [UIFont systemFontOfSize:12.0f*kScale];
        _receiverPhoneNumTextField.textAlignment = NSTextAlignmentLeft;
        _receiverPhoneNumTextField.textColor =  RGB(51, 51, 51, 1);
        _receiverPhoneNumTextField.placeholder = @"请填写联系电话";

        
    }
    return _receiverPhoneNumTextField;
}



-(UILabel *)receiverAddressLabel{
    if (!_receiverAddressLabel) {
        _receiverAddressLabel = [[UILabel alloc] init];
        _receiverAddressLabel.font = [UIFont systemFontOfSize:12.0f*kScale];
        _receiverAddressLabel.textColor = RGB(51, 51, 51, 1);
        _receiverAddressLabel.textAlignment = NSTextAlignmentLeft;
        _receiverAddressLabel.text = @"收货地址:";
        
    }
    return _receiverAddressLabel;
}

-(UITextField *)receiverAddressTextField{
    if (!_receiverAddressTextField) {
        _receiverAddressTextField = [[UITextField alloc] init];
        _receiverAddressTextField.font = [UIFont systemFontOfSize:12.0f*kScale];
        _receiverAddressTextField.textAlignment = NSTextAlignmentLeft;
        _receiverAddressTextField.textColor =  RGB(51, 51, 51, 1);
        _receiverAddressTextField.placeholder = @"请选择收货地址";
        _receiverAddressTextField.delegate = self;

    }
    return _receiverAddressTextField;
}


-(UIButton *)receiverAddressBtn{
    if (!_receiverAddressBtn) {
        _receiverAddressBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        
    }
    return _receiverAddressBtn;
}


-(UILabel *)receiverDetailsAddressLab{
    if (!_receiverDetailsAddressLab) {
        _receiverDetailsAddressLab = [[UILabel alloc] init];
        _receiverDetailsAddressLab.font = [UIFont systemFontOfSize:12.0f*kScale];
        _receiverDetailsAddressLab.textColor = RGB(51, 51, 51, 1);
        _receiverDetailsAddressLab.textAlignment = NSTextAlignmentLeft;
        _receiverDetailsAddressLab.text = @"门牌号:";
        
    }
    return _receiverDetailsAddressLab;
}

-(UITextField *)receiverDetailsAddressTextField{
    if (!_receiverDetailsAddressTextField) {
        _receiverDetailsAddressTextField = [[UITextField alloc] init];
        _receiverDetailsAddressTextField.font = [UIFont systemFontOfSize:12.0f*kScale];
        _receiverDetailsAddressTextField.textAlignment = NSTextAlignmentLeft;
        _receiverDetailsAddressTextField.textColor =  RGB(51, 51, 51, 1);
        _receiverDetailsAddressTextField.placeholder = @"请填写详细的门牌号信息";

        
    }
    return _receiverDetailsAddressTextField;
}




-(UILabel *)recerEmailLabel{
    if (!_recerEmailLabel) {
        _recerEmailLabel = [[UILabel alloc] init];
        _recerEmailLabel.font = [UIFont systemFontOfSize:12.0f*kScale];
        _recerEmailLabel.textColor = RGB(51, 51, 51, 1);
        _recerEmailLabel.textAlignment = NSTextAlignmentLeft;
        _recerEmailLabel.text = @"电子邮箱:";
        
    }
    return _recerEmailLabel;
}

-(UITextField *)receiverEmailTextField{
    if (!_receiverEmailTextField) {
        _receiverEmailTextField = [[UITextField alloc] init];
        _receiverEmailTextField.font = [UIFont systemFontOfSize:12.0f*kScale];
        _receiverEmailTextField.textAlignment = NSTextAlignmentLeft;
        _receiverEmailTextField.textColor =  RGB(51, 51, 51, 1);
        _receiverEmailTextField.placeholder = @"请填写电子邮箱信息 (选填)";

        
    }
    return _receiverEmailTextField;
}



-(UILabel *)sendFreeLabel{
    if (!_sendFreeLabel) {
        _sendFreeLabel = [[UILabel alloc] init];
        _sendFreeLabel.font = [UIFont systemFontOfSize:12.0f*kScale];
        _sendFreeLabel.textColor = RGB(51, 51, 51, 1);
        _sendFreeLabel.textAlignment = NSTextAlignmentLeft;
        _sendFreeLabel.text = @"邮费:";
        
    }
    return _sendFreeLabel;
}

-(UITextField *)sendFreeTextField{
    if (!_sendFreeTextField) {
        _sendFreeTextField = [[UITextField alloc] init];
        _sendFreeTextField.font = [UIFont systemFontOfSize:12.0f*kScale];
        _sendFreeTextField.textAlignment = NSTextAlignmentLeft;
        _sendFreeTextField.textColor =  RGB(51, 51, 51, 1);
        _sendFreeTextField.text = @"包邮";
        
        
    }
    return _sendFreeTextField;
}



@end

//
//  ShopCeritficationView.m
//  Emeat
//
//  Created by liuheshun on 2018/4/18.
//  Copyright © 2018年 liuheshun. All rights reserved.
//

#import "ShopCeritficationView.h"

@implementation ShopCeritficationView

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    return [textField resignFirstResponder];
}

-(void)textFieldDidEndEditing:(UITextField *)textField{
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    
    if (textField.tag == 1) {//店名
       
        [user setValue:textField.text forKey:@"shopName"];
        [self.selectedMdic setValue:textField.text forKey:@"shopName"];
    }else if (textField.tag == 2){//店长姓名
       
        [user setValue:textField.text forKey:@"shopManagerName"];
        
        [self.selectedMdic setValue:textField.text forKey:@"shopManagerName"];
    }else if (textField.tag == 3){//电话
       
        [user setValue:textField.text forKey:@"shopPhoneNum"];
        [self.selectedMdic setValue:textField.text forKey:@"shopPhoneNum"];
    }else if (textField.tag == 4){//详细地址
        [user setValue:textField.text forKey:@"shopAddressDetails"];
        [self.selectedMdic setValue:textField.text forKey:@"shopAddressDetails"];
    }else if (textField.tag == 5){//邀请码
        [user setValue:textField.text forKey:@"shopInviteCode"];
        [self.selectedMdic setValue:textField.text forKey:@"shopInviteCode"];
    }
    
    if ([self respondsToSelector:@selector(textFieldTitleBlock)]) {
        self.textFieldTitleBlock(self.selectedMdic);
    }
    
    
}




#pragma mark = 地址选择

-(void)btnAddressAction{
    if ([self respondsToSelector:@selector(addressTitleBlockClickAction)]) {
        
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        self.addressTitleBlockClickAction(dic);
    }
    
}




#pragma mark ===赋值

-(void)configShopCertifiViewWithModel:(MyModel*)model{

    self.textFieldShopName.text = model.storeName;
    self.textFieldShopManagerName.text = model.kp;
    if (model.callNumber) {
         self.textFieldPhoneNumer.text = [NSString stringWithFormat:@"%ld" ,model.callNumber];
    }
   
    self.textFieldCity.text = model.address;
    self.textFieldDetailsAddress.text = model.addressDetail;
    if (model.bdName) {
        self.textFieldInviteCode.text = [NSString stringWithFormat:@"%ld" ,model.bdName];
    }
    
    
    
}

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.bgView];
        [self.bgView addSubview:self.textFieldShopName];
        [self.bgView addSubview:self.textFieldShopManagerName];
        [self.bgView addSubview:self.textFieldPhoneNumer];
        [self.bgView addSubview:self.btnAddress];
        [self.btnAddress addSubview:self.textFieldCity];
        [self.bgView addSubview:self.textFieldDetailsAddress];
        [self.bgView addSubview:self.textFieldInviteCode];
        [self addSubview:self.submitBtn];
        [self setMainViewFrame];
        
        [self setLineView];
        self.selectedMdic = [NSMutableDictionary dictionary];
        
        
    }
    return self;
}

-(void)setMainViewFrame{
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).with.offset(0);
        make.top.equalTo(self.mas_top).with.offset(0);
        make.right.equalTo(self.mas_right).with.offset( 0);
        make.height.equalTo(@(241*kScale));
    }];
    
    
    
    CGFloat mHeight = 40;
    [self.textFieldShopName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgView.mas_left).with.offset(50*kScale);
        make.top.equalTo(self.bgView.mas_top).with.offset(1*kScale);
        make.right.equalTo(self.bgView.mas_right).with.offset(-15*kScale);
        make.height.equalTo(@(mHeight*kScale));
    }];
    
    
    
    [self.textFieldShopManagerName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgView.mas_left).with.offset(50*kScale);
        make.top.equalTo(self.textFieldShopName.mas_bottom).with.offset(1*kScale);
        make.right.equalTo(self.bgView.mas_right).with.offset(-15*kScale);
        make.height.equalTo(@(mHeight*kScale));
    }];
    
    
    
    [self.textFieldPhoneNumer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgView.mas_left).with.offset(50*kScale);
        make.top.equalTo(self.textFieldShopManagerName.mas_bottom).with.offset(1*kScale);
        make.right.equalTo(self.mas_right).with.offset(-15*kScale);
        make.height.equalTo(@(mHeight*kScale));
    }];
    
    [self.btnAddress mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgView.mas_left).with.offset(50*kScale);
        make.top.equalTo(self.textFieldPhoneNumer.mas_bottom).with.offset(1*kScale);
        make.right.equalTo(self.bgView.mas_right).with.offset(0);
        make.height.equalTo(@(mHeight*kScale));
    }];
    
    [self.textFieldCity mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgView.mas_left).with.offset(50*kScale);
        make.top.equalTo(self.btnAddress.mas_top).with.offset(0*kScale);
        make.right.equalTo(self.bgView.mas_right).with.offset(-15*kScale);
        make.height.equalTo(@(mHeight*kScale));
    }];
    //小图标
    UIButton*btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setImage:[UIImage imageNamed:@"进入"] forState:0];
    [self.btnAddress addSubview:btn];
    [btn addTarget:self action:@selector(btnAddressAction) forControlEvents:1];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.btnAddress.mas_right).with.offset(0);
        make.width.equalTo(@(50*kScale));
        make.top.equalTo(self.btnAddress.mas_top).with.offset(0);
        make.height.equalTo(@(mHeight*kScale));
    }];
  
    
    
    [self.textFieldDetailsAddress mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgView.mas_left).with.offset(50*kScale);
        make.top.equalTo(self.btnAddress.mas_bottom).with.offset(1*kScale);
        make.right.equalTo(self.bgView.mas_right).with.offset(-15*kScale);
        make.height.equalTo(@(mHeight*kScale));
    }];
    
    
    [self.textFieldInviteCode mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgView.mas_left).with.offset(50*kScale);
        make.top.equalTo(self.textFieldDetailsAddress.mas_bottom).with.offset(1*kScale);
        make.right.equalTo(self.bgView.mas_right).with.offset(-15*kScale);
        make.height.equalTo(@(mHeight*kScale));
    }];
    
    
    [self.submitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).with.offset(15*kScale);
        make.top.equalTo(self.textFieldInviteCode.mas_bottom).with.offset(30*kScale);
        make.right.equalTo(self.mas_right).with.offset(-15*kScale);
        make.height.equalTo(@(40*kScale));
    }];
    
    
}

-(UIView *)bgView{
    if (!_bgView) {
        _bgView = [[UIView alloc] init];
        _bgView.backgroundColor = [UIColor whiteColor];
    }
    return _bgView;
}


-(UITextField *)textFieldShopName{
    if (!_textFieldShopName) {
        _textFieldShopName = [[UITextField alloc] init];
        _textFieldShopName.placeholder = @"请输入店铺名称";
        [_textFieldShopName setValue:[UIFont boldSystemFontOfSize:15.0f*kScale] forKeyPath:@"_placeholderLabel.font"];
        _textFieldShopName.font = [UIFont systemFontOfSize:15.0f*kScale];
        [_textFieldShopName setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
        _textFieldShopName.leftViewMode = UITextFieldViewModeAlways;
        
        _textFieldShopName.delegate = self;
        _textFieldShopName.tag = 1;
        
    }
    
    return _textFieldShopName;
}



-(UITextField *)textFieldShopManagerName{
    if (!_textFieldShopManagerName) {
        _textFieldShopManagerName = [[UITextField alloc] init];
        _textFieldShopManagerName.placeholder = @"店长姓名 (请输入真实姓名)";
        [_textFieldShopManagerName setValue:[UIFont boldSystemFontOfSize:15.0f*kScale] forKeyPath:@"_placeholderLabel.font"];
        _textFieldShopManagerName.font = [UIFont systemFontOfSize:15.0f*kScale];
        [_textFieldShopManagerName setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
        _textFieldShopManagerName.leftViewMode = UITextFieldViewModeAlways;
        
        _textFieldShopManagerName.delegate = self;
        _textFieldShopManagerName.tag = 2;
        
    }
    
    return _textFieldShopManagerName;
}




-(UITextField *)textFieldPhoneNumer{
    if (!_textFieldPhoneNumer) {
        _textFieldPhoneNumer = [[UITextField alloc] init];
        _textFieldPhoneNumer.placeholder = @"请输入手机号";
        [_textFieldPhoneNumer setValue:[UIFont boldSystemFontOfSize:15.0f*kScale] forKeyPath:@"_placeholderLabel.font"];
        _textFieldPhoneNumer.font = [UIFont systemFontOfSize:15.0f*kScale];
        [_textFieldPhoneNumer setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
        _textFieldPhoneNumer.delegate = self;
        _textFieldPhoneNumer.tag = 3;
        _textFieldPhoneNumer.keyboardType = UIKeyboardTypeNumberPad;
        
    }
    return _textFieldPhoneNumer;
}

-(UIButton *)btnAddress{
    if (!_btnAddress) {
        _btnAddress = [UIButton buttonWithType:UIButtonTypeCustom];
        
        [_btnAddress addTarget:self action:@selector(btnAddressAction) forControlEvents:1];
        
    }
    return _btnAddress;
}

-(UITextField *)textFieldCity{
    if (!_textFieldCity) {
        _textFieldCity = [[UITextField alloc] init];
        _textFieldCity.placeholder = @"点击选择店铺地址";
        [_textFieldCity setValue:[UIFont boldSystemFontOfSize:15.0f*kScale] forKeyPath:@"_placeholderLabel.font"];
        _textFieldCity.font = [UIFont systemFontOfSize:15.0f*kScale];
        [_textFieldCity setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
        _textFieldCity.userInteractionEnabled = NO;
    }
    return _textFieldCity;
}




-(UITextField *)textFieldDetailsAddress{
    if (!_textFieldDetailsAddress) {
        _textFieldDetailsAddress = [[UITextField alloc] init];
        _textFieldDetailsAddress.placeholder = @"可输入更详细的地址信息,如肯德基旁";
        [_textFieldDetailsAddress setValue:[UIFont boldSystemFontOfSize:15.0f*kScale] forKeyPath:@"_placeholderLabel.font"];
        _textFieldDetailsAddress.font = [UIFont systemFontOfSize:15.0f*kScale];
        [_textFieldDetailsAddress setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
        _textFieldDetailsAddress.delegate = self;
        _textFieldDetailsAddress.tag = 4;
        
        
    }
    return _textFieldDetailsAddress;
}

-(UITextField *)textFieldInviteCode{
    if (!_textFieldInviteCode) {
        _textFieldInviteCode = [[UITextField alloc] init];
        _textFieldInviteCode.placeholder = @"请输入邀请码 (选填)";
        [_textFieldInviteCode setValue:[UIFont boldSystemFontOfSize:15.0f*kScale] forKeyPath:@"_placeholderLabel.font"];
        _textFieldInviteCode.font = [UIFont systemFontOfSize:15.0f*kScale];
        [_textFieldInviteCode setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
        _textFieldInviteCode.delegate = self;
        _textFieldInviteCode.tag = 5;
        
        
    }
    return _textFieldInviteCode;
}


-(UIButton *)submitBtn{
    if (!_submitBtn) {
        _submitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _submitBtn.layer.cornerRadius = 3;
        _submitBtn.layer.masksToBounds = YES;
        _submitBtn.backgroundColor =RGB(236, 31, 35, 1);
        _submitBtn.titleLabel.font = [UIFont systemFontOfSize:15.0f*kScale];
    }
    return _submitBtn;
}









-(void)setLineView{
    
    UIView *lastView = nil;
    UIButton *lastBtn = nil;
    NSArray *imvArray = @[@"shangdian" ,@"xingming" ,@"shoujihao" ,@"dingwei",@" " ,@"yaoqingma"];
    for (int i =0; i < 6; i++) {
        UIView *lineView = [[UIView alloc] init];
        lineView.backgroundColor = RGB(238, 238, 238, 1);
        [self addSubview:lineView];
        
        UIButton *imvBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [imvBtn setImage:[UIImage imageNamed:imvArray[i]] forState:0];
        [self addSubview:imvBtn];
        
        [imvBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@(50*kScale));
            make.left.equalTo(self);
            make.height.equalTo(@(40*kScale));
            make.top.equalTo(self.mas_top).with.offset(41*kScale*i+1*kScale);
        }];

        [imvBtn updateConstraintsIfNeeded];
        
        
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left).with.offset(15*kScale);
            make.width.equalTo(@(kWidth-30*kScale));
            make.height.equalTo(@(1*kScale));
            if (i == 0) {
                make.top.equalTo(self);
            }else {
                make.top.equalTo(lastView.mas_bottom).with.offset(40*kScale);
                
            }
            
            
        }];
        
        [lineView updateConstraintsIfNeeded];
        
        lastView = lineView;
        lastBtn = imvBtn;
    }
    
}



@end

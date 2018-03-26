//
//  AddNewAddressView.m
//  Emeat
//
//  Created by liuheshun on 2017/12/7.
//  Copyright © 2017年 liuheshun. All rights reserved.
//

#import "AddNewAddressView.h"


@implementation AddNewAddressView

//-(BOOL)textFieldShouldReturn:(UITextField *)textField{
//    return YES;
//}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    return [textField resignFirstResponder];
}

-(void)textFieldDidEndEditing:(UITextField *)textField{
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    
    if (textField.tag == 1) {//姓名
        if (textField.text.length == 0) {
            
        }else
        {
            [user setValue:textField.text forKey:@"name"];
        [self.selectedMdic setValue:textField.text forKey:@"name"];
        }
    }else if (textField.tag == 2){//电话
        if (textField.text.length == 0) {
            
        }else
        {
            [user setValue:textField.text forKey:@"phoneNumer"];

        [self.selectedMdic setValue:textField.text forKey:@"phoneNumer"];
        }
    }else if (textField.tag == 3){//详细地址
        if (textField.text.length == 0) {
            
        }else
        {
            [user setValue:textField.text forKey:@"addressDetails"];

        [self.selectedMdic setValue:textField.text forKey:@"addressDetails"];
        }
    }
    
    if ([self respondsToSelector:@selector(textFieldTitleBlock)]) {
        self.textFieldTitleBlock(self.selectedMdic);
    }
    
    
}




#pragma mark = select address click

-(void)btnAddressAction{
    if ([self respondsToSelector:@selector(addressTitleBlockClickAction)]) {
        
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        self.addressTitleBlockClickAction(dic);
    }
    
}



#pragma mark = lable click

- (void)SelectBtnSearch:(UIButton *)Btn{
    
    if (!Btn.isSelected) {
        
        self.btnAddressType.selected = !self.btnAddressType.selected;
        
        self.btnAddressType.backgroundColor = [UIColor whiteColor];
        [self.btnAddressType setTitleColor:RGB(138, 138, 138, 1) forState:0];
        Btn.selected = !Btn.selected;
        Btn.backgroundColor = RGB(231, 36, 35, 1);
        [Btn setTitleColor:[UIColor whiteColor] forState:0];
        
        self.btnAddressType = Btn;
        if ([self respondsToSelector:@selector(lableTitleBlock)]) {
            self.lableTitleBlock(Btn.tag);
        }
        
    }
    
}

#pragma mark ===赋值

-(void)configAddressView:(MyAddressModel*)model{
    
    self.textFieldName.text = model.receiverName;
    self.textFieldPhoneNumer.text = [NSString stringWithFormat:@"%ld" ,model.receiverPhone];
    
   
    
    NSArray *array = [model.receiverProvince componentsSeparatedByString:@","]; //从字符A中分隔成2个元素的数组
    if (array.count!=0) {
        self.textFieldCity.text = [NSString stringWithFormat:@"%@" , [array firstObject] ];
        self.textFieldSubstreet.text =  [NSString stringWithFormat:@"%@" , [array lastObject] ];
    }
   
    self.textFieldDetailsAddress.text = model.receiverAddress;
    
    [self setAddressTypes:model.shippingCategory-1];

}

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.textFieldName];
        [self addSubview:self.textFieldPhoneNumer];
        [self addSubview:self.btnAddress];
        [_btnAddress addSubview:self.textFieldCity];
        [_btnAddress addSubview:self.textFieldSubstreet];
        [self addSubview:self.textFieldDetailsAddress];
        [self setMainViewFrame];

        [self setLineView];
        [self setAddressTypes:0];
        self.selectedMdic = [NSMutableDictionary dictionary];
        
       
    }
    return self;
}

-(void)setMainViewFrame{

    [self.textFieldName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).with.offset(50);
        make.top.equalTo(self.mas_top).with.offset(1);
        make.right.equalTo(self.mas_right).with.offset(-15);
        make.height.equalTo(@44);
    }];
    
    [self.textFieldPhoneNumer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).with.offset(50);
        make.top.equalTo(self.textFieldName.mas_bottom).with.offset(1);
        make.right.equalTo(self.mas_right).with.offset(-15);
        make.height.equalTo(@44);
    }];
    
    [self.btnAddress mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).with.offset(50);
        make.top.equalTo(self.textFieldPhoneNumer.mas_bottom).with.offset(1);
        make.right.equalTo(self.mas_right).with.offset(0);
        make.height.equalTo(@65);
    }];
    
    [self.textFieldCity mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).with.offset(50);
        make.top.equalTo(self.btnAddress.mas_top).with.offset(10);
        make.right.equalTo(self.mas_right).with.offset(-15);
        make.height.equalTo(@20);
    }];

    [self.textFieldSubstreet mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).with.offset(50);
        make.top.equalTo(self.textFieldCity.mas_bottom).with.offset(5);
        make.right.equalTo(self.mas_right).with.offset(-15);
        make.height.equalTo(@20);
    }];


    [self.textFieldDetailsAddress mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).with.offset(50);
        make.top.equalTo(self.btnAddress.mas_bottom).with.offset(1);
        make.right.equalTo(self.mas_right).with.offset(-15);
        make.height.equalTo(@44);
    }];

    //小图标
    UIButton*btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setImage:[UIImage imageNamed:@"进入"] forState:0];
    [self.btnAddress addSubview:btn];
    [btn addTarget:self action:@selector(btnAddressAction) forControlEvents:1];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.btnAddress.mas_right).with.offset(0);
        make.width.equalTo(@50);
        make.top.equalTo(self.btnAddress.mas_top).with.offset(0);
        make.height.equalTo(@65);
    }];
    
}


-(UITextField *)textFieldName{
    if (!_textFieldName) {
        _textFieldName = [[UITextField alloc] init];
        _textFieldName.placeholder = @"收货人姓名";
        [_textFieldName setValue:[UIFont boldSystemFontOfSize:15.0f] forKeyPath:@"_placeholderLabel.font"];
        _textFieldName.font = [UIFont systemFontOfSize:15.0f];
        [_textFieldName setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
        _textFieldName.leftViewMode = UITextFieldViewModeAlways;

        _textFieldName.delegate = self;
        _textFieldName.tag = 1;

    }
    
    return _textFieldName;
}


-(UITextField *)textFieldPhoneNumer{
    if (!_textFieldPhoneNumer) {
        _textFieldPhoneNumer = [[UITextField alloc] init];
        _textFieldPhoneNumer.placeholder = @"收货人手机号";
        [_textFieldPhoneNumer setValue:[UIFont boldSystemFontOfSize:15.0f] forKeyPath:@"_placeholderLabel.font"];
        _textFieldPhoneNumer.font = [UIFont systemFontOfSize:15.0f];
        [_textFieldPhoneNumer setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
        _textFieldPhoneNumer.delegate = self;
        _textFieldPhoneNumer.tag = 2;
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
        _textFieldCity.placeholder = @"选择省、市、区／县";
        [_textFieldCity setValue:[UIFont boldSystemFontOfSize:15.0f] forKeyPath:@"_placeholderLabel.font"];
        _textFieldCity.font = [UIFont systemFontOfSize:15.0f];
        [_textFieldCity setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
        _textFieldCity.userInteractionEnabled = NO;
    }
    return _textFieldCity;
}


-(UITextField *)textFieldSubstreet{
    if (!_textFieldSubstreet) {
        _textFieldSubstreet = [[UITextField alloc] init];
        _textFieldSubstreet.placeholder = @"搜索街道、乡镇、小区名、大厦等";
        [_textFieldSubstreet setValue:[UIFont boldSystemFontOfSize:15.0f] forKeyPath:@"_placeholderLabel.font"];
        _textFieldSubstreet.font = [UIFont systemFontOfSize:15.0f];
        [_textFieldSubstreet setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
        _textFieldSubstreet.userInteractionEnabled = NO;

    }
    return _textFieldSubstreet;
}



-(UITextField *)textFieldDetailsAddress{
    if (!_textFieldDetailsAddress) {
        _textFieldDetailsAddress = [[UITextField alloc] init];
        _textFieldDetailsAddress.placeholder = @"详细地址(精确到门牌号)";
        [_textFieldDetailsAddress setValue:[UIFont boldSystemFontOfSize:15.0f] forKeyPath:@"_placeholderLabel.font"];
        _textFieldDetailsAddress.font = [UIFont systemFontOfSize:15.0f];
        [_textFieldDetailsAddress setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
        _textFieldDetailsAddress.delegate = self;
        _textFieldDetailsAddress.tag = 3;

        
    }
    return _textFieldDetailsAddress;
}


-(void)setLineView{
    
    UIView *lastView = nil;
    UIButton *lastBtn = nil;
    NSArray *imvArray = @[@"shouhuoren" ,@"手机号" ,@"dizhi" ,@"menpai" ,@"biaoqian"];
    for (int i =0; i < 5; i++) {
        UIView *lineView = [[UIView alloc] init];
        lineView.backgroundColor = RGB(238, 238, 238, 1);
        [self addSubview:lineView];
        
        UIButton *imvBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [imvBtn setImage:[UIImage imageNamed:imvArray[i]] forState:0];
        [self addSubview:imvBtn];
        
        [imvBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@50);
            make.left.equalTo(self);
            make.height.equalTo(@44);
            make.top.equalTo(self.mas_top).with.offset(46*i+1);
        }];
        if (i == 2) {
            [imvBtn mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.equalTo(@65);

            }];
        }else if (i == 3){
            [imvBtn mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.mas_top).with.offset(46*i+21);
            }];
        }else if (i == 4){
            [imvBtn mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.mas_top).with.offset(46*i+21);
            }];
        }
        [imvBtn updateConstraintsIfNeeded];

        
        
        
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left).with.offset(15);
            make.width.equalTo(@(kWidth-30));
            make.height.equalTo(@1);
            if (i == 0) {
                make.top.equalTo(self);
            }else if (i == 1){
                make.top.equalTo(lastView.mas_bottom).with.offset(44);

            }else if (i == 2){
                make.top.equalTo(lastView.mas_bottom).with.offset(44);

            }else  if (i == 3) {
               make.top.equalTo(lastView.mas_bottom).with.offset(65);
                
            }else if ( i == 4){
                make.top.equalTo(self.textFieldDetailsAddress.mas_bottom);
                
            }
            
            
           
        }];
       
        [lineView updateConstraintsIfNeeded];

        lastView = lineView;
        lastBtn = imvBtn;
    }
    
}


-(void)setAddressTypes :(NSInteger)defaultIndex{
    
   
    NSArray *titlearray = @[@"公司" ,@"住宅",@"其它"];
    
    for (int i = 0; i < titlearray.count; i++) {

    UIButton *BtnSearch = [UIButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:BtnSearch];

        [BtnSearch mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.textFieldDetailsAddress.mas_bottom).with.offset(12);
            make.width.equalTo(@40);
            make.height.equalTo(@20);
            make.left.equalTo(@(50+50*i));
        
        }];
  
    
        [BtnSearch setTitleColor:RGB(138, 138, 138, 1) forState:0];
        //[BtnSearch setTitleColor:RGB(231, 35, 36, 1) forState:1];
        BtnSearch.backgroundColor = [UIColor whiteColor];
        BtnSearch.layer.borderColor = RGB(238, 238, 238, 1).CGColor;
        BtnSearch.layer.borderWidth = 0.7;
        BtnSearch.titleLabel.font = [UIFont systemFontOfSize:12.0f];
        [BtnSearch setTitle:titlearray[i] forState:0];
        BtnSearch.layer.cornerRadius = 5;
        BtnSearch.layer.masksToBounds = YES;
        BtnSearch.tag = i+1;
        [BtnSearch addTarget:self action:@selector(SelectBtnSearch:) forControlEvents:UIControlEventTouchUpInside];
    
    if (i == defaultIndex) {
        
        BtnSearch.backgroundColor = [UIColor redColor];
        [BtnSearch setTitleColor:[UIColor whiteColor] forState:0];

        BtnSearch.selected = YES;
        
        self.btnAddressType = BtnSearch;
        
    }
    
    
}
    
 
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
